--- cson
title: "Introducing bddify: A simple BDD framework for .Net"
metaTitle: "Introducing bddify: A simple BDD framework for .Net"
description: "bddify is a simple yet powerful and extensible BDD framework for .Net developers"
revised: "2011-12-29"
date: "2011-03-28"
tags: ["bddfy"]
migrated: "true"
resource: "/introducing-bddify-framework"
summary: """
bddify is a simple yet powerful and extensible BDD framework for .Net developers
"""
---
**[Update]: bddify framework has gone through a lot of changes and some of the topics discussed in this article have become much simpler or perhaps obsolete. You may find an extensive tutorial about bddify [here][1].**

bddify is a small yet powerful and extensible BDD framework for .Net developers:

 - bddify can run with any testing framework. It does not force you to use any particular framework. There are samples in the source code for MSTest and NUnit, and I expect it to be just as easy to use it with any other framework. Actually bddify does not force you to use a testing framework at all. You can just apply bddify on your POCO (test) classes! There is a demo for this in the source too.
 - It allows you to run a scenario with different arguments using RunScenarioWithArgs attribute.
 - It allows you to run your test steps with different arguments using RunStepWithArgs attribute.
 - It generates nice Html and console reports.
 - It comes with an "assembly runner" that allows you to bddify your assembly and your assembly does not have to have any dependency on bddify or any testing framework.
 - It provides you with a default running configuration for simplicity; but it allows you to override almost every single behavior and convention. 

bddify core barely has any logic in it. It delegates all its responsibilities to its extensions. Extending bddify is very easy and I will explain it in details in a future post.

###How to install and use the framework?
In Visual Studio 2010:

 0. [Install NuGet][2] if you have not already.
 1. Create a new 'Test' project.
 2. Go to Tools, Library Package Manager, and click Package Manager Console.
 3. In the console type 'Install-Package bddify' and enter.

After this your project should have three new files, apart from Class1 which is created by default: packages.config, bddify.cs and RunMe.cs:

 - packages.config is created and used by NuGet.
 - 'bddify.cs' contains a class including one extension method that allows you to bddify an MSTest test. If you are using any other testing framework it should be very easy to change this extension. All you need to do is to provide the ExceptionHandler class with the action from your testing framework that throws 'inconclusive exception'. In NUnit and MSTest this action is Assert.Inconclusive. If you are working with a framework that does not allow inconclusive exceptions (e.g. XUnit.Net) then simply provide it with Assert.Fail (or its equivalent) and it should work.
 - 'RunMe.cs' contains a few simple tests included as sample. This will later be removed from the package; but I am going to keep it there for now. This way you get to see some of the main features of bddify very easily.

This is what RunMe looks like:

    [RunScenarioWithArgs(1, 2, 3)]
    [RunScenarioWithArgs(-1, 5, 4)]
	[TestClass]
    public class ScenarioWithArgs
    {
        private int _expectedResult;
        private int _input1;
        private int _input2;
        private int _actualResult;

        void RunScenarioWithArgs(int input1, int input2, int expectedResult)
        {
            _input1 = input1;
            _input2 = input2;
            _expectedResult = expectedResult;
        }

        void GivenTwoNumbers()
        {
        }

        void WhenTheNumbersAreAdded()
        {
            _actualResult = _input1 + _input2;
        }

        void ThenTheResultIsCorrect()
        {
            Assert.AreEqual(_actualResult, _expectedResult);
        }

        [TestMethod]
        public void Execute()
        {
            this.bddify();
        }
    }

    [TestClass]
    public class SomeIncompleteTest
    {
        void GivenThisTestOrOneOfTheClassesItCallsToIsIncomplete()
        {
        }

        void WhenTheTestIsRun()
        {
            throw new NotImplementedException();
        }

        void ThenItIsFlaggedAsIncomplete()
        {
            
        }

        [TestMethod]
        public void Execute()
        {
            this.bddify();
        }
    }

    [TestClass]
    public class SomeInconclusiveTest
    {
        void GivenThisTestThrowsInconclusiveException()
        {
        }

        void WhenTheTestIsRun()
        {
        }

        void ThenItIsFlaggedAsInconclusive()
        {
			Assert.Inconclusive();            
        }

        [TestMethod]
        public void Execute()
        {
            this.bddify();
        }
    }

	[TestClass]
    public class WhenTwoNumbersAreSubtracted
    {
        [RunStepWithArgs(5, 3, 2)]
        [RunStepWithArgs(1, 8, -7)]
        [RunStepWithArgs(2, 3, 0)] // this should fail
        void ThenTheResultShouldBeCorrect(int input1, int input2, int expectedResult)
        {
            if (input1 - input2 != expectedResult)
                throw new Exception("Dude, subtract aint working");
        }

        [TestMethod]
        public void Execute()
        {
            this.bddify();
        }
    }

