--- cson
title: "Officially a nettuts author"
metaTitle: "Officially a nettuts author"
description: "I just published my first articles on nettuts about UI automation and am now officially a nettuts author"
revised: "2013-10-15"
date: "2013-10-15"
tags: ["NetTuts","Authoring"]

---
A while back I joined [nettuts](http://net.tutsplus.com/) *"a site aimed at web developers and designers offering tutorials and articles on technologies, skills and techniques to improve how you design and build websites"*. There are a group of very talented and skilled authors and developers writing at nettuts and it's great to be able to work with them. 

In the last few days my first articles were published: [Maintainable Automated UI Tests](http://net.tutsplus.com/tutorials/maintainable-automated-ui-tests/) and [Tips To Avoid Brittle UI Tests](http://net.tutsplus.com/tutorials/tools-and-tips/tips-to-avoid-brittle-ui-tests/).

##Maintainable Automated UI Tests
A few years ago I was very skeptical about automated UI testing and this skepticism was born out of a few failed attempts. I would write some automated UI tests for desktop or web applications and a few weeks later I would rip them out of the codebase because the cost of maintaining them was too high. So I thought that UI testing was hard and that, while it provided a lot of benefit, it was best to keep it to a minimum and only test the most complex workflows in a system through UI testing and leave the rest to unit tests. I remember telling my team about [Mike Cohn’s testing pyramid](http://www.mountaingoatsoftware.com/blog/the-forgotten-layer-of-the-test-automation-pyramid), and that in a typical system over 70% of the tests should be unit tests, around 5% UI tests and the rest integration tests. 

I was wrong! Sure, UI testing can be hard. It takes a fair bit of time to write UI tests properly. They are much slower and more brittle than unit tests because they cross class and process boundaries, they hit the browser, they involve UI elements (e.g. HTML, JavaScript) which are constantly changing, they hit the database, file system and potentially network services. If any of these moving parts don’t play nicely you have a broken test; but that’s also the beauty of UI tests: they test your system end-to-end. No other test gives you as much or as thorough coverage. Automated UI tests, if done right, could be the best elements in your regression suite.
So in the past few projects my UI tests have formed over 80% of my tests! I should also mention that these projects have mostly been CRUD applications with not much business logic and let’s face it – the vast majority of software projects fall into this category. The business logic should still be unit tested; but the rest of the application can be thoroughly tested through UI automation.

[Read more](http://net.tutsplus.com/tutorials/maintainable-automated-ui-tests/)

##Tips To Avoid Brittle UI Tests
In this article I discuss a few advanced topics that could help you write more robust tests, and troubleshoot them when they fail:

 * I discuss why adding fixed delays in UI tests is a bad idea and how you can get rid of them.
 * Browser automation frameworks target UI elements using selectors and it's very critical to use good selectors to avoid brittle tests. So I give you some advice on choosing right selectors and targeting elements directly when possible.
 * UI tests fail more frequently than other types of tests. So how can we debug a broken UI test and figure out what caused the failure? I show you how you can capture a screenshot and page's HTML source when a UI test fails so you can investigate it easier.

[Read more](http://net.tutsplus.com/tutorials/tools-and-tips/tips-to-avoid-brittle-ui-tests/)

##Future articles
I am currently working on an article about code generation using T4 templates. I have a few ideas about some future articles which I won't disclose until the posts are written and approved by nettuts editors.

Stay tuned.