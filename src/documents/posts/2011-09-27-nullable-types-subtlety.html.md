--- cson
title: "Nullable Types' Subtlety"
metaTitle: "Nullable Types' Subtlety"
description: "In this post I explain a little subtlety with .Net Nullable Types that confuses some programmers"
revised: "2011-09-30"
date: "2011-09-27"
tags: [".net","quiz"]
migrated: "true"
urls: ["/nullable-types-subtlety"]
summary: """
In this post I explain a little subtlety with .Net Nullable Types that confuses some programmers
"""
---
I did a post called [.Net Nullable Types][1] on [GeekQuiz.Net][2] that I think is worth sharing here (in case you are not following me there). Also FunnelWeb has a nicer and more readable format. So here we go:

In the following code snippet the *nullable.HasValue* condition is not necessary. Why?

    public static int ToInt(this object value)
    {
        var result = int.MinValue;
     
        if (value is int?)
        {
            var nullable = ((int?)value);
            if (nullable.HasValue) 
                result = nullable.Value;
        }
     
        return result;
    }

Also how you would implement this method?

###The short answer###
According to [msdn][3] "*An 'is' expression evaluates to true if the provided expression is non-null*". So when the '*is*' condition is fulfilled the value is not null; i.e. nullable.HasValue is always true.

###The long answer###
To understand the the behavior of '*is*' operator I am going to need to dig rather deep. So bear with me:

