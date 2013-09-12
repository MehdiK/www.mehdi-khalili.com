--- cson
title: "Zero tolerance on broken windows"
metaTitle: "Zero tolerance on broken windows"
description: "Broken windows in software are dangerous and contagious and the best way to deal with them is usually zero tolerance"
revised: "2013-03-12"
date: "2011-12-02"
tags: ["quality","team"]
migrated: "true"
urls: ["/zero-tolerance-on-broken-windows"]
summary: """
Broken windows in software are dangerous and contagious and the best way to deal with them is usually zero tolerance
"""
---
[Broken windows][1] in software are dangerous. In the long run they severely impact the quality and maintainability of codebase and the longer you tolerate them the worse they and your codebase become. 

The best way to deal with broken windows in software is zero tolerance when it makes sense. No one likes broken windows and we all like to work on a cleaner codebase; but sometimes it just seems so hard to maintain a clean state. That said, I have faced broken windows in several projects and every time when I asked developers how they would feel if we enforced [zero tolerance][2], they accepted it very happily! 

There are many broken windows in software; but below I list a few more common ones and the way I deal with them:

##Broken tests
The problem with broken tests (like any other broken window) is that they are highly contagious. You cannot easily differentiate between 1, 10 and 100 broken tests if they all turn your test suite (or your build) red: if your test suite is broken for a while you get insensitive about it and when your changes break another test you just will not notice (or god forbid care about) it. This results into higher and higher number of broken tests.

![Broken tests][3]

The best way to deal with broken tests is to remove them, period. The test that has been broken for a month is not really providing any value; so you may as well remove it. That said, do not take immediate action on it and take it slowly if you want real result. 

For me it usually starts one morning when I am fed up with broken tests and I turn red :) I then explain the seriousness of the issue and ask the developers to fix their tests within a fixed period depending on the work load and the number of broken tests. At the end of the period the tests that are still red will be removed and from that point forward: 

 - I force the test run as part of CI so a broken test breaks the build. This reinforces the seriousness of broken tests. Even better when my CI server supports it I activate '[Pretested Commits][4]' (AKA [Gated Check-ins][5] in some CI servers) so developers cannot actually check-in until their code integrates on the server, builds and all the (unit) tests succeed. This however can be applied only to fast tests because you do not want to wait 10 minutes (or an hour in case of an extensive functional test suite) every time you check-in. 
 - For slower tests the above process will not work. In this case I will setup slower tests to run in an automated fashion on a regular basis - say twice a day, and when a test is broken it should be fixed ASAP as if it broke the build.

It only takes a week or so for this process to become second nature for the team and over time it just becomes less and less useful because developers find the value of green suite and just will not let it wreck. Even then it is still a good idea to keep the strict process in place so those old habits or new developers do not get a chance ;-)

<small>The only thing that can be worse than broken tests are broken build; but I would not call broken build a broken window: if your build is usually broken then you have a much bigger problem!</small>

##Warnings
Build warnings are not quite as severe as broken tests; however if you ignore 10 build warnings soon you will end up with hundreds. A while back I worked on a project where there were over a thousand build warnings.

Again the best way to deal with these is zero tolerance. Give programmers some time to fix all the warnings and then change the build configuration to treat warnings as errors. This stops any future warning from creeping into your codebase as they would just break the build.

If some of the warnings in your codebase cannot be resolved, for example warnings from third party libraries, then note down the number of warnings and keep a close eye on that number. The number should never increase. This can be easily enforced through code reviews and [check-in dance][6].

##ToDos
Again your list of ToDos in your codebase could grow beyond maintainability very easily if you do not pay attention to it. Sometimes I go through ToDos (using R# To-Do explorer) and find out that many of the To-Dos no longer apply: it has been there for so long that either the requirement has changed or the need has become obsolete!! If a To-Do can live for that long without you doing anything for it, then is it really a To-Do??! I mean you put it there so you can fix an issue in your codebase or pay a technical debt; but if you are not doing anything about it then why is there? 

Do not get me wrong. I am a huge fan of To-Dos and I use them frequently as a productivity tool; e.g. I am working on something and I come across an edge case or a refactoring need or an ugly code and I do not want to be distracted from what I am doing; so I will just leave a To-Do there so I can come back to it after I am done with my current task. So you cannot really get as strict about To-Dos as you do with broken tests and build warnings because they are required and they should live there. In other words you cannot really enforce zero-tolerance or you will lose a good tool from your productivity toolbox.

I think the best way to deal with To-Dos is to tag them with the date you are writing them so next time you or someone else come across them you know how long it has been there. If it has been there for a while then it should either be prioritized and dealt with or if it is not even worth prioritizing then it should be removed.

###Conclusion
Do not let a simple broken window turn your codebase into an unmaintainable nightmare. Spot it and deal with it and when fixed enforce zero tolerance to avoid future instances.

In this post I talked about three common broken windows in software: broken tests, build warnings and ever growing list of to-dos. These are not the only ones: we should never forget technical debt or we will end up with a [BBoM][7]. Dealing with technical debt however is very tricky. While we can very easily enforce zero tolerance on broken builds and build warnings, technical debt is not quite as measurable and cannot be enforced through tooling as easily and effectively. Also [there are some rare cases][8] where it makes sense to have technical debt. 

Another example of a broken window is obsolete and/or out of sync comments which are very common too. Again it is not easy to enforce zero tolerance on that; but you should clean it up as you come across it. 

The bottom-line is that if you find a broken window in your codebase escalate it with your team and deal with it sooner than later. If it is possible and it makes sense to enforce zero tolerance on it, then by all means do it before it spreads throughout your codebase.

Also if you think you cannot enforce it because other programmers in your team will not agree with you, then you are (most likely) wrong. Every time I have proposed and enforced zero tolerance I have seen happier faces in my team. If you want a healthy team and a healthy codebase, then do not tolerate broken windows.


  [1]: http://www.codinghorror.com/blog/2005/06/the-broken-window-theory.html
  [2]: http://en.wikipedia.org/wiki/Zero_tolerance
  [3]: http://www.mehdi-khalili.com/get/blogpictures/broken-windows/broken-tests.JPG
  [4]: http://www.jetbrains.com/teamcity/features/delayed_commit.html
  [5]: http://msdn.microsoft.com/en-us/library/dd787631.aspx
  [6]: http://www.mehdi-khalili.com/mitigate-your-merge-issues
  [7]: http://c2.com/cgi/wiki?BigBallOfMud
  [8]: http://www.mehdi-khalili.com/bad-code