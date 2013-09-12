--- cson
title: "ORM anti-patterns - Part 5: Generic update methods"
metaTitle: "ORM anti-patterns - Part 5: Generic update methods"
description: "One of my biggest issue with ORM usage is when developers save state changes using generic save methods instead of saving the user intention."
revised: "2011-02-07"
date: "2011-02-03"
tags: ["architecture","ORM","anti-patterns"]
migrated: "true"
urls: ["/orm-anti-patterns-part-5-generic-update-methods"]
summary: """
This is part 5 of my <a href=\"/orm-anti-patterns-series\">ORM Anti-Pattern series</a>.

Using generic save method to save object graph changes is a rather common practice. This is a decision that is very hard to change down the track and one that impacts the architecture very badly.
"""
---
I am sure you have seen methods like Update(Customer customer) and that is what I am going to discuss in this post: generic methods that save changes on an object graph as opposed to saving the actual user intended change. 

This anti-pattern has a much larger impact on projects than some of the other issues I have talked about in [the orm anti-pattern series][1]. Other anti-patterns are usually easier to fix than this; for example, [batch operation][2] issue can be fixed with a rather little effort: you only need to change the part of code that does the batch operation; but when you step down this path/pattern it will be very hard to change your decision because it most likely impacts your UI design, service layer design, domain model and so on and so forth.

Below I will try to explain some of the issues that you might face when using this pattern:

##The problems

###More data conflicts (with less recoverability)
*Applicable to any and all architectures*

Imagine the following scenario: User A and user B both load the same data on their screen and both make some changes on it. User A saves her changes first, and then user B clicks Save and you get a conflict. There is no way out of this conflict except letting user B know that his changes were not saved and that he has to load the data again, make his changes, and click save and hope that this time there will not be any conflict.

One may say that it is the only acceptable behavior and conflicting changes should not be saved anyway. In some cases that is true; but in some cases it makes sense or even is mandatory to behave differently (more on this shortly). Also with generic update methods you are much more likely to come across conflicting changes because you are trying to save changes in large chunks. If you send your changes in smaller chunks the possibility of conflict reduces. The more granular update methods, the less likely to see conflicting changes. With granular updates, also, even if there is a conflict the amount of changes you have to discard is much less than that of the case when you are saving a huge chunk of changes.

In addition, with a generic update method and a big object graph to save you do not know if changes are really conflicting or not:
    <ol>
      <li>Just because timestamp of one record in the entire object graph does not match that of the one fetched from the database does not mean the whole change is in conflict. For example user A and B may both change one customer where one adds a new kid and the other one changes the customer address. The save fails (in some implementations) because there is a conflict in one of the entities involved in the transaction. Again this happens because you are saving a lot of changes at once. When saving smaller chunks of changes you are less likely to see this.</li>
       <li>Even on a single row there could be two legitimate changes on two different columns; e.g. user A changes the customer phone number (assuming the phone number is kept in the same table) while user B deactivates the customer. This example may not make sense in your case but I am sure you can think of two legitimate changes on the same version of a record that makes sense to your business. In a generic update you are going to see a conflict here; but if you implemented the same thing using meaningful business operations with granular interface you will have flexibility to accept some of these changes.</li>
    </ol>

In your solution the number of times this happens may be very low (perhaps you do not have many concurrent operations/users) and it may not make sense to undergo the trouble only to avoid rare legitimate concurrent updates; but that is something to consider. Also you never know. There may come a time that your system needs to cope with more concurrent users that you thought you would have.

Also (as I mentioned above) some businesses have to reduce the number of conflicts to a very minimum in which case it only makes sense to have granular changes. Some even mandate the possibility of merging changes or at least finding the actual reason behind the conflict and applying compensating actions to reverse it properly. This again is easier using a granular save interface.

###Sending an entire object graph over the wire
*(Applicable to n-tier applications only)*

I am going to use the following example, which is taken from a project I worked on a while back, to explain this issue . Lets call it Order Portal. Order Portal was a simple web page that allowed confirming orders. The entities involved in the operation looked something (bigger than but) like: 

![alt text][3]