Below is the IL code for *ToInt* (to get the IL code you may run ildasm from VS command prompt and open your executable there):

    .method public hidebysig static int32  ToInt(object 'value') cil managed
    {
      .custom instance void [System.Core]System.Runtime.CompilerServices.ExtensionAttribute::.ctor() = ( 01 00 00 00 )
      // Code size       60 (0x3c)
      .maxstack  2
      .locals init ([0] int32 result,
               [1] valuetype [mscorlib]System.Nullable`1<int32> nullable,
               [2] int32 CS$1$0000,
               [3] bool CS$4$0001)
      IL_0000:  nop
      IL_0001:  ldc.i4     0x80000000
      IL_0006:  stloc.0
      IL_0007:  ldarg.0
      IL_0008:  isinst     valuetype [mscorlib]System.Nullable`1<int32>
      IL_000d:  ldnull
      IL_000e:  cgt.un
      IL_0010:  ldc.i4.0
      IL_0011:  ceq
      IL_0013:  stloc.3
      IL_0014:  ldloc.3
      IL_0015:  brtrue.s   IL_0036
      IL_0017:  nop
      IL_0018:  ldarg.0
      IL_0019:  unbox.any  valuetype [mscorlib]System.Nullable`1<int32>
      IL_001e:  stloc.1
      IL_001f:  ldloca.s   nullable
      IL_0021:  call       instance bool valuetype [mscorlib]System.Nullable`1<int32>::get_HasValue()
      IL_0026:  ldc.i4.0
      IL_0027:  ceq
      IL_0029:  stloc.3
      IL_002a:  ldloc.3
      IL_002b:  brtrue.s   IL_0035
      IL_002d:  ldloca.s   nullable
      IL_002f:  call       instance !0 valuetype [mscorlib]System.Nullable`1<int32>::get_Value()
      IL_0034:  stloc.0
      IL_0035:  nop
      IL_0036:  ldloc.0
      IL_0037:  stloc.2
      IL_0038:  br.s       IL_003a
      IL_003a:  ldloc.2
      IL_003b:  ret
    }

The bit I am interested in is the '*is*' operator which translates to '*isinst*' in IL_0008:

    IL_0008:  isinst     valuetype [mscorlib]System.Nullable`1<int32>

Let's have a look at '*isinst*' from [CIL Instruction Set][4] document. The specification uses '*isinst typeTok*' as the format of the instruction and below is description from the spec (emphasis mine): 

"*typeTok is a metadata token (a typeref, typedef or typespec), indicating the desired class. If typeTok is a non-nullable value type or a generic parameter type it is interpreted as 'boxed' typeTok. **If typeTok is a nullable type, Nullable&lt;T&gt;, it is interpreted as 'boxed' T**.*"

The last bit is interesting; so the result of *isinst* depends on how boxing works for Nullable types. Well, let's have a look at boxing then. First a little bit of code to see how the *ToInt* method is typically called:

    int? input = 12;
    Console.WriteLine(input.ToInt());

You would typically have a nullable int that you pass to *ToInt* (you may also pass other types in; but that is not very important in our case). Let's have a look at the a bit of IL for the above snippet:

    .locals init ([0] valuetype [mscorlib]System.Nullable`1<int32> input)
    IL_0000:  nop
    IL_0001:  ldloca.s   input
    IL_0003:  ldc.i4.s   12
    IL_0005:  call       instance void valuetype [mscorlib]System.Nullable`1<int32>::.ctor(!0)
    IL_000a:  nop
    IL_000b:  ldloc.0
    IL_000c:  box        valuetype [mscorlib]System.Nullable`1<int32>
    IL_0011:  call       int32 NullableParameter.IntExtensions::ToInt(object)
    IL_0016:  pop

As expected, we are calling '*box*' IL instruction (at *IL_000c*) on the input variable. Let's have a look at '*box*' instruction from CIL specification. The format is '*box typeTok*' (emphasis mine): 

"*If typeTok is a value type, the box instruction converts val to its boxed form. When typeTok is a non-nullable type (§I.8.2.4), this is done by creating a new object and copying the data from val into the newly allocated object. **If it is a nullable type, this is done by inspecting val's HasValue property; if it is false, a null reference is pushed onto the stack; otherwise, the result of boxing val's Value property is pushed onto the stack***."

###Alternative implementations of ToInt method###
So for nullable types, after boxing, which is the case for object input parameter, we either get *null* or an *int* value! So we could actually write the *ToInt* method as:

    public static int ToInt2(this object value)
    {
        var result = int.MinValue;
     
        if (value is int)
            result = (int)value;
     
        return result;
    }

... and it would work perfectly with the code below:

    int? input = 12;
    Console.WriteLine(input.ToInt());
     
    Console.WriteLine("test".ToInt());
     
    input = null;
    Console.WriteLine(input.ToInt());

... but that could be a bit confusing because we are passing int? inside. The less confusing and more readable version is:

    public static int ToInt3(this object value)
    {
        var result = value as int?;
        return result ?? int.MinValue;
    }

If value is *int*, you will get the *int* value; otherwise you will get *int.MinValue*. 

That is it. And here is the complete code if you would like to give it a go. Please note that there are three versions of the method and only the first one is called from main:

    using System;
     
    namespace NullableParameter
    {
        class Program
        {
            static void Main(string[] args)
            {
                int? input = 12;
                Console.WriteLine(input.ToInt());
     
                Console.WriteLine("test".ToInt());
     
                input = null;
                Console.WriteLine(input.ToInt());
     
                Console.ReadLine();
            }
        }
     
        static class IntExtensions
        {
            public static int ToInt(this object value)
            {
                var result = int.MinValue;
     
                if (value is int?)
                {
                    var nullable = ((int?)value);
                    if (nullable.HasValue) 
                        result = nullable.Value;
                }
     
                return result;
            }
     
            public static int ToInt2(this object value)
            {
                var result = int.MinValue;
     
                if (value is int)
                    result = (int)value;
     
                return result;
            }
     
            public static int ToInt3(this object value)
            {
                var result = value as int?;
                return result ?? int.MinValue;
            }
        }
    }

If you liked this article there is a good chance you will like other articles/quizzes at [geekquiz.net][5]: another blog that I maintain in which I try to publish geeky quizzes for coding enthusiasts. 

Hope this helps.

<a href="http://www.codeproject.com/script/Articles/BlogFeedList.aspx?amid=khalili" style="display:none" rel="tag">CodeProject</a>


  [1]: http://geekquiz.net/net-nullable-types
  [2]: http://geekquiz.net/
  [3]: http://msdn.microsoft.com/en-us/library/scekt9xw(v=VS.100).aspx
  [4]: http://download.microsoft.com/download/d/c/1/dc1b219f-3b11-4a05-9da3-2d0f98b20917/Partition%20III%20CIL.doc125125
  [5]: http://geekquiz.net/