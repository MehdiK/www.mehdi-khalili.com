--- cson
title: "Humanizer is now a Portable Class Library"
metaTitle: "Humanizer is now a Portable Class Library"
description: "Humanizer is now a Portable Class Library with support for .Net 4 and higher versions, SilverLight 5, Windows Phone 8 and Win Store applications"
revised: "2014-01-01"
date: "2014-01-01"
tags: ["Humanizer"]

---
[Humanizer V1](/humanizer-v1) only worked with .Net 4 and higher versions. Soon after the release I got a request to turn it to a [Portable Class Library](http://msdn.microsoft.com/en-us/library/gg597391.aspx). 

[Robert McLaws](https://twitter.com/robertmclaws) kindly sent me [a pull request](https://github.com/MehdiK/Humanizer/pull/28) that changed the project to Portable Class Library. We still had a few issues like the missing `DescriptionAttribute` on PCL that I [coded around using reflection](https://github.com/MehdiK/Humanizer/blob/master/src/Humanizer/EnumHumanizeExtensions.cs#L33) and missing `CultureInfo.CurrentCulture.TextInfo.ToTitleCase(input)` that had to be [implemented from scratch](https://github.com/MehdiK/Humanizer/blob/master/src/Humanizer/Transformer/ToTitleCase.cs); but no major dramas.

As part of this conversion I also changed the build process from the old MSBuild script to a clean [CI build on TeamCity](/continuous-integration-delivery-github-teamcity) with support for automatic build and test run for checkins and pull request notification. 

In the new version:

 - Humanizer is a Portable Class Library with support for .Net 4+, SilverLight 5, Windows Phone 8 and Win Store applications. 
 - The [Humanizer symbols nuget package](http://www.symbolsource.org/Public/Metadata/NuGet/Project/Humanizer) is published so you can [step through Humanizer code](http://www.symbolsource.org/Public/Home/VisualStudio) while debugging your code.
 - There are a few improvements like the new `ToQuantity` method and smarter `Singularize` and `Pluralize` methods. More info can be found [here](https://github.com/MehdiK/Humanizer#inflector-methods). Thanks [Rob Moore](http://robdmoore.id.au/) for the help.
 
Happy New Year and happy humanizing!

