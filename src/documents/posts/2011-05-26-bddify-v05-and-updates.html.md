--- cson
title: "bddify V0.5 and some updates"
metaTitle: "bddify V0.5 and some updates"
description: "latest about bddify"
revised: "2011-06-02"
date: "2011-05-26"
tags: ["OSS","BDDfy"]
migrated: "true"
urls: ["/bddify-v05-and-updates"]
summary: """

"""
---
I have been quite for a while mainly because I have been spending most of my time working on [bddify][1] framework. After a few months now, I think bddify has reached the quality and feature-richness that I desired. In this post I will update you with the latest on bddify and hopefully you will hear less on bddify on my blog :o)

###bddify V0.5 is released
I released bddify V0.5 on NuGet. This version contains a Fluent API that is somehow similar to that of StoryQ. It also contains a few new features that make it even easier than before to use. The new features are mostly around conventions; e.g. WithScenanrioAttribute is removed because bddify can now figure out the story type by looking at the containing type of the test method from which you are running your scenarios.

###bddify Podcast on Talking Shop Down Under
I discussed bddify with Richard Banks on the awesome Aussie podcast Talking Shop Down Under. You may download the session [here][2] if you are not subscribed! 

It is funny that in that podcast I told Richard that I would not add any new features to bddify (just like I mentioned on the top of this article!) and yet after that I added many new features including the Fluent API. These features are all discussed in my CodeProject article.

###bddify on CodeProject
I published an [introductory article about bddify on CodeProject][3]. In that article I explained bddify in a good length including the new fluent step scanner, some of its extension points, some of the ideas behind it and so on. So forget anything you have seen, read or heard about bddify. Head to code project and see the latest.

##bddify on Twitter
If you want to hear the latest on bddify you may [follow it on Twitter][4].


  [1]: http://code.google.com/p/bddify/
  [2]: http://www.talkingshopdownunder.com/2011/05/episode-54-bddify-and-mehdi-khalili.html
  [3]: http://www.codeproject.com/KB/library/Introducing_bddify.aspx
  [4]: http://twitter.com/#!/bddify