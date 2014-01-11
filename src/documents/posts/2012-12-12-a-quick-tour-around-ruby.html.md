--- cson
title: "A quick tour around Ruby"
metaTitle: "A quick tour around Ruby"
description: "In this post I will give you a very quick tour around Ruby."
revised: "2012-12-13"
date: "2012-12-12"
tags: ["Ruby"]
migrated: "true"
resource: "/a-quick-tour-around-ruby"
summary: """
This is the second post in my ['Ruby for C# developer' series](/ruby-for-csharp-developers). In this post I will give you a very quick tour around Ruby
"""
---
Now that we have our [environment setup](/ruby-for-csharp-developers), let's take a very quick tour around Ruby language. Just before we get into coding, I want to quickly highlight a few somewhat interesting facts about Ruby. Quoting the [wikipedia article](http://en.wikipedia.org/wiki/Ruby_(programming_language) here:

<blockquote>
Ruby was conceived on February 24, 1993 by Yukihiro Matsumoto who wished to create a new language that balanced functional programming with imperative programming. Matsumoto has said, "I wanted a scripting language that was more powerful than Perl, and more object-oriented than Python. That's why I decided to design my own language.". Matsumoto has also said that Ruby is designed for programmer productivity and fun, following the principles of good user interface design. He stresses that systems design needs to emphasize human, rather than computer, needs.
</blockquote>

… and if you ask me he has done a tremendous job at delivering on this promise. We will see some mind blowing DSLs later in this series!

