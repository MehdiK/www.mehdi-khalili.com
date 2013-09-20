--- cson
title: "Seleno V0.6 is released"
metaTitle: "Seleno V0.6 is released"
description: "Seleno V0.6 makes the API more consistent, fluent and extensible"
revised: "2013-09-20"
date: "2013-09-20"
tags: ["seleno"]

---
Seleno V0.6 was just released. The main theme of this release was to make the API more consistent, fluent and extensible. 

If you are an existing Seleno user then you can find the breaking changes and their fixes [here](https://github.com/TestStack/TestStack.Seleno/blob/master/BREAKING_CHANGES.md).

TLDR - There were three main changes in this release:

 - Methods on `UiComponent` were changed to properties to read more fluently.
 - The new `UiComponent` properties were made public to make it easier to interact with pages from test scripts.
 - `IElementAssert` interface API changed to allow for jQuery selectors and also for API consistency between `IElementFinder` and `IElementAssert`.

##Fluency and open API
A lot of the interactions with the page objects in the previous releases were through methods. An example out of the documentation from the previous release:

	public class SearchPage : Page
	{
	    public SearchPage InputSearchTerm(string term)
	    {
	        Find()
	            .Element(By.Name("q"))
	            .SendKeys(term);
	        return this;
	    }
	
	    public ResultsPage Search()
	    {
	        return Navigate().To<ResultsPage>(By.Name("btnG"));
	    }
	}

That `Find` and `Navigate` methods didn't read well. They are now changed to properties so now you can write the same class as:

	public class SearchPage : Page
	{
	    public SearchPage InputSearchTerm(string term)
	    {
	        Find.Element(By.Name("q"))
	            .SendKeys(term);
	        return this;
	    }
	
	    public ResultsPage Search()
	    {
	        return Navigate.To<ResultsPage>(By.Name("btnG"));
	    }
	}

We tried to make the API more fluent by changing methods to properties and also to make signature changes when needed:

    Navigate().To -> Navigate.To
    Find().Elements -> Find.Elements
    AssertThatElements().DoNotExist -> AssertThatElements.DoNotExist
    
An example of a signature change is `ExecuteScript` 

    Execute().ExecuteScript -> Execute.Script

It's also worth noting that all these new properties are made public. This isn't necessarily something we want to promote and you should try to avoid calling public page properties from your test script; but now you can if you really need to. For example, before, to read a page using view model you would have to first create a page wrapper; e.g.

    public class RegisterPage : Page<RegisterModel>
    {
        public RegisterModel Model
        {
            get { return Read.ModelFromPage(); }
        }
    }

And then you could use this class from your test scripts to assert on the values:

    [Test]
    public void CanSeeRegistrationDetails()
    {
	    var registerPage = Host.Instance
		    .NavigateToRegisterPage<RegisterationController, RegisterPage>(x => x.Index());
		    
		Assert.AreEqual("Mehdi", registerPage.Model.FirstName);   
    }
    
Now that the properties are public you can avoid that wrapper if you REALLY REALLY need to. So the same example could be implemented as:

    [Test]
    public void CanSeeRegistrationDetails()
    {
	    var registerPage = Host.Instance
		    .NavigateToRegisterPage<RegisterationController, Page<RegisterModel>>(x => x.Index());
		    
		Assert.AreEqual("Mehdi", registerPage.Read.ModelFromPage().FirstName);   
    }
    
I say if you **really** have to because all page interactions should be encapsulated in a page class and your test scripts should not interact with your pages directly. 

##API consistency for assertions
There is an interface called `IElementFinder` which is returned by the `Find` property of `UiComponent` which allows you to find things on your page:

    public interface IElementFinder
    {
        IWebElement Element(By findExpression, TimeSpan maxWait = default(TimeSpan));
        IWebElement Element(Locators.By.jQueryBy jQueryFindExpression, TimeSpan maxWait = default(TimeSpan));
        IEnumerable<IWebElement> Elements(By findExpression, TimeSpan maxWait = default(TimeSpan));
        IWebElement OptionalElement(By findExpression, TimeSpan maxWait = default(TimeSpan));
        IWebElement OptionalElement(Locators.By.jQueryBy jQueryFindExpression, TimeSpan maxWait = default(TimeSpan));
    }

You can see the complete source code [here](https://github.com/TestStack/TestStack.Seleno/blob/master/src/TestStack.Seleno/PageObjects/Actions/IElementFinder.cs). 

There is a similar interface called `IElementAssert` which is in charge of assertions; but the API was inconsistent and incomplete. This has now changed to look and behave the same as `IElementFinder`:

    public interface IElementAssert
    {
        IElementFinder Find { get; }
        IElementAssert DoNotExist(By findExpression, string message = null, TimeSpan maxWait = default(TimeSpan));
        IElementAssert DoNotExist(PageObjects.Locators.By.jQueryBy findExpression, string message = null, TimeSpan maxWait = default(TimeSpan));
        IElementAssert Exist(By findExpression, string message = null, TimeSpan maxWait = default(TimeSpan));
        IElementAssert Exist(PageObjects.Locators.By.jQueryBy findExpression, string message = null, TimeSpan maxWait = default(TimeSpan));
        IElementAssert ConformTo(By findExpression, Action<IEnumerable<IWebElement>> assertion, TimeSpan maxWait = default(TimeSpan));
        IElementAssert ConformTo(PageObjects.Locators.By.jQueryBy findExpression, Action<IEnumerable<IWebElement>> assertion, TimeSpan maxWait = default(TimeSpan));
	}
	
This new interface also allows you to use `jQueryBy` selector which allows you to use your good old jQuery selectors for element targeting. 

##Some resources to get started
If you are new to Seleno then go grab it while it's hot. Although pre V1 it's quite stable and has been in use by many teams for quite some time now. Seleno allows you to write maintainable UI tests. As a bonus point if you are using ASP.Net MVC it significantly reduces the amount of code you have to write to interact with you page by hooking into MVC infrastructure and using your view models to interact with you pages.

###Learning resources
 - You can read more about Seleno and watch it in action [here](/presentations/automated-ui-testing-done-right-at-dddsydney). 
 - The source code is available in [GitHub](https://github.com/TestStack/TestStack.Seleno). 
 - You can see a few samples to get started with it quickly [here](https://github.com/TestStack/TestStack.Seleno/tree/master/src/Samples). 
 - You can read the documentations on the TestStack documentation website [here](http://docs.teststack.net/seleno/index.html).

