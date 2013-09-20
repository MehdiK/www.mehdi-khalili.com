--- cson
title: "Automated UI Testing Done Right"
metaTitle: "Automated UI Testing Done Right"
description: "Come along to DDDSydney to see how you can do Automated UI Testing Done Right"
revised: "2012-06-29"
date: "2012-06-20"
tags: ["oss","testing","seleno","presentations"]
migrated: "true"
resource: "/presentations/automated-ui-testing-done-right-at-dddsydney"
summary: """
I am giving a talk at DDDSydney called Automated UI Testing Done Right. Come along to see how you can make your UI tests easier to write and maintain
"""
---

**[Update 2013-05-03]: [SSWTV](http://tv.ssw.com/) kindly recorded this session. The video of this session is available from [here](http://tv.ssw.com/3444/ddd-sydney-2012-mehdi-khalili-automated-ui-testing-done-right).**

I will be speaking at [DDDSydney][1] on 30th of June. You may find the details of the conference and the info about the sessions and the timetable [here][2]. If you have not purchased your ticket yet, then leave me a comment or send me a message on [@MehdiKhalili][3] to arrange a discounted ticket.

My talk is called Automated UI Testing Done Right and you may find more info about it [here][4]. 

###Background
Two years ago I was very sceptical about automated UI testing. I had some painful experience with it because while writing the tests seemed relatively easy, maintaining them would become harder and harder over time to the point where it was impractical to maintain.

Over the past year or so, I have been investing more in Automated UI Testing. I have had some discussions with guys at Readify about ways to do it better. Michael Whelan, my partner in crime for [BDDfy][5], had also been going through a similar journey, although he was ahead of me. So we started sharing notes and talking about UI testing, and a few ideas started popping up. Some of the videos from the last [SeleniumConf][6] were really insightful too. We used these ideas and patterns in some personal and work related projects; but then we thought we may formalize these ideas and patterns and turn it into a framework so others will not have to go through the same pain. 

A while back I mentioned a [BDDfy has moved to GitHub][7] and is now part of a test family called TestStack. Now there is a new cool kid on the TestStack block. It is called [Seleno][8] (thanks [Russ Blake][9] for the name).

###Introducing Seleno
Seleno, a framework currently written on top of [Selenium][10], helps you have a better experience in Automated UI Testing. The ideas and patterns used in Seleno are not necessarily all new: we have implemented some of the most popular UI testing patterns like Page Object and Page Component. The framework also leverages some of the power of ASP.Net MVC framework to provide strongly typed Page Objects. You may have a look at the [project homepage][11] for more info.

I am not going to go through the API or feature set now as it is still under (aggressive) construction and everything I write here is going to be obsolete in a few months; but you may access the code [here][12]. The framework is also available for download from nuget:

<code style="background-color: #202020;border: 4px solid silver;border-radius: 5px;-moz-border-radius: 5px;-webkit-border-radius: 5px;box-shadow: 2px 2px 3px #6e6e6e;color: #E2E2E2;display: block;font: 1.5em 'andale mono', 'lucida console', monospace;line-height: 1.5em;overflow: auto;padding: 15px;
">PM&gt; Install-Package TestStack.Seleno
</code>

###Automated UI Testing Done Right
... back to my DDDSydney session. The session is about Automated UI Testing Done Right and through out the session I talk about some of the patterns that you can use to improve the maintainability of your UI tests. The session starts with a horrible test which is very typical when teams start doing UI testing. The test looks something like:

    // much of the code has been removed for brevity
    public void Can_buy_an_Album_when_registered()
    {
        _driver.Navigate().GoToUrl(Application.HomePage.Url);
        _driver.FindElement(By.LinkText("Disco")).Click();
        _driver.FindElement(By.CssSelector("img[alt=\"Le Freak\"]")).Click();
        _driver.FindElement(By.LinkText("Add to cart")).Click();
        _driver.FindElement(By.LinkText("Checkout >>")).Click();
        _driver.FindElement(By.Id("FirstName")).Clear();
        _driver.FindElement(By.Id("FirstName")).SendKeys("Homer");
        _driver.FindElement(By.Id("LastName")).Clear();
        _driver.FindElement(By.Id("LastName")).SendKeys("Simpson");
        _driver.FindElement(By.Id("Address")).Clear();
        _driver.FindElement(By.Id("Address")).SendKeys("742 Evergreen Terrace");
        _driver.FindElement(By.Id("City")).Clear();
        _driver.FindElement(By.Id("City")).SendKeys("Springfield");
        _driver.FindElement(By.Id("State")).Clear();
        _driver.FindElement(By.Id("State")).SendKeys("Kentucky");
        _driver.FindElement(By.Id("Email")).Clear();
        _driver.FindElement(By.Id("Email")).SendKeys("chunkylover53@aol.com");
        _driver.FindElement(By.Id("PromoCode")).Clear();
        _driver.FindElement(By.Id("PromoCode")).SendKeys("FREE");
        _driver.FindElement(By.CssSelector("input[type=\"submit\"]")).Click();
    
        Assert.IsTrue(_driver.PageSource.Contains("Checkout Complete"));
    }

*Trivia - did you know that The Simpsons live in Kentucky!? ;-)*

