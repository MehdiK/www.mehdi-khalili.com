--- cson
title: "Never judge a programmer by their commit history"
metaTitle: "Never judge a programmer by their commit history"
description: "Never judge a programmer by their commit history. No matter how good a programmer you are, there are times you're going to do a crappy work"
revised: "2014-02-22"
date: "2014-02-22"
tags: ["Notes","Rants"]

---

It's been a very long time since I judged any programmer based on their commit history and I believe if you think you can judge a programmer's ability by reading his/her code YOU ARE WRONG.

I am not writing this post to say bad programmers don't exist - in fact I come across A LOT of them. I have even written a post about the worst of them, known as [Net Negative Producing Programmers](/dealing-with-net-negative-producing-programmers). That said there are many things that could lead great developers to write bad code. Here is a few things I have either experienced personally or seen happen to great developers that led to bad code:

###Abiding by bad coding standards
I worked at a government organization in Australia with a horrible codebase. Every single class was public static and obviously no unit tests as their design was untestable. No need to say that the system was bug-ridden. That said they had a brilliantly consistent codebase: every bit of code you looked at was just as shit as the next one because they were diligently following a broken coding standard!

To get my hands dirty with the code, my first task was to fix a few related bugs that had been reported two months before and two devs had spent weeks on it and released a patch that not only didn’t completely fix the bugs but also introduced two more bugs!! I got in the code, put in some integration tests around the mess, refactored their code and made it unit-testable, put in some 30 unit tests around the broken code, found and fixed the three bugs and two more bugs that hadn’t been found before which I reported, confirmed and fixed. I committed the code and a day later the team lead and the manager came to me pretty pissed off after the lead had reviewed my code and told me to fix the code following the existing patterns. That day I was forced to revert my code and to fix the bugs using their broken patterns because they didn’t want their consistency touched. 

Over time I taught them about TDD, BDD and how to write higher quality code. I even [wrote a fully-fledged BDD framework](/bddify-in-action/introduction) to help them write better code and fortunately several months later the efforts paid off and they all started seeing value in writing testable code and writing much better code with proper unit testing which was awesome. So the new code looked nice and clean. Someone's going to come along one day, see some crappy code amongst all the clean code, get a history and see my name against it and think "This Mehdi guy clearly has no idea about programming"!

###Bad leader and project manager
I worked at yet another government organization in Australia. The team leader was still some 10 years behind the technology and didn't want anything new in the codebase because he wouldn't understand it! So we wrote code that felt to have been written with a very old technology and mindset. Over a long period he eventually learnt new practices and technology and became a better programmer and leader; but in the meantime we had to write some subpar code.

I also once worked with a project manager that single handedly led a team of great devs to write bad code! He would pretty much accept any change or additions coming from the users but he never negotiated the scope or the time with the business so the only thing left to flex on was code quality! 

###Junior devs
Junior devs write bad code because they don't know any better. I have written bad code - plenty of it. I have written a lot of unmaintainable stored procedures, untested and untestable code, 500 line methods and 3000 line classes etc just because I didn't know any better, and please don't tell me you were writing awesome code from the get-go. It's harsh to judge a great programmer based on the code s/he wrote many years ago.

Another side of this coin is **working** with junior devs. This could also lead you to intentionally write code that you think could be a lot better, and this is more true for consultants. You are sent to lead a team of junior devs and you are only going to be there for a short period to mentor them and set them on the right path. They are the ones who will be writing the code and maintaining the codebase long after you are gone so you have to be very mindful of their capabilities and potentials. Passionate developers are easy to mentor and they get up to speed pretty fast and you should be able to set them up for success within a short period; but when the team is either not passionate enough or doesn't have the potential to learn a lot in a short period you have to settle for their maximum ability. Anything better than that is going to look overly complex for them and could result into catastrophe. 

So you find yourself in a situation where you know the work can be done a lot better but have to settle for less than perfect because of the team who is going to maintain it. The best solution in this case is the one they can code and maintain, and not the architecturally perfect one you can code in a month and leave them behind with.

###MVP
Have you ever felt proud of your crappy code? I have and if you looked at that code and told me I or any of my team members were bad programmers to write such awful code I'd say you have no idea about market advantage and meeting deadlines. I think [bad code is sometimes great programmers' best productions](/on-bad-code). Don't forget that you're hired to deliver value to the business, not to write DDD code with CQRS SEDA LATEST FAD AWESOMENESS with 96% test coverage. That awesome code you're gold plating may actually never be used: 

