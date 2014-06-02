--- cson
title: "Processing credit card transactions"
metaTitle: "How credit card transactions work and what it takes to implement a proper solution"
description: "A lot of businesses want the ability to process credit card transactions.  In this post we're going to see how credit card transactions work and what it takes to implement a proper solution"
revised: "2014-05-30"
date: "2014-05-30"
tags: ["Notes"]
---

Recently a client asked us to add credit card processing to a website we are creating for them. To them this was just a matter of adding a checkout page and a simple integration with a payment gateway. While the ability to pass a credit card transaction to a payment gateway is the essence of this feature, that's just the tip of the iceberg. So in this post I'll try to clarify how credit card transactions work and what it takes to implement a proper gateway.

##High level view of the process
A credit card transaction goes through three phases:

  - Transaction processing 
  -	Reconciliation
  - Refunds and chargebacks 

###Transaction Processing
A customer/cardholder initiates a transaction. The merchant can optionally run some local transaction verification (more on this shortly). Then the merchant sends the credit card and the purchase info to a payment gateway. The payment gateway, depending on the agreement with the merchant, would then send the transaction to third-party Fraud Detection Services that run the transaction info (usually only card number) through a series of tests to verify if it’s a fraudulent transaction or not. If fraud detection test passes, then the payment gateway sends the credit card and purchase info as well as merchant Id, that is a unique merchant identifier for the acquiring bank, to an acquiring bank as agreed with the merchant. The acquiring bank would then route the transaction to the issuing bank based on the Bank Identification Number (the first six digits of the card number), unless it’s an AMEX transaction in which case the acquiring bank is also the transaction processor. The issuing bank processes the transaction and the response is sent all the way back to the customer.

Depending on the implementation and the provided API this might have to happen in two phases: authorization, where the transaction is authorized, and settlement, where the authorized transaction is cleared.

You pay fees for each transaction you process. These fees depend on the payment gateway you pick and also your agreement with them; but are usually a combination of a fixed processing fee for all transactions regardless of the outcome plus a percentage of the approved transactions.

###Reconciliation 
At the end of a pre-defined cut-off period, normally a day, merchant bundles up all the transactions processed during the period, which also includes the refunds that happened in that period and sends them to the payment gateway. The reconciliation file is then sent to the acquiring bank that settles the payment with the issuing banks. Bank clears the money and the money is transferred to the merchant.

This process is sometimes initiated by the payment gateway instead and that has the benefit of including charged back transactions in the report which makes the reconciliation easier. 

###Refunds and chargebacks
Some transactions are refunded by customers, usually because the customer is not happy with the service or product. The refunds are handled through the merchant: customer calls up the merchant (or in the case of card-present transaction, shows up at the customer service desk) and complains about something and the transaction is refunded (and the merchandise returned). 

Some merchants strangely decide not to provide a refund mechanism or make it really hard which forces the customers to chargeback the transaction. This is NOT a good idea as you will not get your merchandize back and also your rating drops on the issuing bank which means you might get less approvals in the future.

Almost all credit card companies implement Zero Liability policy to give their customers a piece of mind with regards to unauthorized transactions and to protect them against transactions processed on their lost or stolen card and identity theft. That means that you can pretty much chargeback any transaction (if you have a good history with your bank). 

In many countries, banks are very careful with chargebacks and monitor their customers' chargeback behaviors; but in some countries some banks unfortunately seem to be very liberal and approve any and all chargebacks to the expense of the merchant. That means you might get a lot of chargebacks from customers who enjoy free products. This is commonly known as [friendly fraud](http://en.wikipedia.org/wiki/Friendly_fraud)! 