The page displayed a grid of orders with several columns created by denormalizing the object graph. Due to the number of entities involved in the operation the number of involved records were usually really high; e.g. 50 orders with 3 lines with 4 statuses and 3 products. So a typical refresh on the page would send around 200KB of data over the wire. 

On the page each row had a checkbox called 'Confirmed' and then there was a save button on the top of the form that saved all the changes, and the Save operation, as you can guess, looked something like:

    Order[] Save(Order[] orders);

In a typical usage the user would open the portal, tick a checkbox (or two) to confirm an order (or two) and save the changes. The form would send the entire object graph of thousands of objects over the wire to the server to apply changes and then would return the updated list of orders again for the form to display, which of course meant a complete refresh! So in a normal situation each save meant sending around 400KB over the wire (in reality and with the actual object graph which was bigger it was over 1MB in most cases).

Hopefully you are not showing a grid of data to the user; but even if you are displaying and saving one order in such fashion you are still sending too much data for a very simple save operation (in the order portal example it would be something around 4KB). Would not it be easier if you had the following method instead?

    Order ConfirmOrder(int orderId);

This method sends only the id of the order user confirms (that is 4 bytes). The portal was changed to call the above method in an AJAX call and to refresh only the changed row. 

If you are very interested in confirming several orders in one go (or if that is what the business wants) then you can have another method like below that would get an array of order numbers to confirm:

    Order[] ConfirmOrders(int[] orderIds);

Still thousand times lighter on the wire.

###Lazy loading
*Applicable to any and all architectures*

User changes a dropdown box in the customer details form to upgrade the customer from silver to gold, and then clicks the save button that sends the entire customer object (for only one change) for persistence. 

Here is a typical implementation of business/validation rules:

    void MethodRunAsPartOfSave()
    {
        var dbCustomer = _repo.Get(customer.Id); // loads customer from database
        if (dbCustomer.IsSilver && this.IsGold)
        {
            var statuses = dbCustomer.Statuses; // Note: loads customer statuses from database
            var orders = dbCustomer.Orders; // Note: loads customer orders from database
                
            // do some checks 
        }

        if (dbCustomer.Children.Count < this.Children.Count) // Note: loads customer children from database
        {
            // Recalculate insurance premium!!
        }

        // Note: loads orders from database if it has not been loaded as part of upgrade check
        if (dbCustomer.Orders.Any(o => o.Total > TheRichCustomerThresholdAmount))
        {
            // Flag customer as potential rich customer to be picked for the next rich customer marketing campaign
        }

        if (!dbCustomer.IsActive && this.IsActive)
        {
            // check if the customer can be activated
        }

        // and then other business rules which check for other conditions and potentially load other relations
    }

<small>This method can be written in a way to avoid violating SRP and OCP; but it is written like that for readability sake for this article.</small>

This method forces you to use lazy loading and you have no way out of it. The problem is that when you are calling Get on your repository you do not know what has changed on the provided entity and what you may need for checking business rules. It also does not make any sense to eager load all the possible needed entities! So when you are checking for an upgrade you end up lazy loading customer's statuses and orders. Then of course there are other business rules that you want to apply when saving a customer, potentially each needing information from other related entities which needs more lazy loading (I have highlighted these in the code with comments).

Now lets have a look at an alternative method:

    void UpgradeToGold(int customerId) 
    // or perhaps Upgrade(int customerId, CustomerLevel level)
    // or maybe even Handle(CustomerUpgradeCommand command)
    {
       var customer = _repo.GetCustomerForUpgrade(customerId);   
       // apply your business rules
       // Orders and Statuses have been loaded in the GetCustomerForUpgrade method
    }

GetCustomerForUpgrade knows that the customer is being loaded for upgrade, so it loads whatever is needed for checking/upgrading a customer. This is what I meant when I said "[*Implement explicit methods with business meaning to load required entities*][4]" to avoid lazy loading. The code in UpgradeToGold is only specific to upgrade, I do not need to check for all the possible changes applied to customer. All I have been provided with is an id; so I do not even know (and do not need to know) if anything else has changed on the client side or not. 

