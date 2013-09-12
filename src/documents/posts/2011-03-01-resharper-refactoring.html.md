--- cson
title: "Refactoring Using R#"
metaTitle: "Refactoring Using R#"
description: "Refactoring tools are great. They are great time savers and could help us identify and fix some issues in our code; but they could also be dangerous."
revised: "2011-03-02"
date: "2011-03-01"
tags: ["refactoring",".net"]
migrated: "true"
urls: ["/resharper-refactoring"]
summary: """
Refactoring tools are great. They are great time savers and could help us identify and fix some issues in our code; but they could also be dangerous.

In this post I discuss R# which is my favorite refactoring tool and some of the dangers that you should be aware of.
"""
---
I love ReSharper, and without it I feel kind of impaired. This tool is so perfect that you want to trust everything it does. It never seems to make mistakes, it usually does not mess with your code, its shortcuts are great time savers and the refactoring support it provides is invaluable. 

If you do not like ReSharper there are other competitive offerings for .Net (e.g. [CodeRush][1] and it has its own [fan club][2]). If you do not like third party tools then you can use refactoring support built into Visual Studio. MS has brought a lot of [refactoring goodness to VS2010][3].

In this post I am going to talk about ReSharper, some of the shortcuts I use and some of the dangers you should be aware of. I am talking about R# because this is the tool I have used most and feel most comfortable with. These issues may or may not apply to your tool of choice. I would be interested to see how other tools react to these scenarios; so if you are a user of other refactoring tools, please leave me a comment and let me know if they have similar issues.

##Refactoring
Lets have a look at the definition of refactoring before going any further. 

From the [Refactoring website][4]: "*Refactoring is a disciplined technique for restructuring an existing body of code, altering its internal structure without changing its external behavior.*"

From [WikiPedia][5]: "*Code refactoring is "a disciplined way to restructure code" undertaken in order to improve some of the nonfunctional attributes of the software. Typically, this is done by applying series of "refactorings", each of which is a (usually) tiny change in a computer program's source code that does not modify its functional requirements.*". 

So refactoring should not change the external behavior of the code.

##ReSharper refactoring support is awesome
I find myself using R# refactoring shortcuts many times a day. It makes my job much easier and removes the need for a lot of (erroneous) code changes. Refactoring shortcuts are very intuitive. Just like most other VS shortcuts you have to hold down 'ctrl' key, and because you are doing **R**efactoring you have to hit 'R' next, and then comes a choice of easy-to-remember one letter shortcuts. The shortcuts I use most are: 

 - ctrl+R+**F**: to introduce **F**ield.
 - ctrl+R+**V**: to introduce **V**ariable.
 - ctrl+R+**M**: to extract **M**ethod.
 - ctrl+R+**I**: to make a call **I**nline.
 - ctrl+R+**R**: to **R**ename something.
 - ctrl+R+**S**: to change a method **S**ignature.

##So what is the danger?
A lot of developers I know, including myself, trust ReSharper so much. We sometimes blindly accept all its suggestions and use its refactoring methods fearlessly. 

This is what R# provides for refactoring:

![alt text][6]

That is quite extensive; but is everything under the 'Refactor' menu a safe refactoring method? Here I am going to examine two of the shortcuts I use frequently; but you may find other shortcuts with similar problems.

###Introduce Variable (ctrl+R+V)
I have the following (very contrived) method that I would like to refactor:

    class Program
    {
        static void Main(string[] args)
        {
            var prg = new Program();
            var processLengthInMs = prg.DoSomethingLengthy(() => System.Threading.Thread.Sleep(2000));
            Console.WriteLine("DoSomethingLengthy took {0} milliseconds", processLengthInMs);
            Console.ReadLine();
        }

        public double DoSomethingLengthy(Action theLengthyMethod)
        {
            var startTime = DateTime.Now;

            theLengthyMethod();
            
            var endTime = DateTime.Now;
            return (endTime - startTime).TotalMilliseconds;
        }
    }

