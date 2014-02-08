--- cson
title: "Better release notes for your git repository"
metaTitle: "Better release notes for your git repository"
description: "I just started using a new format for 'release notes' which addresses quite a few issues and removes the need to use GitHub releases"
revised: "2014-02-08"
date: "2014-02-08"
tags: ["GitHub","Git","Notes"]

---

In [the last post](/github-wishlist) I mentioned that I struggle with release note duplication: I want a release notes file in my repo, release notes in my NuGet package and then there is GitHub releases with their own notes, and I hate duplicating release notes all over the place. There was an entry in my wish list asking GitHub to provide a way to automatically update the release-notes.md file on creating a release entry; but I changed my mind. There is a better way: a good release-notes file!!

I just created a new [release-notes.md](https://github.com/TestStack/TestStack.BDDfy/blob/master/release-notes.md) file for [BDDfy](https://github.com/TestStack/TestStack.BDDfy). A few release entries are copied at the end of the post for your reference.

Let's see what we get with this format:

##Highlights
The release notes in this format:

 - show the release versions and the associated dates
 - show the pull requests that led to the release
 - provide a link to the commit range. This is just an easy git compare path based on tags; e.g. I can get the commits that went into v3.18.5, which are the commits that happened after the previous release - v3.18.3, by navigating to [https://github.com/TestStack/TestStack.BDDfy/compare/v3.18.3...v3.18.5](https://github.com/TestStack/TestStack.BDDfy/compare/v3.18.3...v3.18.5)
 - highlight the in-development work on the top. This also makes it very easy to create new releases: basically every time you merge in a PR you add an entry to 'In development' section and upon releasing just tag your release, change the Commits range to use the newly created tag, create a release title with date, and you're done.
 - classify the changes so users can differentiate the fixed bugs, new features and improvements easily
 - inline breaking changes: before this I loved having a breaking-changes file on the root of the repo so the users know how to deal with potential breaking changes (a sample from [Seleno](https://github.com/TestStack/TestStack.Seleno/blob/master/BREAKING_CHANGES.md) codebase). Although the release version is included in the breaking changes file, it's disconnected from what actually happened on the release. Using this format the breaking changes are now part of the changes that go into the release so you can see what changes led to the breaking change and have a lot more context around it.
 
Obviously you could get all of the above benefits from GitHub releases.

##No need for GitHub releases
A while back I asked on Twitter why people use GitHub releases and the only convincing answer I got was that it allows users to see the releases and commits that goes into them easily. Well, this format does that - so I don't need GitHub releases anymore!

Here are a few benefits of getting rid of GitHub releases and completely replacing them with release-notes:

 - **DRY**: duplicating release notes in two places involves more work and is error prone., which I can avoid now.
 - **No useless downloads**: creating a GitHub release for a library/framework provides useless download buttons that give you the repo! If you want the repo you should clone it and to download libraries devs should use package managers (e.g. NuGet, npm, gems), and no I don't want to put binaries on GitHub release. That's more pointless work. And please don't give me "but NuGet went down!!" argument. That doesn't work with me. 
 - **Can see the releases locally**: your release notes are in the repo which means they are available on your local clone and when you're offline and you don't need to go to GitHub to see what got changed in a particular release. And it's markdown so you can see it formatted very nicely.

A handy feature of GitHub you'll be missing out though is the issue and pull request lookup. GitHub has a very handy lookup mechanism when you put a hash (#) on comments and messages that provides you with a list of existing issues and pull requests that also filters down as you type part of their message. Also they turn into links so you can just click on an issue or pull request number to navigate to it. When you create your release-notes you have to write this yourself: no issue and pull request autocomplete lookup and if you want links you have to create them yourself. Honestly while this is a loss of a handy feature, I can easily live without it.

##Conclusion
In this post I showed you how I just stopped using GitHub releases and replaced it with a proper release-notes file, and I highlighted some of the benefits of this approach.

One thing I didn't talk about is NuGet release notes. I think I will just create a link to a release entry on release-notes file for that - something like [this](https://github.com/TestStack/TestStack.BDDfy/blob/master/release-notes.md#v3185---2014-02-03).

**Credit where it's due:** I didn't come up with this format. This is borrowed from Yeoman's [generator release](https://github.com/walmartlabs/generator-release#generating-release-notes). Next I will try to automate parts of this process using this package. 

Hope this helps.

##Reference: a few entries from BDDfy release-notes.md
A few entries from [BDDfy](https://github.com/TestStack/TestStack.BDDfy)'s [release-notes.md](https://github.com/TestStack/TestStack.BDDfy/blob/master/release-notes.md) is copied here for your reference:

###In development
[Commits](https://github.com/TestStack/TestStack.BDDfy/compare/v3.18.5...master)

###v3.18.5 - 2014-02-03
####Improvements
 - [#46](https://github.com/TestStack/TestStack.BDDfy/pull/46) - tidies up the layout of the summary pane in the HTML report

[Commits](https://github.com/TestStack/TestStack.BDDfy/compare/v3.18.3...v3.18.5)

###v3.18.3 - 2014-01-24
####Bugs
 - [#42](https://github.com/TestStack/TestStack.BDDfy/pull/42) - fixes a bug that caused html report to fail when there is a BDDfy test without an associated story

[Commits](https://github.com/TestStack/TestStack.BDDfy/compare/v3.18.2...v3.18.3)

###v3.18.2 - 2014-01-13
####Improvements
 - [#40](https://github.com/TestStack/TestStack.BDDfy/pull/40) - reduces memory footprint by disposing unnecessary objects in StoryCache

####Breaking Changes
 - to reduce the memory foot print, `TestObject` on `Story` class and `StepAction` on `ExecutionStep` are nulled out before persisting the story in `StoryCache` as these two properties leave a lot of dangling objects in memory (see [#39](https://github.com/TestStack/TestStack.BDDfy/issues/39) for more details) and they're not used in `BatchProcessors`. Not sure why you would, but if you were using these properties from your tests they'll be null after the test is executed.

[Commits](https://github.com/TestStack/TestStack.BDDfy/compare/v3.18.0...v3.18.2)

###v3.18.0 - 2014-01-02
####New Features
 - [#38](https://github.com/TestStack/TestStack.BDDfy/pull/38) - adds a configuration point to stop execution pipeline on a failing test

[Commits](https://github.com/TestStack/TestStack.BDDfy/compare/v3.17.1...v3.18.0)

###v3.17.1 - 2013-11-04
####New Features
 - [#32](https://github.com/TestStack/TestStack.BDDfy/pull/32) - adds support for async steps

[Commits](https://github.com/TestStack/TestStack.BDDfy/compare/v3.16.14...v3.17.1)

###v3.16.14 - 2013-08-05
####Improvements
 - [#30](https://github.com/TestStack/TestStack.BDDfy/pull/30) - cleans up samples and adds a simple BDDfy Rocks one
 - [#28](https://github.com/TestStack/TestStack.BDDfy/pull/28) - adds nuget tags 
 - [#27](https://github.com/TestStack/TestStack.BDDfy/pull/27) - updates nuspec files with the latest license (MIT) & project url
 - [#26](https://github.com/TestStack/TestStack.BDDfy/pull/26) - removes nuget readme content file 
 - [#24](https://github.com/TestStack/TestStack.BDDfy/pull/24) - removes some text from readme & pointed to the new docos website
 - [#23](https://github.com/TestStack/TestStack.BDDfy/pull/23) - changes the license to MIT

####Bugs
 - [#25](https://github.com/TestStack/TestStack.BDDfy/pull/25) - changes the html report link & fixes the custom scripts
 - [#22](https://github.com/TestStack/TestStack.BDDfy/pull/22) - renames custom script names and fixes the report link - Fixes issue #18

[Commits](https://github.com/TestStack/TestStack.BDDfy/compare/v3.16.5...v3.16.14)

