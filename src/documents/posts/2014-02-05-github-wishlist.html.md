--- cson
title: "GitHub wish list"
metaTitle: "GitHub wish list"
description: "Here is a wish list of changes and improvements that I think would make GitHub better for a lot of developers"
revised: "2014-02-05"
date: "2014-02-05"
tags: ["GitHub","Notes"]

---

I love GitHub and I think it's awesome. However there are a few things that I think would make it better. 

##Issue Tracking
I used to use Trello as task manager for everything including my GitHub projects but about a year ago I completely switched to GitHub issues for GitHub projects. Having used GitHub issue tracker for a while now, there are a few things that I think are missing from it.

Some might argue that GitHub issue management system is not meant to be a fully fledged issue tracker; but where else is the best place to keep issues related to a GitHub project than the integrated issue management system, and no - I don't want to use two products to track issues and tasks of one project.

###Priority property 
A typical project has quite a few issues and the more issues there are the more important the ability to prioritize them. This helps communicate the importance of issues with those who raised it and highlight and tackle the important ones sooner than letting them bury under other potentially not as important issues.

###More statuses
Two statuses, 'Open' and 'Closed', aren't enough for an issue tracker. In addition to those, I at least need: 
 
 - 'Ready' for when an issue is ready for or getting close to development and 
 - 'Doing' for when someone is working on it. 

Perhaps there could also be a 'Done' status for when there is a pending PR against the issue; but I can live without it.

I understand I could create these as labels but to me label is different: labels put issues into different categories; but status is not a category - it's where the issue is at. Additionally status changes have dates associated with them and show up on the issue timeline which is quite nice.

It would be great if, like issue labels, I could manage the additional statuses; but for now just give me the extra statuses. You can deliver the status management at a later date - that's alright ;)

###Visual touch
The above features would be even better if contributors could perform them visually. I would love to be able to drag an issue up on the issue list to prioritize it over other issues and with extra statuses, there could be swim-lanes, like Trello, to allow contributors to drag and drop issues between statuses.

