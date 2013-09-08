--- cson
title: "ORM anti-patterns - Part 4: Persistence vs Domain Model"
metaTitle: "ORM anti-patterns - Part 4: Persistence vs Domain Model"
description: "Persistence Model != Domain Model"
revised: "2011-01-28"
date: "2011-01-13"
tags: ["orm","anti-patterns"]
migrated: "true"
urls: ["/orm-anti-patterns-part-4-persistence-domain-model"]
summary: """
This is the forth article in my <a href=\"http://www.mehdi-khalili.com/orm-anti-patterns-series\">ORM anti-pattern series</a>.

Confusing persistence model with domain model has to be one of the most common mistakes in ORM usage.
"""
---
First some definition to make sure we are on the same page:

####Persistence Model (PM)
For the sake of this article I am going to call the set of ORM entities in a project the Persistence Model of that project. It is the set of entities mapped to your database using an ORM framework. 

####Domain Model (DM)
It is your domain entities. This is where OOD fits into your code and where you code business logic. DM in this context does not necessarily mean fully fledged Domain Model from DDD.

####PM and DM usability
When you use an ORM you always have a PM. That is what gets mapped to your relational model. Depending on your requirements and complexity of project PM may be enough, and you may not need a different model.

####Assumption
This whole article (or I should even say series) is about enterprise size applications. If you have a small project that you have coded in your spare time or you are a team of two developers working very closely on it, then you may not feel some or any of the pain explained below, and in fact a PM might be just the best option for you.

##The problem
In a nutshell, my main problem with PM being used for domain logic is [object-relational impedance mismatch][1].

PM is created because we need to map our tables and columns into something we can use in the code easily. PM classes typically have a one-to-one mapping to database tables, and a lot of times properties on these classes have a one-to-one mapping to the table columns. There are a few techniques that help us deviate from this a bit; but at the end of the day a lot of limitations are imposed on PM due to it being mapped to database tables.

Below I will try to break down this problem:

###PM is a property bag while DM is about business logic and behavior
If you do not code your PM as a property bag (and that is something some ORMs allow) then this does not apply to you. 