I then turn that test into a very maintainable test in three steps. The result of the third step looks something like:

    public void Can_buy_an_Album_when_registered()
    {
        var orderedPage = Application
            .HomePage
            .Menu
            .GoToAdminForAnonymousUser()
            .GoToRegisterPage()
            .CreateValidUser(ObjectMother.ValidUser)
            .GenreMenu
            .SelectGenreByName("Disco")
            .SelectAlbumByName("Le Freak")
            .AddAlbumToCart()
            .Checkout()
            .SubmitShippingInfo(ObjectMother.ShippingInfo, "Free");
    
        orderedPage.Title.Should().Be("Checkout Complete");
    }

At the end of the session I will also provide some pro-tips on what to do and what not to do. These are based on the lessons Michael and I have learnt in the past year or so. There is also a bonus forth step which helps turn your awesome test into a living documentation for your system. 

Although I am using Seleno, BDDfy and Selenium in the talk, it is very important to note that the ideas, patterns and tips mentioned in the talk are not related to any particular UI or UI testing frameworks or even web testing. So you can use the same ideas and patterns to test your website or desktop or mobile application using your UI testing framework of choice. For example I have applied similar patterns for testing a WPF desktop application using Microsoft Coded UI Test.

The samples used in the talk are directly out of the Seleno code-base. The samples are structured in a way to make it easy to read and follow and you should be able to easily compare the steps to see how each step improves the tests. 

![Screenshot of the solution structure with step folders][13]

*There is a file in the FunctionalTests project called `BrittleTests` and then there is one folder per step* 

You may download the zip from [here][14] or clone the framework on [GitHub][15]. 

<div style="width:425px" id="__ss_13493067"><strong style="display:block;margin:12px 0 4px"><a href="http://www.slideshare.net/MehdiKhalili/automated-ui-testing-done-right-13493067" title="Automated UI testing done right!">Automated UI testing done right!</a></strong><object id="__sse13493067" width="425" height="355"><param name="movie" value="http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=auit-120629055816-phpapp01&stripped_title=automated-ui-testing-done-right-13493067&userName=MehdiKhalili" /><param name="allowFullScreen" value="true"/><param name="allowScriptAccess" value="always"/><param name="wmode" value="transparent"/><embed name="__sse13493067" src="http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=auit-120629055816-phpapp01&stripped_title=automated-ui-testing-done-right-13493067&userName=MehdiKhalili" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" wmode="transparent" width="425" height="355"></embed></object><div style="padding:5px 0 12px">View more <a href="http://www.slideshare.net/">presentations</a> from <a href="http://www.slideshare.net/MehdiKhalili">Mehdi Khalili</a>.</div></div>

If you like what you see, come along for the session. There are quite a few tips and tricks to be learnt.

Any ideas, comments, feedback and suggestions about the framework is welcome. 


  [1]: http://www.eventbrite.com/event/3366694875
  [2]: http://lanyrd.com/2012/dddsydney/schedule/
  [3]: https://twitter.com/#!/MehdiKhalili
  [4]: http://lanyrd.com/2012/dddsydney/strqy/
  [5]: http://teststack.github.com/TestStack.BDDfy/
  [6]: http://www.seleniumconf.org/
  [7]: /bddify-moved-to-github-and-renamed-to-teststack-bddfy
  [8]: http://teststack.github.com/TestStack.Seleno/
  [9]: http://www.linkedin.com/in/russblake
  [10]: http://seleniumhq.org/
  [11]: http://teststack.github.com/TestStack.Seleno/
  [12]: https://github.com/TestStack/TestStack.Seleno
  [13]: /get/BlogPictures/dddsydney/Seleno.png
  [14]: https://github.com/TestStack/TestStack.Seleno/zipball/master
  [15]: https://github.com/TestStack/TestStack.Seleno