The customer should initiate the chargeback through their bank. Ideally the bank should get in touch with the merchant to resolve the dispute to figure out whether the transaction should be charged back or not; but usually the chargeback is accepted right away and the merchant only hears about it during reconciliation in which case the merchant can dispute the transaction if they have an evidence of purchase (which doesn't exist for online transactions).

##Possible solutions
So now that we know what the process looks like let's talk about the implementation solutions. The very minimal baseline for an online credit card processing solution is:

  - The actual credit card payment feature that calls the payment gateway to process the transaction.
  - A refund feature that allows a merchandise to be returned and the transaction to be refunded. This obviously also calls the payment gateway to process the refund. 
  - A minimal automated process that would fetch all the transactions on a cut-off period and generates a report to be used manually for reconciliation.

On top of this minimal solution you could, and over time should, have some of the following options:

  - Transaction Verification
  - Automated Reconciliation Process
  - Payment Console

###Transaction Verification
You must use Fraud Detection Services either via the payment gateway or directly. These services have huge databases of credit card and transaction history, lost and stolen cards, spending behavior of customers etc, maintained directly and through integration with issuing banks which allows them to identify suspicious transactions and activities and stop the fraudulent transactions on their inception. Some of the providers also provide a lot of support with chargeback administration and dispute. Some of the Fraud Prevention Service providers allow merchants to directly integrate with them so if your payment gateway doesn’t give you fraud prevention option or if they charge high fee for the service you can decide to integrate to a service directly. One way or another you must use these services.

While fraud detection services are very useful and effective, they use generic patterns and solutions that don't take your special needs and customer base into consideration. So it is highly recommended to implement a local transaction verification process that’s run before any transaction is processed to avoid unnecessary transaction processing fees and also stop known or likely fraudulent transactions and chargebacks that only you could anticipate. 

You can implement many features in this process over time; but at the very least and preferably from the beginning you should have the [Luhn algorithm](http://en.wikipedia.org/wiki/Luhn_algorithm) that verifies the card number. The last digit on the card number is a checksum calculated based on the card number. When card is not present, you're likely to get a lot of invalid card numbers so you should use Luhn algorithm to validate the card number. This will help provide better user experience and also avoid unnecessary transaction processing fees.

Luhn is a good simple and mandatory first step but you should ideally do a lot more than that. Here is a few other options you might want to consider.

> **Note:** You should verify the usefulness of each feature against your needs particularly transaction volume and ticket prices. Some systems have huge number of low priced transactions while others have lower number of high priced items with high profit margin. For the latter you might decide to bear the transaction processing fee for even low success rates.

####BIN List
Luhn algorithm only knows about digits so you could very easily create a valid card number that's never been issued ever. To avoid this situation you can maintain a list of BIN numbers and their associated banks (you should frequently update this list as sometimes new banks pop up and some merge or disappear). This list complements the Luhn algorithm to help verify the card number. It also provides a foundation for blacklisting issuing banks (more on this shortly).

####Avoiding duplicate transactions
A credit card transaction normally takes around a second to process but sometimes the transaction freezes and the calls time out and you or your customers are left there not knowing if the transaction was actually processed or not. So the transaction is sent again and if you're not careful you could end up double-charging your customers. You can stop a lot of these duplicate requests locally by looking up the transaction details in your database if you have the response. If you don't have the response because the call between you and the payment gateway timed out, you should use the payment gateway API, if provided, to lookup the transaction before processing. These calls normally don't incur any charges.

####BIN Blacklist
Most banks have internal rules against some purchases and/or merchant categories, and if a bank doesn't like what you (seem to) do, all your transactions hitting them will be rejected and you will be left only with transaction processing fees. Also some banks and regions have higher potential for fraudulent transactions. To avoid these transactions you should create a BIN blacklist that you maintain both manually and through pattern matching to block all the cards issued by these banks locally. You need to be able to search and update this list.

####Card and Customer Blacklist
Some people make a living by buying merchandize and then charging the transaction back. You can create a chargeback threshold, perhaps with the threshold not greater than two, that would blacklist a card and potentially the cardholder for future purchases. You also need search and update feature over this list so it can be maintained by your customer service.

####Neural Networks
Neural Networks are indispensable for credit card processing. In fact all fraud detection service providers I know about heavily use neural networks for pattern matching. You too can and should implement a neural network. Obviously you need to train the network up properly and improving your network fitness would require a huge sample (think tens or hundreds of thousands of transactions over a long period). When your network is up and running you will feed every transaction into it and let it calculate the success rate of the transaction and process the transaction further only if you're happy with the calculated success rate. Over time and based on heuristics you can fine tune the success thresholds to make sure you only reject transaction with high failure probability. A sophisticated neural network implementation could almost reduce the need for most of the abovementioned features; but you can't start with a neural network due to the need for transaction history. So start with the hard coded rules as mentioned above, build up your transaction history, create and train-up a neural network, use it side-by-side with your other prevention mechanisms and correct it whenever it makes a mistake, and roll it in when you're happy with its accuracy. You should still process some of the transactions with low approval chance to verify the network fitness. That is because payment rules change all the time and you might be rejecting BINs, cards and transactions that were once troubled but could now perform better.

####Routing rules
Different acquiring banks could result into different outcomes based on the way your merchant entity is setup with them; so you might decide to use more than one payment gateway and/or acquiring bank. In this case it's very important to create a local routing rule that predicts the potential result of a transaction on each gateway/bank based on the history and route it accordingly. The neural network could be your best friend here.

###Automated reconciliation process
Reconciliation issues are likely, particularly on high number of transactions. These are mostly caused by communication issues and also duplicate chargeback/refund entries! To find and fix these issues the reconciliation report provided by the payment gateway should be matched against the local database of the processed transactions and also refund entries. This is not a complex process but is very time consuming and error-prone if done manually; but you can and should automate a fair bit of this process leaving only the mismatch processing for human intervention. The automated process would entail a daily task that would: 

  - Fetch cut-off transactions and match them against the transactions reported by the payment gateway
  - Flag duplicate charges, chargebacks and refunds for further investigation
  - Apply charged back transactions in the database (and potentially flag the card and customer for investigation or blacklist them)
  - Clear transactions locally
  - Flag un-cleared transactions for investigation
  - Flag unknown transactions for investigation

###Payment Console
As you can see this is a relatively involved process and as such it is very important to provide an insight for the business into what's happening and to give them more control over it. I just call this Payment Console. 

There are many possibilities for the things you can do in this console. Here is a quick list to give you some ideas. Your console could have a dashboard, a search page and a transaction processing page. 

####Dashboard
The dashboard could show things like: 

 - KPI for BINs, regions, acquirers (if you're using more than one) and payment gateways (if you're using more than one). 
 - Refunds and chargebacks divided by BINs, regions, perhaps ticket price, customer demography etc.

This allows you to find who's under performing and fine tune your routing process or update your BIN/card/customer blacklist.
 
####Search Page
Your search page(s) should allow you to:
 
 - search for a transaction by date, amount, id etc. From there you should be able to see when the transaction was processed, when it was cleared and when it was refunded or charged back. 
 - search for a customer and from there see their cards and transaction history. 
 - search for a card by card number (or number of refunds or chargebacks). 
 - search for an issuing bank by BIN, region and even success rate. From there you should be able to fine tune your routing and local rejection rules.
 
On the search result you should allow some further features. For example on transaction history you can plot the success rates of transactions over a period in time, and for BINs, cards and customers the ability for the entry to be blacklisted (or removed from the blacklist).

####Transaction processing page
You will also need a transaction processing page where you can initiate either new a transaction or a refund on an existing transaction. 

##Conclusion
Processing a credit card transaction seems like an easy task and the processing itself is really easy too; but there are a lot of surrounding processes that you need to add in to make it work properly for you.

In this article I talked about how a credit card transaction is processed, what happens after the process and how the merchant is paid. We also talked about some of the verification and fraud detection/prevention mechanisms, refunds and chargebacks and things you can do to avoid them and also lower your transaction processing fees.

I hope you find this useful.










