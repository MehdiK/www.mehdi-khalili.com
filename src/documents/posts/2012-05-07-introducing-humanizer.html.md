--- cson
title: "Introducing Humanizer"
metaTitle: "Introducing Humanizer"
description: "Introducing Humanizer - A micro-framework that turns your normal strings, type names, enum fields, date fields ETC into a human friendly format"
revised: "2012-05-08"
date: "2012-05-07"
tags: ["oss","humanizer"]
migrated: "true"
resource: "/introducing-humanizer"
summary: """
Introducing Humanizer - A micro-framework that turns your normal strings, type names, enum fields, date fields ETC into a human friendly format
"""
---
I have been carrying a few hundred lines of code with me from project to project to help me make my applications more human friendly. So finally I decided to turn this into a framework - I called it Humanizer! You can find the code [here][1] on GitHub and can download [the library through NuGet][2]:

<code style="background-color: #202020;border: 4px solid silver;border-radius: 5px;-moz-border-radius: 5px;-webkit-border-radius: 5px;box-shadow: 2px 2px 3px #6e6e6e;color: #E2E2E2;display: block;font: 1.5em 'andale mono', 'lucida console', monospace;line-height: 1.5em;overflow: auto;padding: 15px;
">PM&gt; Install-Package Humanizer
</code>

Humanizer is basically a set of extension methods, currently available on <code>String</code>, <code>Enum</code> and <code>DateTime</code>. Over time, I will try to make this a one-stop shop for user-friendly developers!!

Instead of trying to explain this I will just provide some samples (out of the test suite):

###String Extensions###
String extensions are at the heart of this micro-framework. The foundation of this was set in the [bddify framework][3] where class names, method names and properties are turned into human readable sentences. 

    "PascalCaseInputStringIsTurnedIntoSentence".Humanize() => "Pascal case input string is turned into sentence"
    
    "Underscored_input_string_is_turned_into_sentence".Humanize() => "Underscored input string is turned into sentence"
    
    "Underscored_input_String_is_turned_INTO_sentence".Humanize() => "Underscored input String is turned INTO sentence"
    
    "HTML".Humanize() => "HTML" // acronyms are left intact

You may also specify the desired letter casing:

    "CanReturnTitleCase".Humanize(LetterCasing.Title) => "Can Return Title Case"
    
    "Can_return_title_Case".Humanize(LetterCasing.Title) => "Can Return Title Case"
    
    "CanReturnLowerCase".Humanize(LetterCasing.LowerCase) => "can return lower case"
    
    "CanHumanizeIntoUpperCase".Humanize(LetterCasing.AllCaps) => "CAN HUMANIZE INTO UPPER CASE"

###Enum Extensions###
Calling <code>ToString</code> directly on enum members usually results in less than ideal output for users. The solution to this is usually to use <code>DescriptionAttribute</code> data annotation and then read that at runtime to get a more friendly output. That is a great solution; but more often than not we only need to put some space between words of an enum member - which is what <code>String.Humanize()</code> does well. For an enum like:

    public enum EnumUnderTest
    {
        [Description("Custom description")]
        MemberWithDescriptionAttribute,
        MemberWithoutDescriptionAttribute,
        ALLCAPITALS
    }

You will get:

    EnumUnderTest.MemberWithDescriptionAttribute.Humanize() => "Custom description"; // DescriptionAttribute is honored
    
    EnumUnderTest.MemberWithoutDescriptionAttribute.Humanize() => "Member without description attribute"; // in the absence of Description attribute string.Humanizer kicks in
    
    EnumUnderTest.MemberWithoutDescriptionAttribute.Humanize(LetterCasing.Title) => "Member Without Description Attribute"; // an of course you can still apply letter casing 

Hopefully this will help avoid enums littered with unnecessary attributes!

###Date Extensions###
The <code>DateTime</code> extension methods were not part of what I had initially envisaged for this project; but while I was "humanizitationing" .Net types I thought it would be a shame to not have <code>DateTime</code> in there. 

