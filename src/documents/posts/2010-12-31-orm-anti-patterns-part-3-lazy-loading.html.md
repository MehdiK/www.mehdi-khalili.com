--- cson
title: "ORM anti-patterns - Part 3: Lazy loading"
metaTitle: "ORM anti-patterns - Part 3: Lazy loading"
description: "Lazy loading is wrong and programmers use it because it is very convenient and helps them think less before coding."
revised: "2011-02-16"
date: "2010-12-31"
tags: ["ORM","Anti-Patterns"]
migrated: "true"
resource: "/orm-anti-patterns-part-3-lazy-loading"
summary: """
This is the third article in the <a href=\"/orm-anti-patterns-series\">ORM anti-pattern series</a>.
"""
---
We use lazy loading because we do not want to think about how a fetched entity is going to be used: we materialise a database record into an entity and as it goes through business logic related entities required by business logic are traversed and fetched from database. This certainly works, business logic is not cluttered with code to fetch the required entities, and the fact that related entities have or have not been materialized from database is nicely abstracted away. 

##Some Arguments for Lazy Loading
Some people believe lazy loading helps achieve better performance. Lazy loading might help achieve better performance depending on your design. In other words, with some architecture and/or within some design limitation it is better to lazy load a graph than to eager load it! 

If you are loading an object graph without knowing how it is going to be used, then you are better off leaving some parts of it out to be fetched later and upon request as they may never be requested. For example you have a generic method in your app that fetches a customer without knowing how and in what context the method is going to be used. Then the result could be used to either edit customer details or edit his/her orders or check his/her eligibility for an upgrade and so on and so forth. Of course if you are using the same method for all these cases then you do not want to eager load the graph because it is going to load a lot of data while only a small subset of it is required in each case. Also in cases like this, the graph usually does not have a clear end. In other words, due to the generic nature of your method and the way it is used, you do not know in which path and how deep you should prefetch related entities. Instead you want to read the customer into memory, and then as the caller uses the record it will fetch bits and pieces it requires. This way you will not load things you do not need and you have spread the data fetching load over a longer period which gives you an **illusion** of better performance.

Using the same method to fetch customer details, without knowing about the context in which it is going to be used, is not code reuse; it is poor design. If you have several contexts or different needs then you need to have several explicit paths in your code where you know everything you need in advance and can load it in one go (as always there are exceptions).

You may say: "I know it is an illusion of better performance but I need it for the sake of users.". This raises an alarm in my head that perhaps you are binding your UI to ORM entities (to be discussed in another post). Unless your application is forms over data, users of your application should never be exposed to how your object graph is being loaded.

##Lazy loading might help
Lazy loading can provide some help when it comes to forms over data applications and when user gets exposed to the illusion explained above. For example, user opens a customer's details, when they click on the orders tab, orders are lazily loaded and if they want to see details of each order, order lines are loaded.

Even in forms over data there are still quite a few issues. I will explain some of these issues in a future post about binding UI to ORM entities. Other issues are explained below:

##Problems
I have a few issues with lazy loading that I will try to explain below:

###1. Inconsistent state
You load a customer, then you lazy load its orders. At the same time someone changes one of the orders and adds an order line to it. You then lazy load order lines and get the latest state of lines while your order entity is not refreshed and contains the old data. From this point forward you are working with an inconsistent object graph in memory.

Regardless of how lazy loading is implemented you are going to have this problem. Simply put, when you use lazy loading the object graph you are working with is potentially inconsistent. 

We are very strict about ACID property of relational databases and we use transactions on database to make sure that database is in a consistent and valid state before and after a transaction; but when it comes to loading that state into memory we do not quite care if it is being loaded consistently. We are happy to load parts of our graph before a transaction and some other parts after changes are made easily breaking consistency forced by ACID attributes of our relational database on the application level.

