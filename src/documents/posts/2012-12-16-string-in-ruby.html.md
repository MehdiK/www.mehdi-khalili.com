--- cson
title: "String in Ruby"
metaTitle: "String in Ruby"
description: "A quick overview of String class in Ruby and its similarities and differences with String in C#"
revised: "2012-12-20"
date: "2012-12-16"
tags: ["Ruby"]
migrated: "true"
resource: "/string-in-ruby"
summary: """
This is the third post in my '[Ruby for C# developer](/ruby-for-csharp-developers)' series. In this post we will take a look at String class
"""
---
Strings in Ruby have a lot of similarities to C#: even many methods have the same (or similar) names. 

Just like C#, to initialize a new string you have a few options in Ruby:

![Initializing String][1]

The class name is `String`. The third option is the way it really works: initializing a string by calling constructor on the `String` class. Oh by the way, to construct a class in Ruby you call the class' `new` method. In this case the `new` method also accepts a constructor parameter which is used to set the string value.

By calling the default constructor you will get an empty string:

![String default constructor][2]

In C# you can use backslash to escape a double quote in a string: e.g. '`var str = "This is a \"escaped\" string";`'. You have the same option in Ruby too:

![Escaping with backslash][3]

... but have you ever been in a situation where the number of escaped double-quotes in your string just wants to kill you?! Ruby can help you in these situations. Ruby by default uses double quote as string delimiter; but you can change that when you want!!

![Custom string delimiter][4]

Here I am telling Ruby that for this particular assignment `*` is my string delimiter so it considers double quote just as a normal character in the string. It still uses double quote for displaying the result; but you can see that the result is escaped! Of course the other solution to this problem would be (as Javascript developers would guess) to use quote to delimit string which is also supported by Ruby as normal delimiter:

![Wrap string with quotes][5]

Nonetheless being able to define custom string delimiters is handy in some situations.

In C# we have got a notion of verbatim strings where the value of the string preserves line breaks ETC:

<code>
var emailBody = @"Dear reader,

This is a verbatim string in C#.

Yours truly,

Mehdi";
</code>

In Ruby that's called `here doc` and you can write it as:

![Here doc][6]

And if you wondered, of course you can use a custom delimiter here too!

![Multiline string][7]

In this case I am using `/` (slash) as a normal string delimiter; but you don't have to use a character for this!

![Here doc with custom delimiter][8]

More often that not though, we have placeholders in our strings which gets replaced by some variables. '`string.Format`' is how we deal with this in C#: e.g. '`var header = string.Format("Dear {0} {1}", title, name);`'. This sometimes gets rather scary with too many parameters being passed in the string where we lose track of indices. What's even worse is when we have to swap around a few parameters in the string which leads to reorder the placeholders over and over again. In Ruby this is handled more gracefully using variable interpolation:

![Variable Interpolation][9]

You could get a bit fancy with variable interpolation too and do more than just replacement. What goes between curly brackets is interpreted at runtime:

![Expression for variable interpolation][10]

Do you notice how I am concatenating the name and title inside the string?! Here is another example:

![Math expression in variable interpolation][11]

That math expression is evaluated at runtime and interpolated into the string. So one big difference in string interpolation between C# and Ruby is that in C# you can only provide formatting out of a list of [predefined formats][12] for your placeholder or if you want very custom behavior you can implement an `[IFormatProvider][13]`.

Just a quick note about variable interpolation in Ruby: it doesn't work with single quote!!

![No interpolation for single quote][14]

See how tokens didn't get replaced? The single quote and double quote are not quite interchangeable in Ruby. That said you can still use variable interpolation with custom delimiters:

![Interpolation with custom delimiter][15]

**Note:**
To practice inside irb you don't have to keep loading stuff into variables. In C# I use `Console.WriteLine` to verify something quickly. In Ruby you get that with `puts`:

![puts][16]

In C#, strings are arrays of characters and you can access each character using array indexers; e.g. 

<code>
var str = "Hello world!";

Console.WriteLine(str[0]);
</code>

This will print `H` as the first character in the string. In Ruby you can access characters in a string in the very same way:

