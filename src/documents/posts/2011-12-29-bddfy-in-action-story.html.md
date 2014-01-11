--- cson
title: "Story in BDDfy"
metaTitle: "Story in BDDfy"
description: "We wrote a simple scenario in the previous post; but how can we write a user story using BDDfy?"
revised: "2013-08-10"
date: "2011-12-29"
tags: ["BDDfy"]
migrated: "true"
resource: "/bddify-in-action/story"
summary: """
We wrote a simple scenario in the <a href=\"/bddify-in-action/method-name-conventions\">previous post</a>; but how can we write a user story using BDDfy?
"""
---
**[Update - 2013-08-10] BDDfy is now part of [TestStack](http://teststack.net) organization. So this article has been ported to and is superseded by [this post](http://docs.teststack.net/BDDfy/Usage/Story.html) on the [documentation website](http://docs.teststack.net/).**

**This is the third article in the ['BDDfy In Action' series][1]. It is recommended to read this series in the presented order because I use some of the references provided in the previous articles.**

You can download the code used in this article from [here][2].

In this post we will discuss how you can add story support to your BDD behaviors.
As mentioned before and as we saw in the [previous post][3] BDDfy does not force you to use stories. This could be quite useful for teams that do not work in an Agile environment. Forcing developers to come up with a story definition, while I believe is useful in many cases, could be less than optimal in some situations. For this reason you can <code>BDDfy</code> a scenario without associating it with a story; but that is more of an exception than a rule. So let’s see how you can create stories and associate them with some scenarios.

##How to create a story definition?
In BDDfy for everything you want to do there are several options; there is one exception to this and that is defining stories. There is only one way to define a story and it is quite simple: to define a story all you need to do is to decorate a class, any class anywhere in your solution, with a <code>StoryAttribute</code>. Doing so creates a story that you can then associate with your scenarios. Here is an example of a story:

<pre>
namespace BDDfy.Story
{
    [Story(
        AsA = "As a .net programmer",
        IWant = "I want to use BDDfy",
        SoThat = "So that BDD becomes easy and fun")]
    public class BddfyRocks
    {
    }
}
</pre>

All I have here is a class decorated with a <code>Story</code> attribute. By decorating this class you have setup your story metadata once and forever so you will not have to repeat this info for every scenario.

##So how do I associate a story with a scenario?
There are two ways to achieve this:

###1. Let BDDfy find the association!
BDDfy can associate a story with a scenario if the scenario is bddified in a method defined in the story class. 

Let's write a scenario:

<pre>
namespace BDDfy.Story
{
    public class ShouldBeAbleToBddfyMyTestsVeryEasily
    {
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

Please note that there is nothing related to BDDfy in this class. It is just a Plain Old C# Class which will eventually have some assertions in it. I can then BDDfy this scenario from my story class like:

<pre>
using BDDfy.Core;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BDDfy.Story
{
    [TestClass]
    [Story(
        AsA = "As a .net programmer",
        IWant = "I want to use BDDfy",
        SoThat = "So that BDD becomes easy and fun")]
    public class BddfyRocks
    {
        [TestMethod]
        public void LetBddfyFindTheStory()
        {
            new ShouldBeAbleToBddfyMyTestsVeryEasily().BDDfy();
        }
    }
}
</pre>

There are a few changes here:

 - I added MSTest and BDDfy namespaces on the top.
 - Decorated the story class with TestClass. This is an MSTest requirement.
 - Created a new method which is my scenario and instantiated and bddified my scenario from within the method.

Let's run our only test with R#:

![Let BDDfy find the story][4]

If you compare this to the similar test we ran in the previous post you notice that this report shows a story on the top. The story details are picked up from the <code>StoryAttribute</code> on the class. 

And as you would expect the story details will appear in the html report too:

![Html report with story][5]

In the html report scenarios will be categorized by their stories. You can also expand or collapse them by clicking on them or by clicking on the expand all and collapse all which will expand and collapse them all respectively.

... but how does BDDfy know how to associate the story with the scenario? At runtime BDDfy walks up the stack trace until it finds your test method and then finds the declaring class and checks to see if it is decorated with a <code>StoryAttribute</code> and if yes it associates the two. This brings us to the next approach of associating the stories and scenarios which is the recommended approach; but before going further I would like to ask you to read [this article][6] about the intricacy of stack trace. I will wait here until you read that.

Read it?! At runtime JIT may decide to flatten a few method calls and for that reason BDDfy may or may not be able to find your story class. Basically if you are running or intending to ever run your tests in release mode then you must use the second approach.

###2. Tell BDDfy which story to use!
If you may run your tests in release mode, to avoid disappointment, you may want to explicitly associate a story with a scenario. This approach has some other advantages that I will explain shortly.

In order to specify the story you should use an overload of <code>BDDfy</code> method which accepts a type argument for story. Here is the same example but using this overload:

<pre>
using BDDfy.Core;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BDDfy.Story
{
    [TestClass]
    [Story(
        AsA = "As a .net programmer",
        IWant = "I want to use BDDfy",
        SoThat = "So that BDD becomes easy and fun")]
    public class BddfyRocks
    {
        [TestMethod]
        public void TellBddfyWhatStoryToUse()
        {
            new ShouldBeAbleToBddfyMyTestsVeryEasily().BDDfy&lt;BddfyRocks&gt;();
        }
    }
}

</pre>

The only difference here is that I am passing <code>BDDfyRocks</code> type as a type argument to the <code>BDDfy()</code> method. This runs the very same steps and provides the very same report as we saw above; except that this method is guaranteed to find the story regardless of your build configuration or CPU architecture.

##How can I override the story title?
By default BDDfy turns your story class name into the title for the story which  appears in the reports. For example <code>BDDfyRocks</code> is turned into 'BDDfy rocks'. For what it is worth, the same logic is used to drive scenario and step titles.

In the previous post we overrode a scenario title by passing the custom title into the <code>BDDfy()</code> method; but how can we override the story title? It is very simple: <code>StoryAttribute</code> has a <code>Title</code> property that you can set. If you leave that property alone BDDfy uses your story class name for the title; but if you set it, that value is used instead. 

As an example to override the title of the <code>BDDfyRocks</code> story we can set the title as follows:

<pre>
[Story(
   Title = "Setting the story title is very easy",
   AsA = "As a .net programmer",
   IWant = "I want to use BDDfy",
   SoThat = "So that BDD becomes easy and fun")]
public class BDDfyRocks
{
}
</pre>

##How can I reuse the same story for scenarios in different projects?
This is the only question I get asked every now and then about using stories. This usually happens when there are more than one test project in the solution and two tests/behaviors in two different projects happen to be related to the same story. This is where the second approach shines. When specifying the story in the <code>BDDfy()</code> the framework does not really care whether your scenario is being run within the story or is in the same class or in the same project. It is happy as long as it can see the story (which means as long as your code compiles).

As an example the same scenario above could be written as (assuming that <code>AScenarioRunFromAnotherProject</code> lives in a different project):

<pre>
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BDDfy.Story
{
    [TestClass]
    public class AScenarioRunFromAnotherProject
    {
        [TestMethod]
        public void TellBDDfyWhatStoryToUse()
        {
            new ShouldBeAbleToBDDfyMyTestsVeryEasily().BDDfy&lt;BDDfyRocks&gt;();
        }
    }
}
</pre>

This works the exact same way as if the story is defined in the same project or on the same class.

##Conclusion
In this post we discussed how you can define a story and associate it with a scenario.

You can download the code used in this article from [here][7].

Hope this helps.


  [1]: /bddify-in-action/introduction
  [2]: /get/Downloads/bddify-in-action/Bddify.Story.zip
  [3]: /bddify-in-action/method-name-conventions
  [4]: /get/BlogPictures/bddify-in-action/story/let-bddify-find-the-story.JPG
  [5]: /get/BlogPictures/bddify-in-action/story/separate-story-html-report.JPG
  [6]: /that-tricky-stacktrace
  [7]: /get/Downloads/bddify-in-action/Bddify.Story.zip