Another less measurable benefit is that the code written in GetCustomerForUpgrade shows you exactly what you need to load for a customer upgrade and how many times you hit the database. This is the requirement that would otherwise be lost in lazy loading in MethodRunAsPartOfSave.

###Unnecessary processing
In a generic update each time you want to save a change you have to check to see which business and validation rule apply. In other words, because you do not know what has changed and which business rule has to be run, you have to run a lot of checks on the object graph to find the applicable business rules. 

In the MethodRunAsPartOfSave example (given above for lazy loading) several checks are run every time the save method is called for the customer entity. **All** these checks are unnecessary. These checks are only there because the generic save method does not know what has changed. If you look at UpgradeToGold method, as an alternative for one of the changes, you can see that there is no check for changes. We know what has changed and we know that we should check for customer upgrade and nothing more.

Back to the generic save method with array of entities (as shown above): on the server the generic update method has no idea what has changed in the provided entity, and in order to save its changes the object graph has to be loaded from database into memory and compared with the provided graph to find changes. I do not have any problem with loading objects from database and in fact if you want to apply any sort of validation and/or business rules you have to do that. What I do not like is the concept of cross-checking two huge object graphs in order to find changes. This is going to put some serious load on your memory and CPU when it comes to concurrent calls. Even in the face of powerful servers (and endless money to be spent on hardware) I still think it is a waste of resources. It also makes every operation unnecessarily slow. You should not have to check for changes; the changes should be provided to the method.

Some developers, who do not like this additional processing, make another mistake: they use self tracking entities. This means that you will not have to load entities from database to find changes, because each entity knows what has changed and keeps a track of its original state as well as the changed state. This in my opinion is yet another anti-pattern. I will have to write a post to explain this more; but for now just think of the load you send over the wire to the server: you potentially double the amount of data sent over the wire!! The other issue with self-tracking entities is that validation and business rules are applied based on the state that was sent to the client (which is now stale); not based on the latest state of data.

###UI design
The problem of generic update method is very closely related to UI design. Different UI designs can ask for different saving mechanism and vice versa.

