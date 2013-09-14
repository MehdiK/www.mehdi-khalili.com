--- cson
title: "Transform app.config and web.config"
metaTitle: "Transform app.config and web.config"
description: "How to transform app.config and web.config files easily using CodeAssassin.ConfigTransform and SlowCheetah"
revised: "2012-03-29"
date: "2012-03-28"
tags: ["agile","build","ci"]
migrated: "true"
resource: "/transform-app-config-and-web-config"
summary: """
Web config transformation is a neat solution for transforming config files for different environment. It however has some issues and limitations that make it a less than ideal solution. 

In this article I will explain how you can transform any and all config file regardless of the project type and even without relying on build configuration
"""
---
One of the biggest promises and benefits of Agile is short feedback loops and to get short feedback loop we need to deploy our application frequently. From [Agile Manifesto][1]: 

"*Our highest priority is to satisfy the customer through early and continuous delivery of valuable software.*"

To be able to that you really want to get as close as possible to the Push-Button deployment so deploying to any environment is just a click away; otherwise the deployment will turn into a heavy burden and you will give up on the benefits.

Different environments require different settings. This means that to deploy to each environment you need to change your connection strings, security settings, active directory and network addresses, proxy settings, service endpoints and so on and so forth. You really do not want to maintain a separate config file per environment as it gets messy and unwieldy very quickly. A DRY solution is to use the development config file and just transform it for each environment. This way you will only need to maintain the delta/transformations for each environment.

The out of the box [web config transformation][2] built into Visual Studio and MSBuild is awesome. It does exactly that and in a very clean way.. but there are a few issues with it:

 - It only works for web applications. This means that if you want to deploy a desktop application or a windows service that require config transformation you are out of luck with OOTB solution. I honestly do not understand why Microsoft thinks that only web applications require or deserve config transformation!!
 - It works with Build Configuration. You should have one build configuration per environment for the config transformation to work. On the same line, for the transformation to happen you need to build your solution using the relevant build configuration; e.g. if you want to deploy to Production you need to build your solution using a build configuration created for production release (which perhaps is called 'Production') and for Test environment you need to build using the 'Test' build configuration.

##Config Transformation 
In this article, I am going to talk about two great solutions for config transformation: CodeAssassin.ConfigTransform and SlowCheetah. Both solutions fix the same problem: they allow you to apply config transformation on any and all config file regardless of the project type. They, however, have a few differences that I will explain below.

###CodeAssassin.ConfigTransform
CodeAssassin.ConfigTransform is a great solution implemented by Jason Stangroome one of my colleagues at Readify. From the [nuget homepage][3]: "*Transforms all *.config files at build time instead of the default MSBuild behaviour of only transforming the configuration file matching the current build configuration*". 

To use CodeAssassin.ConfigTransform you need to install the nuget package (from Package Manager Console) on the project where you want to apply the transformation:

Install-Package CodeAssassin.ConfigTransform

This will install and activate the package on your project. If you open your project file in a text editor you will see the following line added to the bottom:

    <Import Project="..\packages\CodeAssassin.ConfigTransform.1.1\tools\CodeAssassin.ConfigTransform.targets" />

As part of package installation a PowerShell script is run which adds this MSBuild target  to your project which is what makes the transformation magic happen. 

Let's see how it works. For demo, I have created a console project called <code>CodeAssassin</code>. It does not have to be a console app: it could be a windows service, a website or anything really - it does not matter as far as this package is concerned. I have also added an application configuration file (app.config) to the project which for the purpose of this demo only has a connection string in it:

    <?xml version="1.0" encoding="utf-8" ?>
    <configuration>
      <connectionStrings>
        <add 
          name="MyDatabaseConnection" 
          connectionString="Data Source=.\SQLEXPRESS;Initial Catalog=SomeDatabase;Integrated Security=True" 
          providerName="System.Data.SqlClient" />
      </connectionStrings>
    </configuration>

When you build the project as is, the config file ends up in the build output as is as you do not have any transformation. So let's add the transformation. To do this you should add a file with <code>.config</code> extension. The name does not matter as long as the extension is '.config'; however to make it consistent with the OOTB naming convention I am going to name mine app.UAT.config which supposedly holds the transformation required for my UAT environment:

    <?xml version="1.0"?>
    
    <configuration xmlns:xdt="http://schemas.microsoft.com/XML-Document-Transform">
        <connectionStrings>
          <add name="MyDatabaseConnection" 
            connectionString="Data Source=ReleaseSQLServer;Initial Catalog=MyReleaseDB;Integrated Security=True" 
            xdt:Transform="SetAttributes" xdt:Locator="Match(name)"/>
        </connectionStrings>
    </configuration>

