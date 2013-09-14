--- cson
title: "Fiddler In Action - Part 2"
metaTitle: "Fiddler In Action - Part 2"
description: "In this article I will try to cover some of the advanced features of Fiddler"
revised: "2012-04-25"
date: "2011-08-26"
tags: ["debugging","web","fiddler"]
migrated: "true"
resource: "/fiddler-in-action/part-2"
summary: """
In the first article I covered some of the basic features of Fiddler. In this article I will try to cover some of the more advanced features.
"""
---
**[Update - 2012-04-25] I covered these features in my presentation at [DDD Brisbane][1]. You may find the slides, the video and more details [here][2]**

In the [first part][3] we covered some of the basic features of Fiddler. In this article we will cover some of the more advanced features of this great tool. So fire up your Fiddler and get ready for some interesting features.

##QuickExec
There is a little textbox with black background color and green forecolor on the bottom of Fiddler form where you can run some very useful commands. To see a complete list of available commands type 'help' and enter. That takes you to the [Fiddler's website][4] where all the available commands are explained in details. Below I will list a few of them:

 - ?sometext: *As you type sometext, Fiddler will highlight sessions where the URL contains sometext.  Hit Enter to set focus to the selected matches.*; e.g. ?google
 - <span>>size: *Select sessions where response size is greater than size bytes.*; e.g. >4000</span>
 - <size: *Select sessions where response size is less than size bytes.*; .e.g <200
 - =status: *Select sessions where response status = status*; e.g. =304
 - =method: *Select sessions where request method = method.*; e.g. =post
 - select MIME: *Select any session where the response Content-Type header contains the specified string.*; e.g. select image
 - urlreplace: *Replace any string in URLs with a different string.  Setting this command will clear any previous value for the command; calling it with no parameter will cancel the replacement.*.

<img src="/get/blogpictures/fiddler-in-action-2/quickexec-box.png" alt="QuickExec box" />

*Figure 1 - Highlighting the traffic where the URL contains my name*

The above list (plus a few commands I will discuss below) are those I use most. Please go to the Fiddler's reference page to see the complete list.

For shortcut lovers when Fiddler window is active you can use Alt+Q to activate QuickExec box.

##Set breakpoints
Fiddler provides us with a few ways to set breakpoints which I explain below:

###1. Use the small button on the status bar to set breakpoints
<img src="/get/blogpictures/fiddler-in-action-2/breakpoint-button.png" alt="Breakpoint button on status bar" />

*Figure 2 - Breakpoint button on status bar*

Clicking on that button once sets breakpoint for all requests. Clicking on it again removes the requests breakpoint and sets breakpoint for all responses. Clicking on it the third time removes all the breakpoints that were set by this button.

###2. Automatic Breakpoints menu
You can achieve the same result using menus:

  - Go to 'Rules' menu -> 'Auto Breakpoints'
  - Clicking 'Before Requests' does the same thing as clicking on the breakpoint button in status bar once and sets breakpoint for all requests.
  - Clicking 'After Responses' does the same thing as clicking on the breakpoint button in status bar for the second time and removes requests' breakpoint and set responses' breakpoints.
  - Clicking 'Disabled' does the same thing as clicking on the breakpoint button in status bar for the third time and disables responses' breakpoints.

<img src="/get/blogpictures/fiddler-in-action-2/breakpoint-on-rules-menu.png" alt="Breakpoint menus" />

*Figure 3 - Breakpoint menus*

You could also achieve the same result using the keyboard shortcuts shown on the menu.

###3. Breakpoint commands run on QuickExec
My preferred way is to set breakpoint using QuickExec commands. If you want to quickly set a breakpoint you may want to use one of the abovementioned features; however I have found that setting breakpoints through commands is much more powerful and gives me a very fine control over where I am setting the breakpoint. The problem with setting breakpoints on all requests or responses is that they get hit too frequently and on urls or requests that you do not care about which becomes annoying very soon. You could use Filters to limit the traffic to what you are interested and use breakpoints on all requests or responses. I will discuss Filters shortly.

In the QuickExec box type in 'bp' and enter. This will show you a handy help popup dialog that lists the breakpoint commands.

<img src="/get/blogpictures/fiddler-in-action-2/bp-commands.png" alt="bp commands" />

*Figure 4 - Breakpoint commands' help dialog*

As you can see in the dialog you have four commands to set breakpoints:

- bpu url: that sets breakpoint for the requests on the provided url; e.g. bpu mehdi-khalili
- bpm method: that sets breakpoint on a method which is very handy; e.g. bpm post which breaks only on POST requests.
- bps status: that sets breakpoint on a response with the provided status; e.g. bps 304
- bpafter url: that sets breakpoint for the responses from the provided url.

To clear the breakpoint you should use the command alone. For example, using 'bpu' clears the request breakpoints you have set.

##Let's change the traffic on the fly
Above we saw a few ways to set breakpoints. When the breakpoint is set the next time you make a request or receive a response that fulfils the breakpoint's requirements the breakpoint is hit and you get the opportunity to change the traffic.

You can change pretty much anything in the header or in the body. Below I will do two very quick demos: one for request and one for response modification.

###Request breakpoint on Fiddler's sandbox
Fiddler even has a sandbox you can use for practicing! To navigate to the sandbox go to Tools menu and click on Sandbox. This takes you to the Fiddler's sandbox website. 

![Sandbox][5]

*Figure 5 - Fiddler's Sandbox*

We are going to use online shopping cart to set up a breakpoint on the request and change the request data on the fly; but first let's see how the website works:

- If Fiddler is not running, fire it up.
- Go to the sandbox website and click on the first link: "Shopping Cart Example".
- Click 'CheckOut' button on one of the items. This "checks out" the item and takes you to the next page that shows you what you are purchasing and how much it is costing you.

OK, now that we know how the website actually works, let's change its behavior:

- Bring Fiddler to the front and enter 'bpm post' in the QuickExec box. This sets a breakpoint for HTTP POST requests. You can use Ctrl+Alt+F to bring Fiddler to the front (and the shortcut to activate QuickExec box is Alt+Q).
- Go back to the shopping cart again and 'checkOut' an item. This should cause a hit on the post breakpoint we just set because it is a submit button that sends an HTTP POST request.
- Bring Fiddler to the front (you know the shortcut, right?). You can see that the request icon has changed to 'Breakpoint hit on the request' (Figure 6).
- Double click the request. This takes you to inspector tab and to the most relevant inspector - in this case 'Web Forms'.
- Change the values of 'Cost' and 'lbQuantity' to 10 and 100 (Figure 7). Well, you could pick any value really.
- Now click on the 'Run to Completion' button which sends the changed request and runs the session to completion.

![Breakpoint hit on POST][6]

*Figure 6 - Breakpoint hit on POST*

![Inspector when breakpoint is hit][7]

*Figure 7 - Inspector window when breakpoint is hit*

Now double check the website again. Congratulations - you just added 100s of the same item to your cart for the price of one :o)