###2. Unnecessary database hits
Database call is one of the most expensive operations in any software solution, and yet we liberally write code to hit database many times in a simple operation! Between 1 to 3 database hits, in my experience, is enough for most operations and if you are hitting database more than that, then there is a good chance you are doing it wrong. Some operations could take more hits, but they are more of an exception than a rule.

Here is two examples of unnecessary database calls I encounter frequently:

####Great abstraction leads to stupid mistakes
Frameworks are very good at abstracting and hiding away a lot of complexities from developers, and lazy loading is one of those things that is abstracted away very neatly. This abstraction leads some developers to make stupid mistakes. For this I am just going to use an example I have come across a lot. Assuming the following class dependencies:

    class Customer
    {
        public IList<Order> Orders { get; set; }
    }

    class Order
    {
        public IList<OrderLine> OrderLines { get; set; }
        public Customer Customer { get; set; }
    }

    class OrderLine
    {
        public Product Product { get; set; }
    }

    class Product
    {
    }

I have seen code like the following a lot:

    private static void SomeOperation()
    {
        // some customers loaded into 'customers' variable
        var customers = LoadSomeCustomers();

        foreach (var customer in customers)
        {
            foreach (var order in customer.Orders)
            {
                foreach (var orderLine in order.OrderLines)
                {
                    // do something here perhaps with orderLine.Product
                }
            }
        }
    }

When lazy loading, a nested loop like this could simply lead to several hundred database calls! First, customers are loaded, and then inside the first loop Orders are loaded once per customer, and then inside the second loop OrderLines are loaded per order and so on and so forth.

####Fetching the same record so many times
Given the above class dependency, here is another example of unnecessary database hits:

    private static void SomeOperation()
    {
        // load some orders into 'orders' variable
        var orders = LoadSomeOrders();

        foreach (var order in orders)
        {
            var customer = order.Customer;
        }
    }

A very contrived example, but say you have 100 customers with average of 50 orders. If you load 200 orders into memory and call the above method it is going to hit database 200 times to load customer while those 200 orders could have been placed by 5 customers; i.e. you only need at most 5 database hits to load all needed customers.

To be fair, this happens when you do not have an [Identity Map][1] (e.g. you are using Active Record) or caching on you ORM level. Every time Customer property on order is called ORM checks to see if that property has already been loaded and if not it loads it from database. In the presence of Identity Map ORM holds a collections of all loaded entities and each time you ask for an entity it checks to see if it has already been loaded. If it supports caching then it may return the already loaded entity. In the absence of an Identity Map ORM does not know that that entity has been loaded on another path or graph, and hits the database again to load it. This problem exhibits only when you are traversing your object graph bottom up.

###3. Business requirements lost in abstraction 
Lazy loading sometimes hides some of the explicit business requirements away. If to perform some business logic I need to load a few things from database, I need that to be an explicit action and I want it to be readable. I want the next programmer taking over my code to know that to achieve that goal we need to load a few things from database. With lazy loading you do not know when something is loaded; you just call properties one after another without any real business meaning.

This can be improved with strict coding practices. Programmers can still use explicit methods to do the same with lazy loading; but my experience is that when that convenience is there it is abused and it is very hard to trace because it looks like a very normal property call. If lazy loading was not there lazy programmer would end up putting that code and the rest of the business logic inside one big method; but it would be very easy to find and refactor.

##Solutions
###1. Domain Aggregates to the rescue
[Domain Driven Design][3] is a beautiful book that every programmer should read at least once. The book is full of great concepts and techniques; but the one that stands out for me is the concept of Aggregates. From the book:

"*It is difficult to guarantee the consistency of changes to objects in a model with complex associations. Invariants need to be maintained that apply to closely related groups of objects, not just discrete objects. Yet cautious locking schemes cause multiple users to interfere pointlessly with each other and make a system unusable.

Put another way, how do we know where an object made up of other objects begins and ends? In any system with persistent storage of data, there must be a scope for a transaction that changes data, and a way of maintaining the consistency of the data (that is, maintaining its invariants). Databases allow various locking schemes, and tests can be programmed. But these ad hoc solutions divert attention away from the model, and soon you are back to hacking and hoping.*"

