--- cson
title: "ORM anti-patterns - Part 2: Batch Operations"
metaTitle: "ORM anti-patterns - Part 2: Batch Operations"
description: "Batch operations are not always implemented properly when programmers use ORM."
revised: "2011-01-28"
date: "2010-12-23"
tags: ["ORM","architecture","anti-patterns"]
migrated: "true"
urls: ["/orm-anti-patterns-part-2-batch-operations"]
summary: """
This is the second article in the <a href=\"/orm-anti-patterns-series\">ORM anti-pattern series</a>.

Batch operations are not always implemented properly when programmers use ORM. In this article I will discuss batch operations and how it should and should not be implemented.
"""
---
Most applications have some batch operation requirements: you want to blacklist several customers, or set a cut-off date and time on all the transactions processed in the past x hours, or delete all spams and so on and so forth. Implementing batch operations using a collection of objects fetched by an ORM in a for loop is one of those mistakes that a lot of programmers make. 

####Background
Before there were any ORMs most of us used stored procs and views for everything data related, and when we saw ORMs we stopped using stored procs and views. Why? The problem with stored procedures and views or generally SQL is that they are designed to work efficiently with sets of data; not for writing business logic. Sure there are if statements and loops and so on; but the whole thing makes it hard to implement a typical business logic compared to a fully fledged programming language. So we moved our business logic out of a set-based language into OO languages so we can easily write and maintain it. It just makes sense. We can use all the goodness and power of our favorite programming language/framework. Awesome ... well ... until we need to do set-based operations in the code.

####The problem
Let me tell you a story. I worked on a project a few years ago. The data layer in the application was written using Linq2Sql to process huge lists of data. Almost every day a few thousand records were fed into the application. A few operators then would push the records through a cleansing process. Every day there were thousands of business transactions and tens of thousands database transactions to process these records. 

To implement the workflow behind the cleaning process we had a State field on the Record table that stored what status the record was in and we would update this field whenever the record changed its state. When users started testing the application one of the first things they wanted was for them to be able to visually go through so many records at once and then multi-select and push them to the next state. In a typical usage they would go through hundreds of records in a few minutes and then click a button to send these records to the next state. The only thing that had changed about all these records was its state. In our first implementation, we would load all the records using their ids on the application server, iterate over them in a loop and change their state, and then at the end of the method we would call SubmitChanges to save the changes. Sweet and easy!! Except that it was very slow and it would hammer our database server and network when few operators were using the system at the same time; but why? To do a very simple batch operation we were loading hundreds of records from database, and after updating them in memory we were sending hundreds of update queries to server! Why did I really have to load all those objects, each of which with around 25 fields, into the memory? I needed to update one field on these records and that in no way necessitated loading all those records! 

####The solution
We were trying to do a set-based operation in a procedural way, and that is just wrong. This is exactly where set-based languages (e.g. SQL) shine. We could achieve the very same thing using a very simple, short and readable SQL update statement. What would we gain from that? Using the update statement we would not 
 - ask the database server to return any data
 - put all that load on the network to move the data from database server to application server
 - chew processor on the application server to materialise those entities using the data
 - chew the memory in our application server to hold our entities
 - send hundreds of updates over the network to the database server
 - cause potential table lock escalation due to so many updates on rows
 - have to make the user wait while all these craziness happened on the application server

One easy change and all those wins.

I actually did not even write it as a SQL query. [A clever guy wrote a nice extension for L2S][2] that provided batch update and delete using our very loved linq expressions and I just used that. I believe that all ORM frameworks should have batch operations built in. If they do not (and if someone has not already written any extension for your ORM of choice) try to write one yourself. It should not be very hard. If you do not have time to do so or if it is very hard, then just write a simple stored procedure that does the batch operation for you and call it from your code. You can even import your SP in your ORM and call it like a method. Most ORMs I know allow this. If your ORM does not allow this, then simply write a method on your repository or data access layer that abstracts the SP call away and then simply call that method. Do not be afraid of SPs. We used them for a long time and they were ok. They were actually great when we needed to deal with sets of data. Just because we have ORMs does not mean we should not use SPs or views anymore. There are still quite a few scenarios where SPs and views are exactly what you need to solve your problem.

####Conclusion
Having business logic inside SPs and views was wrong. Same way if you are doing set-based operation in a procedural way then you are most likely doing it wrong, and we programmers do this all the time.

There are cases where you need to update/delete, for example, two records in a table and that is alright if you did it using ORM because the load is going to be very little and introducing some maintenance load for a new SP may not be worth it; but if your set-based operation is working over a big set of data then you should seriously consider using a set-based language to achieve your result. 


  [1]: /orm-anti-patterns-part-1-active-record
  [2]: http://www.aneyfamily.com/terryandann/post/2008/04/Batch-Updates-and-Deletes-with-LINQ-to-SQL.aspx