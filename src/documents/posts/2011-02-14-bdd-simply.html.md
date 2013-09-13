--- cson
title: "BDD Simply"
metaTitle: "BDD Simply"
description: "In this article I discuss a simple technique that provides a rather decent result if you cannot or do not need to use a fully fledged BDD framework."
revised: "2011-10-20"
date: "2011-02-14"
tags: ["testing","bdd"]
migrated: "true"
resource: "/bdd-simply"
summary: """
In this post I discuss a simple technique that provides a rather decent result if you cannot or do not need to use a fully fledged BDD framework.
"""
---
BDD is a very interesting concept. It is amazing how much a rather small shift in mindset can provide such [a huge benefit][1]. If you have not heard about BDD or would like to refresh your understanding you may want to have a quick look at Dan North's article [here][2]. While you are at it, you may also read his article about [what is in a story][3]. I use one of the examples in his article for my code here.

This article is about a very simple technique I have used (and have seen used) in many projects; but I thought if you do not know BDD or have not used any of the frameworks then you would not know what you are gaining and what you are losing using this technique. So I decided to provide a list of some the frameworks along with tutorials and resources I have seen for your benefit.

###OSS BDD Frameworks
The frameworks in the alphabetic order are:

- [Bddify][4]: "A small yet powerful and extensible BDD framework for .Net developers.". You can find two articles about it [here][5] and [here][6].
- [MSpec][7]: Rob Conery has [a nice article][8] and [a very nice video][9] about it.
- [NBehave][10] I think is the oldest BDD framework in .Net. I used it back when it did not support separate spec/implementation. There is a rather old but nice article [here][11] on BDD using nBehave "the old" way; i.e. with spec and test implementation mixed.
- [SpecFlow][12]: "*a pragmatic and frictionless approach to Acceptance Test Driven Development and Behavior Driven Development for .NET projects*". [Here][13] I have an article about SpecFlow and how you can write executable requirements using it.
- [SpecUnit.Net][14]: "*Library supporting BDD-style use of xUnit testing frameworks in .NET*"
- [Storevil][15]: "*a natural language BDD tool for .NET*". I have not used this; but apparently this is the .Net equivalent of Cucumber.
- [StoryQ][16] "*is a portable (single dll), embedded BDD framework for .NET 3.5. It runs within your existing test runner and helps produce human-friendly test output (html or text)".

I apologize if you have a killer BDD framework I have not listed in this article. Please leave me a comment and I will add it to the list.

###BDD simply!
Ever since I started writing unit tests I had issues with unit test names. I tried all sorts of different ideas and settled for [a naming convention][17] by Roy Osherove. I used that convention for a while as it was better than some of the other alternatives; but it still left a lot to be desired.

That was until I learnt about BDD. The following implementation provides you with some of the benefits of BDD. It is not a fully fledged framework. Well, it is not a framework or even a library; just a very small class that could make your testing experience easier and could result in higher test quality.

I first saw this idea in [Fohjin][18] and then in [NSubstitute][19]. In fact a lot of open source projects use this idea.

For this sample I am using NUnit; but you may choose any other framework:

    [TestFixture]
    public abstract class SpecFor<T>
    {
        protected T Subject;

        [SetUp]
        public void Setup()
        {
            Subject = Given();    
            When();
        }

        protected abstract T Given();
        protected abstract void When();
    }

That is it! Let's use this and write some tests (or behaviors as called in BDD). 

    public class GivenTheCardIsDisabled_WhenTheAccountHolderRequestsMoney : SpecFor<Atm>
    {
        private Card _card;

        protected override Atm Given()
        {
            _card = new Card(false);
            return new Atm();
        }

        protected override void When()
        {
            Subject.RequestMoney(_card);
        }

        [Then]
        public void TheAtmShouldRetainTheCard()
        {
            Assert.That(Subject.CardIsRetained, Is.True);
        }

        [Then]
        public void TheAtmShouldSayTheCardHasBeenRetained()
        {
            Assert.That(Subject.Message, Is.EqualTo(DisplayMessage.CardIsRetained));
        }
    }

    public class Card
    {
        private readonly bool _enabled;

        public Card(bool enabled)
        {
            _enabled = enabled;
        }

        public bool Enabled
        {
            get { return _enabled; }
        }
    }

    public class Atm
    {
        public void RequestMoney(Card card)
        {
        }

        public bool CardIsRetained { get; private set; }

        public DisplayMessage Message { get; private set; }
    }

    public enum DisplayMessage
    {
        None = 0,
        CardIsRetained
    }

<small>The sample has a rather lame API because I did not want to complicate a sample about a testing class with dependency injection and isolation frameworks. </small>

Just in case you are wondering where that Then attribute came from I have simply defined it as:

    public class ThenAttribute : TestAttribute
    {
    }


If you run the tests using ReSharper you see a report created by R# showing the tests have failed:

![alt text][20]

Now let's implement the logic to pass the tests. My Atm class now looks like:

    public class Atm
    {
        public void RequestMoney(Card card)
        {
            if (!card.Enabled)
            {
                CardIsRetained = true;
                Message = DisplayMessage.CardIsRetained;
            }
        }

        public bool CardIsRetained { get; private set; }

        public DisplayMessage Message { get; private set; }
    }

and my tests now pass. Note that R# does not give me any report on the passed tests (on the html pane on the right hand side)!

![alt text][21]

The test hierarchy on the left is pretty good though. You can easily see your scenarios along with the verified expected results.

