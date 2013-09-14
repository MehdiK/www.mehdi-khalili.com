--- cson
title: "Why I do not mind VS2012 ALL CAPS menu"
metaTitle: "Why I do not mind Visual Studio 2012 ALL CAPS menu"
description: "A lot of devs seem unhappy about Visual Studio 2012 ALL CAPS menu; but I do not mind them and I think you should not either"
revised: "2012-06-12"
date: "2012-06-12"
tags: ["visual studio"]
migrated: "true"
resource: "/why-i-do-not-mind-visual-studio-all-caps-menus"
summary: """
Visual Studio 2012 is very impressive and I like a lot of things about it. It has quite a lot of useful features and yet the ALL CAPS menus seem to be the most popular topic and a lot of devs seem unhappy about it; but I do not mind all caps menus. In fact I do not even notice it.
"""
---
There are a lot of great features in Visual Studio 2012 and I really like what I see. There has been some discussion and posts about the new goodness but there has also been a lot of talk around why Microsoft made the VS menus ALL CAPS. 

The good news for those who do not like the all caps menus is that the Visual Studio team [has taken the feedback on-board][1] and will allow customizing the casing. If that is not good enough and you really want to switch to normal casing menus **now** [Richard Banks somehow found][2] a way to disable the setting and switch the menus to normal casing. I think that is an awesome find and as you can see in the comments **many** developers are really pleased with this find.

That said ...

###The menu casing does not matter
As explained in the VS blog they have thought the decision through and have made the change for a reason and are now even happy to allow customization of the casing; but I honestly think the casing of the menus does not matter.

One of the features I really like about VS2012 is the new Quick Launch box on the top right of VS window:

![Quick Launch box][3]

From [MSDN][4]: *You can use Quick Launch to quickly search and execute actions for IDE assets such as options, templates, menus.*

... and the Quick Launch box is basically the reason I do not care about menu casing: it helps me avoid using menus almost completely. Whether you are keyboard or a mouse person you can leverage the power of Quick Launch to boost your speed in VS. Say for example you want to 'Manage NuGet Packages for Solution'. To find that option from menus (apart from the wasteful act of reaching for your mouse) you will need to click on Tools, then click on 'Library Package Manager' and then click on 'Manage NuGet Packages for Solution':

![Navigating using menus][5]

The alternative is to (not reach for your mouse and keep your hands on your keyboard and look professional and) hit Ctrl+Q to focus the Quick Launch box and then type 'manage nuget' and hit Enter:

![Using Quick Launch][6]

I find the latter option much better. Well, admittedly you do not need to use your mouse to navigate to the menus and can call the actions by using keyboard shortcuts which is what a lot of devs have been doing in previous versions of VS; but it is nowhere as good as the Quick Launch. Let me give you another example: how would you navigate to 'Fonts and Colors' options?

![Fonts and Colors options][7]

Using menus you would have to click Tools -> Options and then find your way in the huge list of options (on the left). Perhaps the faster way would be to hit Alt+T (for Tools) and then hit 'O' (for options) and then again find your way in the huge list of options. Alternatively you could hit Ctrl+Q and then type 'fonts' and Enter. That is all. You are already there :)

... but what if the result of my search keyword was a big list?

![Big search result][8]

*(Did you notice the shortcuts next to items in the list? So you can actually pick up a few new shortcuts using Quick Launch too)*

Well, firstly you can narrow your search by typing more. For example instead of 'edit' I could search for 'Edit speci' if I am looking for 'Edit -> Paste Special'. There is also the concept of Categories which you can use to filter down your list. There are four categories: `Most recently used`, `Menus`, `Options` and `Documents` for which you could prefix you search with `@mru`, `@mnu`, `@opt` and `@doc` respectively. Ok, I will stop here. I am not going to repeat [MSDN][9] here and there are already [great posts][10] on the Quick Launch box.

IMO there are quite a few benefits in using Quick Launch box instead of using menus and your mouse. A few ones that stand out for me are that you can use your keyboard more effectively which means you can work faster without having to constantly reaching for and using your mouse ... which also means that you will not have to use your computer the same way you grandma does and run the simplest of commands using your mouse ;-)

###... but my VS is still shouting at me?!
Even if you do not use the menus you may still not like the ALL CAPS menus as some devs find it rather distracting. In my post about [Developer Productivity Tools][11] I mentioned a VS extension called [HideMenu][12]. I really like this extension and kudos to Matthew Johnson for writing it. 

Whether you like the menu casing or not, I think hiding the main menu is a good idea and is very handy. Firstly you do not have to sit there and watch while, as some devs say, VISUAL STUDIO IS SHOUTING AT YOU; but even more importantly (at least for me) you get more screen real estate which I always welcome:

![No menus][13]

See? No menus and I do not need one thanks to 'Quick Launch' which means that I do not care about menu casing. In fact I do not mind some ALL CAPS menus for a change for those rare cases when I need to use menus ;-)


  [1]: http://blogs.msdn.com/b/visualstudio/archive/2012/06/05/a-design-with-all-caps.aspx
  [2]: http://www.richard-banks.org/2012/06/how-to-prevent-visual-studio-2012-all.html
  [3]: /get/blogpictures/vs2012-all-caps/VS2012-quick-launch.png
  [4]: http://msdn.microsoft.com/en-us/library/hh417697(v=vs.110).aspx
  [5]: /get/blogpictures/vs2012-all-caps/navigating-using-menus.png
  [6]: /get/blogpictures/vs2012-all-caps/using-quick-launch.png
  [7]: /get/blogpictures/vs2012-all-caps/fonts-and-colors.png
  [8]: /get/blogpictures/vs2012-all-caps/big-result-set.png
  [9]: http://msdn.microsoft.com/en-us/library/hh417697(v=vs.110).aspx
  [10]: http://blogs.msdn.com/b/visualstudio/archive/2011/09/27/visual-studio-11-developer-preview-quick-launch.aspx
  [11]: /developer-productivity-tools-and-visual-studio-extensions
  [12]: http://visualstudiogallery.msdn.microsoft.com/bdbcffca-32a6-4034-8e89-c31b86ad4813
  [13]: /get/blogpictures/vs2012-all-caps/no-menus.png