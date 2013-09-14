--- cson
title: "Offline Web Application"
metaTitle: "Offline Web appcache manifest"
description: "Making a web site available in offline mode could be tricky. In this post I cover a lot of gotchas and provide quite a few tips on how to do it"
revised: "2012-08-28"
date: "2012-08-27"
tags: ["html5","web","javascript","presentations"]
migrated: "true"
resource: "/presentations/wdyk-offline-web"
summary: """

"""
---
So you have got an awesome website and you want to make it even more awesome by making it (or parts of it) available to your users in offline mode. I this post I explain how you can do that. 

This is not an extensive post going through every single details. Instead I will show you techniques and ideas to get you started quickly and cover a lot of gotchas and provide quite a few tips on how to and not to do offline web. If you want to dig deeper and learn more I have also provided reference to some great articles about each topic. 

##Phone book sample app
I have put together a very simple phone book web application to show some of these features. The sample is built for my [What Do You Know talk][1]. Not that I have a lot of slides for a five minute talk; but you may find my slidedeck [here][2] just in case you are interested. You may also find the code from my GitHub account [here][3]. 

**WARNING**
This code is written to be demoed over 5 minutes. So I had to cut down on every possible bit of noise and keep the code to its simplest form. Feel free to check the code out as a sample for how offline web apps can be done but don't use it as is - a LOT must be improved on it.

To see the phone book web app in action run it Chrome which is the browser I have used to build and test the application. The app may not behave properly in other browsers - I told you this is demo quality :p 

Open the Chrome Dev Tools and bring up the console. If you now navigate to the Contacts page you can see in the console that the browser starts caching the pages and resources. After the caching has completed stop your dev web server to simulate an offline situation. Now navigate around the web site, go to the Contacts page, create contacts and so on to see how the web site works in offline mode. When the web server is down the pages are served from cache. Also the contacts you add are added to the local storage. When you fire up your dev web server again and navigate to the Contacts page you can see the records getting synced up to the server and then removed from local storage. 

Again this is just a sample app. You will need to implement some logic to deal with failures and reattempts while making sure that you will not double up the records. You can use a correlation id that is communicated to the server to make the sync operation idempotent.

A quick tip if you are writing an offline web app and want to constantly check how your app behaves in offline mode. Stopping and restarting web server or unplugging ethernet cable is a bit of pain. You can avoid that by using Fiddler. Setup an Auto Responder rule that rejects the requests from the website with a non-successful http status; e.g. 500. This will simulate the unavailable server. You can then activate and deactivate the offline mode from Fiddler by starting and stopping the capture. For the keyboard lovers hit ctrl+alt+f to bring Fiddler to the front and then hit F12 to toggle capture. If you are interested to learn more about Fiddler I have an extensive two part tutorial [here][4] and [here][5] or you may watch my DDDBrisbane about it [here][6].

Now back to the offline web.

##AppCache
Offline web apps are composed of two parts: offline cache and client side storage. You use offline cache (also known as AppCache) to make the resources available in offline mode and use client side storage so users can add, update and remove data without connectivity.  

AppCache is communicated to the browser through a resource known as AppCache Manifest. You tell the browser about the manifest through manifest attribute of the html tag. 

![Manifest Attribute][7]

When the browser sees the manifest, it will download and cache the manifest as well as the page with the manifest attribute. It then goes through the entries in the manifest and caches them all too.

![Browser downloading the offline cache][8]

(*This is what you should see in your console when you navigate to the Contacts page in the phone book application for the first time*)

