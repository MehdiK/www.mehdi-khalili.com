--- cson
title: "How to make a bug more easily reproducible"
metaTitle: "How to make a bug more easily reproducible"
description: "We should not work on a bug without a good understanding of it or being able to reproduce it.
"
revised: "2011-01-28"
date: "2010-12-26"
tags: ["communication","debugging"]
migrated: "true"
urls: ["/bug-fixing-help-reproduce-a-bug"]
summary: """
The first step to fix a bug is to understand and then reproduce it. Even though it sounds like a very easy step it could take a lot of time. Also sometimes a bug is closed because you and the person who raised it just cannot reproduce it, or even worse due to misinterpretation instead of fixing the bug you regress the code and introduce another bug. 

In this article I will try to explain some of the ways I have found useful in understanding and reproducing bugs and then later to make sure the bug is fixed.
"""
---
You cannot fix a bug unless you can reproduce it consistently. Reproducing a bug sounds very simple; but it amazes me how much time is spent on it. In this post I will try to explain a few simple things that could make the bug fixing "experience" simpler for everyone in the team. 

##Problems
The following is the list of problems I would like to discuss in this article:

###"Fixing" the wrong thing
Sometimes we misunderstand the issue and try to fix the wrong thing. Sounds silly, does not it? But this has happened to me and people I have worked with so many times. A ticket is raised. We read the description, have a look at the code and the application behavior and "find" what is wrong with it and "fix" it. Not only we did not fix the actual bug; but we also regressed a potentially working piece of code. It is a very serious and common issue. It could lead to a situation where users/QA are afraid of raising tickets because for every ticket they raise they could get a few new bugs into the system! Even worse, the actual problem could still live there. 

###Not knowing how to test a ticket flagged as 'fixed'
Here is a scenario I have seen so many times: a user raises a ticket, the ticket is later flagged as 'fixed' and has come back for testing, they cannot/do not know how to reproduce it, so they think the bug has been fixed and close the ticket! But what if the bug is not fixed? What if it is still there, and it is just that they cannot reproduce it? If the user cannot reproduce the bug and if it has not been fixed, then the developer has most likely broken something else (explained in the previous item). If the user can reproduce the bug, then the developer will know that he/she has changed the wrong thing and it may have broken something else. Also the ticket is not closed just because no one can reproduce it.

###Wasted time, and bugs living in the system longer
We get a ticket, we spend half an hour trying to reproduce it without any luck; so we give up and flag it as 'could not reproduce it'. This sends the ticket back to the 'bug admin' who after noticing it in their list (which may take a few days) will send the ticket back to the user. Some time later the person who raised the ticket notices it is back in his/her list and will try to reproduce it. I have seen tickets sent back with only one extra line which looks something like "I tested the bug and it is still there!" and the same cycle again. In a system with busy team and a rather big bug backlog this cycle could take a few weeks, and at the end of the first cycle the programmer still does not have much information about the bug. This, apart from the wasted time, means that the bug gets to live in the system much longer than it should. Also you will potentially hassle the user over and over and over again, and that could get very frustrating for everyone involved.

##Solution
Now that we know what we are talking about, lets see how we can fix them and/or make them a bit easier for everyone.

###Ticket Description
Ticket description in my opinion plays a very important role in the whole experience. It is used for understanding, reproducing, fixing and then later testing and closing the bug. So a good description helps you all the way through and a bad description hinders you in all those steps. 

Below I will try to explain what a typical good and bad ticket look like plus how a good ticket could help and a bad ticket could make everything harder.

####Example of a well described missing/incorrect behavior
Bugs are usually about a missing/incorrect behavior. For this class of bugs I would like to see something like this:
 
"There is a problem with the way customer status changes. I was able to consistently reproduce the problem using the following steps:

   - Open the form y
   - Enter the customer details
   - Save and close the form
   - Search for the customer and open its details
   - Go to tab t
   - Click on button b
   - The customer status should change to 'AAA' but it currently changes to 'BBB'"

<small>Just to avoid any confusion, if 'creating a customer, opening the details form and clicking on the button b' is a very well known process, then it does not necessarily have to be explained in details. All that matters is for programmer (and later the person who raised the bug) to be able to follow the steps and reproduce the bug or make sure it has been resolved.</small>


The description should resemble a user story or a scenario in a user story as much as possible. In this case the user story could look something like: "Given the customer is just created, when we upgrade the customer level, then the customer status should change to 'AAA'"

