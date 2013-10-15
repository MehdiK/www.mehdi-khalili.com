--- cson
title: "Changing RunTime Behavior Of Application Under Test"
metaTitle: "Changing RunTime Behavior Of Application Under Test"
description: "One of the reasons UI and integration tests fail at times is bad test environment. In this article I explain a few ideas for setting up your test environment properly."
revised: "2013-10-16"
date: "2013-10-16"
tags: ["testing",".net"]

---

One of the reasons UI and integration tests fail at times is bad test environment setup. For UI and integration tests you should hit a different database that is setup specifically for your tests with some handcrafted test data. Also, you want the persisted state to reset after every test so that you can run your tests against a known base. Like database, the services you hit while testing should be compatible with the data provided by your test database. You might also have a set of test files on your file system that you want your application to use while in "test" mode. To make this all work seamlessly you need to be able to change the runtime behavior of the application under test to work on the test environment and hit test databases and services. 

In UI automation, however, the application under test is like a blackbox in the sense that it is run on a separate process or might even be hosted on a separate machine. So you don't have access to the memory or runtime behaviors of the system under test and cannot directly change its configuration.

I am going to provide a few solutions here that you can mix and match as each has some strengths and weaknesses. Here we are only going to change the runtime behavior of the application so it can work in the "test" mode. If you would like to learn more about how you can run your UI tests on a Continuous Integration (CI) server, Jake Ginnivan, one of the main contributors on [TestStack](http://teststack.net), has written an extensive post about it [here](http://jake.ginnivan.net/teamcity-ui-test-agent). The post explains how you can setup a VM in Azure using TeamCity to run your UI tests on your CI server, but you can use the same tricks to run your UI tests on a physical server.

###Build Configuration
One solution to this problem is to have a separate <a href="http://msdn.microsoft.com/en-us/library/kkz9kefa(v=vs.110).aspx">Build Configuration</a> for your functional tests. To do this, open Visual Studio and select "Configuration Manager" from the "Build"" menu:

![UITests Build Configuration](/get/BlogPictures/changing-runtime-behavior-for-tests/build-configuration.PNG)

Then create a new Build Configuration based on the Release config (I called it FunctionalTests):

![FunctionalTests Build Configuration](/get/BlogPictures/changing-runtime-behavior-for-tests/new-build-config.PNG)

Then create a config transformation file for the `FunctionalTests` Build Configuration by adding a new web configuration file to the project:

![config transformation](/get/BlogPictures/changing-runtime-behavior-for-tests/functionaltests-web-config.PNG)

Then change `Web.FunctionalTests.config` to add the configuration for the functional tests, e.g.:

	<?xml version="1.0"?>
	
	<!-- For more information on using Web.config transformation visit http://go.microsoft.com/fwlink/?LinkId=125889 -->
	
	<configuration xmlns:xdt="http://schemas.microsoft.com/XML-Document-Transform">
	  <connectionStrings>
	    <add name="MyDB"
	      connectionString="Data Source=DatabaseServer;Initial Catalog=TestDatabase;Integrated Security=True"
	      xdt:Transform="SetAttributes" xdt:Locator="Match(name)"/>
	  </connectionStrings>
	
	  <system.web>
	    <compilation xdt:Transform="RemoveAttributes(debug)" />
	  </system.web>
	
	</configuration>

This is just a simple example of a web configuration transform file that changes the database connection string in a web application. This approach only works for web applications though: out of the box there is no support for configuration transformation for other types of .Net projects. There are, however, a few workarounds for that. You can read about two configuration transformation techniques with support for all types of projects [here](/transform-app-config-and-web-config).

###Compilation Symbols
You can also use compilation symbols to alter the application behaviors at compile time. Here I am defining a `FunctionalTests` conditional compilation symbol in my project's build settings:

![define compilation symbol](/get/BlogPictures/changing-runtime-behavior-for-tests/define-compilation-symbol.PNG)

We can use this symbol using <a href="http://msdn.microsoft.com/en-us/library/system.diagnostics.conditionalattribute(v=vs.100).aspx">ConditionalAttribute</a> or using the `if` <a href="http://msdn.microsoft.com/en-us/library/vstudio/4y6tbswk(v=vs.110).aspx">directive</a>. An example of when you can use conditional compilation symbols is where you are setting your IoC container up:

	var builder = new ContainerBuilder();
	
	#if FunctionalTests
	build.RegisterType<MockService>().As<IService>();
	#else
	builder.RegisterType<RealService>().As<IService>();
	#endif

This bit of code will register `MockService` as an `IService` when the `FunctionalTests` compilation symbol is defined; otherwise `RealService` is registered. So in the "test" mode `IService` resolves to `MockService` (instead of `ReadService`) which returns the data required for your tests.

This is using preprocessor directives which work at compile time; so for this to work you have to build your solution with `FunctionalTests` compilation symbol. There are two ways to do this: you either define the conditional compilation symbol as part of a Build Configuration as we did above and just build the solution using that configuration or you pass the symbol as a build constant to your build tool. For example if you are using MSBuild you can [do this](http://stackoverflow.com/a/480207) by setting the `DefineConstants` msbuild parameter to `FunctionalTests`:

	/p:DefineConstants="FunctionalTests"

###Process Environment Variables
Build Configurations and Compilation Symbols allow you to change the runtime behavior of an application by changing the configuration or application code at compile time. This is quite powerful but has some drawbacks too. For example if the expected behavior depends on some runtime decision you cannot use these approaches. You can overcome this shortcoming using Environment Variables. You know the good old Windows System Properties where you can set Environment Variables like Path, Temp folder etc:

![System Properties](/get/BlogPictures/changing-runtime-behavior-for-tests/win-environment-variables.PNG)

You can use Environment Variables to configure your applications too. You could obviously use the System Properties form and define user or system level Environment Variables on your test machine. That way all applications running on that machine will inherit these variables. This solution has a few issues: 

 * We still would have to know the expected values beforehand, which is what we are trying to fix by using Environment Variables. 
 * You might not want to share these variables between all applications/users. 
 * You will need to set these values on the test machine automatically as part of your continuous deployment which is yet another thing to worry about.
 
An alternative is to inject environment variables into the process of the application you are running, if you have control over it. 

If you are starting the application from your test, you can use `ProcessStartInfo`'s [EnvironmentVariables](http://msdn.microsoft.com/en-us/library/system.diagnostics.processstartinfo.environmentvariables.aspx) property to inject environment variables into the process. This property "*gets search paths for files, directories for temporary files, **application-specific options**, and other similar information*" (highlight is mine). Also from the MSDN article "*Although you cannot set the EnvironmentVariables property, you can modify the StringDictionary returned by the property*".

The beauty of this approach is that the injected environment variables are scoped and isolated to the process you run which means they won't impact other applications running on the same machine and they are forgotten as soon as the process exits. Also you can dynamically set them at runtime for each test run.

When you have your environment variables in place, either set on windows or injected into the process, you can access them using `Environment`'s [GetEnvironmentVariable](http://msdn.microsoft.com/en-us/library/77zkk0b6.aspx) method.

So let's say you want to test a website and you use IIS Express to host it for testing. I am going to use [the framework](https://github.com/tutsplus/maintainable-automated-ui-tests/tree/master/src/MvcMusicStore.FunctionalTests/Framework) I put together for my nettuts' [Maintainable Automated UI Tests](http://net.tutsplus.com/tutorials/maintainable-automated-ui-tests/) article. In the framework we had a class called [IisExpressWebServer](https://github.com/tutsplus/maintainable-automated-ui-tests/blob/master/src/MvcMusicStore.FunctionalTests/Framework/IisExpressWebServer.cs) which was in charge of starting the IIS Express process over a website and later disposing it. I just changed the `Start` method on the class to accept environment variables optionally:
	
	public void Start(params KeyValuePair<string, string>[] environmentVariables)
	{
	    var webHostStartInfo = ProcessStartInfo(_application.Location.FullPath, _application.PortNumber);
	
	    foreach (var variable in environmentVariables)
	        webHostStartInfo.EnvironmentVariables.Add(variable.Key, variable.Value);
	
	    _webHostProcess = Process.Start(webHostStartInfo);
	}
	
If the method is called with some key-value pairs for environment variables, they will be injected into the IIS Express process. You can now call `Start` with the desired environment variables:

	webServer = new IisExpressWebServer(webApplication);
	webServer.Start(new KeyValuePair<string, string>("FunctionalTests", ""));

Then in your website code you can use the environment variables to execute conditional logic to change configuration and/or runtime behavior:

	var environmentVariable = Environment.GetEnvironmentVariable("FunctionalTests");
	if (environmentVariable != null)
	{
		// do something here that you want only in your functional tests
	}	

Sometimes, like this, you only need to know whether some key exists in Environment Variables; other times the value of the key is important too so you also provide a value for the injected variable:

	public void RunWebSite(string database)
	webServer = new IisExpressWebServer(webApplication);
	webServer.Start(
		new KeyValuePair<string, string>("FunctionalTests", ""), 
		new KeyValuePair<string, string>("Database", database));

Then in your website and application code you can use the `Database` environment variable to target different databases and services. This could be used, for example, when you want to run your tests in parallel and each parallel run hits a different database and service.

Credit where it's due: [Michael Whelan](http://michael-whelan.net/), one of the main contributors on [Seleno](https://github.com/TestStack/TestStack.Seleno), taught me this cool trick.