R# only reports the test name on the html pane when something is printed as part of the tests and that is why it reports the failure; because failure is printed to console. So let's change our SpecFor class to print something (half) useful: 

    [TestFixture]
    public abstract class SpecFor<T>
    {
        protected T Subject;

        [SetUp]
        public void Setup()
        {
            Console.WriteLine(typeof(T));
            Subject = Given();    
            When();
        }

        protected abstract T Given();
        protected abstract void When();
    }

The only difference is the addition of Console.WriteLine in the Setup method, and now the report looks like:

![alt text][22]

That is it. We have a very small class that helps us write more readable tests with half-decent reporting.

Obviously you do not need to have R# to get this result. You can use any other test runner and get the same result. In this case if you ran these tests with NUnit runner you would be able to see the name of the tests printed into the 'Text Output' tab.

###The same done in StoryQ
This is what the same behavior implemented in StoryQ would look like: 

    [TestFixture]
    public class CardHasBeenDisabled
    {
        private Card _card;
        private readonly Atm _atm = new Atm();
        private readonly Story _story = new Story("Account Holder withdraws cash");

        [Test]
        public void MoneyWithdrawalBehavior()
        {
            _story
                .InOrderTo("have access to my money")
                .AsA("Account Holder")
                .IWant("to withdraw cash from an ATM")
                .WithScenario("Card has been disabled")
                .Given(CardIsDisabled)
                .When(TheAccountHolderRequestsMoney)
                .Then(TheAtmShouldRetainTheCard)
                .And(TheAtmShouldSayTheCardHasBeenRetained)
                .Execute();
        }

        private void TheAtmShouldSayTheCardHasBeenRetained()
        {
            Assert.That(_atm.Message, Is.EqualTo(DisplayMessage.CardIsRetained));
        }

        private void TheAtmShouldRetainTheCard()
        {
            Assert.That(_atm.CardIsRetained, Is.True);
        }

        private void TheAccountHolderRequestsMoney()
        {
            _atm.RequestMoney(_card);
        }

        private void CardIsDisabled()
        {
            _card = new Card(false);
        }
    }

<small>I will provide similar samples in some of the other mentioned frameworks in another post.</small>

All you need to do to get this compiled and working is to reference StoryQ.dll in your test project, and the result beautifully gets printed as:

![alt text][23]

<small>Again, you do not need R# to run these tests and get this report.</small>

Very nice indeed. Nicety aside, this is far more readable if you use these reports as your requirements and/or present these result to BAs to get confirmation on implemented behaviors.

Another difference between the SpecFor and StoryQ implementations is that with our small SpecFor class we would typically get a class per scenario. That is how we get our readable report from R#. With StoryQ, though, there is one class per story and one test per scenario. 

###When would I use SpecFor?
I know SpecFor is not as shiny and brilliant as a fully fledged BDD framework. This does not allow you to separate the spec definition and implementation either; but I would still use this simple implementation in a few situations:

 - In a project where developers are not quite familiar with BDD and are feeling comfortable with the old unit testing style. This technique could bridge the unfamiliarity gap: developers will still use their existing knowledge and framework; but they can now write more readable and maintainable tests and get exposed to BDD.
 - When separating spec and implementation is not required and indented html reports are not necessary. There are times when you do not gain much by using a real BDD framework. An example of that is a small team of developers working on a rather small project. Another example is when the requirements are not very complex and there are not many bugs caused by misinterpretation of requirements. I have a post coming up about this.
 - When there is a resistance against using OSS projects or introducing external dependencies.

###Conclusion
Sometimes the separation of spec and test implementation provides a lot of benefit; and sometimes it does not. Sometimes using a real BDD framework helps avoid some issues in software team, and sometimes it is not that critical.

You can use some of the more advanced frameworks out there and get a very nice result, and when you cannot or you do not need to you may just stick with the simple SpecFor implementation and still make huge improvements on your tests quality.

One size does not fit all - choose the one that suits your needs.

Hope this helps.


  [1]: /bdd-to-the-rescue
  [2]: http://dannorth.net/introducing-bdd/
  [3]: http://dannorth.net/whats-in-a-story/
  [4]: https://code.google.com/p/bddify/
  [5]: /introducing-bddify-framework
  [6]: /extending-bddify
  [7]: https://github.com/machine/machine.specifications
  [8]: http://blog.wekeroad.com/blog/make-bdd-your-bff-2/
  [9]: http://blog.wekeroad.com/2009/05/14/kona-3
  [10]: http://nbehave.org/
  [11]: http://www.codeproject.com/KB/testing/bddnbehave.aspx
  [12]: http://www.specflow.org/
  [13]: /executable-requirements
  [14]: http://code.google.com/p/specunit-net/
  [15]: https://github.com/davidmfoley/storevil
  [16]: http://storyq.codeplex.com/
  [17]: http://www.osherove.com/blog/2005/4/3/naming-standards-for-unit-tests.html
  [18]: https://github.com/MarkNijhof/Fohjin
  [19]: https://github.com/nsubstitute/NSubstitute
  [20]: /get/BlogPictures/bdd-simply/failed-tests.JPG
  [21]: /get/BlogPictures/bdd-simply/passed-tests-without-report.JPG
  [22]: /get/BlogPictures/bdd-simply/passed-tests-with-report.JPG
  [23]: /get/BlogPictures/bdd-simply/storyQ-result.JPG