If you want to see what has been cached you can navigate to [chrome://appcache-internals](chrome://appcache-internals) in Chrome. 

![Chrome AppCache Internals][9]

Did you notice the 'Remove' link there? Yes, users can clear their offline cache.

From there by clicking on 'View Entries' you can see a list of cached pages and can even drill down and see the pages too. 

![AppCache Internals entries][10]

###AppCache structure
AppCache manifest "file" should start with 'CACHE MANIFEST' and then come three optional sections: CACHE, NETWORK and FALLBACK: 

 - CACHE is where you specify the resources you want cached. It is worth mentioning that the page with the manifest pointer is cached too and is called 'Master' as shown in the AppCache Internals screenshot above.
 - You use NETWORK section to tell the browser which resources should not be served locally and require the user to be online.
 - FALLBACK is a very handy section where you can specify what the user should see if they request a resource not part of AppCache while in offline mode. To see the FALLBACK in action, try to navigate to phone book's home page in offline mode - after the resources are cached of course.

Here is a simplistic example of a manifest file:

![Cache Manifest Sample][11]

You can find much more information about AppCache manifest on [this post][12] on Html5Rocks.

**A few tips on AppCache:**

 - By convention you should use 'appcache' extension for the cache manifest "file"
 - The cache manifest resource mime type should be set to ‘text/cache-manifest’
 - The browser does not refresh the cache when you change the resources linked to by the manifest. If you want the cache to be refreshed because you have changed some of the resources you should change the manifest file itself. This can be done in a few ways: 
    - As shown above you can use a comment line to version the manifest file.  
    - You can use the website's build number (which is [what I have done][13] for the phone book app). The [build number increases][14] every time you deploy; so when you make changes on resources and deploy your website the manifest file changes and browsers will reload it. 
    - You can also append hash value of your static resources to their URL which again causes the manifest to change when the content of static files change. You can either [generate the hash manually][15] or use a framework that does that for you. The new [Bundler][16] in `System.Web.Optimization` in ASP.Net 4.5 appends the hash value to the URL of the bundled resources.
 - You can force the browser to refresh the cache by calling `window.applicationcache.update`. Please note that this call fails on pages that do not have manifest.
 - The caching process happens on the background and in the meantime the browser loads and shows you the old page it has cached before. So you are usually one page refresh behind the latest which could be confusing. To avoid that confusion you can call `applicationCache.swapCache()` when the cache status is `UPDATEREADY`. I would personally avoid this when possible to avoid page reloads. More info about this [here][17].
 
You may find a fair bit of useful info and tips on AppCache [here][18].
 
###Dynamic manifest file 
Browsers do NOT care or know if your AppCache manifest is dynamic or static; so you can dynamically generate it. Take a look at [AppCacheManifest.cshtml][19] view from my demo to see how you can do it. As you can see I am treating the Manifest just like a normal razor view: I am using html helpers to create links and even to render partial views inside the manifest file.

This is very crucial in some web applications including the phone book sample. The phone book app should cache phone book entries per user which means the cache manifest is different from user to user. So I am rendering a child action in the manifest using `@Html.Action("ContactsEdit", "OfflineSupport")` and the child action renders the [ContactsEdit partial view][20] (shown below) after it queries the database for the user's contact:

    @model List<int>

    @foreach(var id in Model)
    {
    @:@Url.Action("Edit", "Contacts", new { id })
    }

Another useful MVC trick is using routing. As mentioned above the cache manifest "file" should have 'appcache' extension. I called my manifest 'manifest.appcache' and that is mapped to `AppCacheManifest` action on `OfflineSupport` controller in my [RouteConfig][21]:

    routes.MapRoute(
        null,
        "manifest.appcache",
        new { controller = "OfflineSupport", action = "AppCacheManifest" });

This way it looks like a file with 'appcache' extension to the browser but is mapped to my action method and then razor view at runtime.

##Client storage
I call this client storage because it is not necessarily related to offline applications and you can use it in online mode too. That said as mentioned above you will need to use some sort of client storage so your users can persist changes in offline mode.

There are currently a few viable options available for client-side storage:

 - **Web Storage** is basically the `localStorage` object. It has [great browser support](http://caniuse.com/#search=web storage), is very simple to use and despite its rather poor performance is a good choice at the moment.
 - **Indexed Database** is a collection of "object stores" which you can just drop objects into. It has relatively good browser support, is a bit more complex than `localStorage` to use but has great performance and all in all is a great option for client-side persistence.
 - **Web SQL** would have been a great addition to this list; but unfortunately it was deprecated right when it was taking off. It is [still supported](http://caniuse.com/#search=web sql) on a lot of major browsers but IE and FF have never supported it and never will which makes it less than a perfect choice.

To learn much more about these choices and their pros and cons you may refer to [this post][22] on HTML5Rocks.

**A few tips on client-side persistence**

 - It is not safe to leave the data on users' browsers for a long time. So you should sync up the data persisted on the client as soon as the connection is back up again.
 - It is a good idea to show the offline entries to the user as if they are not offline. This helps avoid confusion and make a more consistent user experience.

It is also worth noting that users have read/write access to the data persisted on client side. For example you can see, edit and delete the local storage entries in chrome dev tools (and the same applies to Indexed Database and Web SQL):

![Client-persisted records in Chrome Dev tools][23]

*Have I ever mentioned how much I love Chrome Dev tools?! [Yes I have][24].*. 

If you want to learn more about Chrome Dev Tools you may read a terrific article about it [here][25].

##Detecting connectivity
So now that we have decided what technology to use to store user data while in offline mode we need to figure out when the user is actually offline!! There is going to be some javascript code you want to run only in online mode and some only in offline mode. For example when you show a form to the user you need to know whether the application is online or offline. In offline mode the users' actions should be stored in the offline storage and the entries should be shown to the user (this is done using [persistence.js][26] and [showOfflineRecords.js][27] respectively in the phone book app). Also when the application goes online again you need to sync up these entries (this is done using [syncUp.js][28] in the phone book app). 

So how can you identify the browser's connectivity? As you would expect there is an API for that: `navigator.isOnline`; but unfortunately [it is badly broken][29] - *"Browsers implement this property differently."* and most implementations are more or less useless!!

So without the support from the API what can we do? You could use an AJAX call to the server to see if the connection is up or not; but it is quite painful and confusing to set that up in an offline capable application and also requires an additional call to the server. The other alternative is to hook into AppCache events as raised by the browser. The browser is going to check for the AppCache anyway and in doing so it raises events. It is a relatively safe assumption that the user is offline if browser raises an error on the AppCache lookup (of course errors could happen for other reasons too). 

I am [hooking into AppCache events][30] to figure out whether the browser is online or offline. I then publish some messages about the browser status which are used by other parts of the application:

    App.connectivity = (function () {
        var publishConnectivityStatus = function (status) {
            if (status.type === "error")
                amplify.publish('app-is-offline');
            else
                amplify.publish('app-is-online');
        };

        var init = function () {
            window.applicationCache.addEventListener("error", publishConnectivityStatus);
            window.applicationCache.addEventListener("noupdate", publishConnectivityStatus);
            window.applicationCache.addEventListener("cached", publishConnectivityStatus);
            window.applicationCache.addEventListener("updateready", publishConnectivityStatus);
        };

        return {
            init: init
        };
    }());

These are not the only events raised from applicationCache; but these are the few I care about to identify connectivity.

You may see a few more options about checking connectivity [here][31].

##Conclusion
It feels relatively easy to make your website available in offline mode; but unfortunately there are quite a few gotchas in doing that. In this post I tried to cover some of these gotchas and to provide a solution or workaround for them.

You may find a few other gotchas [here][32]. There is also a great article about offline web applications on [dive into html5][33].

I hope you find this useful.


  [1]: http://whatdoyouknow.webdirections.org/brisbane
  [2]: http://www.slideshare.net/MehdiKhalili/offline-web-applications-14083038
  [3]: https://github.com/MehdiK/wdyk-offline-web
  [4]: http://mehdi-khalili.com/fiddler-in-action/part-1
  [5]: http://mehdi-khalili.com/fiddler-in-action/part-2
  [6]: /advanced-web-debugging-with-fiddler
  [7]: /get/blogpictures/wdyk-offline-web/manifest-attr.png
  [8]: /get/blogpictures/wdyk-offline-web/browser-caching.png
  [9]: /get/blogpictures/wdyk-offline-web/appcache-internals.png
  [10]: /get/blogpictures/wdyk-offline-web/appcache-internals-entries.png
  [11]: /get/blogpictures/wdyk-offline-web/cache-manifest-sample.png
  [12]: http://www.html5rocks.com/en/tutorials/appcache/beginner/
  [13]: https://github.com/MehdiK/wdyk-offline-web/blob/master/PhoneBook/Views/OfflineSupport/AppCacheManifest.cshtml
  [14]: https://github.com/MehdiK/wdyk-offline-web/blob/master/PhoneBook/Extensions/HtmlHelperExtensions.cs#L16
  [15]: http://www.deanhume.com/Home/BlogPost/mvc-and-the-html5-application-cache/59
  [16]: http://www.asp.net/mvc/tutorials/mvc-4/bundling-and-minification
  [17]: http://www.html5rocks.com/en/tutorials/appcache/beginner/
  [18]: http://appcachefacts.info/
  [19]: https://github.com/MehdiK/wdyk-offline-web/blob/master/PhoneBook/Views/OfflineSupport/AppCacheManifest.cshtml
  [20]: https://github.com/MehdiK/wdyk-offline-web/blob/master/PhoneBook/Views/OfflineSupport/ContactsEdit.cshtml
  [21]: https://github.com/MehdiK/wdyk-offline-web/blob/master/PhoneBook/App_Start/RouteConfig.cs
  [22]: http://www.html5rocks.com/en/tutorials/offline/storage/
  [23]: /get/blogpictures/wdyk-offline-web/client-side-records.png
  [24]: /developer-productivity-tools-and-visual-studio-extensions
  [25]: http://jtaby.com/2012/04/23/modern-web-development-part-1.html
  [26]: https://github.com/MehdiK/wdyk-offline-web/blob/master/PhoneBook/Scripts/offline/persistence.js
  [27]: https://github.com/MehdiK/wdyk-offline-web/blob/master/PhoneBook/Scripts/offline/showOfflineRecords.js
  [28]: https://github.com/MehdiK/wdyk-offline-web/blob/master/PhoneBook/Scripts/offline/syncUp.js
  [29]: https://developer.mozilla.org/en-US/docs/DOM/window.navigator.onLine
  [30]: https://github.com/MehdiK/wdyk-offline-web/blob/master/PhoneBook/Scripts/offline/connectivity.js
  [31]: http://www.html5rocks.com/en/mobile/workingoffthegrid/
  [32]: http://www.alistapart.com/articles/application-cache-is-a-douchebag/
  [33]: http://diveintohtml5.info/offline.html