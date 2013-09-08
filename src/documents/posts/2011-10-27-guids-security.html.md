--- cson
title: "How secure are GUIDs?"
metaTitle: "How secure are GUIDs?"
description: "In this post I explain whether GUIDs can be hacked or not - just some old news!"
revised: "2011-10-27"
date: "2011-10-27"
tags: ["quiz"]
migrated: "true"
urls: ["/guids-security"]
summary: """

"""
---
This is a port from [GeekQuiz.Net][1]. 

<small>I am considering shutting down GeekQuiz because handling two blogs is a bit of a hard job, it is leaving this blog, which is my main blog, unattended which I do not like and also many of the things I post there are worth sharing here and that is not DRY. I will have to ponder on that one; but for now ...</small>

##Can you hack GUIDs? 

Let's give it a go. Give me as much information as you can about the following GUID:

e56d9850-e9a7-11e0-9572-0800200c9a66

How about this one? 

acfb0e5e-4869-405a-a36e-852a1688bce7

From [Wikipedia article][2], "*the original (version 1) generation scheme for UUIDs was to concatenate the UUID version with the MAC address of the computer that is generating the UUID, and with the number of 100-nanosecondintervals since the adoption of the Gregorian calendar in the West. This scheme has been criticized in that it is not sufficiently "opaque"; it reveals both the identity of the computer that generated the UUID and the time at which it did so.*"

And to understand the [significance of the security issue in V1 algorithm][3] "*This privacy hole was used when locating the creator of the Melissa virus.*". To address these issues version 4 was created which is randomly generated: "*Version 4 UUIDs use a scheme relying only on random numbers. This algorithm sets the version number as well as two reserved bits. All other bits are set using a random or pseudorandom data source. Version 4 UUIDs have the form xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx where x is any hexadecimal digit and y is one of 8, 9, A, or B. e.g. f47ac10b-58cc-4372-a567-0e02b2c3d479.*"

As mentioned above you can differentiate GUID versions using the first letter of the third group of letters. As you can see in my example the former GUID is V1 (e56d9850-e9a7-**1**1e0-9572-0800200c9a66) and the latter is V4 (acfb0e5e-4869-**4**05a-a36e-852a1688bce7).

Microsoft started [using version 4 from Windows 2000][4]: "The upper four bits of the timestamp section contain the GUID's version that specifies the content of each section. Before Windows 2000, the CoCreateGuid function generated version 1 GUIDs. With Windows 2000, Microsoft switched to version 4 GUIDs, since embedding the MAC address was viewed as a security risk. ThePocketGuid class also generates version 4 GUIDs.". Also it is worth mentioning that .Net and SQL Server use underlying OS algorithm to generates GUIDs and as such you are guaranteed to get GUID V4.

Hope this helps (if you had not already read it on GeekQuiz :P).


  [1]: http://geekquiz.net/hack-that-guid
  [2]: http://en.wikipedia.org/wiki/Universally_unique_identifier
  [3]: http://en.wikipedia.org/wiki/Globally_unique_identifier#Algorithm
  [4]: http://msdn.microsoft.com/en-us/library/aa446557.aspx