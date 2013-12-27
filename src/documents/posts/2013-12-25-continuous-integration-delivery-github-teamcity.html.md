--- cson
title: "Continuous Integration & Delivery For GitHub With TeamCity"
metaTitle: "Continuous Integration & Delivery For GitHub With TeamCity"
description: "This is an end-to-end tutorial for setting up Continuous Integration and Delivery for a GitHub project using TeamCity"
revised: "2013-12-25"
date: "2013-12-25"
tags: ["continuous integration","continuous delivery","teamcity","github","nuget"]

---
There must be around 2 billion articles out there about setting up TeamCity; but I thought I'd write an end to end tutorial for setting up [Continuous Integration](http://www.martinfowler.com/articles/continuousIntegration.html) (AKA CI) and [Continuous Delivery](http://martinfowler.com/bliki/ContinuousDelivery.html) (AKA CD) for a GitHub project using TeamCity. There is going to be quite a few very basic steps and some a little bit more advanced bits in this post. 

I should mention that the details of TeamCity projects are rather specific to the technology you're using. This is the technology stack I am using:

 - .Net: the programming language used for Humanizer.
 - Git and GitHub: Humanizer repository is git and the project is [hosted on GitHub](https://github.com/MehdiK/Humanizer).
 - XUnit: the testing framework I am using in Humanizer.
 - Nuget: the package manager for .Net which is where [Humanizer is deployed to](http://nuget.org/packages/humanizer).

That said many of the topics in this post are more or less applicable to other technologies. 

What this post is about:

 - Creating a TeamCity project
 - Setting up Continuous Integration:
 
   - Getting the source code
   - Building the solution
   - Running the tests
   - Creating a Nuget package   
   - Rewriting assembly versions
   - Setting up build notification for GitHub pull requests
   - Showing build status icon on GitHub]

 - Setting up Continuous Delivery: publishing nuget packages to [nuget.org](http://nuget.org) and nuget symbol packages to [symbolsource.org](http://symbolsource.org).

And what this post is not about: installing TeamCity on your servers and setting up build agents, users and roles. For this post, I assume that you have a running TeamCity server and a user with System administrator rights and you're logged into the admin console.

Hopefully you find some bits useful. 

##Creating a TeamCity project
So before anything else we need to create a [TeamCity project](http://confluence.jetbrains.com/display/TCD4/Project) which is a simple grouping of the build configurations.

On the TeamCity admin console go to Administration (and click on the Projects from the left navigation bar). That takes you to a page showing a list of projects. There is also a 'Create Project' button (if you are System Administrator) to create new projects:

![Projects](/get/BlogPictures/cd-for-github-with-teamcity/admin-projects-new-project.png)

After clicking on the 'Create Project' button you see the following page where you can enter your project details:

![New Project](/get/BlogPictures/cd-for-github-with-teamcity/create-new-project.png)

After you create the project, you are taken to the project home page where you can setup the build configurations:

![Project is created](/get/BlogPictures/cd-for-github-with-teamcity/project-is-created.png)

##Setting up Continuous Integration
So you now have a TeamCity project and want to setup [Continuous Integration](http://www.martinfowler.com/articles/continuousIntegration.html) for your project:

 > Continuous Integration is a software development practice where members of a team integrate their work frequently, usually each person integrates at least daily - leading to multiple integrations per day. Each integration is verified by an automated build (including test) to detect integration errors as quickly as possible.


###Create build configuration
The first step is to create a build configuration for Continuous Integration. You can do so by clicking on the 'Create build configuration' button on the project home page:

![Project home page](/get/BlogPictures/cd-for-github-with-teamcity/project-home-page.png)

After clicking on the button you will be taken to the 'Create build configuration' page:

![Create build configuration](/get/BlogPictures/cd-for-github-with-teamcity/create-ci-build-config.png)

The settings:

 - I name the build setting '1. CI' so the next person knows that this is a CI build configuration and also that it's the first build config. 
 - 'Build configuration ID' should be unique. It's a unique identifier for this build configuration. We will see where this is useful later.
 - 'Description' is optional; but having a description there again makes it easier for the person maintaining the project.
 - 'Build number format' is the build number. You can hardcode this value or could use the TeamCity provided value `%build.counter%` as part of your build number. I use `1.0.%build.counter%` because the project I am setting up, [Humanizer](https://github.com/MehdiK/Humanizer), is currently on version 1 and I want the future builds to continue from there. This is one setting that you will be changing rather often: in my case any time I want to release a new version with a different major or minor.
 - `Build counter` starts from 1 and increases on each build. This is basically the value that gets injected into `%build.counter%`.
 
###Source control settings
Once your build config is created you should set the 'VCS settings' so TeamCity knows how to get the code needed for the build.

Different VCS engines have different settings so the first step is to pick the VCS you want to use - in our case Git (for GitHub):

![Type of VCS](/get/BlogPictures/cd-for-github-with-teamcity/type-of-vcs.png)

Once you choose Git you are provided with a page to setup your git repository connection:

![Git repository settings](/get/BlogPictures/cd-for-github-with-teamcity/git-vcs-config.png)

The important [git VCS settings](http://confluence.jetbrains.com/display/TCD8/Git+%28JetBrains%29) are:

 - VCS root name and ID: use a unique name preferably related to your project so it's easy to spot it amongst other VCS roots you might have in your TeamCity.
 - Fetch URL: this tells TeamCity where it should look for the source code. If you're using GitHub you can grab this from your project's GitHub home page:
 
 ![GitHub repository fetch URL](/get/BlogPictures/cd-for-github-with-teamcity/repo-fetch-url.png)

 - 'Default branch' should be set to your master branch which is where your CI should focus more. So we set it to `refs/heads/master` which is the git master branch. You can get that using `git show-ref master` on your git repo.
 - We want to also monitor pull request branches so we set the 'Branch specification' to `+refs/pull/*/head` which uses wildcard to monitor all pull request branches.
 
I leave the rest of the settings to their default values. Before you save, make sure to 'Test connection' so that TeamCity can find your repository with the settings you have provided - the button located down the bottom of the page:

![Test VCS connection](/get/BlogPictures/cd-for-github-with-teamcity/test-vcs-connection.png)

Once you create a VCS root you can reuse it across build configurations.

###Create build steps
You have a build configuration attached to a source control. We can now create the build steps. I am going to create three steps: 

 1. Build Solution: to build the code
 2. Run Tests: to run the tests
 3. Pack Nuget: to create nuget packages from the artifacts generated in previous steps

To create a build step you should click on the 'Add build step' button. Much like the VCS setting, you should first specify what sort of step you are creating before you're provided with the specific settings for that action.

####1. Build Solution
To build a .Net solution the easiest way is to to build the Visual Studio solution which is how Visual Studio works too. So I pick 'Visual Studio (sln)' for the 'Runner type':

![Build Solution](/get/BlogPictures/cd-for-github-with-teamcity/create-vs-solution-build-step.png)

The important settings for this step are:

 - Step name: like I said before pick a right name so it's easy to figure out what the step does. I think '1. Build Solution' is quite nice.
 - Execute step: I leave this as default - 'If all previous steps finished successfully'.
 - Solution file path: you should tell TeamCity where the solution file is so it can build it. You can fill this easily by clicking on the tree icon next to the box and finding the solution file in the provided file browser as shown in the above screenshot.
 
I leave the rest as default. 

#####Assign your build configuration to an agent
Once you a build step to build your source code it's a good idea to run your build to see if it works. So I am going to jump ahead a bit and explain how you can assign your build configuration to a build agent.

On the top navigation bar click on the 'Agents' link and then navigate to the build agent you want to use for your CI build configuration:

![Agents](/get/BlogPictures/cd-for-github-with-teamcity/agent-config.png)

From there you go to the 'Compatible Configurations' pane where you can assign your new build configuration to your agent: 

![Compatible Configurations](/get/BlogPictures/cd-for-github-with-teamcity/agent-compatible-configs.png)

From there you just click 'Assign configurations', select the configuration you want to assign to this agent, which is your recently created build configuration, in my case `Humanizer :: 1.CI`: 

![Assign configuration](/get/BlogPictures/cd-for-github-with-teamcity/assign-build-config-to-agent.png)

`Humanizer` is the name of the TeamCity project and `1.CI` is the name of my build configuration.

#####Your first build run
So now you have your build configuration with one build step and an agent assigned to it. Go forth and click run on your build. It should get the source from your repository and build it:

![Successful build run](/get/BlogPictures/cd-for-github-with-teamcity/successful-build-run.png)
 
Make sure your build is green and it does what it should do: getting the latest code and building your solution. Check the 'Changes' and 'Build Log' panes.

####2. Run Tests
Now that we have a passing build step, lets add test run to our build.

To add a new build step, go to your build configuration and on the left navigation bar click on '3. Build Step(s)':

![configuration steps](/get/BlogPictures/cd-for-github-with-teamcity/configuration-steps.png)

Now you can click 'Add build step' button to create your test runner step. As mention I am using xUnit for Humanizer and there isn't a built-in xUnit runner in TeamCity unlike nUnit and MSTest. If you are using nUnit then you can just pick nUnit runner from the 'Runner type' dropdown and fill the settings pages (Obviously the same applies to MSTest; but hopefully you're not using MSTest).

Before switching to TeamCity I had an MSBuild script which would do pretty much everything I am explaining here. To run the tests I had to download xUnit and put it [in a 'tools' folder in my repository](https://github.com/MehdiK/Humanizer/tree/master/tools/xunit). That's how I was running my xUnit tests as part of my MSBuild script. I will just reuse the xUnit in my repository to setup xUnit with TeamCity: 

![setup xunit test run](/get/BlogPictures/cd-for-github-with-teamcity/run-xunit-tests-build-step.png)

The important settings are:

 - 'Runner type' is set to '.Net Process Runner' to run the xUnit console runner.
 - 'Step name' is set to '2. Run Tests' for readability.
 - 'Path' is the path to the .Net process I wish to run, in this case `xunit.console.clr4.exe` picked using the source tree explorer (the tree icon next to the Path box).
 - 'Command line parameters': set to the relative path of my test dll: 'src\Humanizer.Tests\bin\Release\Humanizer.Tests.dll'.
 
The rest are left to the default values.

Make sure you run your CI build again, this time with the test step:

![CI run with tests](/get/BlogPictures/cd-for-github-with-teamcity/ci-run-with-tests.png)

Note the test results lighting up in the build result, oh yeah :)

####3. Pack Nuget
A great practice in Continuous Delivery is that you want to be able to publish the artifacts of any green build/test to production with a push of a button. In other words when you want to deploy you don't rebuild stuff - you just deploy the existing artifacts of a healthy build. We now have a green build with its tests in our CI - so we should extract the deployment artifacts now so we can later use them in deployment. Humanizer is a .Net library and releasing this library means pushing a new nuget package to [nuget.org](http://nuget.org). So lets create the nuget package from the build artifacts:

![Create nuget build step](/get/BlogPictures/cd-for-github-with-teamcity/create-nuget-build-step-1.png)
![Create nuget build step](/get/BlogPictures/cd-for-github-with-teamcity/create-nuget-build-step-2.png)

The important settings are:

 - 'Runner type' is set Nuget Pack to create the nuget package.
 - 'Step name' is set to '3. Pack Nuget' for readability.
 - 'Specification files' is set to the [existing 'Humanizer.nuspec' file](https://github.com/MehdiK/Humanizer/blob/master/src/Humanizer.nuspec). More on this shortly.
 - In the 'Output' setting group, we tick the 'Publish created packages to build artifacts' checkbox to make sure the created nuget package ends up in the CI build artifacts so we can later use them for deployment.
 - 'Additional commandline arguments' is set to '-Symbols'. This tells Nuget to create a Symbols package to be published to [symbolsource.org](http://symbolsource.org). More on this shortly.
 
Before we go ahead and run the build again I would like to highlight a few things on these settings. Lets take a look at our nuspec file first:

```
<?xml version="1.0"?>
<package >
  <metadata>
    <id>Humanizer</id>
    <version>$version$</version>
    <title>Humanizer</title>
    <authors>Mehdi Khalili</authors>
    <owners>Mehdi Khalili</owners>
    <projectUrl>https://github.com/MehdiK/Humanizer</projectUrl>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <description>A framework that turns your normal strings, type names, enums and DateTime into a human friendly format and provides human friendly API for DateTime, TimeSpan etc</description>
    <copyright>Copyright 2012-2013  Mehdi Khalili</copyright>
    <licenseUrl>https://github.com/MehdiK/Humanizer/blob/master/LICENSE</licenseUrl>
    <releaseNotes>
      In this version we changed the library to Portable Class Library. There are no breaking changes.
    </releaseNotes>
  </metadata>
  <files>
    <file src="Humanizer\bin\Release\**" target="lib\portable-win+net40+sl50+wp8" />
    <file src="Humanizer\**\*.cs" exclude="**\obj\**\*.*" target="src" />
  </files>
</package>
```

The metadata bit is just normal metadata tags that you should provide in a nuspec file. I am particularly interested in the 'files' section:

`<file src="Humanizer\bin\Release\**" target="lib\portable-win+net40+sl50+wp8" />` is telling nuget command to fetch all the files from 'Humanizer\bin\Release\', **which is relative to the nuspec file path**, and copy them to the 'lib\portable-win+net40+sl50+wp8' path relative to the nuget output folder, which we set to 'package' in our nuget step. `portable-win+net40+sl50+wp8` means that the library is a [Portable Class Library](http://msdn.microsoft.com/en-us/library/vstudio/gg597391(v=vs.100).aspx) that can target Win Store Apps (*win*), .Net 4 & higher versions (*net40*), SilverLight 5 (*sl50*) and Windows Phone 8 (*wp8*).

`<file src="Humanizer\**\*.cs" exclude="**\obj\**\*.*" target="src" />` is telling nuget command that we also want the source files to be included in the 'src' target folders!!! But this is library - why would we need source files?! The answer is to create a symbols nuget package to publish to [symbolsource]('http://symbolsource.org/') so the users of the library can step through the code while debugging.

You can read [this article](http://docs.nuget.org/docs/creating-packages/creating-and-publishing-a-symbol-package) to learn more about how you can create a Symbol Package. The gist of that is:

 - Copy all your source files to a 'src' folder in your nuget folder (which we're doing using the 'file' element in the 'files' section of the nuspec file.
 - Call `nuget pack` with a `-Symbols` parameter to create an additional Symbols package which we are doing by setting 'Additional commandline arguments' in '3. Pack Nuget' build step to '-Symbols'.
 
Alright lets run the CI build and see what we get:

![CI build run with nuget](/get/BlogPictures/cd-for-github-with-teamcity/ci-build-run-with-nuget.png)

There are now three build steps and if we check the 'Artifacts' pane we can see the nuget packages:

![Complete CI build artifacts](/get/BlogPictures/cd-for-github-with-teamcity/complete-ci-build-artifacts.png)

###Rewriting Assembly Versions
Although our CI build configuration can build the code, run the tests and package the artifacts it has a relatively big flaw, and that is the library version as stored in ['AssemblyInfo.cs'](https://github.com/MehdiK/Humanizer/blob/master/src/Humanizer/Properties/AssemblyInfo.cs) files is static and while the published nuget package version increases the version of the dll inside the package never changes as it's set to a static value!

TeamCity has a very elegant solution for this problem: 'AssemblyInfo patcher'. In the 'Build Steps' page of your Build Configuration there is a section down the bottom called 'Additional Build Features' where you can, errrrm, add additional features to your build! Click on the 'Add build feature' button and add 'AssemblyInfo patcher' feature:

![Assembly Info Patcher](/get/BlogPictures/cd-for-github-with-teamcity/assembly-info-patcher.png)

That's it!! TeamCity takes care of everything for you now so when you run your build again you can see the magic happening in your build log:

![assembly info patch in build log](/get/BlogPictures/cd-for-github-with-teamcity/assembly-info-in-build-log.png)

Another thing of note is that this correctly happens as part of your '1. Build Solution' build step so the '3. Pack Nuget' step packs the build artifacts with correct versions.

###Notification

###Build Trigger

##Setting up Continuous Delivery

##Rewriting assembly versions

##Build notification for GitHub pull requests

##Showing build status icon on GitHub