Most PMs end up as property bags. It is either that the ORM framework forces you to use public getter/setters or that programmers make PM a property bag even if [the ORM supports private setters][2]. Either case, you end up with classes that expose all (or most) of their inner state through properties which breaks class encapsulation and makes classes more tightly coupled. An almost inevitable side effect of this is violation of [Tell Don't Ask][3] and [Single Responsibility Principle][4] principles. SRP says "*There should never be more than one reason for a class to change*". This also means that "*[Each responsibility should be a separate class, because each responsibility is an axis of change.][5]*" (a.k.a [Once and Only Once][6]). Using PM the behavior belonging to a class spreads all over the application which results to maintenance hell. If you need to change some functionality there is no single place you can go and change. Instead you have to scan through the application and find all the usages of your property bag (PB) class and change it accordingly. It gets even more interesting when it comes to debugging. You are trying to debug a logic spread amongst so many classes and most likely hidden in the interaction of those classes; i.e. you have to find where your PB is used, and then from there another class is called where a changed instance of your PB is passed to which in turn makes some more changes to it and so on and so forth.

In my experience, when a team is working on a project, once a logic gets out of a class it is just a matter of time before it gets duplicated. Here is a typical scenario: Developer A needs some functionality that he writes in the class CA he is working on because that is where he needs it. Developer B some time later needs the same functionality in class CB. He has two choices: 

<ol>
 <li>To write the functionality in class CB, and he is going to write it completely different to the way it is implemented in CA. His code may have bugs that CA does not because the functionality written in CA has been tested and fixed by now.</li>
 <li>To scan the whole project (or ask the team) to see if that functionality already exists somewhere else in the code. So he finds the code written by A which by the way is cluttered by unrelated logic required by CA. After all it was written in CA to support some of CA's requirements. From here B again has two choices:
  <ol>
   <li>To copy/paste that functionality and mold it to his requirements in CB. </li>
   <li>To refactor the logic out of CA into where it belongs (and perhaps break the code along the way).</li>
  </ol>
</li>
</ol>

And 9 out of 10 go either 1 or 2.1. because that is much easier. So you end up with duplicate functionality. That is duplicate maintenance and debugging load.

I am not saying it is not possible to have behavior in a class with exposed state; it is just that when you expose this state, there is a good chance it is going to get (ab)used out of the class. The result is that the logic that belongs to a class ends up on [service layer or duplicated on other classes or on the UI][7]!

DM, on the other hand, is all about behaviors. You do not need to expose any state of the class for the sake of complying by/using a framework (You only ever expose a very minimal state needed from outside), and this way you make sure the logic stays inside the class. If you do not have public properties then no one can ask class inappropriate questions; instead callers should tell the class what they want. With a bit of effort you can also cut and dice responsibilities in proper sizes to get a bit of SRP too.

###Business logic is far more testable in DM than PM
Using PM, as explained above, the business logic could get spread all over the application, and you do not even know where that logic is because it is most likely hidden in the interaction of so many classes. So you cannot unit test it. Also the logic is likely to get duplicated when PM is used. Duplicate logic means duplicate testing code (if you test the logic twice, that is).

Using a DM the logic becomes a responsibility of a class and each class hopefully has a single responsibility. This makes it very easy to write unit tests and BDD style tests on your DM to check the functionality of your classes as well as your business requirements.

###PM looks like database while DM should look like the business domain
When using an ORM, PM is created to accommodate the ORM needs. It is created to bridge the gap between object oriented and relational world with the help of ORM. So it is going to look more or less like our relational model: there are going to be a lot of classes in PM named and structured exactly the same as our tables with properties named the same as table columns. Well, it makes sense. Due to object relational mismatch we do not have a lot of wiggle room and that is what we get.

DM does not have that limitation. It should not care about how or where things are stored. It is all about business domain and it is modeled in a way it makes sense to the business and implemented in a way it makes sense in an object oriented language.

If we did not have to store anything in a database, then we would see more DM like than PM like classes. We would, hopefully, start a project [thinking about what the business wants and would create classes that would map more closely to the business domain][8]. 

We use PM because we (think we) have to have it and not because the business really cares about it. We have these classes and we do not feel like creating another set of rather related classes so we may as well use these everywhere!!

###PM (typically) has dependencies on ORM while DM is POCO
PM (in a lot of cases) gets coupled to ORM related interfaces, classes, base-classes, attributes and so on. Some ORMs are better than others in dealing with POCO objects; but in a lot of cases you see ORM related attributes on class properties in PM, you have to implement some interfaces to achieve some functionality, you have to use some ORM collection classes, or worse than all you have to inherit from a base-class. These all couple your PM entities to your ORM of choice, make your classes ugly and introduce some noise.

###PM has DB related constraints while DM is about business rules and constraints
PMs are full of DB related constraints. You see these constraints either as validation rules (on the entity itself or on a common class that knows the metadata and applies it on each property) or as attributes (e.g. NotNull, StringLength and so on). Some of these constraints have some business meaning like a car should have an engine number; but most of them are just about database related constraints. We do not set a description column to varchar(200) because that has a meaning. The person creating tables (programmer or DBA) thinks that 200 characters should be enough for description and that is what it is limited to. This has no business value; but we should force this validation on the PM entity so we do not get an unreadable SQL exception. The use of this validation is forced upon us due to data type difference between our OO language and our relational database (refer to [Object Relational Impedance Mismatch][9]).

DM however does not quite care about database constraints. It is about business rules and constraints (e.g. A customer with more than one chargeback cannot be upgraded.). It is clean, readable and valuable to the business.

Again the same rules can be applied on PM if you use your PM properly. It is just that there are usually too much unnecessary noise on PM; i.e. things that do not have any value to the business but have to be there or our application will fall apart.

###PM can enter invalid state while DM should not allow invalid state even temporarily
This again applies if your PM exposes its state via public getter/setters. So when I say PM here, I mean PM entities with public getter/setter and exposed state.

You may use validation frameworks in validating the state of your persistent model/object graph and that is what we usually see: lots of validation attributes and validation logic on a PM entity. When you have public getter/setters it is very easy to end up in an invalid state; so we have to force validation in some critical points (e.g. saving the graph into database to avoid persistent invalid state).

DM does not need any help from any validation framework because it should never enter into an invalid state. DM does not expose state, it exposes behavior and we should force [invariants][10] on each behavior/method including the class constructor. Here is a few lines from wikipedia link: "*Methods of the class should preserve the invariant. The class invariant constrains the state stored in the object. Class invariants are established during construction and constantly maintained between calls to public methods.*".

Let me give you an example from the mighty [Greg Young][11]: setting address on an entity.

When you set address on an ORM entity via public setters your object could enter into invalid state; e.g. if you set the country field first, both country and postcode fields become invalid because they do not match, and the same happens when you set the postcode first. There is no way out of a (temporary) invalid state.

When you set address on a domain entity through a method call (hopefully, because you do not want to expose entity's internals through properties) you can avoid this problem. You have a method called ChangeAddress that gets passed all the changes and checks everything before it makes any changes to the state of the object. Calling that method either changes the address to the new valid address or perhaps throws an InvalidAddressException; either way the class state stays valid.

Some argue that in that method we should set internal state of the class and as soon as we set country the class enters an invalid state. Fair enough; but no one ever knows about this and it does not impact anything. From the caller's point of view this class is always valid. The only exception to this could be parallel access to the class where two callers are working with the class at the same time one forcing the shared state into a temporary invalid state which results into error for the other one. That is a totally different story: if you have multi-threading or parallelism you have to apply access synchronization regardless of how you use/implement the class.

##Cost of a separate DM
Moving your business logic out of PM into a new model of course comes with a cost: the cost of coding and maintaining more classes. Also depending on the way you have coded your DM you may incur the cost of mapping between the two model which at times could be painful.

##Choices
Now that we know the pros and cons of PM and DM let's talk about available choices. I am going to propose a few possible solutions (in ascending order of idealism) to deal with PM (and possibly DM) along with their pros and cons:

###1. PM with public getters and setters and no DM
I will just come out and say it: I do not like this. You may get started with a model like this; but do yourself a favor and upgrade your model as soon as you can.

Just like always, there are scenarios where this option is just what you want. For example in a project with little to no business logic you may decide to use your PM entities all the way to your UI. This way you avoid a huge cost in creating several models that may not provide any value. This is actually how I see PMs used most and in a lot of cases without any thought. This is a viable option in some scenarios; but do not apply it just because it looks simplest.

####Pros
It is the cheapest **to start with**: only one set of classes and no mapping.

####Cons
All the abovementioned issues apply.

Also I may add that if you are working on a decent size project - which requires several developers - (and unless you are all senior developers and are very strict about code reviews or pair programming in which case you are one of the luckiest programmers in the world) you are going to end up with a tangled mess due to the issues mentioned above and the cost of maintaining it is far more than the cheap and quick start it provides.

###2. PM with public getters and private/protected setters and no DM
I feel far better about this one. The difference with the first model in terms of implementation could be insignificant (depending on your ORM of choice); but the difference in terms of cleanliness of the result and ease of maintenance could be **HUGE**. I think this is a very good and acceptable middle ground for a lot of projects as long as you know what you are losing, have considered its pros and cons (below) and have made an informed decision about it. 

####Pros
 1. Behaviors are easier to keep within your PM and are less likely to spread all over your app.
 2. The logic can be written in a unit-testable way.
 3. You may avoid temporary invalid state to some extent. This is going to be hard because most of the times your ORM is in charge of the lifecycle of PM entities and can construct them in an invalid state.
 4. You will avoid maintenance hell to a great extent in a long run.
 5. It is not very hard and does not cost much to achieve and it definitely costs much less than the first solution to maintain. 

####Cons
 1. You can still violate Tell Don't Ask and SRP. The moment the internal state of your object is exposed (even in readonly mode) developers are going to ask it about its state and make decisions from outside: the decision that belongs to the object itself. It is going to be harder compared to the previous solution particularly if you have private setters. With protected setters sooner or later that bad programmer in your team is going to subclass your entities and provide a public setter for that property.
 2. There is going to be a fair bit of unnecessary noise around your business logic: the noise that is related to mapping to database columns and/or checking database constraints and/or using ORM related classes and interfaces. In other words, you cannot expect a POCO with easily readable business intent.

###3. DM is composed of PM
You will have a separate DM; but you can avoid the cost of mapping between the two by using your PM entities inside your DM entities. By this I mean your DM can be composed of your PM (with or without exposing it out).

This like the previous solution could be a very sensible middle ground.

####Pros
 1. You have a separate DM and your logic will live where it belongs. This means that you can avoid pretty much all the issues mentioned above which is a huge win.
 2. You do not have to write any mapping between your PM and DM entities in order to save/materialise your PM model. In effect you are still working with PM; it is just that it is under the bonnet.

####Cons
 1. Using PM inside your DM can and usually does push some of the issues forced by object relational impedance mismatch on PM to your DM. What you were trying to abstract and hide away by using a separate model may surface and make your DM ugly.
 2. This is more of purist point of view; but in projects with extensive and complex domain the noise of having PM inside DM hurts a lot. These are the projects where you can gain a lot by doing DDD and having a pure DM is of great benefit.

###4. DDD done on top of an ORM
DM is completely unaware of PM. It maintains its own state in the way it makes sense to it. In this implementation, [repository pattern][12] can be used to abstract and hide PM away from DM and the rest of the application. This is a rather big topic and I do not want to expand it here. Also I am pretty sure you are aware of repository pattern and how to map between DM and PM when saving/materializing your entities. This implementation has great cost due to the required mappings. This cost in some cases is ignorable (and actually quite welcome) when you consider the cost of maintaining the application without the separate models.

I am pretty sure there are plenty of successful applications out there doing DDD this way. That said, I think in some cases it makes sense [to ditch out the whole relational/ORM thing altogether][13] and stick to something like [CQRS with Event Sourcing for persistence][14].

####Pros
You will have a pure DM without any of the issues mentioned above. This is great as you can code your business logic the way you like it without caring about limitations exposed on PM.

####Cons
The mapping between DM and PM is going to hurt. The cost of this mapping plus coding and maintaining separate models could be insignificant compared to the cost of not having separate models; but you have to be aware of it and consider it.

##Conclusion
Just like my previous posts, this is not an anti-pattern in itself. The reason I am calling this an anti-pattern is that a lot of developers use PM with public getter/setters in every situation: PM gets used everywhere in the app through its getter/setters leading to an Anemic Domain Model.

If you have some business logic, then it has to be implemented properly either in your PM or DM. It should not be spread all over your app. Consider putting your business logic into a set of classes separate from your PM if it makes sense to your project taking the cost of coding and maintaining the separate model into account. Use PM directly if it makes sense and not just because it is there. This is all about knowing your options and making an informed choice.

Also I may add that some of the solutions mentioned above are quite compatible and you may mix and match them to meet your needs. For example you may use solution 1, 2 and 3 next to each other in the same project with great win. The same could happen to 3 and 4. One size does not fit all and you do not have to apply the same technique throughout the whole solution.

Hope this helps.


  [1]: http://en.wikipedia.org/wiki/Object-relational_impedance_mismatch
  [2]: http://nhforge.org/Default.aspx
  [3]: http://pragprog.com/articles/tell-dont-ask
  [4]: http://www.objectmentor.com/resources/articles/srp.pdf
  [5]: http://www.c2.com/cgi/wiki?SingleResponsibilityPrinciple2.3.2.
  [6]: http://c2.com/xp/OnceAndOnlyOnce.html
  [7]: http://martinfowler.com/bliki/AnemicDomainModel.html
  [8]: http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215
  [9]: http://en.wikipedia.org/wiki/Object-relational_impedance_mismatch
  [10]: http://en.wikipedia.org/wiki/Class_invariant
  [11]: http://codebetter.com/gregyoung/
  [12]: http://martinfowler.com/eaaCatalog/repository.html
  [13]: http://codebetter.com/gregyoung/2010/02/18/using-an-orm-is-like-kissing-your-sister/
  [14]: http://codebetter.com/gregyoung/2010/02/13/cqrs-and-event-sourcing/