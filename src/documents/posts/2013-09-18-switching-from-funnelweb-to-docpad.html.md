--- cson
title: "Switching from FunnelWeb to DocPad"
metaTitle: "Switching from FunnelWeb to DocPad"
description: "I have switched my blog from FunnelWeb to DocPad"
revised: "2013-09-18"
date: "2013-09-18"
tags: ["funnelweb","docpad","blog"]

---
I am a big fan of static site generators. We initially used [Jekyll](https://github.com/mojombo/jekyll) for the TestStack website. Later we ported it to [Pretzel](https://github.com/Code52/pretzel) to make it easier for .Net devs to contribute to it. I have been meaning to use a static website generator for my blog for a long time too, and finally I got around to do it.

I love Jekyll and it was a good fit considering I having been working with Ruby lately; but then I heard about [DocPad](docpad.org) which is a site generator powered by NodeJS. I have heard good things about DocPad and want to learn more about NodeJS so I gave it a shot. As a bonus point Aaron Powell, a former colleague and one of the guys behind FunnelWeb, recently [ported his FunnelWeb powered blog to DocPad](http://www.aaron-powell.com/posts/2013-06-10-new-blog-less-funnelweb.html). He had implemented migration scripts to port data from FunnelWeb to markdown files for DocPad which made my life easier. He had also faced and tackled a few gotchas which meant I didn't have to. Thanks Aaron :p

There were quite a few benefits to be gained from this switch:

 - No more SQL, SQL backups etc
 - No more heavy handed ASP/IIS 
 - No need to backup. GitHub is doing that for me.
 - I write my article and see it live on my local DocPad host and easily push it up when happy.
 - No more hosting costs: I am using Heroku free instance to host my blog.

More than anything else though I love that I am in full control of my website structure, layout and design, routes and pretty much everything and it's all using the good old HTML, JavaScript and CSS which is awesome.

It wasn't all gain though - I lost quite a few valuable things. Most notably, for over two years I used FunnelWeb's native commenting which persisted the comments in a SQL database. The comments weren't ported to DocPad and don't show up in the comments in the new blog which is a huge loss for me. I am really sorry if you left a comment on my blog which was lost in this transition. Another thing that might be annoying for you is potential RSS screw up. There is a chance the last 20 posts on my blog are doubling in your RSS reader. If that's the case please let me know so I can fix it.

As mentioned before I am now hosting my blog on Heroku; but there wasn't a clean path to deploy a DocPad website to Heroku; so I implemented a plugin that deploys a clean repo to Heroku while also keeping the main blog repo clean of output files. In the coming weeks I will blog about some of my findings and will try to clean up my deploy-heroku plugin and push it to npm.

You can see the code behind my blog [here](https://github.com/MehdiK/myblog).