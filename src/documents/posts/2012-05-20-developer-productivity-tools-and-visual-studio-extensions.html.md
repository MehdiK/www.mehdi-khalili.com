--- cson
title: "Developer productivity tools and Visual Studio extensions"
metaTitle: "Developer productivity tools and Visual Studio extensions"
description: "A list of windows and Visual Studio productivity tools and extensions I am currently using"
revised: "2012-05-20"
date: "2012-05-20"
tags: ["tools"]
migrated: "true"
urls: ["/developer-productivity-tools-and-visual-studio-extensions"]
summary: """

"""
---
A few days ago a question was asked on Readify's internal forum about useful VS extensions. A few extensions were mentioned that I had not used before and I am glad to have installed them now. So I thought I'd share my current toolbox with you.

This is not meant to be anywhere as exhaustive as [Hanselman's Ultimate Developer and Power Tools][1]. I honestly just do not use that many applications! This is a list of tools and applications I find very useful and/or use very frequently.

## Visual Studio extensions and tools
 - **[HideMenu][2]**: *"Automatically hides the Visual Studio main menu when not in use, similar to Windows Explorer and Internet Explorer."*: mentioned by Dmitry Kryuchkov.
 - **[Image Optimizer][3]**: *"A Visual Studio extension that optimizes PNG, GIF and JPG file sizes without quality loss. It uses SmushIt and PunyPNG for the optimization."*
 - **[JetBrains ReSharper][4]**: *"a renowned productivity tool that makes Microsoft Visual Studio a much better IDE."*
 - **[jslint.VS2010][5]**: *"Adds JSLlint support into Visual Studio"*: mentioned by [Liam McLennan][6].
 - **[NCrunch][7]**: *"NCrunch is an automated parallel continuous testing tool for Visual Studio .NET. It intelligently takes responsibility for running automated tests so that you don't have to, and it gives you a huge amount of useful information about your tests (such as code coverage and performance metrics) inline in your IDE while you work."*
 - **[NestIn][8]**: *"Nest any type of file on any other type of file within your solution explorer!"*: mentioned by [Jake Ginnivan][9].
 - **[NuGet Package Manager][10]**: *"A collection of tools to automate the process of downloading, installing, upgrading, configuring, and removing packages from a VS Project."*
 - **[PowerCommands for Visual Studio 2010][11]**: *"A set of useful extensions for the Visual Studio 2010 adding additional functionality to various areas of the IDE."*
 - **[SlowCheetah][12]**: *"This package enables you to transform your app.config or any other XML file based on the build configuration. It also adds additional tooling to help you create XML transforms."*. [CodeAssassin.ConfigTransform][13], while not an application or a VS extension, is an alternative option. You may find a comparison [here][14].
 - **[VisualHG][15]**: *"Mercurial source contol provider for Visual Studio."*
 - **[VSColorOutput][16]**: *"adds color highlighting to Visual Studio's Build and Debug Output Windows. Errors are in Red, Warnings in Yellow, build headers are Green."*: mentioned by Jake Ginnivan.
 - **[TestDriven.Net][17]**: *"makes it easy to run unit tests with a single click, anywhere in your Visual Studio solutions."*
 - **[RestoreReloadPackage][18]**: *"This package will reload the files you had open when your project reloads."*: mentioned by Jake Ginnivan. Scott says it works on his machine and I know quite a few of my colleagues are using this; but after installing this package my VS felt much slower and crashed a few times!! Perhaps it has some collision with my other extensions. Otherwise this is a much needed extension.
 - **[JScript Editor Extensions][19]**: *"Contains a number of extensions for the JScript editor in Visual Studio 2010."*
 - **[Team Foundation Sidekicks][20]**: *"a suite of tools for Microsoft Team Foundation Server administrators and advanced users providing Graphic User Interface for administrative and advanced version control tasks in multi-user TFS environments."*
 - **[TFS Power Tools][21]**: *"a set of enhancements, tools and command-line utilities that increase productivity of Team Foundation Server scenarios."*
 - **[EF Power Tools][22]**: *"Adds useful design-time DbContext features to the Visual Studio Solution Explorer context menu."*

## Dev Productivity and Power User Applications
I did not want to include my windows apps; but I thought while I am at dev productivity tools I may include my productivity applications too:

Here is a list of tools I use for debugging and troubleshooting:

 - **[dotPeek][23]**: *"a free-of-charge .NET decompiler from JetBrains."*
 - **[SysInternal Suite][24]**: *"Troubleshooting Utilities"*. I use Process Explorer, Process Monitor, ZoomIt (and sometimes TcpView and DebugView) more than other utilities in this suite.
 - **[WinDbg][25]**: *"a multipurposed debugger for Microsoft Windows."*
 - **[DebugDiag][26]**: *"designed to assist in troubleshooting issues such as hangs, slow performance, memory leaks or fragmentation, and crashes in any user-mode process."*
 - **[EQATEC][27]**: *"A great code profiler."*
 - **[Fiddler][28]**: *"a Web Debugging Proxy which logs all HTTP(S) traffic between your computer and the Internet."*. If you want to learn more about Fiddler you may see my presentation about it [here][29].
 - **[MS Network Monitor][30]**: *"Tool to allow capturing and protocol analysis of network traffic."*. Before MSNetMon I used to use [WireShark][31]; but I find MSNetMon easier to use.

... not quite windows tools and applications; but it would not be just if I did not mention these as part of my debugging stack:

 - **[Glimpse][32]**: *"A client side Glimpse to your server"*
 - **[Chrome Developer Tools][33]**: *"The Developer Tools, bundled and available in Chrome, allows web developers and programmers deep access into the internals of the browser and their web application."*. I used to use [FireBug][34]; but now I barely ever use it and FireFox for web programming and I must admit I cannot do it without Chrome and Chrome Dev Tools. If you want some kick-arse Chrome Dev Tools download [Chrome Canary][35]. I cannot stop talking about Chrome! When in dev tools (which you can bring up by pressing ctrl-shift-i) press ? to see a list of keyboard shortcuts. The shortcuts are awesome. For example, I felt really silly for having spent so much time on the Scripts pane looking for a script file after I learnt ctrl-o (resharper like) file lookup!

... and a few source control power tools: 

 - **[git-tfs][38]**: *"git-tfs is a two-way bridge between TFS and git, similar to git-svn."*. If you like me **have to** use TFS then do yourself a favor and use git-tfs to almost completely avoid TFS. git-tfs combined with Posh-Git have saved me so many f words a day ;-)
 - **[Posh-Git][36]**: *"A PowerShell environment for Git"*
 - **[git extensions][37]**: *"the only graphical user interface for Git that allows you control Git without using the commandline."*
 - **[TortoiseGit][39]**: *"supports you by regular tasks, such as committing, showing logs, diffing two versions, creating branches and tags, creating patches and so on"*
 - **[Posh-Hg][40]**: *"Inspired by the Posh-Git project. Posh-hg provides a custom prompt and tab expansion when using Mercurial from within a Windows Powershell command line."*
 - **[TortoiseHG][41]**: *"a Windows shell extension and a series of applications for the Mercurial distributed revision control system."*. The rather new HG Workbench is great.
 - **[DiffMerge][42]**: *"an application to visually compare and merge files within Windows, Mac OS X and Linux"*. I use this for my file and folder comparison from windows explorer.
 - **[P4Merge][43]**: *"allows users to visualize the differences between file versions. P4Merge uses color coding to simplify the process of resolving conflicts that result from parallel or concurrent development."*. I use this as my code diff and merge tool. You may find an article about integrating P4Merge with VS [here][44].

