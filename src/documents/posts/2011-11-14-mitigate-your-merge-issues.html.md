--- cson
title: "Mitigate your merge issues"
metaTitle: "Mitigate your merge issues"
description: "There are a few things you can do to mitigate merge issues to a large extent"
revised: "2011-11-15"
date: "2011-11-14"
tags: ["agile","team"]
migrated: "true"
urls: ["/mitigate-your-merge-issues"]
summary: """
There are a few things you can do to mitigate merge issues to a large extent
"""
---
When working in a team it is very easy to get into merge hell where your changes do not easily/nicely integrate with those made by your teammates. Merge issues could get quite serious and ugly. 

On my current project I noticed that two of the test classes I had checked into source control were not there a few days later. I talked to other devs and none of them knew how they went missing. A quick history search showed that there was a merge conflict on the test project file and one of the developers had not merged properly. Later we had some other issues where a developer had checked in his new files but the project file he had checked in did not reference those files again due to a merge issue. This basically means that the code would build and work on his machine and nowhere else. 

There is no easy solution for this problem (particularly if you are using a non DVCS solution) and this is going to happen to you no matter how good a developer you are; but here I am going to talk about a process I introduced in my team that helped mitigate the problem. This is not something I have come up with and a lot of Agile teams have been doing this for years; but I thought I would share my thoughts.

##Check-In Dance
Check-In dance is a few steps a developer should perform before every check-in which help reduce the risk of merge issues to a great extent. The Check-In dance we are doing goes like this:

 1. **Get the latest from source control**: making sure changes made by your teammates are integrated into your local copy of the code.
 2. **Resolve the merge conflicts CAREFULLY** 
 3. **Build the solution**: so you know that the latest code will build with your code integrated at least on your machine.
 4. **Run all the unit tests**: and make sure they all (and not just yours) pass. This helps you find those pesky little issues caused by semantic conflicts. What looks like an innocent change may be a regression for other bits of a class/unit/module.
 5. **Run the functional and integration tests**: well, you do not really want to run all functional tests as that may take a while; but you could run those that cover the bits your changes may have impacted. This helps find those integration issues caused by behavioral changes. You may actually fix a bug in your code which breaks other bits of the system. 
 6. **Get your code reviewed by a teammate**
 7. **Fix the code review issues**
 8. **Check-In**
 9. **Wait for the green light before moving on**: Make sure your check-in integrates on the build server and passes the build and tests. Sure it works on your machine; but there is a chance that after all these steps your changes are not going to work on the build server. The case of the project file not referencing the added classes mentioned above is an example of this.

This is an ordered list and you cannot proceed to the next step until your current step passes.

We do code reviews rather religiously and I could not be happier with the result. We find and fix many issues in code reviews. Some of these issues had made it past unit and functional and even manual (developer) tests.

So our check-in dance is a two-phase activity: the first phase is step 1 to 5. We then start the code review process that may result into starting from step 1 again: the developer may need to do step 1 to 5 again depending on how long the code review and its resulting fixes take and how the code review goes. The reason for going back to step 1 is that if the code review process takes a while you will need to get the latest again for the reasons explained above which basically resets the cycle. 

This cycle happens enough times until the reviewer gives the green light upon which the developer can proceed to next step and check-in his/her code. That said, in practice we finish the dance in one or two passes.

##Other things you should do
So we saw what check-in dance is and how it can help us; but that dance alone can only take you so far and there are other things you should/could do that really help.

###Check-in frequently
Check-In dance is a good way of reducing merge issues; but the longer you wait between your check-ins the harder your merge gets; so do yourself and your teammates a favor and check-in at least once a day.

Your code does not have be "[Done][1]" before you can check-in. Just check-in when you think it is good enough to go on others' machines without breaking their build or slowing them down. Just leave some 'ToDo', 'Note' and 'Hack' notes on places you think need more attention so (if for some reason you cannot continue your work) someone else can easily take over your work and finish it. 

If the code has to live on your machine for a long time before it is ready to be checked in because what you are working on is too big or your changes make the solution unstable, then there is a good chance you are doing something wrong. Maybe you need to break down your tasks a bit further or you may need to make changes in smaller and more measured and manageable way instead of changing some 50 classes at once.

###Get the latest frequently
Source code integration is a two way procedure: pulling the latest version and pushing your changes back. It is important to note that getting the latest version frequently is just as critical and important as checking in. In fact if you do your check-in dance properly, then you can make sure that getting the latest is not going to break your local build or slow you down; so you can and you should more confidently and frequently pull from the server.

So even if you do not want to or cannot check-in frequently at least make sure you get the latest version frequently so you can fix merge conflicts as you go instead of waiting for two days and trying to fix tens of merge conflicts just before you check-in.

###Never do auto merge
Some SCMs are smarter than others in picking up conflicts and in resolving them. Some diff/merge tools also make the experience a whole lot easier than others <small>(and BTW my favorite one is [P4merge][2])</small>. That said, you should never ever trust your SCM to do auto merge. There is a (not so slim) chance that what can be textually merged has some [subtle semantic conflict][3]s. So just open that conflicting file and have a look even if for a few seconds. You will be surprised how often your SCM gets it wrong. 

###Do a diff even if it does not have a conflict
Just before the code review (or check-in) I go through all my changes, which should not be too many files hopefully, and do a diff on them one by one even if they have not had any conflicts and do a quick visual inspection. This is something I always do and every now and then I find (and avoid) some "interesting" changes. 

If you check-in very frequently then this check should take less than a minute which totals to say five minutes a day: a very well spent time IMO. On the other hand, if you do not check-in very frequently then this check becomes even more important and critical as many things could have gone wrong. 

If you do not do code reviews in your team then it is even more important to do this before every check-in; it is kinda like you are reviewing your own change; nowhere as effective as peer review; but much better than no review.

###Last but not least, CI Server
Most of abovementioned steps could work with and without a Continuous Integration Server; but you will get much more out of it if you have a CI server that builds the code and runs tests frequently and upon check-ins. Even if you do not have a dedicated server, just grab that unused desktop machine under your desk and setup a CI server.

One of the biggest benefits of a CI server is highlighting the quality of what is on the server. This way you get a red light as soon as you check-in some broken code. You can also more confidently get the latest knowing that if it builds and passes all the tests on the CI server it is hopefully not going to do you much harm.


  [1]: definition-of-done-in-an-mvc-project
  [2]: http://www.perforce.com/product/components/perforce_visual_merge_and_diff_tools
  [3]: http://martinfowler.com/bliki/SemanticConflict.html