Now you can run the tests (either using R# test runner or TD.Net or MSTest runner or any other runner you are using - should not make a difference).

Below is a few samples of what the result of running the test using R# looks like. For successful scenario with args the result looks like:

![alt text][3]

... and for failing step with args it looks like:

![alt text][4]

If you run your tests with [TD.Net][5] you will see something like below in your output window:

![alt text][6]

These are provided by ConsoleReporter class. bddify also has an HtmlReporter that generates an html report for every run. The result can be found under your project's output directory in a file called bddify.html and it looks like:

![alt text][7]

[Credit: Html Report would not look anywhere as nice without the help I received from [Paul Stovell][8], [Aaron Powell][9] and other great colleagues at [Readify][10]. Thanks guys.]

The report shows a summary on the top and the list of scenarios underneath. Scenarios are grouped by namespaces they belong to. On the right of each namespace you can see a summary of the scenarios run as part of it. 

If you click on a scenario you can see its steps and the result of each one including exceptions if there was any.

The RunMe file as mentioned above contains a few samples; but if you want to see more samples you may [download the code][11] and have a look at demos in the solution.

###bddify an assembly
Just like bddify extension method that works on object instances there is an extension method for assemblies. The assembly runner can scan an assembly and run all its tests. The following code snippet shows a console application that bddifies all the classes whose name starts with 'When':

    [STAThread]
    public static void Main()
    {
        typeof(Run).Assembly.bddify(t => t.Name.StartsWith("When", StringComparison.Ordinal));
        Console.ReadLine();
    }

The framework does not know what classes you have in your assembly and which one it should run. So you have to pass it a predicate using which it can filter out non-test classes or test classes you do not want to run with assembly runner (e.g. slow tests). 

The assembly runner provides a report on the console for you (plus the html report of course). The console report looks like:

![alt text][12]

This could be useful when you want to run your tests from command prompt.

###Testing without a testing framework
bddify does not depend on any testing framework. For example you can bddify a class that looks like:

    [RunScenarioWithArgs(1, 2, 2)]
    [RunScenarioWithArgs(4, 5, 20)]
    public class WhenTwoNumbersAreMultiplied
    {
        private int _expectedResult;
        private int _input1;
        private int _input2;

        void RunScenarioWithArgs(int input1, int input2, int expectedResult)
        {
            _input1 = input1;
            _input2 = input2;
            _expectedResult = expectedResult;
        }

        void ThenTheResultIsCorrect()
        {
            if (_input1 * _input2 != _expectedResult)
                throw new Exception("Dude, multiplication aint working");
        }
    }

You could make the asserting methods public and use a testing framework if you wish. It does not make any difference for bddify.

It is worth noting that these sort of tests need a host to run; i.e. R# or other test runners will not be able to run these tests. This is where the assembly runner could help. There is a sample application, called AssemblyRunner, for this in the source code solution.

###bddify needs your feedback
bddify is still very young and has a long way to go: there are still quite a few things I would like to add to the framework and hopefully it will be very easy to extend. I have provided a rather decent test coverage for the framework but I guess there will be a few bugs here and there.

I am interested in your feedback. Let me know what you think about the framework, where it is lagging and what it would take for you to use it in your project. If you find a bug or if you have a suggestion or issue with the project please raise it in [the project home at Google Code][13].


  [1]: http://www.mehdi-khalili.com/bddify-in-action/introduction
  [2]: http://nuget.codeplex.com/wikipage?title=Using%20the%20Extension%20Manager%20to%20Install%20the%20Library%20Package%20Manager%20%28NuGet%29
  [3]: /get/BlogPictures/introducing-bddify-framework/runme-resharper-scenario-with-args-result.JPG
  [4]: /get/BlogPictures/introducing-bddify-framework/runme-resharper-when-two-numbers-are-added-result.JPG
  [5]: http://www.testdriven.net/
  [6]: /get/BlogPictures/introducing-bddify-framework/runme-td-net-result.JPG
  [7]: /get/BlogPictures/introducing-bddify-framework/runme-html-report.JPG
  [8]: http://www.paulstovell.com/
  [9]: http://www.aaron-powell.com/
  [10]: http://readify.net/
  [11]: https://code.google.com/p/bddify/source/checkout
  [12]: /get/BlogPictures/introducing-bddify-framework/assembly-runner-result.JPG
  [13]: https://code.google.com/p/bddify/