We have a very simple method called DoSomethingLengthy that takes an Action and executes it and returns how many milliseconds it took to run. I know it is contrived; but that is the simplest thing I could think of to show my point. 

You run the method and it shows you that the lengthy method took around 2000 ms to run. All good. 

Now let's do a bit of refactoring. What can we improve on that code? "Oh, I know. There are two calls to DateTime.Now. That is duplicate code and should be removed!!! R# is my friend and if there is any chance of making a mistake it warns me and prevents me from doing it. Also I am going to use R# Refactor and because it is refactor, it is safe!"

R# makes it very easy indeed. Just put your cursor on DateTime.Now, type ctrl+R+V and R# gives you an option to replace one or all occurrences with a variable:

![alt text][7]

"It is duplicate code so of course I want to replace both". And here is the result:

    public double DoSomethingLengthy(Action theLengthyMethod)
    {
        var dateTime = DateTime.Now;
        var startTime = dateTime;

        theLengthyMethod();

        var endTime = dateTime;
        return (endTime - startTime).TotalMilliseconds;
    }

You may run the app again. This time it says the operation took 0 milliseconds. We changed the behavior of the method and broke the logic. It is VERY easy to [regress your code][8] using 'Introduce Variable' carelessly.

###Inline (ctrl+R+I)
Inline is kind of opposite in its changes. Let's look at the previous example (before changes) again:

    public double DoSomethingLengthy(Action theLengthyMethod)
    {
        var startTime = DateTime.Now;

        theLengthyMethod();

        var endTime = DateTime.Now;
        return (endTime - startTime).TotalMilliseconds;
    }

This is the working code that prints the correct value to the console. 

"Oh look - that variable 'startTime' there is quite redundant and useless. Why would you introduce a variable when all it does is to store the result of a property getter? I will just Inline that". Click on 'startTime' and type 'ctrl+R+I'. This time R# does not even ask you for confirmation: it just makes the change for you, and effectively your code looks "shorter and more readable":

    public double DoSomethingLengthy(Action theLengthyMethod)
    {
        theLengthyMethod();

        var endTime = DateTime.Now;
        return (endTime - DateTime.Now).TotalMilliseconds;
    }

... and we broke it again.

I understand that these samples are rather obvious and you would immediately know that something is wrong; but I have broken code and I have seen code broken using 'Inline'. Inline is a useful refactoring method; but be careful with it. 

##What about simple code restructuring?
There is another method that is not just about refactoring; but more about code cleanup: Alt+Enter. It feels like Alt+Enter knows everything! R#, when Code Analysis is enabled, shows you some warnings and errors in code files through which you can traverse using 'Alt+PageDown' and 'Alt+PageUp' and then on each warning/error simply do 'Alt+Enter' and the greatest wizard of all times fixes your code in a blink. That is just brilliant.

One thing I have found rather annoying with Alt+Enter fixes is its conversions to LINQ. It is the only place that I think R# has gotten a bit too smart if you know what I mean:

    public int DoSomethingElse(IEnumerable<int> inputs)
    {
        var counter = 0;

        foreach (var input in inputs)
        {
            if (IsWrongInput(input))
            {
                counter++;

                if(counter > 20)
                    throw new Exception("Too many wrong input");
            }
        }

        return counter;
    }

    public  bool IsWrongInput(int input)
    {
        return (input%2 == 0);
    }

In this case R# does not warn you about your foreach loop: it just provides a tiny 'Hint' when cursor is on foreach. Let's R#ize this code (press Alt+Enter):

    public int DoSomethingElse(IEnumerable<int> inputs)
    {
        var counter = 0;

        foreach (var input in inputs.Where(input => IsWrongInput(input)))
        {
            counter++;

            if(counter > 20)
                throw new Exception("Too many wrong input");
        }

        return counter;
    }