![Hacked sandbox Shopping Cart][8]

*Figure 8 - Hacked sandbox Shopping Cart*

This could be very useful in testing the behavior of your website on different inputs and verifying that your website is doing proper validation.

In the last step, instead of clicking on 'Run to Completion' you could click on 'Break on Response' which would send the request to the server, wait for the response, and break upon receiving the response. This would give you an opportunity to also modify the response before returning it to the client.

###Response breakpoint on Bing homepage
You could use the knowledge you learnt above to also change a response. For this example I am going to use Bing's homepage:

- Start up Fiddler or bring it to front
- Set a breakpoint on Bing's homepage response using the following QuickExec command: bpafter www.bing.com
- Navigate to Bing in your browser. This should cause the breakpoint hit.
- Bring Fiddler to the front and double click on the session where the breakpoint is hit. This takes you to the Inspectors.
- Change the body of the response in any shape and form and click 'Run to completion'.

If you go back to your browser you should see your changes there. Here is an example of changes I made to Bing homepage:

![Hacked Bing][9]

*Figure 9 - Lame design of hacked bing*

Yeah, I know - that is pretty lame; but this is not an article about design; it is about Fiddler. Well, to be honest with you even if it was about design I could not make it much nicer ;-)

##AutoResponder
AutoResponder is a very handy tool. It allows you to fake server's responses. If you think about it, Fiddler is sitting between you and the web server and nothing can stop it from returning the response locally without hitting the server, and that is basically what AutoResponder does. You can configure AutoResponder to respond to specific requests and let the others through, or you can ask it to only respond to the traffic you expect and block the rest. 