![Character indexer][17]

To get a substring in Ruby you can use Ruby's range syntax:

![Substring with range syntax][18]

You can achieve the very same result using '`str[0, 5]`' and '`str.slice(0, 5)`' the latter being very similar to `Substring` in C#. 

Before the next exercise try `str` again to make sure that it hasn't been changed. Now let's try a method with a new syntax: `slice!`:

![slice vs slice!][19]

As you can see after calling `slice` the str value didn't change but `slice!` did change the value of str. From the [Ruby `string` reference](http://www.ruby-doc.org/core-1.9.3/String.html) `slice!` *"Deletes the specified portion from str, and returns the portion deleted"*. In general in Ruby methods ending with exclamation mark have side effects. 

Do a quick '`str.methods`' to see the methods with side effects. That's too many methods. We need a way to filter that list to only list the methods we're interested in. Try this:

![Methods ending in exclamation mark][20]

'`methods`' is an `Array` which is an '`Enumerable`' and '`Enumerable`' module has a lot of methods to deal with enumerables including '`select`'. What is passed into '`select`' is basically a lambda expression which filters the `methods` array and returns another array which is what you see in the result! Very similar to C#, isn't it? For a more advanced and denser version check out Derek's comment below. I have got another post coming up for `Enumerable` and I am getting far ahead of myself.

Just go through the list and exercise some of the methods. Now take a quick look at methods ending with question mark:

![Methods ending with question mark][21]

This should get you going on your string explorations so I will stop here. If you want to learn more about strings you may refer to this [tutorial](http://zetcode.com/lang/rubytutorial/strings/).

Just a few exercises before we wrap up. Try the following:

 - `"Echo! " * 5`
 - `"Hello" " " "world!"` 
 - `"Hello" " " "world!".size` 
 - `"Hello" << " " << "world!"` 
 - `"Hello" == "Hello"`
 - `"Hello" <=> "Hello"`
 - `"Hello" <=> "Helicopter"`
 - `"Hello" <=> "Help"`
 - `"hello world".capitalize`
 - `"all lower".upcase`
 - `"ALL CAPS".downcase`
 - `"down UP".swapcase`
 - `"  some padded text  ".strip`
 - `('a'..'z').to_a.join`
 - `('a'..'z').to_a.join.reverse`  


  [1]: /get/BlogPictures/strings-in-ruby/initializing-string.png
  [2]: /get/BlogPictures/strings-in-ruby/string-default-ctor.png
  [3]: /get/BlogPictures/strings-in-ruby/escape-with-backslash.png
  [4]: /get/BlogPictures/strings-in-ruby/custom-string-delimiter.png
  [5]: /get/BlogPictures/strings-in-ruby/wrap-with-quote.png
  [6]: /get/BlogPictures/strings-in-ruby/heredoc.png
  [7]: /get/BlogPictures/strings-in-ruby/multi-line-string.png
  [8]: /get/BlogPictures/strings-in-ruby/heredoc-delimiter.png
  [9]: /get/BlogPictures/strings-in-ruby/variable-interpolation.png
  [10]: /get/BlogPictures/strings-in-ruby/interpolation-expression.png
  [11]: /get/BlogPictures/strings-in-ruby/interpolation-math-expression.png
  [12]: http://msdn.microsoft.com/en-us/library/26etazsy.aspx
  [13]: http://msdn.microsoft.com/en-us/library/system.iformatprovider.aspx
  [14]: /get/BlogPictures/strings-in-ruby/no-interpolation-with-quote.png
  [15]: /get/BlogPictures/strings-in-ruby/interpolation-with-custom-delimiter.png
  [16]: /get/BlogPictures/strings-in-ruby/puts.png
  [17]: /get/BlogPictures/strings-in-ruby/char-indexer.png
  [18]: /get/BlogPictures/strings-in-ruby/substr-with-range.png
  [19]: /get/BlogPictures/strings-in-ruby/slice.png
  [20]: /get/BlogPictures/strings-in-ruby/methods-ending-w-exclamation.png
  [21]: /get/BlogPictures/strings-in-ruby/methods-ending-with-question.png