... and some really handy applications and not necessarily programming related:

 - **[EverNote][45]**: *"a suite of software and services designed for notetaking and archiving."*
 - **[SublimeText][46]**: *"Sublime Text is a sophisticated text editor for code, html and prose. You'll love the slick user interface and extraordinary features."*. This is great for editing Javascript and CSS.
 - **[Balsamiq Mockups][47]**: *"a Rapid Wireframing Tool"*
 - **[FocusBooster][48]**: *"a simple and elegant application designed
to help you eliminate the anxiety of time and enhance your focus and concentration."*
 - **[Synergy][49]**: *"lets you easily share your mouse and keyboard between multiple computers on your desk, and it's Free and Open Source."*
 - **[LastPass][50]**: *"LastPass is a password manager that makes web browsing easier and more secure."*
 - **[DropBox][51]**: *"a free service that lets you bring your photos, docs, and videos anywhere and share them easily. Never email yourself a file again!"*
 - **[SkyDrive (for Windows)][52]**: *"Keep important files on your PC in sync with SkyDrive.com."*
 - **[Connectify][53]**: *"The Easy-to-Use software router for windows."* 
 - **[RAMDisk][54]**: *"creates a virtual RAM drive, or block of memory, which your computer treats as if it were a disk drive."*
 - **[FreeMind][55]**: *"a premier free mind-mapping software written in Java."*

