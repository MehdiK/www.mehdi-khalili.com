--- cson
title: "Extracting input arguments from expressions"
metaTitle: "Extracting input arguments from expressions"
description: "For BDDfy's Fluent API I needed a way to be able to inspect a method call lambda expression and extract input parameters from it."
revised: "2012-10-06"
date: "2011-05-22"
tags: [".Net"]
migrated: "true"
resource: "/extracting-input-arguments-from-expressions"
summary: """
For BDDfy's Fluent API I needed a way to be able to inspect a method call lambda expression and extract input parameters from it and this is how I did it.

This post is quite technical and is mostly code; but I thought it is worth it because I was not able to find this elsewhere and thought this may be useful for others.
"""
---
Last week I found myself in a situation where I needed to extract input arguments from a lambda expression. I needed a simple method that would get a lambda expression as input and would return an array of objects representing the input arguments in return. 

For example given

    class SomeClass
    {
        public void MethodWithInputs(int input1, string input2)
        {
        }

        public void MethodWithArrayInputs(int[] input1, string[] input2)
        {
        }
    }

when I run

    ExtractConstants<SomeClass>(x => x.MethodWithInputs(1, "2"))

I want to get back

    new object[] {1, "2"}

or when I run

    ExtractConstants<SomeClass>(x => x.MethodWithArrayInputs(new[] {1, 2}, new[] {"3", "4"}))

I would receive an array equating:

    new object[] { new[] {1, 2}, new[] {"3", "4"} }

I also needed it to understand passed variables, fields, properties and so on. Below is a class I wrote that helped me with that: 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;

namespace TestStack.BDDfy.Scanners.StepScanners.Fluent
{
    public static class ExpressionExtensions
    {
        public static IEnumerable<object> ExtractConstants<T>(this Expression<Action<T>> expression)
        {
            var lambdaExpression = expression as LambdaExpression;
            if (lambdaExpression == null)
                throw new InvalidOperationException("Please provide a lambda expression.");

            var methodCallExpression = lambdaExpression.Body as MethodCallExpression;
            if(methodCallExpression == null)
                throw new InvalidOperationException("Please provide a *method call* lambda expression.");

            return ExtractConstants(methodCallExpression);
        }

        private static IEnumerable<object> ExtractConstants(Expression expression)
        {
            if (expression == null || expression is ParameterExpression)
                return new object[0];

            var memberExpression = expression as MemberExpression;
            if (memberExpression != null)
                return ExtractConstants(memberExpression);

            var constantExpression = expression as ConstantExpression;
            if (constantExpression != null)
                return ExtractConstants(constantExpression);

            var newArrayExpression = expression as NewArrayExpression;
            if (newArrayExpression != null)
                return ExtractConstants(newArrayExpression);

            var newExpression = expression as NewExpression;
            if (newExpression != null)
                return ExtractConstants(newExpression);

            var unaryExpression = expression as UnaryExpression;
            if (unaryExpression != null)
                return ExtractConstants(unaryExpression);

            return new object[0];
        }

        private static IEnumerable<object> ExtractConstants(MethodCallExpression methodCallExpression)
        {
            var constants = new List<object>();
            foreach (var arg in methodCallExpression.Arguments)
            {
                constants.AddRange(ExtractConstants(arg));
            }

            constants.AddRange(ExtractConstants(methodCallExpression.Object));

            return constants;
        }

        private static IEnumerable<object> ExtractConstants(UnaryExpression unaryExpression)
        {
            return ExtractConstants(unaryExpression.Operand);
        }

        private static IEnumerable<object> ExtractConstants(NewExpression newExpression)
        {
            var arguments = new List<object>();
            foreach (var argumentExpression in newExpression.Arguments)
            {
                arguments.AddRange(ExtractConstants(argumentExpression));
            }

            yield return newExpression.Constructor.Invoke(arguments.ToArray());
        }

        private static IEnumerable<object> ExtractConstants(NewArrayExpression newArrayExpression)
        {
            Type type = newArrayExpression.Type.GetElementType();
            if (type is IConvertible)
                return ExtractConvertibleTypeArrayConstants(newArrayExpression, type);
            
            return ExtractNonConvertibleArrayConstants(newArrayExpression, type);
        }

