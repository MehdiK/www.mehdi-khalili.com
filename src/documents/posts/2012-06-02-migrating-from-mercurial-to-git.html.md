--- cson
title: "Migrating from Mercurial to Git"
metaTitle: "Migrating from Mercurial to Git"
description: "In this post I explain what you need to do to migrate your repository from Mercurial to Git "
revised: "2012-06-02"
date: "2012-06-02"
tags: ["Git","Mercurial","GitHub"]
migrated: "true"
resource: "/migrating-from-mercurial-to-git"
summary: """
A few days ago I migrated one of my projects from Mercurial to Git. That was an interesting experience and I thought I'd share my experience and explain some of the glitches I had
"""
---
I have used quite a lot of source control systems: started with Visual Source Safe, then used SVN, various versions of TFS, SourceGear for a short while, StarTeam, Mercurial and Git ... and in my opinion Git is THE most awesome source control system (even if you were to discount its distributed nature so you can compare it with non-distributed VCS solutions like TFS and SVN).

I have been using Mercurial for a project for 18 months now and just recently after some discussion with a team member on the project we decided to migrate to git. I had heard some horror stories about migration from Mercurial to Git and from BitBucket to GitHub. One of my colleague had to install linux a few months ago for the migration. After a quick googling I found quite a few solutions and migration paths: on StackOverFlow and on various blogs. I tried some of them and quickly gave up as they were a bit of overkill and then I found exactly what I was looking for: an exhaustive [solution for migrating from BitBucket to GitHub][1] (which is basically what I wanted). That post and its foundation that can be found [here][2] are great and were really helpful. That said I had a few glitches that I will try to explain here.

[Fast-Export][3], which is the solution used to read from Mercurial and feed into Git's fast-import, is a Shell Script that can be run on [Git Bash][4]. The abovementioned [post][5] explains what you need to do to setup your git repository and how to run the shell script to export your Mercurial code into git. So I am not going to bore you with that.

Fast-Export is written using python. So you will need to install python to be able to run the script. More specifically you will need to install versions pre-v3! If you try to run the script using python V3+ you will get '**SyntaxError: invalid syntax**':

![Python V3+ error][6]

Invalid syntax!! The fast-export script is written using pre-python v3. We are getting the error on the print line because apparently [<code>print</code> was turned into a function][7] in v3. Well, that in itself is not a big error as you can just comment the print line out as I did; but I just could not get the script work with python 3.2. So I installed [python 2.6 for Windows][8] and all the errors went away, or so I wished!

Next stop: '**ImportError: No module named mercurial**'!! That means that python does not know about Mercurial. The fix for that would be to install Mercurial as a  python module which you can find [here][9]. I installed [mercurial-2.2.1.win-amd64-py2.6.exe][10] which fixed that error. 

Now I was getting '**Error: repository has at least one unnamed head...**'. 

![Unnamed head][11]

I had a closed branch and the basic fast-export command did not quite like it. Thankfully [using --force option][12] fixed it nicely.

One step closer; still not quite there though. Now I was getting '**fatal: Branch name doesn't conform to GIT standards: refs/heads/master**'

![Branch name doesn't conform][13]

[StackOverflow to the rescue][14]. All you need to do to fix this error is to add the following lines to the top of your script file:

    import sys
    
    if sys.platform == "win32":
       import os, msvcrt
       msvcrt.setmode(sys.stdout.fileno(), os.O_BINARY)

So now the first few lines of my <code>hg-fast-export.py</code> look like:

    #!/usr/bin/env python
    
    # Copyright (c) 2007, 2008 Rocco Rutte <pdmef@gmx.net> and others.
    # License: MIT <http://www.opensource.org/licenses/mit-license.php>
    
    from mercurial import repo,hg,cmdutil,util,ui,revlog,node
    from hg2git import setup_repo,fixup_user,get_branch,get_changeset
    from hg2git import load_cache,save_cache,get_git_sha1,set_default_branch,set_origin_name
    from tempfile import mkstemp
    from optparse import OptionParser
    import re
    import sys
    import os
    import sys
    
    if sys.platform == "win32":
       import os, msvcrt
       msvcrt.setmode(sys.stdout.fileno(), os.O_BINARY)
    
    # silly regex to catch Signed-off-by lines in log message
    sob_re=re.compile('^Signed-[Oo]ff-[Bb]y: (.+)$')

... and finally, **Done**.

The rest of steps are explained very well in [the James' blog][15].

Not quite as bad as installing linux; but I think it could be a more seamless experience. I guess I should send this as a feature request to [GitHub For Windows][16].

Hopefully this post saves you some time.


  [1]: http://www.wordsinboxes.com/2012/02/migrating-repositories-from-bitbucket.html
  [2]: http://hivelogic.com/articles/converting-from-mercurial-to-git/
  [3]: http://repo.or.cz/w/fast-export.git
  [4]: http://code.google.com/p/msysgit/
  [5]: http://www.wordsinboxes.com/2012/02/migrating-repositories-from-bitbucket.html
  [6]: /get/BlogPictures/mercurial-to-git/python-v3-error.JPG
  [7]: http://stackoverflow.com/a/826957/141101
  [8]: http://www.python.org/download/releases/
  [9]: https://bitbucket.org/tortoisehg/thg-winbuild/Downloads/
  [10]: https://bitbucket.org/tortoisehg/thg-winbuild/Downloads/mercurial-2.2.1.win-amd64-py2.6.exe
  [11]: /get/BlogPictures/mercurial-to-git/unnamed-head.JPG
  [12]: https://github.com/cosmin/git-hg/issues/12
  [13]: /get/BlogPictures/mercurial-to-git/branch-name-doesnt-conform.JPG
  [14]: http://stackoverflow.com/questions/9537454/how-to-solve-hg-fast-export-error-branch-name-doesnt-conform-to-git-standards
  [15]: http://www.wordsinboxes.com/2012/02/migrating-repositories-from-bitbucket.html
  [16]: http://windows.github.com/