I can actually write a unit test as part of my spec for this bahavior which is great. This not only helps fix the bug, but also prevents it from regression in the future. In addition,  scenario or user story explained in the ticket could be missing from our spec or may have been captured incorrectly, and this ticket helps us refine our requirements. For an existing user story a reference to the story in the ticket would be just awesome :)

####Example of poorly described bugs
On the other side of the coin there are poorly explained tickets and they are actually very common. Here is a typical format I see very often: 
 
 - Title: Form x does not work
 - Description: {None or very brief description plus sometimes a screenshot of the form that failed!}

How am I supposed to reproduce this bug? Unless it is a silly exception that happens in almost every single action in that form, I would have to spend a lot of time trying to figure out what is wrong. Particularly for missing/incorrect behavior this is just not going to work.

####Reproducing bugs consistently
Ticket description should not only explain what happened. It should also explain what it takes to reproduce the bug consistently.

Take the example of good bug description given above. There we got a great help from the user. The user has gone "the extra mile" to consistently reproduce the bug and has provided us with steps it takes to do so. Perhaps you are thinking it should not be done by the user; instead it should always be done by QA team (or the developer); but I would disagree. I believe the person who raises the ticket should try his/her best to consistently reproduce the bug and explain their findings in the ticket. Even if they cannot reproduce it consistently they should explain circumstances under which they have seen the bug to make it easier for developer to find the bug. This way developer can try to simulate those situations and to reproduce the bug. If the user failed to provide steps to consistently reproduce the bug, the developer should complete the ticket by providing those steps after finding the issue. You also want to double check with the user that what you have found is actually what they meant to report (explained further down). Either way, when the bug is fixed there has to be an easy-to-follow instruction to test the bug to make sure it is fixed.

####Training 
The problem is not that users do not want to write a proper description; but that some of them just do not know any better. 

It is very easy to train your users to write proper tickets and they are more than willing to learn and to do it properly. Give it a go next time you see a poorly described ticket and you will be amazed how supportive users can be. It is because they would really like get hassled less for the same bug, they hate regression much more than we do, and they like to learn a little bit about our complex world :)

At the end of the day, no one knows a system better than its users and no one can explain its issues better. You just have to teach them how to do it. 

###Face to face communication
Even with a great ticket description it is still possible to misinterpret the ticket and fix the wrong thing! One of the other things I have found very useful in avoiding problems explained above is to ask the person who raised the ticket to try to explain it to me and/or reproduce it in front of me. I have found this to be very helpful because apart from finding the bug quicker I get to observe the user and find out things that I would not be able to otherwise, even with a very good description. There are always some details that get left out of written communication.

I would actually like to say that, apart from very obvious bugs, it is always a good idea to get the user to explain to you what is wrong, try to reproduce it in front of you, and also explain how they want it to work. You can also use the understanding gained by observing the user to improve the ticket description and remove any ambiguity. This makes the whole bug fixing experience a lot easier for everyone involved - including users. 

<small> If you do not have direct access to users, phone call is still better than nothing. In the absence of phone contact, you may try seeking some guidance and more explanation via email.</small>

###Preserving the state under which the bug happened
Some bugs are trickier than others in the sense that they happen under very specific circumstances. This usually involves how user has setup the data/state under which the bug exhibits. Just the other day I was working on a very well explained bug; but I just could not repro it. After talking to the user it turned out that it happens only on one of the records he was working on. I spent some time on the record and realised that there was some issues in the way the data for that particular record had been migrated from the old system. Not having had access to that state I would not be able to find the problem (at least not as simply).

Another real example: there was this other bug that was very well explained by the user, I tried to repro it in dev, but I could not. I asked the user to repro it, but he could not either. Then we thought the problem must have been with the record he was working on at the time (which he actually had provided a reference to); but the problem was that the record had been cancelled, and we had no way of reproducing the bug. I advised the user to try to simulate it on other similar records, which he could not, so we half-heartedly closed the bug!

If the error happens only on some specific situation and assuming the bug has happened in UAT environment, I would ideally like users to leave the test data there for me so I can examine the code with the same state. This of course means that you should be able to point your code at the UAT which may not be possible or acceptable. Nonetheless it is always good idea for the users to provide some link/reference to the entity/data they were testing when the bug exhibited. This way, even if the data is changed, there is a chance we can narrow down the issue easier.

###Conclusion
In conclusion here is a list of things I have found very useful in understanding and reproducing (and hopefully to later fix) a bug:

 - Properly explained tickets ideally with reproduction steps
 - Face to face communication
 - Preserving the state under which the bug happened for data related bugs