> “There is nothing more unproductive than to build something efficiently that should not have been built at all.”
– Milt Bryce

Admittedly there is an occasional unfortunate side-effect to this when things get out of hand after the successful release because of bad management and broken promises and you never get the chance to clean up the mess you deliberately made! That's not your fault.

###Brain fart
You see some horrible code, think some idiot must have written it, get the history, and find out you wrote it last week. Sounds familiar?!

Sleep deprivation, day dreaming, personal issues, frequent interruptions etc may result into a phenomenon commonly referred as brain fart. Great developers are a lot less prone to writing bad code because of brain fart but it still could happen to anyone.

###Personal issues
Early 2013 I went through the most difficult period of my time. If you check on me during that period you will notice I didn't write any blog post or didn't tweet for several months; but I am a programmer and still have to write code no matter what, and so I did and the code I wrote and the "solutions" I came up with were shit. Ask Rob Moore if you want some confirmation as he patiently reviewed some of the code I wrote in that period. The truth is when you're consumed by a personal issue it's your lowest priority to think about your job, let alone the quality of it. 

Some 10 years ago I worked with a brilliant hardware engineer. I have no idea about hardware but his peers believed he was genius, at least until he became the father of a sick baby. His newborn son had a sickness and spent most of his first year in hospitals. Many doctors checked him and tried different treatments but couldn't quite figure out what was wrong. Fortunately his son was eventually treated and returned home healthy and they resumed their normal life. During that tough year, this guy would show up to work almost everyday because he needed a lot of money to treat his son; but apart from an or two of low quality work he did, the rest of his day was spent on reading medical journals, searching for doctors in other cities and countries, and googling the symptoms and potential treatments!

###Synergy or lack thereof
I have seen great developers write bad code when they have interpersonal issues with other team members or the manager! Producing high quality work requires synergy with the team you're working with. Put a brilliant dev amongst a bunch of adamant morons and you'll get low quality code, and put an average dev amongst a bunch of awesome developers and you'll get high quality code from him and at the end a better programmer. People assimilate. 

Another issue is uninteresting work. I was once working on a great project with full autonomy over how it should be designed and implemented. Some 30% of the way through, the working MVP got rightfully canned when the business realized it wasn't going to fly; so I was taken off the abandoned project and sent to maintain an old project of mine which significantly lowered my morale, and the low quality outcome ensued until I quitted a few months later.

###Physical issues
Having physical issues could seriously impact the quality of your work. It's really hard to concentrate when your body is not coping. Have three nights of sleep deprivation because your kid has had food poisoning and you'll write some code you won't even see in your worst nightmares. 

An awesome developer I have a lot of respect for had to quit a prestigious job he loved because of the impact of chronic insomnia on his health.

###Imposters!
This is a funny one, but this has happened to me twice and thus worth the mention. I worked at yet another government organization in Australia with crippled I.T. department. Creating a new account or unlocking one would take them weeks! We had a new team member joining us and we didn't want him to sit around just because he couldn't login. So I gave him my credentials and he committed against my name for about a month, and boy did he write some bad code! What makes this situation even funnier is that he left the project before the I.T. dep created his account so there is absolutely no trace of him to be found anywhere - it was all "me"!

That code is still in production and is being maintained and I am sure someone has maintained the code written by that guy and cursed at me because all they can see is my name! Even I did maintain his code and cursed at me for writing it only to later realize that wasn't a brain fart and I never wrote that code. Do'h!
 
##Don't judge
If you haven't experienced any of these you are definitely luckier but not necessarily a better programmer than me and others who have. 

Writing good code requires good conditions. A great programmer, an average one and a horrible one will all write bad code under certain circumstances and just because their code looks more or less as bad doesn't mean they are all the same. Feel free to judge bad code all you want but don't judge the programmer; particularly if you weren't there and under the same circumstance as when they wrote it.

> "Never judge a man until you've walked a mile in his shoes"

Admittedly you can avoid some of the above situations by quitting the job. As a consultant though you are not sent in to quit but to influence however painful that might be.

One last thing: don't write shitty code and use these as excuse. Always give it your best shot.
