--- cson
title: "Method name conventions in BDDfy"
metaTitle: "Method name conventions in BDDfy"
description: "In this article I explain how you may take advantage of method name conventions in BDDfy to very easily write a BDD behavior"
revised: "2013-08-10"
date: "2011-12-27"
tags: ["bddify","testing","bdd","bddify-in-action"]
migrated: "true"
urls: ["/bddify-in-action/method-name-conventions"]
summary: """
In this article I explain how you may take advantage of method name conventions in BDDfy to very easily write a BDD behavior
"""
---
**[Update - 2013-08-10] BDDfy is now part of [TestStack](http://teststack.net) organization. So this article has been ported to and is superseded by [this post](http://docs.teststack.net/BDDfy/Usage/MethodNameConventions.html) on the [documentation website](http://docs.teststack.net/).**

**This is the second article in the ['BDDfy In Action' series][1]. It is recommended to read this series in the presented order because I use some of the references provided in the previous articles.**

The code used in this article is available for download from [here][11].

BDDfy can scan your tests in one of two ways: using Reflective API and Fluent API.  Reflective API uses some hints to scan your classes and afterwards pretty much all the burden is on BDDfy's shoulders to find your steps, make sense of them and execute them in order. You can provide these hints in two ways: using method name conventions and/or attributes. For this post we will only concentrate on method name conventions. 

#Method Name Conventions
BDDfy uses quite a bit of magic to figure out what your scenario looks like and what it should execute. Despite the amount of magic gone into implementing the logic the programmers' API is extremely simple and it basically boils down to 14 letters:

    this.BDDfy();

That is all the API you need to know to be able to use BDDfy in Reflective Mode. Well, that and a bit of knowledge about the conventions which we are going to discuss in this post.

##A class per scenario
In the reflective mode BDDfy associates each class with a scenario and you will basically end up with one class per scenario. Some developers like the Single Responsibility Principle forced nature of this approach and some do not quite like it. For those who think this is not very DRY (Don't Repeat Yourself) BDDfy allows you to take full control over this using the Fluent API. I personally use both approaches in every project because each has its pros and cons.

A typical example of using method name convention looks like:

<pre>
using NUnit.Framework;

namespace BDDfy.MethodNameConventions
{
    public class BddfyRocks
    {
        [Test]
        public void ShouldBeAbleToBddfyMyTestsVeryEasily()
        {
            this.BDDfy();
        }

        void GivenIHaveNotUsedBddfyBefore()
        {
        }

        void WhenIAmIntroducedToTheFramework()
        {
        }

        void ThenILikeItAndStartUsingIt()
        {
        }
    }
}
</pre>

The only thing related to BDDfy in this class is <code>this.BDDfy();</code>!!

As mentioned in [the introductory post][2], BDDfy does not care what testing framework or test runner you use and it provides the same result for all of them. Here is the result of the test run using R#:

![Resharper Result][3]

Using that one line of code BDDfy was able to find out what your scenario title and test steps are and how to run them! It also provides the above console report and an html report as below:

![Html report][4]

##How does BDDfy do all that?
When using the reflective mode, BDDfy scans your class (which is <code>this</code> you are calling <code>BDDfy()</code> on) and finds all the methods in it. It then adds all the methods which match its conventions to a list. After having gone through the class (and its base classes) it loops over the methods and runs them and then generates a report from it.

Here is the complete list of the out of the box conventions. The method name:

 * ending with "Context" is considered as a setup method (not reported).
 * "Setup" is considered as as setup method  (not reported). 
 * starting with "Given" is considered as a setup method (reported). 
 * starting with "AndGiven" is considered as a setup method that runs after Context, Setup and Given steps (reported).
 * starting with "When" is considered as a transition method  (reported). 
 * starting with "AndWhen" is considered as a transition method that runs after When steps (reported).
 * starting with "Then" is considered as an asserting method (reported).
 * starting with "And" is considered as an asserting method (reported).
 * starting with "TearDown" is considered as a finally method which is run after all the other steps (not reported).

Some of these conventions lead to the step not being reported and some report the step. For example if your method name ends with the word 'Context' the step will be picked up by the framework and will be executed; but it will not be reported in console or html report. This was created on a request by a user; but I personally do not use this feature. If I need to setup my state I either do it in the 'Given' steps or in the class constructor if it is not directly related to the scenario state.

It is worth mentioning that these conventions can be easily overridden (but not a topic of this post).

BDDfy by default uses your scenario class name to generate a title for your scenario. You may easily override this behavior too as we will see further down.

##Another example
Let's expand on the example above and create something a bit more complex. My specification this time reads as:

<pre>
Given I am new to BDD
  And I have not used BDDfy before
When I am introduced to the framework
Then I like it and I start using it
  And I learn BDD through BDDfy
</pre>

Not much difference to what I had before; but now I have two additional 'And' steps: one for 'Given' and one for 'Then'. Going by the conventions explained above you should implement this like below:

<pre>
using NUnit.Framework;

namespace BDDfy.MethodNameConventions
{
    public class BddfyRocksEvenForBddNewbies
    {
        [Test]
        public void ShouldBeAbleToBddfyMyTestsVeryEasily()
        {
            this.BDDfy();
        }

        void GivenIAmNewToBdd()
        {
        }

        void AndGivenIHaveNotUsedBddfyBefore()
        {
        }

        void WhenIAmIntroducedToTheFramework()
        {
        }

        void ThenILikeItAndStartUsingIt()
        {
        }

        void AndILearnBddThroughBddfy()
        {
        }
    }
}
</pre>

Let's run this guy. This time I use [TD.Net][5] to show you the result from another test runner:

![TD.Net result of the expanded test][6]

So BDDfy was capable to find the 'AndGiven' method and turn it into an 'And' step that runs after the 'Given' step. The same goes for the 'And' method that is run after the 'Then' step.

##How to use input arguments with method name conventions?
If your test requires input arguments there is a good chance you should be using the fluent API; that said BDDfy provides support for input arguments for the method name convention scanner too.

In order to run the same scenario using different input arguments you need to create a scenario class which is not a test class. The scenario class should accept the input arguments through constructor parameters and then you may assign those to instance fields and use them in your step methods. You then will have another class, which will usually be your story class, to instantiate your scenario class using different input arguments and call BDDfy on the instance. It is hard to explain this and an example shows the usage better. 

BDDfy comes with two complete examples that showcase different most BDDfy features. You may install these samples through <code>BDDfy.Samples.TicTacToe</code> and <code>BDDfy.Samples.ATM</code>. This particular feature is used in the [BDDfy.Samples.TicTacToe][7] sample for testing the winner games. You may see the winner game scenario class [here][8]. For brevity I only include the class constructor here:

<pre>
public class WinnerGame : GameUnderTest
{
    private readonly string[] _firstRow;
    private readonly string[] _secondRow;
    private readonly string[] _thirdRow;
    private readonly string _expectedWinner;

    public WinnerGame(string[] firstRow, string[] secondRow, string[] thirdRow, string expectedWinner)
    {
        _firstRow = firstRow;
        _secondRow = secondRow;
        _thirdRow = thirdRow;
        _expectedWinner = expectedWinner;
    }
</pre>

... and the code from the story that instantiates the class and runs it using different input arguments can be found [here][9]. A bit of code copied from that codebase is shown below for your convenience:

<pre>
[Test]
[TestCase("Vertical win in the right", new[] { X, O, X }, new[] { O, O, X }, new[] { O, X, X }, X)]
[TestCase("Vertical win in the middle", new[] { N, X, O }, new[] { O, X, O }, new[] { O, X, X }, X)]
[TestCase("Diagonal win", new[] { X, O, O }, new[] { X, O, X }, new[] { O, X, N }, O)]
[TestCase("Horizontal win in the bottom", new[] { X, X, N }, new[] { X, O, X }, new[] { O, O, O }, O)]
[TestCase("Horizontal win in the middle", new[] { X, O, O }, new[] { X, X, X }, new[] { O, O, X }, X)]
[TestCase("Vertical win in the left", new[] { X, O, O }, new[] { X, O, X }, new[] { X, X, O }, X)]
[TestCase("Horizontal win", new[] { X, X, X }, new[] { X, O, O }, new[] { O, O, X }, X)]
public void WinnerGame(string title, string[] firstRow, string[] secondRow, string[] thirdRow, string expectedWinner)
{
    new WinnerGame(firstRow, secondRow, thirdRow, expectedWinner).BDDfy(title);
}
</pre>

This runs the <code>WinnerGame</code> test class as several scenarios with different inputs. The html report from the sample is shown below:

![Tic Tac Toe html report][10]

<small>The report has a story which I have not covered yet.</small>

So far we have been calling <code>BDDfy()</code> with no arguments so you may wonder what the <code>title</code> argument does. As you may guess from its name that argument overrides the scenario title. If we had not passed that argument in we would end up with 7 scenarios all titled 'Winner game' which is not what we want. So we pass in the title we want for the scenario based on the input arguments.

##FAQ
These are some of the FAQ I have received for Method Name Conventions:

###Should I have my methods in the right order?
No you do not. BDDfy picks the methods based on the naming convention and regardless of where in the class they appear BDDfy runs and reports them in the right order.

There is only one rare case where you need to put some of your methods in the right order and that is when you have multiple 'AndGiven' or 'AndWhen' or 'And' steps in which case BDDfy picks up the 'And' steps in the order they are written in the class.

###How I can reuse some of the testing logic?
You may achieve that through scenario inheritance or composition as you would in your business logic code. 

When inheriting from a base class that has a few steps BDDfy picks the steps from your base classes as if they were in your scenario class. This is useful when you have several scenarios that share a few steps. This way you put the shared steps in the base class and subclass that in your scenario classes.

Using composition you may put the actual logic in a separate class and use them from your scenario classes. If you are using composition then you may want to consider the fluent API because it does just what you want. I will discuss them in another post in near future.

###Why does not BDDfy pick up my base class methods?
Because you should define them either as public or protected. BDDfy ignores the base class methods with private access modifier.

###Can my step methods be static or should they be instance methods?
BDDfy handles both cases. So feel free to use whatever makes sense.

###Where can I setup my mocks or other bits not directly related to the scenario?
When unit testing you usually end up mocking a few interfaces and setting up a few things that are not necessarily related to the scenario under test; but are necessary for you to be able to test the scenario. I usually put this logic into the class constructor. If what you are setting up is directly related to the scenario then you should put the logic in your 'Given' step(s).

##Conclusion
In this post we saw Method Name Convention: one of many ways BDDfy can help you write BDD behaviors. In the future posts I will explain other alternatives.

The code used in this article is available for download from [here][11].

Hope this helps.


  [1]: http://www.mehdi-khalili.com/bddify-in-action/introduction
  [2]: http://www.mehdi-khalili.com/bddify-in-action/introduction
  [3]: http://www.mehdi-khalili.com/get/blogpictures/bddify-in-action/method-name-conventions/Resharper-result.JPG
  [4]: http://www.mehdi-khalili.com/get/blogpictures/bddify-in-action/method-name-conventions/html-report.JPG
  [5]: http://www.testdriven.net/
  [6]: http://www.mehdi-khalili.com/get/blogpictures/bddify-in-action/method-name-conventions/TDNet-expanded-test-result.JPG
  [7]: http://nuget.org/packages/Bddify.Samples.TicTacToe
  [8]: http://code.google.com/p/bddify/source/browse/Bddify.Samples/TicTacToe/WinnerGame.cs
  [9]: http://code.google.com/p/bddify/source/browse/Bddify.Samples/TicTacToe/TicTacToe.cs#126
  [10]: http://www.mehdi-khalili.com/get/blogpictures/bddify-in-action/method-name-conventions/tictactoe-html-result.JPG
  [11]: http://www.mehdi-khalili.com/get/sourcecode/bddify-in-action/Bddify.MethodNameConventions.zip