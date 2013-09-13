--- cson
title: "ORM anti-patterns - Part 1: Active Record"
metaTitle: "ORM anti-patterns - Part 1: Active Record"
description: "There are some common mistakes and anti-patterns in using ORMS. Active Record is one of those data access patterns that is abused."
revised: "2011-01-28"
date: "2010-12-09"
tags: ["anti-patterns","orm"]
migrated: "true"
resource: "/orm-anti-patterns-part-1-active-record"
summary: """
This is the first article in the <a href=\"/orm-anti-patterns-series\">ORM anti-pattern series</a>.

Martin Fowler who coined the term Active Record explains where and why this pattern should be used; but most of the times we use it just because it is easy without considering its ramifications on our project. In this article I will discuss Active Record as a pattern that is usually abused. 
"""
---
One of the patterns implemented by a few ORM frameworks is [Active Record][2]:
"*An object that wraps a row in a database table or view, encapsulates the database access, and adds domain logic on that data.*", from [PoEAA][3] book.

Active Record is very simple to use. Usually everything you need is generated for you by the framework.

####Pros
About suitability of the pattern Martin Fowler says:
"*Active Record is a good choice for domain logic that isn't too complex, such as creates, reads, updates, and deletes. Derivations and validations based on a single record work well in this structure.*"

The pattern could provide for a great productivity boost and value when you have next to no business logic. This is the case for forms over data applications where all the user wants is to be able to enter and search some data. 

I believe in most cases, regardless of how simple your requirements are you can still provide a lot of value if you stay away from this architecture. In majority of cases you will have some business logic and your application is not a simple data capturing/searching interface which means this pattern will not work for you.

In rare cases where all you need is forms over data this pattern can be very useful.

####Cons
The pattern (or one might say the way it is implemented)  has several issues:

 - It (seriously) violates SRP. In a typical implementation of the pattern you will have the following set of methods and properties in every class:
   - Getting the data from database.
   - Instantiating a new instance in memory for inserting it into the database.
   - Saving changes to the database.
   - Loading related entities.
   - Validation.
   - Usually loads of methods (inherited from the base framework class) to deal with all the complexity involved with the above-mentioned methods.
   - Column related properties: there will be at least one property generated per column.
   - Also frameworks usually provide several overloads of each method to enable you to handle every possible scenario. And then of course there is the business logic that you put into this class.
 - No POCO. I have yet to see an implementation of the pattern with POCO support, and it just makes sense. Due to the complexity of the pattern there is a load of methods implemented by the framework which your class inherits from.
 - One to one mapping between table structure and entity that is for each column in the table there is one property on the entity (Most ORMs allow you to hide some columns on your entity).
 - Database is very nicely abstracted away which is a good thing; but this also means accessing a property could cause a database hit. In fact, due to the simplicity, a lot of developers tend to forget that they are working with a row in database. One typical mistake I have seen is applying some logic on the object in a foreach loop not knowing that each iteration hits the database.
 - In my experience unit testing Active Record entities is next to impossible. Active Record entities have a lot of infrastructure to make them interact with the database easily. You use a property on your entity and it wants to hit the database. This makes unit testing very hard (in my experience impractical); so you are left with one option that is integration testing.

###Active Record gone crazy
As mentioned above in most cases your application is not that simple so this pattern quickly becomes an anti-pattern:

You start with a big application, you have limited time, and there it is the framework in the shelf that could help you deliver "value" very quickly. So you think: "yeah, this is a simple forms over data. Let's just generate some entities from the schema and bind them to the UI". Two months later, you have a lot of UI elements bound to your active record entities, inevitably you have implemented lots of validation rules in them plus binding and UI related logic. In fact your entity kind of has to know how it is being displayed on the UI as it has UI related validation logic/messages with binding attributes all over it. You just managed to merge all the architectural layers into one class and your project will turn into a [BBOM][4] quickly. It is also no longer the class that you have generated once and no longer touch. In fact everything - including UI, business and validation logic - is in that class and most of your changes end up in that class one way or another.

The problem gets even bigger when you realise that this entity is not used in only one form; so you have to add some logic inside your entity to deal with different forms; e.g. if seen from this form binding and validation messages should work like this while from the other form it is totally different. Wait a minute; but it is not only used in two different forms. It is perhaps also used in two different business contexts; so the business rules and validation logic implemented inside the entity should also know about the contexts and take different actions. My example may sound very extreme; but I have seen projects like this. It is in fact very typical of projects using Active Record. The project sounds simple in the beginning and then as it grows the pattern brings the project down to its knees.

###How to make it a bit better
UI related issues could be mitigated using view models. It is usually a bad idea to bind to your persistence model. You may instead create some view models that wrap your entities which you use for binding and UI related logic. This will eliminate quite a few of the issues caused by the UI explained above.

You can then extract the logic out of your entities into some business logic services. This turns your domain into an [Anemic Domain Model][5] which is not ideal; but better than lots of [God Objects][6]. That happens because in Active Record the business logic does not belong to any class: the pattern assumes that you do not have much business logic. After spending a lot of effort to clean up your entities, you end up with an architecture where your domain logic is spread over several services and lost in the interaction between these services. Still better than before with everything mixed; but not the easiest thing to maintain and definitely not an idea object oriented design.

Same thing could be applied to validation logics if needed; but in my experience validation logic can be spared as it is not usually where the problem lies. Also invariants are best and simplest kept inside the entity.

###Conclusion
Sadly a lot of developers consider Active Record as their default choice for database interaction while most applications will have some business logic and complex behavior where Active Record pattern will fail. 

It is OK to use Active Record if your application does not have these complexities; but there is a good chance that it will grow beyond your expectation. So before choosing Active Record make sure you know the project, the scope and your stakeholders very well.

One last thing I may add is that you may choose Active Record for some of your database interactions. In other words, you do not have to apply the same technique/framework to every bit of your project/architecture. In some cases it just makes sense to use different techniques because different modules have different requirements.

That is all for now.


  [2]: http://en.wikipedia.org/wiki/Active_record_pattern
  [3]: http://www.amazon.com/Patterns-Enterprise-Application-Architecture-Martin/dp/0321127420
  [4]: http://en.wikipedia.org/wiki/Big_ball_of_mud
  [5]: http://martinfowler.com/bliki/AnemicDomainModel.html
  [6]: http://en.wikipedia.org/wiki/God_object