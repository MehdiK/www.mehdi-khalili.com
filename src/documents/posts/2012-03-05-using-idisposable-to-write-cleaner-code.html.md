--- cson
title: "Using IDisposable to write cleaner code"
metaTitle: "IDisposable clean code"
description: "IDisposable is usually used for garbage collection. Here I explain a simple technique that can help you clean up some of your code using IDisposable"
revised: "2012-03-05"
date: "2012-03-05"
tags: ["maintainability"]
migrated: "true"
urls: ["/using-idisposable-to-write-cleaner-code"]
summary: """
IDisposable is usually used for garbage collection. In this post I explain a very simple technique that can help you clean up some of your code using IDisposable.
"""
---
Just before I start I should mention here that this is not a new idea and there is a good chance that you have already seen and used it. This is a very simple trick that helps simplify the code that requires scoping logic and prevents unnecessary mess and complication:

![Metaphorical unreadable code][1]

So I thought I'd share it here just in case you have not seen it. 

##IDisposable
<code>IDisposable</code> is usually used as a marker interface to let programmers know that a class should be disposed of when it is no longer needed. It is quite useful when class references some unmanaged resources. Also for costly managed resources this interface could be used to clean up the memory footprint of the objects when we are done with them. You may read more about it on [MSDN][2].

Despite the common belief Garbage Collector has no interest in  <code>IDisposable</code> and the interface is only useful for programmers which is what makes this trick safe to implement. One of the things that makes <code>IDisposable</code> so popular and useful is the <code>using</code> statement. I assume that you know the statement. If not, please refer to [MSDN][3] before reading further.

###The not so readable code
So this is the code I am trying to clean: 

<pre>
namespace IDisposableForCleanup
{
    using System;

    class Program
    {
        static void Main()
        {
            DisplayWelcomeNotes();
            DoSomeWork();
            DisplayExitNotes();
        }

        private static void DoSomeWork()
        {
            Console.WriteLine("doing some work");

            try
            {
                Console.WriteLine("and doing more work");
                throw new Exception("Some dummy exception that we can survive");
            }
            catch 
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("oops there was an exception but I was able to survive it");
                Console.ForegroundColor = ConsoleColor.White;
            }

            Console.WriteLine("My work is done...");
        }

        private static void DisplayWelcomeNotes()
        {
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Welcome to this very useful app");
            Console.ForegroundColor = ConsoleColor.White;
        }

        private static void DisplayExitNotes()
        {
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine();
            Console.WriteLine("Thanks for using this very useful app");
            Console.WriteLine("Press enter to exit");
            Console.ForegroundColor = ConsoleColor.White;
            Console.ReadLine();
        }
    }
}

</pre>

It is a very simple console application that prints a few lines of text on the console using different colors for different bits of text. Not very useful, I know... and when you run the application you get an even less exciting output:

![Console output][4]

As shown in the code, every time we set foreground color within a scope we have to reset it back to its default value when leaving the scope which is not very nice. In fact, that code is a bit flawed because the code surrounded by the color changes should be in try-finally block to guarantee that even in the face of an unhandled exception the color is going to be reset. This is a very small application and the code smell may not be that bit a deal; but in a real codebase this smell could make your application stink. 

So let's clean that up. <code>IDisposable</code> interface and <code>using</code> statement are usually used for memory management; but in this trick we use them only to clean up the code. In puristic point of view and according to [Framework Design Guidelines][5] this solution is wrong; but honestly with all due respect I prefer to have a clean codebase than to comply with some guideline.

###The solution
I will create a small class I call ForeColor:

<pre>
namespace IDisposableForCleanup
{
    using System;

    public class ForeColor : IDisposable
    {
        private readonly ConsoleColor _previousColor;

        public ForeColor(ConsoleColor foreColor)
        {
            _previousColor = Console.ForegroundColor;
            Console.ForegroundColor = foreColor;
        }

        public void Dispose()
        {
            Console.ForegroundColor = _previousColor;
        }
    }
}
</pre>

A very simple class which implements <code>IDisposable</code>. In implementing the interface I am not releasing any unmanaged and/or heavy resources. All the class does is that when it is constructed it memorizes the current console foreground color and when it is disposed it sets back the foreground color to that value. That is all.

Now let's use this class in our little app:

<pre>
namespace IDisposableForCleanup
{
    using System;

    class Program
    {
        static void Main()
        {
            DisplayWelcomeNotes();
            DoSomeWork();
            DisplayExitNotes();
        }

        private static void DoSomeWork()
        {
            Console.WriteLine("doing some work");

            try
            {
                Console.WriteLine("and doing more work");
                throw new Exception("Some dummy exception that we can survive");
            }
            catch 
            {
                using (new ForeColor(ConsoleColor.Red))
                {
                    Console.WriteLine("oops there was an exception but I was able to survive it");
                }
            }

            Console.WriteLine("My work is done...");
        }

        private static void DisplayWelcomeNotes()
        {
            using (new ForeColor(ConsoleColor.Green))
            {
                Console.WriteLine("Welcome to this very useful app");
            }
        }

        private static void DisplayExitNotes()
        {
            using (new ForeColor(ConsoleColor.Green))
            {
                Console.WriteLine();
                Console.WriteLine("Thanks for using this very useful app");
                Console.WriteLine("Press enter to exit");
                Console.ReadLine();
            }
        }
    }
}
</pre>

which compared to the initial solution looks more like:

![Metaphoric readable code][6]

Alright, ok I admit it: it is not that different :P In fact the number of lines of code in this sample has not changed much and the solution itself is not so much more readable than before; but this is just a sample. In a bigger application with more complex scoping needs this trick could save you a lot of code duplication. more importantly you can avoid the headache when trying to reset to the previous ambiance. A good example of this is [TransactionScope][7] class that makes transaction scoping so much simpler to deal with.

You could use this trick pretty much anywhere you require some scoping; e.g. indentation, frozen objects, applying mutex within a scope and so on and so forth.

You may download the code from [here][8].

I hope this helps.


  [1]: http://www.mehdi-khalili.com/get/blogpictures/idisposable-for-readability/unreadable-code.png
  [2]: http://msdn.microsoft.com/en-us/library/system.idisposable.aspx
  [3]: http://msdn.microsoft.com/en-us/library/yh598w02.aspx
  [4]: http://www.mehdi-khalili.com/get/blogpictures/idisposable-for-readability/console-output.png
  [5]: http://www.amazon.com/Framework-Design-Guidelines-Conventions-Libraries/dp/0321545613
  [6]: http://www.mehdi-khalili.com/get/blogpictures/idisposable-for-readability/readable-code.jpg
  [7]: http://msdn.microsoft.com/en-us/library/system.transactions.transactionscope.aspx
  [8]: http://www.mehdi-khalili.com/get/sourcecode/IDisposableForCleanup.zip