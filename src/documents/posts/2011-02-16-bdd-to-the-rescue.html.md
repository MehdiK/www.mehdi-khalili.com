--- cson
title: "BDD to the rescue"
metaTitle: "BDD to the rescue"
description: "BDD removes the ambiguity from the requirements; but taking it a step further could provide a lot of other benefits."
revised: "2012-08-21"
date: "2011-02-16"
tags: ["testing","bdd"]
migrated: "true"
resource: "/bdd-to-the-rescue"
summary: """
BDD can help you in more than one way. First and foremost it removes the ambiguity from the requirements; but taking it a step further could give you a lot of significant benefits.
"""
---
Programmers are not best at communicating. It is even beautifully argued that "*[Sometimes, The Better You Program, The Worse You Communicate][1]*".

###My favorite programmers' joke
<p>
A woman asks her husband, a programmer, to go shopping: “Dear, please, go to the nearby grocery store to buy some bread. Also, if they have eggs, buy 6.”  <br />
Husband: “O.K., hun.”. Twenty minutes later the husband comes back bringing 6 loaves of bread. His wife is flabbergasted. <br />
Wife: “Dear, why on earth did you buy 6 loaves of bread?” <br />
Husband: “They had eggs.”
</p>

We, programmers, misinterpret requirements and effectively make silly mistakes. We also get ambiguous and prone to misinterpretation requirements a lot. I do not think it is far from reality to say that the majority of bugs are related to miscommunication and/or misinterpretation of requirements; but how can we avoid these issues?

###BDD to the rescue
[BDD][2] is very helpful for communicating requirements effectively. It brings a mutually understandable structure to communication between programmers and business people and helps communicate with less ambiguity (and frustration). This is what we have been failing to do effectively for years.

Some of the benefits of BDD are:

####1. Getting verification from BAs and testers earlier and more effectively in SDLC
With Waterfall the verification step is at the very end of the project when things could have gone wrong so badly. We use Agile and iterative approach to bring that verification into the development and typically at the end of each iteration. We use short iterations/sprints to make sure we are on the track and to get early feedback frequently. With BDD you can bring most of that verification to the beginning of a sprint. You start verifying the feature before you start implementing it. It is kind of like TDD on steroids!

Without BDD, even if you are doing TDD, the following scenario is not so uncommon: BA provides some requirements, developers read and "understand" the requirements, they (may) write some tests, and they code the feature (and may do some refactoring). Then the result is presented to BA only to find out that the whole thing is wrong due to misinterpretation. This is to be expected though. The developer writes tests based on his/her understanding of the requirements and then writes code to pass those tests. When the requirements are miscommunicated and/or misinterpreted these tests are not going to help. On the contrary they are going to provide confidence in an incorrect understanding! You write incorrect tests to assert incorrect understanding and you write incorrect code to pass incorrect tests. At the end, your code looks beautiful and your tests pass; and yet you have got everything wrong!

So we need to make sure we do not misinterpret the requirements. BDD language helps us do just that. Even better would be to also get someone else to write the tests for you. I think the best person to do that is the person who writes the requirement or is going to eventually verify the implemented feature - that is BAs or testers.

Using BDD we could verify the requirements before writing any code (or even write [executable requirements][3]). This way your code is tested properly and under correct assumption and you know you are passing the right assertions. 

####2. Automated regression suite defined by BAs
So you got your requirements right and you are coding against tests defined by someone else. That is pretty sweet. What is sweeter is that the moment you implement the feature those tests turn into an automated regression suite. This is not necessarily related to BDD as such and any test first methodology provides this; but BDD tests, due to their abstract and high level nature, tend to cover the system in ways that would be very hard using traditional unit tests. BDD really shines when you use it to implement Automated UI Tests. I have talked about this a few times [here][4] and [here][5].

Sure this regression suite will not replace manual testing; but it removes the need for a lot of repetitive and mindless manual tests.

####3. Always up-to-date software requirements 
One of the issues of having separate requirements document is that they tend to go out of sync with code. A feature is written based on some requirements document, and while the code changes, the requirements document typically does not. You can put a lot of effort into having an always up-to-date requirement; but many of the efforts I have seen have been rather unsuccessful even when hours and hours is spent trying to keep the two in sync.

If you do BDD all the way through, there will not be any feature in your system without a set of BDD tests and those tests work as [executable software requirements][6] that results into living documentation. The requirement cannot go out of sync because if the spec or the code change, tests will break. In effect BDD tests work as a synchronization mechanism between requirements and code. If needed, you can also print the BDD test report in a very readable and software-specification-like format.

####4. YAGNI
With BDD you code to pass the BDD specs and you are done when you get a green test. This way you can more easily avoid the violation of [YAGNI][7] from the feature point of view. This does not prevent you from writing unneeded infrastructure though.

Many times YAGNI is violated because we are not sure based on the written document whether something is needed or not. With BDD we get more certainty on what is needed and what is not. So it helps avoid some of the uncertainty and as a result unneeded code. BDD does not prevent the violation of YAGNI; but it helps.

####5. Asserting on the fly 
In some cases you do not need to write a new test to assert a different form of a requirement you have already implemented. If the BDD framework you are using supports separate feature file and argument matching then you can assert for new inputs without touching the test or code. NBehave, SpecFlow and StorEvil allow that.


  [1]: http://secretgeek.net/program_communicate_4reasons.asp
  [2]: http://dannorth.net/introducing-bdd/
  [3]: /executable-requirements
  [4]: /presentations/automated-ui-testing-done-right-at-dddsydney
  [5]: /presentations/auit-qmsdnug
  [6]: /executable-requirements
  [7]: http://c2.com/xp/YouArentGonnaNeedIt.html