        private static IEnumerable<object> ExtractNonConvertibleArrayConstants(NewArrayExpression newArrayExpression, Type type)
        {
            var arrayElements = CreateList(type);
            foreach (var arrayElementExpression in newArrayExpression.Expressions)
            {
                object arrayElement;

                if (arrayElementExpression is ConstantExpression)
                    arrayElement = ((ConstantExpression)arrayElementExpression).Value;
                else
                    arrayElement = ExtractConstants(arrayElementExpression).ToArray();

                if (arrayElement is object[])
                {
                    foreach (var item in (object[])arrayElement)
                        arrayElements.Add(item);
                }
                else
                    arrayElements.Add(arrayElement);
            }

            return ToArray(arrayElements);
        }

        private static IEnumerable<object> ToArray(IList list)
        {
            var toArrayMethod = list.GetType().GetMethod("ToArray");
            yield return toArrayMethod.Invoke(list, new Type[] { });
        }

        private static IList CreateList(Type type)
        {
            return (IList)typeof(List<>).MakeGenericType(type).GetConstructor(new Type[0]).Invoke(BindingFlags.CreateInstance, null, null, null);
        }

        private static IEnumerable<object> ExtractConvertibleTypeArrayConstants(NewArrayExpression newArrayExpression, Type type)
        {
            var arrayElements = CreateList(type);
            foreach (var arrayElementExpression in newArrayExpression.Expressions)
            {
                var arrayElement = ((ConstantExpression)arrayElementExpression).Value;
                arrayElements.Add(Convert.ChangeType(arrayElement, arrayElementExpression.Type, null));
            }

            yield return ToArray(arrayElements);
        }

        private static IEnumerable<object> ExtractConstants(ConstantExpression constantExpression)
        {
            var constants = new List<object>();

            if (constantExpression.Value is Expression)
            {
                constants.AddRange(ExtractConstants((Expression)constantExpression.Value));
            }
            else
            {
                if (constantExpression.Type == typeof(string) ||
                    constantExpression.Type.IsPrimitive ||
                    constantExpression.Type.IsEnum ||
                    constantExpression.Value == null)
                    constants.Add(constantExpression.Value);
            }

            return constants;
        }

        private static IEnumerable<object> ExtractConstants(MemberExpression memberExpression)
        {
            var constants = new List<object>();
            var constExpression = (ConstantExpression)memberExpression.Expression;
            var valIsConstant = constExpression != null;
            Type declaringType = memberExpression.Member.DeclaringType;
            object declaringObject = memberExpression.Member.DeclaringType;

            if (valIsConstant)
            {
                declaringType = constExpression.Type;
                declaringObject = constExpression.Value;
            }

            var member = declaringType.GetMember(memberExpression.Member.Name, MemberTypes.Field | MemberTypes.Property, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Static).Single();

            if (member.MemberType == MemberTypes.Field)
                constants.Add(((FieldInfo)member).GetValue(declaringObject));
            else
                constants.Add(((PropertyInfo)member).GetGetMethod(true).Invoke(declaringObject, null));

            return constants;
        }
    }
}

There is too much to discuss in full details; but basically what I am doing here is 

 1. Turn the expression into <code>MethodCallExpression</code>
 2. Go through the expression and break it down into smaller expressions.
 3. For each expression find what the type of expression is and how the input parameter can be extracted.
 4. Then extract and return the parameter out.

This class should be able to extract any input argument including constants, static fields, properties, objects and so on. 

This is rather tricky and every now and then I find an edge case it does not support and as such is going under constant change. For example a while back I found out that if you pass a public static field as an input parameter it will not be found which took a bit of adjustment and fix.

You may find the latest code in [BDDfy][1] codebase [here][2].

Hope it helps.


  [1]: http://teststack.github.com/TestStack.BDDfy/
  [2]: https://github.com/TestStack/TestStack.BDDfy/blob/master/TestStack.BDDfy/Scanners/StepScanners/Fluent/ExpressionExtensions.cs