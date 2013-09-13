--- cson
title: "Introduction to BDDfy"
metaTitle: "Introduction to BDDfy"
description: "BDDfy V1 is released. This is an introduction to the framework and a start of an extensive series about BDDfy."
revised: "2013-08-10"
date: "2011-12-25"
tags: ["testing","bddfy","bdd","oss"]
migrated: "true"
resource: "/bddify-in-action/introduction"
summary: """
BDDfy V1 is released. This is an introduction to the framework and a start of an extensive series about BDDfy.
"""
---
**[Update - 2013-08-10] BDDfy is now part of [TestStack](http://teststack.net) organization. So this article has been ported to and is superseded by [this post](http://docs.teststack.net/BDDfy/index.html).**

**[Update: 2012-06-03] bddify has now [been moved to GitHub][1] and renamed to BDDfy. You may find more information [here][2].**

If you are new to BDD you may want to read [BDD to the rescue][3] first.

This is an introduction and a start of a series about BDDfy, a powerful BDD framework for .Net, called 'BDDfy In Action':

###Using BDDfy
 - [Introducing BDDfy][4]: which is this post
 - [Using Method Name Conventions][5]
 - [Writing stories][6]
 - [Using Executable Attributes][7]
 - [Using Fluent API][8]
 - [Input parameters in Fluent API][9]
 - [Reports and report configuration][10]

###Advanced bits
 - [Architecture overview][11]
 - [Customizing and Extending BDDfy Reports][12]
 - [Case Study - Rolling your own testing framework][13]: A sample application demonstrating how you can replace whole pieces of the BDDfy framework to customize it to your own needs. This will include:
  - Create a new MethodNameStepScanner to replace the BDDfy Given When Then grammar with a different grammar of EstablishContext, BecauseOf, ItShould.
Make BDDfy work with Story classes rather than Story attributes.
  - Plug in a new StoryMetaDataScanner
  - Customize the HTML Report
  - Run BDDfy tests in a console application without any test framework or test runner.
 - [Case Study - Rolling your own testing framework (2)][14]: Adding parallel testing to the custom framework.
 - [Using BDDfy in a Class per Scenario style for unit tests][15]: Using BDDfy with an auto-mocking container.

##A bit of history
In January 2011 I started working with a team who did not have any exposure to BDD. The codebase they were working on could benefit from testing in general but more so from BDD; so I introduced them to the concept and they liked it; but the existing frameworks did not feel like a good fit for the team and organization. One of the reasons was that they were not doing Agile. The existing frameworks would work very nicely in Agile organizations but not as easily in non-Agile teams. Sure, BDD was born in Agile land; but in my experience it is as useful (if not more) for non-Agile teams. Also it always felt like an extension to TDD in the sense that in order to learn BDD you should first know and do TDD. This made BDD rather unreachable for average developers.

As such I started an attempt to make BDD very simple for every .Net developer regardless of their experience, knowledge of BDD and testing or whether they work on an Agile or non-Agile organization. 

... and [BDDfy was born][16] as a one-file-framework. Well the first few incarnations were rather crude but soon it was turned into a fully-fledged BDD framework with quite a few handy and cool features. Since then BDDfy has been used by many teams in Australia and overseas: some developers learnt BDD through BDDfy and some switched to BDDfy after having used other BDD frameworks and luckily they are all very happy with it. 

After one year, today I am pleased to announce the release of BDDfy V1. The code is now hosted on GitHub and you can find it [here][17].

The framework is called BDDfy because it BDDfies (as in turns into BDD) your otherwise traditional unit tests. With BDDfy it is very simple to turn your AAA tests into a BDD test/behavior. Oh and BTW it is pronounced B D Defy.

##Why another BDD framework?
Below are some of the BDDfy highlights:

 - BDDfy can run with any testing framework. It does not force you to use any particular framework. Actually BDDfy does not force you to use a testing framework at all. You can just apply it on POCO classes even in a console app if that is what you need!
 - BDDfy does not need a separate test runner. You can use your runner of choice. For example, if you like NUnit, then you may write your BDDfy tests using NUnit and run them using NUnit console or GUI runner, Resharper or TD.Net and regardless of the runner, you will get the same result. This means it integrates with the tools you know and love instead of adding yet another one on the top of them.
 - BDDfy can run standalone scenarios. Although BDDfy supports stories, you do not necessarily have to have or make up a story to use BDDfy. This is useful for developers who work in non-Agile environments but would like to get some decent testing experience.
 - You can use underscored or pascal or camel cased method names for your steps.
 - You do not have to explain your scenarios or stories or steps in string: BDDfy infers them based on conventions but you can override the conventions if you need full control over what gets printed into console and HTML reports. Conventions galore in BDDfy and pretty much everything has a convention; but it is also very easy to override these conventions.
 - BDDfy is very extensible. In fact, BDDfy core barely has any logic in it. It delegates all its responsibilities to its extensions.
 - BDDfy learning curve is rather flat. Not only that but it makes learning BDD effortless.

##The team
Up until V0.9 BDDfy was a one-man framework - basically I was the only one working on it. I am not a big fan of one-man frameworks because they are a bit risky to use: if something happens to the sole developer of the framework or if he/she loses interest in maintaining it, the community will suffer.

Since early releases of BDDfy there was a programmer from London called Michael Whelan who provided a lot of feedback and comments on the framework. He also found and reported a few bugs. Recently he asked if he could help in the framework and soon he became a committer and in the short period he has been officially engaged with the framework he has provided a lot of help. So there are now two of us which is great. Hopefully the team of two will grow into a community of bddifiers.

##BDDfy: the simplest BDD framework
This is only meant to be an intro and the actual technical content will follow in the upcoming posts; but I thought I'd give you a taste of BDDfy. So let's give it a quick shot:

 - Create a new test project in Visual Studio. It could be an MSTest project or a library project where your favorite testing framework is installed.
 - Then install BDDfy nuget package: Install-Package TestStack.BDDfy
 - Now create a new class called BDDfyRocks and paste the following bit of code in it:

<pre>
using TestStack.BDDfy.Core;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BDDfy;

namespace BDDfyIntro.MsTest
{
    [TestClass]
    [Story(
        AsA = "As a .net programmer",
        IWant = "I want to use BDDfy",
        SoThat = "So that BDD becomes easy and fun")]
    public class BDDfyRocks
    {
        [TestMethod]
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

I am a big fan of NUnit and in all BDDfy demos I have used it; so I thought I'd use MSTest for a change here. Well, I admit this is not a real BDD behavior but I am just trying to show you the usage. You may now run the test.

Here is the what you get if you run using resharper:

![Resharper result][18]

The one line of code in the test method that calls BDDfy on the class instance turned my class into a [BDD story][19] and my methods into readable specification.

BDDfy does not care what testing framework or runner you use. Below is what we get if we run the same test using MSTest runner:

![MSTest result][20]

You will get decent result for TD.Net too:

![TD.Net result][21]

What you saw above was console report generated by BDDfy as displayed by different test runners. BDDfy also generates html report(s):

![BDDfy html report][22]

An image does not really do a justice for the html report; so you may want to run the test yourself and play with the report.

Before V1 BDDfy generated the html report using RazorEngine. RazorEngine only works on .Net 4 which meant BDDfy could only generate html report for .Net 4 tests. This limitation has been removed because BDDfy no longer depends on RazorEngine. So if you are using BDDfy for your .Net 3.5 tests you can now take advantage of the html report.

##This was just an intro
This was just a very quick intro to BDDfy and what you just saw was one of the many cool features of this framework. If you want to learn more about the framework stay tuned as I have got quite a few posts coming that will walk you through most of the features and explain how it works and how you may use it.

To see a few samples for BDDfy you may install the [TestStack.BDDfy.Samples][23] nuget package which includes [Dan North's ATM sample][24] plus Tic Tac Toe game done in BDD.

If you want to stay up-to-date with BDDfy changes you may follow it on twitter on [@BDDfy][25].

That is all for now. 

**[Update: 2012-06-03] bddify has now [been moved to GitHub][26] and renamed to BDDfy. You may find more information [here][27].**


  [1]: http://teststack.github.com/TestStack.BDDfy/
  [2]: http://www.mehdi-khalili.com/bddify-moved-to-github-and-renamed-to-teststack-bddfy
  [3]: http://www.mehdi-khalili.com/bdd-to-the-rescue
  [4]: http://www.mehdi-khalili.com/bddify-in-action/introduction
  [5]: http://www.mehdi-khalili.com/bddify-in-action/method-name-conventions
  [6]: http://www.mehdi-khalili.com/bddify-in-action/story
  [7]: http://www.mehdi-khalili.com/bddify-in-action/executable-attributes
  [8]: http://www.mehdi-khalili.com/bddify-in-action/fluent-api
  [9]: http://www.mehdi-khalili.com/bddify-in-action/fluent-api-input-parameters
  [10]: http://michael-whelan.net/bddfy-in-action/bddfy-reports
  [11]: http://michael-whelan.net/bddfy-in-action/bddfy-architecture-overview
  [12]: http://michael-whelan.net/bddfy-in-action/custom-reports
  [13]: http://michael-whelan.net/bddfy-in-action/roll-your-own-testing-framework
  [14]: http://michael-whelan.net/bddfy-in-action/roll-your-own-testing-framework-2
  [15]: http://michael-whelan.net/bddfy-in-action/using-bddfy-for-unit-tests
  [16]: http://www.mehdi-khalili.com/bdd-simply-with-bddify
  [17]: https://github.com/TestStack/TestStack.BDDfy
  [18]: http://www.mehdi-khalili.com/get/blogpictures/bddify-in-action/intro/mstest-with-resharper.JPG
  [19]: http://dannorth.net/introducing-bdd/
  [20]: http://www.mehdi-khalili.com/get/blogpictures/bddify-in-action/intro/mstest-with-mstest-runner.JPG
  [21]: http://www.mehdi-khalili.com/get/blogpictures/bddify-in-action/intro/mstest-with-tdnet.JPG
  [22]: http://www.mehdi-khalili.com/get/blogpictures/bddify-in-action/intro/mstest-html-report.jpg
  [23]: http://nuget.org/packages/TestStack.BDDfy.samples
  [24]: http://dannorth.net/introducing-bdd/
  [25]: https://twitter.com/BDDfy
  [26]: http://teststack.github.com/TestStack.BDDfy/
  [27]: http://www.mehdi-khalili.com/bddify-moved-to-github-and-renamed-to-teststack-bddfy