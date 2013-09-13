--- cson
title: "That Tricky StackTrace"
metaTitle: "That Tricky StackTrace"
description: "In this article I will show you a tricky situation that could happen when you walk up the StackTrace"
revised: "2012-10-14"
date: "2011-10-05"
tags: ["quiz",".net"]
migrated: "true"
resource: "/that-tricky-stacktrace"
summary: """
Do you know what is in your StackTrace at run time? Well, you can guess what it could be, but you cannot know it. Do you wonder why? Then read on.
"""
---
What does this application print and why? The answer may not be as simple as you think.

    using System;
     
    namespace StackTrace
    {
        class Program
        {
            static void Main()
            {
                Method1();
                Console.ReadLine();
            }
     
            static void Method1()
            {
                var stackTrace = new System.Diagnostics.StackTrace(1);
                var stackFrame = stackTrace.GetFrame(0);
                Console.WriteLine(stackFrame.GetMethod().Name);
     
                Method2();
            }
     
            static void Method2()
            {
                var stackTrace = new System.Diagnostics.StackTrace(1);
                var stackFrame = stackTrace.GetFrame(0);
                Console.WriteLine(stackFrame.GetMethod().Name);
     
                Method3();
            }
     
            static void Method3()
            {
                var stackTrace = new System.Diagnostics.StackTrace(1);
                var stackFrame = stackTrace.GetFrame(0);
                Console.WriteLine(stackFrame.GetMethod().Name);
            }
        }
    }

 

Feel free to run it!!

At the first look and even when you run it the answer seems to be:

Main

Method1

Method2

which is right but not always! In fact, in production (i.e. in release mode) that answer is always wrong!! Let me explain:

Obviously stack trace is populated at run time and not at compile time. When you are debugging this application or even when you are running it when it is built with 'debugging' configuration the stack trace is what you would hope it to be, which is what I wrote above. However if you run the very same application in release mode, the situation is different.

At run time, when it comes the time for JIT compiler to compile this module, it has a look at the methods and thinks to itself: "Hey, you know what. These calls are very simple and I could inline these methods and save myself, CPU and memory from a lot trouble. This way we will not have to deal with pushing addresses into stack and popping them up later. So I am just going to inline this. This not only performs better but is also really cool. So yeah, let's do it". OK, maybe JIT does not think like this; but the result is the same! :)

So what is going to happen at run time in release mode (and depending on your machine's CPU architecture) is that JIT is going to inline these methods and the application output all of a sudden becomes:

Main

Main

Main

The decision process is actually much more complex than what I naively explained above. So many criteria are involved in making a decision about inlining a method. [Here][1] is a few:

 - Methods that are greater than 32 bytes of IL will not be inlined.
 - Virtual functions are not inlined.
 - Methods that have complex flow control will not be in-lined. Complex flow control is any flow control other than if/then/else; in this case, switch or while.
 - Methods that contain exception-handling blocks are not inlined, though methods that throw exceptions are still candidates for inlining.
 - If any of the method's formal arguments are structs, the method will not be inlined.


And then there is tailcalling which makes it even more confusing. [Here][2] is a few considerations on tailcalling: 

"For the 64-bit JIT, we tail call whenever we’re allowed to. Here’s what prevents us from tail calling (in no particular order):

 - We inline the call instead (we never inline recursive calls to the same method, but we will tail call them)
 - The call/callvirt/calli is followed by something other than nop or ret IL instructions.
 - The caller or callee return a value type.
 - The caller and callee return different types.
 - The caller is synchronized (MethodImplOptions.Synchronized).
 - The caller is a shared generic method.
 - The caller has imperative security (a call to Assert, Demand, Deny, etc.).
 - The caller has declarative security (custom attributes).
 - The caller is varargs
 - The callee is varargs

...."

If you want to learn more Scott Hanselman has a [good article][3] that explains these in a good depth and provides much more info on them.

Hope this helps.


  [1]: http://blogs.msdn.com/b/ericgu/archive/2004/01/29/64717.aspx
  [2]: http://blogs.msdn.com/b/davbr/archive/2007/06/20/tail-call-jit-conditions.aspx
  [3]: http://www.hanselman.com/blog/ReleaseISNOTDebug64bitOptimizationsAndCMethodInliningInReleaseBuildCallStacks.aspx