There are tools, like [HuBoard](http://huboard.com/), that provide this interactive task wall over GitHub issues using labels. I personally like HuBoard. It's free for open source projects which is great; but again in absence of proper issue statuses it uses labels to create the lanes which I don't quite like.

##GitHub Pages
GitHub pages for repositories, or as GitHub calls them "project pages", are great for promoting a project. You basically create a gh-pages branch, either manually or using the Automatic Page Generator from your repository Settings page, and put a static website there (more info [here](https://help.github.com/categories/20/articles)). You can also setup a [custom domain for the GitHub pages](https://help.github.com/articles/setting-up-a-custom-domain-with-pages) which is quite nice. There are however a few issues with GitHub pages that prevent me from using it frequently and very often I instead end up creating a website using a static site generator.

###Auto updating the website on readme updates
A GitHub project pages website is typically a one pager that mirrors the readme file. To create the website you can just use the Automatic Page Generator from the settings. The wizard allows you to generate the site from the repo readme; but that's a one-off port. Once the website is published, it's unaware of changes to the readme file. So every time you change your readme you have to update the website too which is a pain. I know this can be [automated to some extent](https://stackoverflow.com/questions/15214762/how-can-i-sync-documentation-with-github-pages) but why so much pain? 

Since the website lives on a gh-pages branch of the repo, it shouldn't be that hard for GitHub to recreate the website every time the readme file changes. This can be just an option in the generator wizard so it doesn't break the custom GitHub pages site. 

###Custom domain
Setting up a custom domain for a User or Organization pages site is easy. The steps are very well defined [here](https://help.github.com/articles/setting-up-a-custom-domain-with-pages). The article actually starts up as a generic article for GitHub pages; but halfway through it completely ignores what's required for projects pages and only focuses on User and Organization pages particularly for DNS settings. 

You can find some (magic) solution for setting up custom domain for project pages [here](http://stackoverflow.com/questions/9082499/custom-domain-for-github-project-pages) but it would be great if GitHub could provide proper guidance or solution for GitHub project pages.

###Better and wider themes for GitHub pages
There are very few prepackaged themes for GitHub pages and they are not particularly appealing. The body width, like GitHub itself (more about this shortly), is also unnecessarily narrow. This is not necessarily related to project pages as the same applies to User pages too.

It would be great if more themes were added for Automatic Page Generator. There are plenty of nice [themes for Jekyll](http://jekyllthemes.org/) that GitHub can pull in.

##User Interface
The GitHub user experience is already quite awesome; but there are a few things that could make the interface a lot easier to use. 

###Built-in Expandinizr
[Expandinizr](https://github.com/thecodejunkie/github.expandinizr) is [a Chrome extension](https://chrome.google.com/webstore/detail/githubexpandinizr/cbehdjjcilgnejbpnjhobkiiggkedfib/) that improves GitHub user interface a fair bit. From the readme, it:

 - Removes the truncating of file and directory names in the repository browser
 - Really long file and directory names will word-wrap
 - Fully expands the website, with breakpoints at 1400px, 1600px and 1800px
 
Funny as I was writing this post Phillip Haydon wrote a post about Expandinizr. So instead of detailing the difference in user experience I just point you to [his post](http://www.philliphaydon.com/2014/02/fixing-github-with-chrome-plugin-github-expandinizr/). Thanks Phillip.

Basically I want GitHub to behave as if Expandinizr is installed for everyone and all browsers. It's just a CSS!

###Side by side diff
I find the existing diffing UI a bit inconvenient. It may just be that I am used to side by side diffs because that's what I get from the majority of diff tools and I look at file diffs that way all the time; but then again I guess a lot of developers are in this boat with me. So it would be great if there was an option to view commit changes side by side. FWIW there is [a (broken) Chrome extension](https://chrome.google.com/webstore/detail/side-by-side-diff-view-in/ihmhmdmhllhleioijdeoocgoddjckbcd?hl=en-US) for this. Just want the functionality properly implemented in GitHub.

##ReleaseNotes.md updated by GitHub
[GitHub releases](https://github.com/blog/1547-release-your-software) are great as they allow you to highlight the releases and the changes associated with each one; but I've always struggled with the duplication: there is the release notes in NuGet packages, the ReleaseNotes.md file in the root of the repo and now the release notes in GitHub release, and I love them all :) 

I understand that GitHub cannot and shouldn't touch my NuGet packages; but it would be great if creating a GitHub release updated the ReleaseNote.md file if it exists or created one. Basically I want GitHub Release to be a glorified GUI over the release-notes file so I can take advantage of an [in-repo release-notes file](/better-git-release-notes). I don't understand why GitHub decided readme and license files should be part of the repository but releases have to live outside!

Good news is that my friend Jake Ginnivan has a great solution for this called [GitReleaseNotes](http://jake.ginnivan.net/gitreleasenotes/). This is a common need though and should be there for everyone out of the box.

##Announcements
I want an ability to notify followers and/or stargazers of my repository about a new event etc. In January 2014 [Humanizer](http://humanizr.net/) became, and stayed for a while, the C# repository of the week. Obviously I was very glad and wanted to share the great news with project contributors, watchers and stargazers; but I had no way to do it. So I created [a new issue](https://github.com/MehdiK/Humanizer/issues/57) labelled as announcement.

It would be really nice if we could notify people of news and events for the project they're interested in.

##Conclusion
I understand GitHub cannot be everything for everyone and while I think it is awesome as is, there are still a few things as listed in this post that could be improved. There are other things that I think could be different/better; but I am only raising issues that I believe make a big difference for a lot of developers (as opposed to just me or a minority of devs).

I hope that one day some of these requests are implemented and make it into GitHub.

If you have easy solutions to some of these issues I would love to hear it. I am also interested to hear what else you think could be improved. Please share your thoughts in the comments. 