Well, I did not write much of this code myself and do not want to take any credit for it. This is a copy of [StackOverFlow algorithm][4] - although I had to apply some minor fixes on top of it. I am not going to bore you with all the examples as I am sure you know what this does: you basically give it an instance of <code>DateTime</code> and get back a string telling how far back in time that is:

    DateTime.UtcNow.AddHours(-30).Humanize() => "yesterday"

##What else?##
This is just a baseline and you can use this to simplify your day to day job. For example, in Asp.Net MVC we keep chucking <code>Display</code> attribute on ViewModel properties so <code>HtmlHelper</code> can generate correct labels for us; but, just like enums, in vast majority of cases we just need a space between the words in property name - so why not use string.Humanizer for that?! 

You may find an Asp.Net MVC sample [in the code][5] that does that (although the project is excluded from the solution file to make the nuget package available for .Net 3.5 too). 

This is achieved using a custom <code>DataAnnotationsModelMetadataProvider</code> I called <code>[HumanizerMetadataProvider][6]</code>. It is small enough to repeat here; so here we go:

    public class HumanizerMetadataProvider : DataAnnotationsModelMetadataProvider
    {
        protected override ModelMetadata CreateMetadata(
            IEnumerable<Attribute> attributes,
            Type containerType,
            Func<object> modelAccessor,
            Type modelType,
            string propertyName)
        {
            var propertyAttributes = attributes.ToList();
            var modelMetadata = base.CreateMetadata(propertyAttributes, containerType, modelAccessor, modelType, propertyName);
    
            if (IsTransformRequired(modelMetadata, propertyAttributes))
                modelMetadata.DisplayName = modelMetadata.PropertyName.Humanize();
    
            return modelMetadata;
        }
    
        private static bool IsTransformRequired(ModelMetadata modelMetadata, IList<Attribute> propertyAttributes)
        {
            if (string.IsNullOrEmpty(modelMetadata.PropertyName))
                return false;
    
            if (propertyAttributes.OfType<DisplayNameAttribute>().Any())
                return false;
    
            if (propertyAttributes.OfType<DisplayAttribute>().Any())
                return false;
    
            return true;
        }
    }

This class calls the base class to extract the metadata and then, if required, humanizes the property name. It is checking if the property already has a <code>DisplayName</code> or <code>Display</code> attribute on it in which case the metadata provider will just honor the attribute and leave the property alone. For other properties it will Humanize the property name. That is all.

Now I need to register this metadata provider with Asp.Net MVC:

    ModelMetadataProviders.Current = new HumanizerMetadataProvider();

... and now I can replace:

    public class RegisterModel
    {
        [Display(Name = "User name")]
        public string UserName { get; set; }
    
        [Display(Name = "Email address")]
        public string EmailAddress { get; set; }
    
        [Display(Name = "Confirm password")]
        public string ConfirmPassword { get; set; }
    }

with:

    public class RegisterModel
    {
        public string UserName { get; set; }
        public string EmailAddress { get; set; }
        public string ConfirmPassword { get; set; }
    }

... and the "metadata humanizer" will take care of the rest.

No need to mention that if you want title casing for your labels you may call the other overload of <code>Humanize</code> method:

    modelMetadata.DisplayName = modelMetadata.PropertyName.Humanize(LetterCasing.Title));

##Conclusion
Humanizer is a collection of methods that help you turn your .Net stuff into human readable sentences.

This package is just in V0.2 and I am going to keep adding to it things that will make this type of transformation easier. If you have an idea, a bit of code, any feedback or comment please shout out.

Hope it helps.


  [1]: https://github.com/MehdiK/Humanizer
  [2]: https://nuget.org/packages/Humanizer
  [3]: /bddify-in-action/introduction
  [4]: http://stackoverflow.com/a/12/141101
  [5]: https://github.com/MehdiK/Humanizer
  [6]: https://github.com/MehdiK/Humanizer/blob/master/src/Humanizer.MvcSample/HumanizerMetadataProvider.cs