AutoResponder uses some rules to match the request. From [Fiddler's reference][10]: 

> On the AutoResponder tab, you enter a match rule and an action string, and Fiddler will undertake the action if the request URI matches the match rule. Tips: 

> - Rules are applied in the order that they appear. Hit the Plus key to promote a rule to earlier in the list. Hit the Minus key to demote a rule to later in the list.
> - From the context menu, you can Export a .FARX file which contains a list of rules and actions.
> - You can also Import a .SAZ or Import a .FARX file to create rules based on previously captured traffic.
> - You can drag-drop sessions from the Web Sessions list to replay previous responses. You can edit a rule's stored response by selecting the rule >and hitting Enter.
> - You can also drag & drop files from Windows Explorer to automatically generate AutoResponder Rules for those files.

The AutoResponder rule-engine is quite rich. It allows you to match the exact url or part of it or use regex to define a pattern (plus a few other rules).

So I used the change I made above to the Bing homepage and created an AutoResponder archive. You can download the archive from [here][11]. After downloading this to your drive, drag and drop it from Windows Explorer to Fiddler's AutoResponder tab. Well, first make sure that AutoResponder is enabled otherwise it will be readonly. To enable AutoResponder tick 'Enable automatic responses' checkbox on AutoResponder tab.

![AutoResponding to Bing][12]

*Figure 10 - AutoResponding to Bing*

Now enter [www.Bing.com][13] in your browser's address bar and you are going to get the image I provided above. Now disable your internet access and try the url in your browser again. It works!! You do not need Internet connection because your browser requests are all responded to locally thanks to the WinINet proxy. 

AutoResponder is very handy if you want to avoid hitting your servers for some of the requests. For example, assume you want to test a website that hits a web service using AJAX and assume that web service is broken but you still want to test it. You can use AutoResponder to return a canned response when the web service is requested. 

Adversely, you could also test your web site's fault tolerance by AutoResponding to web service requests and making web service calls fail.

##RequestBuilder
I was going to write something up for this; but what is in the [Fiddler's Reference page][14] is concise and nice. So I am just copy-pasting from there ;-)

<i>
The Request Builder allows you to craft custom requests to send to a server. You can either create a new request manually, or you can drag and drop a session from the Web Sessions list to create a new request based on the existing request.

There are two modes for the RequestBuilder. In Parsed mode, you can use the boxes to build up a HTTP(S) request. In Raw mode, you must type in a properly formatted HTTP request yourself. Generally, using Parsed Mode is what you want.
</i>

![Request Builder][15]

*Figure 11 - RequestBuilder*

All I did above was to drag and drop the session from Shopping Cart, which we hacked together, from the session list to the RequestBuilder page and it populated the fields for me. Now I can change anything I want and click Execute.

Request Builder could be very useful when you want to quickly test the behavior of a web service given a response; particularly if your client is not very easy to drive. For example, I am currently working on a project where client is a third party application I do not have any access to. It makes calls into some web services that we have developed. Testers could use Fiddler to test the behavior of our web services without having to deal with the intricacies of the third party client.

##Filters
From the [reference page][16], *Fiddler's Filters tab allows you to easily filter and flag traffic displayed in the Fiddler UI, as well as do some lightweight modifications.*

There is not much to Filters really and what you see is what you get. It is pretty simple and what is in the reference page is quite good.

For filtering to a process, instead of Filters tab, I think the 'Process Filter' from toolbar or process category filter from status bar are good enough:

![Process Filters][17]

*Figure 12 - Process Filters*

To use Process Filter push your mouse button on it and hold it down while you hover it over other processes. When the target window is highlighted leave the mouse button and the traffic will be limited to that process. If you click on the button again, it removes the filter.

To filter traffic by process category you may click on the button shown in the screenshot. By default filter captures traffic from all processes. If you click on the button that says 'All Processes' it will change to 'Web Browsers' and will limit the capture to only Web Browser traffic. Another click reverses the filter and shows Non-Browser traffic, and next click hides away all the traffic and next one resets it back to 'All Processes'.

You could achieve the same result using the Client Process Panel from Filters tab:

![Filter by Client Process][18]

*Figure 13 - Filter by Client Process*

But many times that simple filter does not cut it and there are tones of other useful filters in the Filters tab including filtering by host, request headers, response status codes, type and size that you can use to trim down the traffic and keep it focused on what you are 'fiddling' with. The rest of Filters UI is very nicely classified as shown in the below screenshot:

![Request and Response Filters][19]

*Figure 14 - Request and Response Filters and Breakpoints*

Oh, and there is a forth way of setting breakpoints as shown above which is quite handy. You could also delete or set request and response headers using Filters.

##FiddlerCap
[FiddlerCap][20] is an amazing tool in terms of its ease of use for end users. FiddlerCap to Fiddler is what ADPlus is to windbg: it allows your end user with no technical knowledge to capture some useful information from the production for you to have a look at on your computer and troubleshoot the issue as if you were running the actual tool on the user's computer. So in a way it bridges the gap between developers and production environment.

![Fiddler Cap][21]

*Figure 15 - FiddlerCap*

FiddlerCap is very useful for end users that do not want to know about Fiddler and how it works. They use the tool on their computer to capture the traffic (from the functionality that is not behaving), optionally add comment and screenshot to it, and save it and send it to you. You can then open it up in Fiddler and see what happened on their computer, read their comments and see their screenshot. Very handy.

##FiddlerCore
FiddlerCap uses [FiddlerCore][22] which is a .Net library in the heart of Fiddler:

![Fiddler Architecture][23]

*Figure 16 - Fiddler Architecture*

*FiddlerCore allows you to integrate HTTP/HTTPS traffic viewing and modification capabilities into your .NET application, without any of the Fiddler UI.*

So if you are writing an application that could benefit from Fiddler like functionality you have got a nice very thoroughly tested library, called FiddlerCore, that you can use.

###Fiddler Extensions
Just before we wrap this up, I would like to ask you to go to [Fiddler's extension page][24] and have a look at available extensions. There are quite a few very useful extensions in there that I am sure you will enjoy using.

###Conclusion
So there you have it. I hope you found this tutorial useful. As mentioned before, this in no way is an exhaustive reference to Fiddler; instead I tried to give you enough information for you to be able to more effectively use Fiddler. If you want to dig deeper then [Fiddler website][25] and [Fiddler Blog][26] will be the place to look at.

Hope this helps.

<a href="http://www.codeproject.com/script/Articles/BlogFeedList.aspx?amid=khalili" style="display:none" rel="tag">CodeProject</a>


  [1]: http://dddbrisbane.com/
  [2]: /advanced-web-debugging-with-fiddler
  [3]: /fiddler-in-action/part-1
  [4]: http://www.fiddler2.com/fiddler/help/quickexec.asp
  [5]: /get/blogpictures/fiddler-in-action-2/sandbox.png
  [6]: /get/blogpictures/fiddler-in-action-2/breakpoint-hit-on-post.png
  [7]: /get/blogpictures/fiddler-in-action-2/inspector-on-breakpoint-changed.png
  [8]: /get/blogpictures/fiddler-in-action-2/hacked-shopping-cart.png
  [9]: /get/blogpictures/fiddler-in-action-2/hacked-bing.jpg
  [10]: http://www.fiddler2.com/fiddler2/help/AutoResponder.asp
  [11]: /get/downloads/HackBing.saz
  [12]: /get/blogpictures/fiddler-in-action-2/autoresponder.png
  [13]: http://www.bing.com
  [14]: http://www.fiddler2.com/fiddler/help/requestbuilder.asp
  [15]: /get/blogpictures/fiddler-in-action-2/request-builder.png
  [16]: http://www.fiddler2.com/fiddler2/help/Filters.asp
  [17]: /get/blogpictures/fiddler-in-action-2/process-filter.png
  [18]: /get/blogpictures/fiddler-in-action-2/filters-by-client-process.png
  [19]: /get/blogpictures/fiddler-in-action-2/filters-request-bp-response.png
  [20]: http://www.fiddlercap.com/FiddlerCap/
  [21]: /get/blogpictures/fiddler-in-action-2/fiddler-cap.png
  [22]: http://www.fiddler2.com/fiddler/Core/
  [23]: /get/blogpictures/fiddler-in-action-2/fiddler-core.png
  [24]: http://www.fiddler2.com/fiddler2/extensions.asp
  [25]: http://www.fiddler2.com/fiddler2/
  [26]: http://blogs.msdn.com/b/fiddler/