--- cson
title: "An experiment with Git, Vim and posh-git"
metaTitle: "An experiment with Git, Vim and posh-git"
description: "I was looking for a way to be more productive with git which led me to do an experiment with Git, Vim and posh-git"
revised: "2012-07-15"
date: "2012-07-12"
tags: ["git","vim","powershell"]
migrated: "true"
resource: "/an-experiment-with-git-vim-posh-git"
summary: """

"""
---
If you are using git on windows you must have heard of [posh-git](https://github.com/dahlbyk/posh-git). From the project homepage, posh-git is a *"set of PowerShell scripts which provide Git/PowerShell integration"*. I have been using posh-git for a while now and I love it. That said I still would like to be more productive - I need to get rid of that mouse or at least I have an itch I want to scratch:

![Getting rid of the mouse][1]

My issue is not with posh-git but more with shell environments. Even though shell environments are made to be very keyboard friendly they do not offer some of the basic functionalities like navigating up and down in the text or copying things off the screen using keyboard (at least not in an easy way). I did try Console2 and ConEmu; but they did not give me what I wanted and I personally do not see many benefits in using them. The idea of ConEmu was really cool and I tried it<del>; but for some reason it ran my PowerShell commands VERY slowly: think a second wait after each execution!!</del>. **Updated 2012/07/15: As Maximus mentioned in the comments, I disabled the 'Inject ConEmuHk' option and PowerShell in ConEmu is now working just as fast as bare PowerShell. I will need to give ConEmu another go.**

Here is a typical example where I struggle with my current setup: say I want to  see the details of a commit. To do that I would have to first find the commit I am interested in. So I do a `git log` (perhaps combined with `-S` or `--grep` or `--author`) to find the particular commit and it usually comes back with a few commits. 

![Git Log][2]

To do anything with the commit I am interested in I would then have to type the commit hash. For example to see the details of the commit I would do a `git show the_commit_hash`; but I do not want to reach for my mouse to copy the commit hash from the log result and typing it is not very fun either as reading the hash could be tricky when there are a few of them next to each other. Another example is when I want to scroll through the result returned by a git command; e.g. going up in the list of changes returned by `git diff`. Again I do not want to have to use my mouse for it.

So I want to be able to move up and down in the git command results, search in it, copy things from it and so on using keyboard. What is a great tool to navigate a textual environment and copy some text? I have been using vim for a few years now and I must say it is an awesome tool and feels like the right tool for this requirement. So I need to be able to either pipe the result of my git commands into a vim buffer or use vim as my terminal and run git from it!! 

My first attempt was to redirect the result of a git command into vim buffer as it first felt like a plausible and simple idea. I am not a pro PowerShell user and there may be a way to do this; but I could not figure anything out. Please leave me a comment if you know a way to make this work. 

Bringing some vim love into PowerShell failed; so I thought I may be able to shoehorn some PowerShell love into Vim!! The rest of this post is going to be about setting this up... and I guess I just lost vast majority of my readers! ;)

So how can I setup vim, a text editor, as my terminal?! [Conque][3] to the rescue: *"Conque is a Vim plugin which allows you to run interactive programs, such as bash on linux or powershell.exe on Windows, inside a Vim buffer. In other words it is a terminal emulator which uses a Vim buffer to display the program output."*

From Conque documentation, the installation requirements (for Windows) are:
<em>

 * [G]Vim 7.3 with +python and/or +python3
 * Python 2.7 and/or 3.1
 * Modern Windows OS (XP or later)

</em>

... and then