But now R# is not happy: input => IsWrongInput(input) could be replaced by IsWrongInput method group. So do your 'Alt+PageUp' thing to go to that error and R#ize it:

    public int DoSomethingElse(IEnumerable<int> inputs)
    {
        var counter = 0;

        foreach (var input in inputs.Where(IsWrongInput))
        {
            counter++;

            if(counter > 20)
                throw new Exception("Too many wrong input");
        }

        return counter;
    }

Still not happy; but this time there is not much R# can do with it. 

Now compare the last 'for loop' with the first one. I know some people [just do not like if statements][9] and I agree with them most of the times; but in this case the first 'for loop' is much more readable. Maybe it is just me; but I prefer my code over what R# created out of it.

As we just saw there is a chance that R# suggestions make your code less readable, and I have found that to be the case mostly with LINQ conversions. I love LINQ and I use it quite heavily. R# Suggestions, even those for LINQ conversions, are usually good though. Here is an example:

    public int LetReSharperShine(IEnumerable<int> inputs)
    {
        var counter = 0;

        foreach (var input in inputs)
        {
            if (IsWrongInput(input))
            {
                counter++;
            }
        }

        return counter;
    }

This time R# gives you a suggestion to improve your code. The R# suggestions are displayed next to your scrollbar as a green line. Do your 'Alt+PageUp' (or 'Alt+PageDown') to go to the line R# thinks needs improvement and do 'Alt+Enter' (twice) - Voila. The result is beautiful, very short and readable:

    public int LetReSharperShine(IEnumerable<int> inputs)
    {
        return inputs.Count(IsWrongInput);
    }

Usually when R# provides a suggestion or warning it is for good cause; but you still have to be careful and verify the result for readability.

##Conclusion
Refactoring tools are there to help us and they are great. They help us find issues with our code and fix it. R# is actually quite good at finding some of the potential bugs in the code (e.g. Access to Modified Closure warning explained [here][10] and [here][11]). 

What is also important to realize is that regardless of how great these tools are they do not think in your stead. At the end of the day you are the programmer and you choose what tools to use and how to use them. With or without refactoring tools you should always think before making a change, and with or without refactoring tools the bugs in your code are the bugs you have created. I think the lamest excuse I have ever heard when someone broke some functionality was that "R# did that. It is R#'s bug"!

Regardless of how careful you are with your refactoring activities and how perfect your refactoring tools are it is still quite valuable (and in some cased necessary) to have some unit tests around the code under refactoring before making any serious changes. This way you can verify that the refactored code still behaves the same.

Do refactoring frequently to pay your [technical debt][12] and to avoid ending up in a [BBoM][13]. Use refactoring tools to do this as they could save you quite a lot of time; but do it responsibly. 

You can download the code used in this article from [here][14].

Hope this helps.


  [1]: http://www.devexpress.com/Products/Visual_Studio_Add-in/Coding_Assistance/
  [2]: http://www.hanselman.com/blog/ReSharperVsCodeRush.aspx
  [3]: http://www.microsoft.com/downloads/en/details.aspx?FamilyID=92ced922-d505-457a-8c9c-84036160639f
  [4]: http://www.refactoring.com/
  [5]: http://en.wikipedia.org/wiki/Code_refactoring
  [6]: /get/BlogPictures/resharper-refactoring/refactor-menu.JPG
  [7]: /get/BlogPictures/resharper-refactoring/introduce-variable.JPG
  [8]: http://en.wikipedia.org/wiki/Software_regression
  [9]: http://www.antiifcampaign.com/
  [10]: http://stackoverflow.com/questions/235455/access-to-modified-closure
  [11]: http://stackoverflow.com/questions/304258/access-to-modified-closure-2
  [12]: http://martinfowler.com/bliki/TechnicalDebt.html
  [13]: http://c2.com/cgi/wiki?BigBallOfMud
  [14]: /get/BlogPictures/sourcecode/RefactoringUsingReSharper.zip