All I am doing here is to transform the connection string into the one required for the (fake) UAT environment. If you are not familiar with XDT config transformation I would recommend you to have a look at [the article at MSDN][4] website.

Now when I build the project again I see another file, called app.UAT.config.transformed, appearing in my output folder next to the rest of the build result:

![CodeAssassin's result][5]

... and the content of this file is the transformed version of my app.config. The comparison with the original config file is shown below:

![CodeAssassin's result compared with the original app.config][6]

The only thing left to do is to rename that file into the actual config file name, in this case CodeAssassin.exe.config. If it was a web application you would want to rename the file into web.config. You could do the clean up using PowerShell which should run as part of your deployment script. The script could be something like:

    function ConfigTransform ($destinationPath, $originalConfig, $transformedConfig) {
        # get full path for the new config
        $newConfig = Join-Path -Path $destinationPath -ChildPath $transformedConfig
        
        # rename the transformed config to the desired config name; e.g. app.UAT.config.transformed => ConsoleApp.exe.config
        Rename-item $newConfig $originalConfig

        # delete unwanted files
        $patternToRemove = ("*.transformed", "*.config")
        $patternToKeep = ("web.config", "*.exe.config")
        
        # remove all the .transformed and .config files from the destination path except web.config and *.exe.config
        gci $destinationPath\* -include $patternToRemove -exclude $patternToKeep | foreach ($_) { Remove-Item $_.fullname }   
    }

The second part is required if you want to get rid of all the other .transformed files. You may end up with quite a few .transformed files depending on the number of config transform files/environments you have. This happens because CodeAssassin.ConfigTransform, as mentioned above, does the transformation regardless of the current build configuration which means it is going to transform all the available .config files.

**Pros:**

 - This package can apply config transformation to any and all config file regardless of the project type.
 - It does not require one build configuration per transformation. To apply transformation all you need to do is to add a config transform file. This means that even for web applications which have the out of the box support for config transform you can use this package to do your transformation without relying on different build configurations. This could simplify your solution where you would otherwise end up with many build configurations: one per environment.
 - It provides for a self-contained solution; i.e. to build a project that uses CodeAssassin.ConfigTransform you will not need to do anything as the dependency is in the nuget package that either is included with the code or gets downloaded as part of build.

**Cons:**

 - The result does not just work. You still have to rename the files to the actual config file before running the application.
 - Because it runs all the transformations you will potentially end up with many .transformed files. These files are not going to harm: they just add some unnecessary noise. Of course this is the price we pay for not relying on (current) build configurations.
 - By default the config transform files are not grouped under the config file. You can easily fix this by manually editing the project file though.

To sum up, I think this is quite a neat package and the abovementioned cons are not really con: it is the price we pay to avoid relying on build configuration which IMO is quite a low price ... and we just saw above how easy it is to rename the result config file and to clean up the unnecessary transformed files.

###SlowCheetah
SlowCheetah, implemented by Chuck England and Sayed Ibrahim Hashimi from Microsoft, is another awesome solution that does more or less the same thing. From the [project homepage][7]: "*This package enables you to transform your app.config or any other XML file based on the build configuration. It also adds additional tooling to help you create XML transforms.*". 

To install SlowCheetah you will need to [download and install the SlowCheetah Visual Studio extention][8]. After doing so you will get the 'Add Transform' option in all projects (and not only web projects) with a UI experience which is very similar to the built in config transform. Let's apply SlowCheetah on the same project with the same config and transformation requirements: 

So I have gone ahead and created a console application called SlowCheetah and added the same app.config to it. After having installed SlowCheetah I can right click on the app.config file and now I get an 'Add Transform' menu item! Please note that without SlowCheetah you will get this option ONLY for web.config files:

![Add Transform menu added by SlowCheetah][9]

When I click the menu, I get one config transform added under my config file **per build configuration**. It is important to note that SlowCheetah like the OOTB solution only works based on build configurations which means you need to have one build configuration per environment (or I should say per transformation). For brevity I am not going to add the UAT build configuration; but if we were to get a config transformation for UAT we could add a UAT build configuration. For now I will add config transformation with the default build configurations (debug and release):

![SlowCheetah transform files added][10]

All I need to do to apply my transformation is to edit the transform files (as if it is a web application and I am transforming web.config file). For this demo I am just copying the very same transformation I used above in the CodeAssassin example.

Now I build the solution and voila:

![SlowCheetah Transform Result][11]

Notice how there is only one config file called SlowCheetah.exe.config. This file is actually the transformed file whose content matches exactly the content of the file transformed by CodeAssassin.ConfigTransform. The reason SlowCheetah can overwrite the actual config file is that it works off the build configuration and only applies transformation for the current build configuration.

SlowCheetah uses pretty much the same technique as CodeAssassin.ConfigTransform. So if you open the project you are doing the transformation on you can see a few lines added:

    <PropertyGroup>
       <SlowCheetahTargets Condition=" '$(SlowCheetahTargets)'=='' ">$(LOCALAPPDATA)\Microsoft\MSBuild\SlowCheetah\v1\SlowCheetah.Transforms.targets</SlowCheetahTargets>
    </PropertyGroup>

... which is basically loading the SlowCheetah MSBuild build target from the above path ($(LOCALAPPDATA)\Microsoft\MSBuild\SlowCheetah\v1\SlowCheetah.Transforms.targets) and then down the bottom very similar to CodeAssassin.ConfigTransform we see:

    <Import Project="$(SlowCheetahTargets)" Condition="Exists('$(SlowCheetahTargets)')" />

... which applies the build target.

There is also a very handy 'Preview Transform' feature that allows you to preview the transformation even without building the app. To preview the transformation you should right click on your config transform file and then click on the 'Preview Transform' menu item:

![Preview Transform menu item][12]

... which opens the transformed and original config files in a diff tool:

![Preview Transform result][13]

**Pros:**

 - As mentioned above SlowCheetah can apply config transformation to any and all config file regardless of the project type.
 - It outputs the config file required to run the application which means you will not have to do anything to get the app running (e.g. renaming config files after build like we did with CodeAssassin.ConfigTransform is not required)
 - It comes with a nice and handy preview feature that shows you what the config file will look like after the transformation is done.

**Cons:**

 - Just like out of the box solution, you need to have one build configuration per transformation.
 - And again just like OOTB solution you need to build your solution with the appropriate build configuration for it to use the right transform template.
 - This solution is not self-contained. If you are using SlowCheetah you will either have to have the extension installed on all the dev machines (and the build server) or copy the required files to the expected path: $(LOCALAPPDATA)\Microsoft\MSBuild\SlowCheetah\v1\SlowCheetah.Transforms.targets.

##Conclusion
CodeAssassin.ConfigTransform and SlowCheetah are great solutions that allow easy config transformation for any project type which in turn empowers your Continuous Delivery and provide for shorter feedback cycles. 

Which of these solutions you choose depends on your requirements and environment. If you do not have any problem having several build configurations and if you can easily build whatever build configuration (from your build server) then SlowCheetah is a great fit (even though CodeAssassin.ConfigTransform will work too). If, on the other hand, you do not want to have multiple build configuration files, you are already doing some PowerShell magic as part of your deployment, or for some reason you cannot or do not want to build your solution using different Build Configuration, then CodeAssassin.ConfigTransform is the answer (but SlowCheetah will not work).

The code for this post is available for download from [here][14]. 


<a href="http://www.codeproject.com/script/Articles/BlogFeedList.aspx?amid=mehdi-khalili" rel="tag" style="display: none;">CodeProject</a>


  [1]: http://agilemanifesto.org/principles.html
  [2]: http://msdn.microsoft.com/en-us/library/dd465326.aspx
  [3]: http://nuget.org/packages/CodeAssassin.ConfigTransform
  [4]: http://msdn.microsoft.com/en-us/library/dd465326.aspx
  [5]: /get/blogpictures/config-transform/app.UAT.config.transformed.JPG
  [6]: /get/blogpictures/config-transform/app.UAT.config.transformed-compared.JPG
  [7]: http://visualstudiogallery.msdn.microsoft.com/69023d00-a4f9-4a34-a6cd-7e854ba318b5
  [8]: http://visualstudiogallery.msdn.microsoft.com/69023d00-a4f9-4a34-a6cd-7e854ba318b5
  [9]: /get/blogpictures/config-transform/SlowCheetah-Add-Transform-Menu.JPG
  [10]: /get/blogpictures/config-transform/SlowCheetah-transform-files-added.JPG
  [11]: /get/blogpictures/config-transform/SlowCheetah-transform-result.JPG
  [12]: /get/blogpictures/config-transform/SlowCheetah-transform-preview-menu.JPG
  [13]: /get/blogpictures/config-transform/SlowCheetah-transform-preview.JPG
  [14]: /get/Downloads/ConfigTransform.zip