<em>
Download the latest vimball from [http://conque.googlecode.com](http://conque.googlecode.com)

Open the .vba file with Vim and run the following commands:

:so %

:q

That's it! The :ConqueTerm command will be available the next time you start Vim. You can delete the .vba file when you've verified Conque was successfully installed.
</em>

I am using Windows 7 Ultimate 64 bit and I had gVim 7.3 and python 3.2 installed; but gVim kept telling me that python is not enabled!!

If you want to see if vim can see/support python or not you can run the following command in vim: `:echo has("python")`. With python 3.2 I kept getting '0' which means vim cannot see python. I reinstalled python (both 32 and 64 bit) and gVim in different orders with no luck and then installed Python 2.7 which fixed the issue. This would be the [second time][4] in one month that Python 3.2 has let me down! Well, in all fairness Conque documentation has some specific setup for Python 3 which I found only after I got it working with Python 2.7 so I have not tried it; but here it is for you if you are running Python 3+:

<em>
Conque will work with either Python 2.x or 3.x, assuming the interfaces have
been installed. By default it will try to use Python 2 first, then will try 
Python 3. If you want Conque to use Python 3, set this variable to 3. 

Note: even if you set this to 3, if you don't have the python3 interface
Conque will fall back to using Python 2.

`let g:ConqueTerm_PyVersion = 2`

</em>

To see if your installation worked or not let's try to run windows command prompt from vim: `:ConqueTerm cmd`. That should run windows command terminal inside vim and that means that I can now run Git from within Vim and scroll up and down and copy things off the result. It is a fully functional terminal with PowerShell and posh-git auto-completion ETC.

![Git in Vim][5]

If you are wondering where the nice Vim coloring comes from, it is from the beautiful [Solarized][6]. To install the Solarized theme for vim you can download/clone the [source from github][7] and follow the installation process on the github page.

Now that we got gim working in vim we can setup a split screen to make it double the awesome. To create a split window in vim you normally run `:split new`; but with Conque you can run `:ConqueTermSplit PowerShell` which creates a split window and runs PowerShell in it.

Now in one window I will write and run my git commands and in the other window I will visualize my last few commits.

![Split Screen][8]

The handy Git command I use to visualize the source tree is:

`git log -n 15 --oneline --graph --decorate --color=always`

I have created a batch file for this which I called gitv (git visualizer) which I run from my git command window.

If on running this command you get 'Warning: terminal not fully functional' you can have a look at this [stackoverflow thread](http://stackoverflow.com/questions/7949956/git-diff-not-working-terminal-not-fully-functional) which has a few fixes on it. I used the easy hack on my git.cmd file by adding `@set TERM=msys` and it worked great.

Now I can execute my git commands in vim and traverse the result using vim. So if I want to search the result of my git command I run `/some_search_text` and then I can loop over the search result by pressing 'N' or 'Shift+N'. I can move up (k) and down (j), back (b) and forth (w) in the result, copy a word (yw) or a line (yy) and so on which makes me happy. To run my git visualizer I press Ctrl+W and then 'up' arrow key, run `gitv`, do my search, go to the beginning of the line (0) and copy the ref (yw) and then switch back to my git command window and do something like `git show` and then hit escape and then `p` which pastes the copied hash, and enter. That sound very nice and it works too ...

... but I must admit I am not quite pleased with the result. There are a few issues with it. Firstly the always-fast Vim now feels a bit sluggish when running two shells. Also for some reason the Conque "shell" seems a bit flaky. Some of the Vim commands fail every now and then and Vim sometimes confuses the colors! Did you notice the out-of-the-blue red commit message in the middle of top window on the above screenshot!? 

I may try to improve the vim-git-ps experience and if I can I will post it here; but for now I am back at the good ol' PowerShell terminal. If you have a keyboard friendly or any other productive setup please leave me a comment and share your experience.

I certainly enjoyed the experiment and learnt a few thing. So I hope you found this useful or at least entertaining too!!


  [1]: /get/BlogPictures/git-vim-poshgit/getting-rid-of-mouse.jpg
  [2]: /get/BlogPictures/git-vim-poshgit/git-in-cmd.png
  [3]: http://code.google.com/p/conque/
  [4]: /migrating-from-mercurial-to-git
  [5]: /get/BlogPictures/git-vim-poshgit/git-in-vim-solarized.JPG
  [6]: http://ethanschoonover.com/solarized
  [7]: https://github.com/altercation/vim-colors-solarized
  [8]: /get/BlogPictures/git-vim-poshgit/split-screen.JPG
  [9]: /get/BlogPictures/git-vim-poshgit/losing-to-the-mouse.png