Aggregates define consistency boundaries. You can eager load your entire aggregate in one database call. This not only reduces the number of database calls but it also avoids the problem with inconsistent in-memory state.

I am not going to discuss this further because I am sure I cannot do justice. If you are interested you should read the book.

###2. Prefetch all entities you need
Even if you are not using DDD, you should always know how you are going to use an entity before fetching it, and thus you should prefetch/include related entities you are going to need. Do not use GetCustomer method from everywhere in your code you need something related to customers. You should create more explicit methods that are context-aware and from those methods you should prefetch all required entities.

In other words, design your application so whenever you are loading an entity from database you know exactly what you need and how that entity is going to be used; so load everything you need upfront. If you are not loading something upfront it means that it is not going to be used. So you will not need lazy loading because everything you need is already loaded, and ONLY things that are needed in that specific context are loaded – nothing more, nothing less.

###3. Implement explicit methods with business meaning to load required entities
There are some scenarios where you cannot know in advance what you are going to need. For example, you may need to load and check the last 100 orders for silver customers before authorizing a large payment while for gold customers you do not. In cases like this I prefer to load required entities explicitly from my business logic code to make that requirement very clear and readable in the code. A side benefit of this is that I will not need lazy loading support from ORM.

<small>I must say that this is much harder to implement in Active Record because, in the absence of identity map and a proper unit of work, every object graph only tracks its own changes, and if you load an object explicitly and not through lazy loading then its changes are not saved as part of the main object graph and have to be handled explicitly. So you have to remember to call save on all separately loaded object graphs you have changed (as part of one transaction). But hey, we are not going to use Active Record so let's not talk about it ;-)</small>

###4. Use caching
If you are using Lazy Loading and it is too late to change then caching could really help. Recently I added a cache with 5 second sliding expiry to a property call which reduced the number of database hits significantly. The call that took 600 database hits now only needs 5 hits, because the other 595 calls were made to load the objects that had already been loaded. Caching could significantly decrease the number of database calls in your application; but it also means that you use potentially stale data. (You should always think very carefully before caching. This is not an article about caching and I am not going to dig deep in it; but it is very important to note that caching could cause inconsistent/corrupt in-memory and ultimately database state just like the one I explained above on lazy loading).

When you are using caching to avoid unnecessary database calls, that is when the entity being lazily loaded has just been loaded from database, then you should cache your entities for a very short period of time. Cached items' expiry should be shorter than the operation response time. For example, if you have an operation that takes 10 seconds to run and hits database 1000 times due to lazy loading and if you know a lot of those calls are unnecessary and are to load a very small number of entities, then you may cache those entities for 10 seconds. If your operation response time is reduced to half a second, then you can reduce your cache expiry to half a second. Also my personal preference is to use a cache key like LazyLoadCustomerForCheckUpgradeEligibility-CustomerId-{PK goes here} and use this key/item only for this operation.

##Conclusion
Lazy loading may provide a tiny bit of benefit in some rare cases; but it is being used almost everywhere an ORM is used! The way it is used is doing far more harm than good and I believe the good it is doing is not justifiable at all. In my opinion, lazy loading should be limited to Active Record pattern, and [Active Record pattern should only be used in forms over data applications][2]. Even in that case lazy loading should be used only when there is no high concurrency requirement or you will have the risk of working with inconsistent state. All the other issues explained above will also apply. 

Explaining all of the edge cases and providing code for everything I explained above would be rather impractical. If you have used ORMs and lazy loading then I am sure you know what I am talking about, and hopefully the solutions I provided above could help you avoid some of these issues. If you still have any questions feel free to post in the comments.

Hope this helps.

  [1]: http://martinfowler.com/eaaCatalog/identityMap.html
  [2]: /orm-anti-patterns-part-1-active-record
  [3]: http://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215125125