Some other quick facts:

 - Ruby is written in C and [is open source](https://github.com/ruby/ruby). 
 - Ruby unlike C# is an interpreted language. 
 - Ruby is considered a scripting language!
 - Ruby unlike C# is a dynamic language (I don't think DLR makes C# dynamic) 
 - Ruby like C# is a pure object oriented language.
 - There are no primitive types in Ruby. EVERYTHING is an object including "null" or as Ruby calls it `nil`!
 - Ruby has had classes with inheritance, mixins, iterators, closures, exception handling and garbage collection since 1995!
 - Ruby allows **easy** reflection and alteration of objects to facilitate metaprogramming.
 - Like C#, Ruby only supports single inheritance.

With that out of our way, fire up irb in your terminal and run the below statements:

![Simple math][1]

<small>irb is one powerful console application and it makes it very simple to pick up the language</small>

No surprises there. The simple mathematic in Ruby works just like C#. Ok, let's take it a step further and do a simple assignment:

![Variable assignment][2]

This should show you the same result as before (which is 5); but it does a bit more than that. Now if you type `result` in irb it shows you `5`. 

![Variable result][3]

Oh, so we have now got a variable called `result`! The equivalent of this in C# would be something like '`int result = 2 + 3;`' or '`var result = 2 + 3;`'. So a few things here:

 - Statements in Ruby don't end with semicolon unlike C# (in Ruby you can use semicolons to indicate the end of a statement; e.g. `some_var=2+4;some_var/3` will print 2).
 - Unlike C#, types in Ruby are implicit; i.e. the interpreter determines the type of a variable based on the assignment at runtime instead of developer having to explicitly (e.g. `int result = 5;`) or implicitly (e.g. `var result = 5;`) tell the compiler what the variable type is! Even with var the C# compiler figures out the type of the variable and turns it into a strongly typed variable. Another difference is that `var` only works for local variables. 

You can now use the `result` variable in your statements: try '`result+2`' or '`result%2`'.

![Using variables][4]

Now write '`result = "Hello, world!"`'. Yep, we just changed the type of the `result` variable to string! So now we can try things like '`result + " I am learning Ruby"`' or maybe even '`result + ' I am learning Ruby'`'. So like C# you can wrap strings in double quote; but unlike C# (and like JavaScript) you can also wrap strings in single quote!

![Changing variables to string][5]

##A quick tour around reflection
To see the type of a variable or an instance of a class you can call the '`class`' method on it. The '`class`' method is very much like '`GetType()`' in C# in that you can call it on an instance to see its type! 

![Class method][6]

Two differences here: unlike C#, methods in Ruby are written in lower case (and the words in multi-word methods are separated using underscore) and to call a method in Ruby you don't have to add parenthesis at the end of the method name but you can if you want to. There are also cases where you cannot drop parenthesis from a method call - we will discuss these in a future post. 

'`Fixnum`' in Ruby is like '`int`' in C#. Not that you ever have to care about this; but when a number doesn't fit into an '`integer/Fixnum`', in other words when it overflows, it gets upgraded to '`Bignum`'. 

"So `class` method is nice but how can I see the list of methods on '`Fixnum`'?" I hear you say. In other words what's the equivalent of '`typeof(int).GetMethods()`'? 

Type '`Fixnum.methods`':

![methods][7]

Interesting, so I can call a method directly on a class. Yep, these are called 'class methods' as opposed to 'instance methods'. The C# devs can think of these as static methods that you can run on a `class`. To get a list of 'instance methods' you can call the `instance_methods` method:

![Instance methods][8]

As you may have noticed there are some overlaps on the methods. These methods can be called on the class and on an instance of it. The result is not necessarily the same though:

![Class vs instance methods][9]

Now try `2.methods`:

![methods on an instance][10]

The list is the same as that of '`Fixnum.instance_methods`'. That is because `2` is an instance of the `Fixnum` class. Now let's try ``2.instance_methods``

![No instance_methods on instances][11]

Hmmm, no `instance_methods` method for 2 (more on `NoMethodError` shortly)! It's not that 2 doesn't have any instance methods; but to get instance methods of an object instance you should (logically) call `methods` on it. To get a list of 'class methods' on 2 you can of course call `2.class.methods`.

You may have noticed above that some of the methods end up with a question mark. These methods are yes/no questions you ask from the object or class and they return a boolean response. To see what I mean try `2.odd?`, `2.even?`, `2.integer?`, `2.to_f.integer?` and `2.between? 1, 3`:

![Methods ending in question marks][12]

Just a quick note about `NoMethodError` that we saw above - this is an exception. Because Ruby is a dynamic language it doesn't complain when you call a non-existing method (until runtime that is) and at runtime it gives you an exception if it cannot find the method or dispatch the call (this is VERY funky and powerful and I will need an entire post for it). If you want to see if some object has a particular method you can call `respond_to?` on it:

![respond_to? method][13]

Ok, I don't want to overload you. So I will stop here and will give you some exercises:

 - Try `2/3`
 - Try `2.to_f/3`
 - Try `2.0/3`
 - Try `2.0.class`
 - Try `2.0.methods`
 - Try `2 + " cows"`
 - Try `2.to_s + " cows`"

I hope you find this useful.

Please let me know what you think. Do you like this format? Do you want me to put more focus on similarities and differences? Anything you can think of that could improve this series? 


  [1]: /get/BlogPictures/a-tour-around-ruby/simple-math.jpg
  [2]: /get/BlogPictures/a-tour-around-ruby/variable-assignment.jpg
  [3]: /get/BlogPictures/a-tour-around-ruby/variable.jpg
  [4]: /get/BlogPictures/a-tour-around-ruby/using-variables.jpg
  [5]: /get/BlogPictures/a-tour-around-ruby/changing-var-to-string.jpg
  [6]: /get/BlogPictures/a-tour-around-ruby/class-method.jpg
  [7]: /get/BlogPictures/a-tour-around-ruby/methods-method.jpg
  [8]: /get/BlogPictures/a-tour-around-ruby/instance_methods.jpg
  [9]: /get/BlogPictures/a-tour-around-ruby/class-vs-instance-methods.jpg
  [10]: /get/BlogPictures/a-tour-around-ruby/methods-on-instance.jpg
  [11]: /get/BlogPictures/a-tour-around-ruby/no-instance_methods-on-instances.jpg
  [12]: /get/BlogPictures/a-tour-around-ruby/question-mark-in-methods.jpg
  [13]: /get/BlogPictures/a-tour-around-ruby/respond_to.jpg