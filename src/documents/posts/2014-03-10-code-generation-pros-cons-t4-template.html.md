--- cson
title: "Code generation pros and cons and T4 Template"
metaTitle: "Code generation pros and cons and T4 Template"
description: "Code generation is almost always a code smell; but every once in a while you come across a problem where code generation just might be the right the solution"
revised: "2014-03-10"
date: "2014-03-10"
tags: ["Notes","Rants"]
---

I dislike code generation and usually see it as a smell. If you are using code generation of any kind, there is a good chance something is wrong with your design or solution! So perhaps instead of writing a script to generate thousands lines of code, you should take a step back, think about your problem again and come up with a better solution. That said, there are situations where code generation might be a good solution. 

In this post I will talk about pros and cons of code generation and then show you how to use T4 templates, the built-in code generation tool in Visual Studio, using an example.

##Code generation is a bad idea
I am writing a post about a concept I think is a bad idea more often than not and it would be unprofessional of me if I handed you a tool and didn't warn you of its dangers. 

The truth is code generation is quite exciting: you write a few lines of code and you get A LOT more of it in return that you would perhaps have to write manually. So it's easy to fall into a one-size-fits-all trap with it:

“*[If the only tool you have is a hammer, you tend to see every problem as a nail](http://www.software-quot.es/if-the-only-tool-you-have-is-a-hammer-you-tend-to-see-every-problem-as-a-nail/).*”
– A. Maslow

But code generation is almost always a bad idea. I refer you to [this post](http://www.codethinked.com/code-generation-should-be-the-nuclear-option) that explains most of the issues I see with code generation pretty well. In a nutshell, code generation results into inflexible and hard to maintain code.

Here is a few examples of where you should NOT use code generation:

 - **Code generated distributed architecture**: you run a script that generates the service contracts and the implementations and magically turns your application into a distributed architecture. That obviously fails to acknowledge the excessive chattiness of in-process calls that dramatically slows down over network and the need for proper exception and transaction handling of distributed systems and so on. 
 - **Visual GUI designers** is what Microsoft developers have used for ages (in Windows/Web Forms and to some extent XAML based applications) where they drag and drop widgets and UI elements and see the (ugly) UI code generated for them behind the scene.
 - **Naked Objects** is an approach to software development where you define your domain model and the rest of your application including UI and database gets generated for you. Conceptually it's very close to Model Driven Architecture.
 - **Model Driven Architecture** is an approach to software development where you specify your domain in details using a Platform Independence Model (PIM). Using code generation, PIM is later turned into a Platform Specific Model (PSM) that a computer can run. One of the main selling points of MDA is that you specify the PIM once and can generate web or desktop applications in a variety of programming languages just by pushing a button that can generate the desired PSM code. A lot of RAD (Rapid Application Development) tools are created based on this idea: you draw a model and click a button to get a complete application. Some of these tools go as far as trying to completely remove developers from the equation where non-technical users are thought to be able to make safe changes to the software without the need for a developer.

I was also going to put Object Relational Mapping in the list as some ORMs heavily rely on code generation to create the persistence model from a conceptual or physical data model. I have used some of these tools and have undergone a fair bit of pain to customize the generated code. That said a lot of developers seem to really like them so I just left that out (or did I?!) ;) 
 
While some of these "tools" do solve some of the programming problems and reduce the required upfront effort and cost of software development, there is a huge hidden maintainability cost in using code generation that sooner or later is going to bite you and the more generated code you have the more that's going to hurt.

I know that a lot of developers are huge fan of code generation and write a new code generation script every day. If you are in that camp and think it is a great tool for a lot of problems, I am not going to argue with you. After all, this post is not about proving code generation is a bad idea. 

##Sometimes, only sometimes, code generation might be a good idea
Very rarely though, I find myself in a situation where code generation is a good fit for the problem at hand and the alternative solutions would either be harder or uglier. 

Here is a few examples of where code generation might be a good fit:

 - **You need to write a lot of boilerplate code** that follow a similar static pattern. Before trying code generation in this case you should think really hard about the problem and try writing this code properly (e.g. using object oriented patterns if you're writing OO code). If you have tried hard and haven't found a good solution then code generation might be a good choice.
 - You very frequently use some static metadata from a resource and retrieving the data requires using magic strings (and perhaps is a costly operation). Here is a few examples: 
   - **Code metadata fetched by reflection**: calling code using reflection requires magic strings; but at design time you know what you need you can use code generation to generate the required artifacts. This way you will avoid using reflections at run time and/or magic strings in your code. A great example of this concept is [T4MVC](http://t4mvc.codeplex.com/) that creates strongly typed helpers that eliminate the use of literal strings in many places.
   - **Static lookup web services**: every now and then I come across web services that only provide static data that can be fetched by providing a key, which ends up as a magic string in the codebase. In this case, if you can programmatically retrieve all the keys, code generate a static class containing all the keys and access the string values as strongly typed first class citizens in your codebase instead of using magic strings. You could obviously create the class manually; but you would have to also maintain it manually every time the data changes. You can then use this class to hit the web service and cache the result so the subsequent calls are resolved from the memory. Alternatively, if allowed, you could just generate the entire service in code so the lookup service is not required at runtime. Both solutions have some pros and cons so pick the one that fits your requirements. The latter is only useful if the keys are only used by the application and are not provided by the user; otherwise sooner or later there will be a time when the service data has been updated but you haven't generated the code, and the user initiated lookup fails.
   - **Static lookup tables**: This is very similar to static web services but the data lives in a data store as opposed to a web service. 

As mentioned above code generation makes for inflexible and hard to maintain code; so if the nature of the problem you're solving is static and doesn't require (frequent) maintenance, then code generation might be a good solution!

> Just because your problem fits into one of the above categories doesn't mean code generation is a good fit for it. You should still try to evaluate alternative solutions and weigh your options.  

Also if you go for code generation make sure to still write unit tests. For some reason, some developers think that generated code doesn't require unit testing. Perhaps they think it's generated by computers and computers don't make mistakes! I think generated code requires just as much (if not more) automated verification. I personally TDD my code generation: I write the tests first, run them to see them fail, then generate the code and see the tests pass.

##Text Template Transformation Toolkit
There is an awesome code generation engine in Visual Studio called Text Template Transformation Toolkit (AKA T4). 

From [MSDN](http://msdn.microsoft.com/en-us/library/vstudio/bb126478.aspx): 

> Text templates are composed of the following parts:
>  
>   - **Directives**: elements that control how the template is processed. 
>   - **Text blocks**: content that is copied directly to the output. 
>   - **Control blocks**: program code that inserts variable values into the text, and controls conditional or repeated parts of the text.

You might read the rest of the article on [nettuts+](http://code.tutsplus.com/tutorials/code-generation-using-t4--cms-19854) where I go through a relatively big code generation exercise using T4 template and explain the process in details.