So many times we see big UI forms/pages with a lot of elements on them and just one save button. When you have one save action for your entire screen you do not know what user has done. All you can do is to pass the object your screen is bound to into a generic method. This is a chicken and egg problem though; i.e. you may be forced to create one save action on your UI because your architecture enforces generic save mechanism, or you may have to write a generic save method because of incorrect UI design. When possible we should try to use [Task Based UI][5] (This article which I just found while trying to find a reference for Task Based UI appears to cover a lot of issues I am covering in this article with an example that is very much like Order Portal - du`h). Task based UI is a UI designed to capture user intention and business operation as opposed to state changes. 

For example, for the Order Portal we removed the save button from the top of the form. Instead each row now has a confirm button that when clicked sends a very explicit AJAX request to the server ultimately calling into ConfirmOrder(int orderId).

For the customer example you could have explicit Upgrade action. This can be implemented in a variety of ways; e.g. having an 'Upgrade' button or a tab called Upgrade that shows the current level and provides a drop down with available levels and a button to save the change.

You should try to break down your form into several meaningful parts/actions. Each of these actions should have a meaning in your business domain and should be executable in isolation of others.

Another benefit of breaking your UI into several parts is composability. You can reuse these parts on other forms. To do that you will not need to do much because the UI element is already there and the action behind it is already working and is isolated from the rest of the screen.

So next time you are designing your UI think about this. This may or may not apply to some of your screens; but it is worth considering every time.

###Generic log
Logging done through generic update methods are usually generic which is less than ideal. For example UpdateCustomer log could look something like:

<table>
<thead>
<tr>
<td>Action</td>
<td>Other log information</td>
</tr>
</thead>
<tr>
<td>SaveCustomer id:2344</td>
<td></td>
</tr>
<tr>
<td>SaveCustomer id:87456</td>
<td></td>
</tr>
<tr>
<td>SaveCustomer id:33</td>
<td></td>
</tr>
</table>

In some cases that is totally unacceptable and in others that is alright but not ideal. You can improve this by adding a lot of checks to your update method. So MethodRunAsPartOfSave could be changed to provide good logging mechanism like below:

    void MethodRunAsPartOfSave()
    {
        var dbCustomer = _repo.Get(customer.Id); // loads customer from database
        if (dbCustomer.IsSilver && this.IsGold)
        {
            // do some checks 

            Logger.Log("Upgraded To Gold {0}", Id);
        }

        if (dbCustomer.Children.Count < this.Children.Count) // Note: loads customer children from database
        {
            // Recalculate insurance premium!!

            Logger.Log("Child added {0}", Id);
        }

        // Note: loads orders from database if it has not been loaded as part of upgrade check
        if (dbCustomer.Orders.Any(o => o.Total > TheRichCustomerThresholdAmount))
        {
            // Flag customer as potential rich customer to be picked for the next rich customer marketing campaign
        }

        if (!dbCustomer.IsActive && this.IsActive)
        {
            // check if the customer can be activated
            Logger.Log("Customer Activated {0}", Id);
        }

        // and then other business rules which check for other conditions and potentially load other relations
    }

Certainly possible; but you see how a simple save method is growing beyond maintainability. Also the issues mentioned above (lazy loading and unnecessary processing apply to logging too).

Now lets take a look at the alternative method:

    void UpgradeToGold(int customerId) // or perhaps Upgrade(int customerId, CustomerLevel level)
    {
       Logger.Log("UpgradeToGold {0}", customerId);

       var customer = _repo.GetCustomerForUpgrade(customerId);   
       // apply your business rules: note that Orders and Statuses have been loaded in the GetCustomerForUpgrade method
    }

You know what is happening and you log just that and get a great result easily:

<table>
<thead>
<tr>
<td>Action</td>
<td>Other log information</td>
</tr>
</thead>
<tr>
<td>UpgradeToGold id:2344</td>
<td></td>
</tr>
<tr>
<td>UpdateContactDetails id:345</td>
<td></td>
</tr>
<tr>
<td>CustomerActivated id:3456</td>
<td></td>
</tr>
</table>

That makes a big difference for logging. Some businesses analyze their operational logs and it is critical to have proper and meaningful log entries, and some are very strict about accuracy of their audit log due to security of operation/data.

Actually now that there is one log per method we can do even better. We can easily remove all audit log calls and achieve the same result using an [AOP][6] framework. I have a post coming up about this.

##Active Record and self tracking entities
When you are using Active Record or self tracking entities you are somehow forced down the road of generic saves. OK, you are not forced, but you usually end up there. The reason is that the entity knows almost everything it needs and all it takes to save the changes is to call a save method. This is almost too convenient to give up; thus you end up in the nasty world of generic updates. 

The other side effects I have observed is that all the business rules usually turn into validation logics applied on the entity itself because it knows everything, and you are "sure" that saving the entity is safe. Again a topic for another post.

##The solution
The solution is very easy: you should try to break down each save into meaningful business actions.

You can create meaningful business operations on your domain model (and on your service layer if you have one). This approach is suitable when you use RPC; e.g. Request/Response pattern on WCF services. I provided some examples of this above. If you use messaging (e.g. pub/sub pattern on something like nServiceBus) create meaningful business commands. For order confirmation this would look something like:

    public class ConfirmOrder : ICommand
    {
        public int OrderId { get; set; }
    }

And for customer upgrade it would look something like:

    public class UpgradeCustomer : ICommand
    {
        public int CustomerId { get; set; }
        public CustomerLevel Level { get; set; }
    }

And then you will have a command handler that knows how to execute these commands and where to dispatch them. Not a topic for this article; but I think you get the point.

Then you will also have to design your UI to call these methods which will lead into task-based UI.

This alternative design will avoid the abovementioned issues and will help achieve class and UI composability.


  [1]: /orm-anti-patterns-series
  [2]: /orm-anti-patterns-part-2-batch-operations
  [3]: /get/BlogPictures/generic-update-methods/Order_Portal_Diagram.png
  [4]: /orm-anti-patterns-part-3-lazy-loading
  [5]: http://cqrsinfo.com/documents/task-based-ui/
  [6]: http://en.wikipedia.org/wiki/Aspect-oriented_programming