I hope you find something interesting and useful in this list. 

I am interested to hear what productivity tools and extensions you use. So leave me a comment about your gems.


  [1]: http://www.hanselman.com/blog/ScottHanselmans2011UltimateDeveloperAndPowerUsersToolListForWindows.aspx
  [2]: http://visualstudiogallery.msdn.microsoft.com/bdbcffca-32a6-4034-8e89-c31b86ad4813
  [3]: http://visualstudiogallery.msdn.microsoft.com/a56eddd3-d79b-48ac-8c8f-2db06ade77c3
  [4]: http://www.jetbrains.com/resharper/
  [5]: http://visualstudiogallery.msdn.microsoft.com/961e6734-cd3a-4afb-a121-4541742b912e
  [6]: http://hackingon.net/
  [7]: http://www.ncrunch.net/
  [8]: http://visualstudiogallery.msdn.microsoft.com/9d6ef0ce-2bef-4a82-9a84-7718caa5bb45
  [9]: http://jake.ginnivan.net/
  [10]: http://visualstudiogallery.msdn.microsoft.com/27077b70-9dad-4c64-adcf-c7cf6bc9970c
  [11]: http://visualstudiogallery.msdn.microsoft.com/e5f41ad9-4edc-4912-bca3-91147db95b99
  [12]: http://visualstudiogallery.msdn.microsoft.com/69023d00-a4f9-4a34-a6cd-7e854ba318b5
  [13]: https://nuget.org/packages/CodeAssassin.ConfigTransform
  [14]: http://www.mehdi-khalili.com/transform-app-config-and-web-config
  [15]: http://visualhg.codeplex.com/
  [16]: http://vscoloroutput.codeplex.com/
  [17]: http://testdriven.net/
  [18]: http://www.hanselman.com/blog/IntroducingWorkspaceReloaderAVisualStudioAddInToSaveYourOpenFilesAcrossProjectReloads.aspx
  [19]: http://visualstudiogallery.msdn.microsoft.com/872d27ee-38c7-4a97-98dc-0d8a431cc2ed?SRC=Home
  [20]: http://www.attrice.info/cm/tfs/
  [21]: http://visualstudiogallery.msdn.microsoft.com/c255a1e4-04ba-4f68-8f4e-cd473d6b971f
  [22]: http://visualstudiogallery.msdn.microsoft.com/72a60b14-1581-4b9b-89f2-846072eff19d
  [23]: http://www.jetbrains.com/decompiler/
  [24]: http://technet.microsoft.com/en-us/sysinternals/bb842062.aspx
  [25]: http://msdn.microsoft.com/en-us/windows/hardware/gg463009.aspx
  [26]: http://www.microsoft.com/en-us/download/details.aspx?id=26798
  [27]: http://eqatec.com/Profiler/
  [28]: http://www.fiddler2.com/fiddler2/
  [29]: http://www.mehdi-khalili.com/advanced-web-debugging-with-fiddler
  [30]: http://www.microsoft.com/en-us/download/details.aspx?id=4865
  [31]: http://www.wireshark.org/
  [32]: http://getglimpse.com/
  [33]: https://developers.google.com/chrome-developer-tools/
  [34]: http://getfirebug.com/
  [35]: https://tools.google.com/dlpage/chromesxs
  [36]: https://github.com/dahlbyk/posh-git
  [37]: http://code.google.com/p/gitextensions/
  [38]: http://git-tfs.com/
  [39]: http://code.google.com/p/tortoisegit/
  [40]: http://poshhg.codeplex.com/
  [41]: http://tortoisehg.bitbucket.org/
  [42]: http://www.sourcegear.com/diffmerge/
  [43]: http://www.perforce.com/product/components/perforce_visual_merge_and_diff_tools
  [44]: http://www.richard-banks.org/2009/09/using-p4merge-with-visual-studio-2008.html
  [45]: http://evernote.com/
  [46]: http://www.sublimetext.com/
  [47]: http://www.balsamiq.com/
  [48]: http://www.focusboosterapp.com/
  [49]: http://synergy-foss.org/
  [50]: https://lastpass.com/
  [51]: https://www.dropbox.com/
  [52]: https://apps.live.com/skydrive
  [53]: http://www.connectify.me/
  [54]: http://memory.dataram.com/products-and-services/software/ramdisk
  [55]: http://freemind.sourceforge.net/wiki/index.php/Main_Page