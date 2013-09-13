--- cson
title: "ORM anti-pattern series"
metaTitle: "ORM anti-pattern series"
description: "Due to their convenience developers tend to use ORM frameworks everywhere possible leading to a lot of issues."
revised: "2011-02-12"
date: "2011-01-04"
tags: ["anti-patterns","orm"]
migrated: "true"
resource: "/orm-anti-patterns-series"
summary: """
In this series I will try to cover some of the ORM anti-patterns I have come across. Most of these issues have huge impact on your project architecture, maintainability, user experience, database and network load. Some could complicate your project to the point of paralysis.

Hopefully this series will help you to avoid some of these issues and to make better decisions when using an ORM.
"""
---
We as developers tend to apply the same techniques to solve every problem thrown at us. We learn a new design pattern and all of a sudden that pattern is all over our codebase. We find a new way of writing code and we apply it wherever we can because we are very excited about it or because it feels like it could simplify our solution.

In the past few years, particularly in .Net space, there has been a lot of excitement about ORMs, and when we get excited about something we overuse it. There are scenarios where using ORM is not a good idea, and there are common ORM anti-patterns that could severely impact the project architecture, maintainability, user experience and database and network load. In this series I will try to cover issues I have come across as well as their solution. In this series I am not going to show you how to use a particular ORM and you may not even see any code. I assume that you know your ORM; however, I will try to provide some links to ORM related patterns for those not familiar with inner workings of one.

Below is the list of articles in no particular order:

 - [Part 1: Active Record][1]
 - [Part 2: Batch operations][2]
 - [Part 3: Lazy loading][3]
 - [Part 4: Persistence Model VS Domain Model][4]
 - [Part 5: Generic Update Methods][5]
 - Part x: Confusing persistence model with presentation model
 - Part x: Using ORMs for reporting
 - Part x: Long running Unit of Works
 - Part x: Database first

Never ever one size fits all and this applies to my solutions explained as part of this series. Think about your problem, your requirements and your constraints, know your choices and make an informed decision.


###Are these really anti-patterns or am I over-designing?
I call these anti-patterns only because they are used where they should not be and because I see them used incorrectly very frequently. In other words, some of these patterns are used as one-size-fits-all and are thrown at any and all persistence problems without any thought. I have used and will use some of these patterns in my code if they fit my requirements/context. 

This series is about issues I have with these patterns; so I am going to do my best to highlight their issues. That said, I will also try to explain where each pattern fits.


  [1]: /orm-anti-patterns-part-1-active-record
  [2]: /orm-anti-patterns-part-2-batch-operations
  [3]: /orm-anti-patterns-part-3-lazy-loading
  [4]: /orm-anti-patterns-part-4-persistence-domain-model
  [5]: /orm-anti-patterns-part-5-generic-update-methods