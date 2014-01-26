--- cson
title: "bddify is moved to GitHub and is renamed to BDDfy"
metaTitle: "bddify is moved to GitHub and is renamed to BDDfy"
description: "Good news for those who could not pronounce bddify. It has now been renamed to BDDfy and lives in GitHub :)"
revised: "2012-06-20"
date: "2012-06-03"
tags: ["BDDfy"]
migrated: "true"
resource: "/bddify-moved-to-github-and-renamed-to-teststack-bddfy"
summary: """
Ever since I created bddify one of the most frequent question I was asked was 'how is it pronounced?'! Good news... it has now been renamed to BDDfy - well BDDfy to be more precise
"""
---
I will just come out and say it: bddify was a confusing name. The reason I called the project bddify, as mentioned [in the introduction post][1], was to turn that action into a verb: the framework can BDD-fy your otherwise traditional tests. Well, that did not go down the way I expected and I have always been faced with a 'how do you pronounce it' question which has not been fun. The pronunciation issue along with a few other things led the bddify team, me and Michael Whelan, to rename the project and to move it to GitHub (yes, my previous post was about [migrating bddify from BitBucket to GitHub][2]). So bddify is now renamed to [BDDfy][3] and [lives in GitHub][4]. May that bring you a richer test suite and us a bigger community.

... but it is not just about avoiding the pronunciation confusion. It is bigger than that. **BDDfy** is now part of a bigger test suite called [TestStack][5]. That is the topic of another post though. For now, let's focus on BDDfy and how to migrate your code easily.

**Everything** in the framework has been renamed from bddify to BDDfy. That includes [nuget package][6], assembly name, APIs, namespaces, samples ETC. Since that was a (serious) breaking change we have also pushed the version up to V3.0!

###What does that mean for you?
You will need to uninstall bddify package and install BDDfy.

Well, before that I would highly recommend to upgrade to Bddify V2.11 if you have not done already as that had a few breaking changes from previous versions. Once that is done you can change to BDDfy with less hassle:

<code style="background-color: #202020;border: 4px solid silver;border-radius: 5px;-moz-border-radius: 5px;-webkit-border-radius: 5px;box-shadow: 2px 2px 3px #6e6e6e;color: #E2E2E2;display: block;font: 1.5em 'andale mono', 'lucida console', monospace;line-height: 1.5em;overflow: auto;padding: 15px;
">PM&gt; Uninstall-Package Bddify
</code>

<code style="background-color: #202020;border: 4px solid silver;border-radius: 5px;-moz-border-radius: 5px;-webkit-border-radius: 5px;box-shadow: 2px 2px 3px #6e6e6e;color: #E2E2E2;display: block;font: 1.5em 'andale mono', 'lucida console', monospace;line-height: 1.5em;overflow: auto;padding: 15px;
">PM&gt; Install-Package TestStack.BDDfy
</code>

After that your tests will not compile; but do not worry - it is VERY simple to fix:

**Replace All** (ctrl+shift+h) instances of .Bddify( with .BDDfy(

![replace .Bddify( with .BDDfy(][7]

As Michael mentioned in the comments, you would also have to replace <code>.Bddify<</code> with <code>.BDDfy<</code> if you are using the overload with TStory type argument.

Now **Replace All** (ctrl+shift+h) instances of <code>using Bddify</code> with <code>using TestStack.BDDfy</code>

![Fixing namespaces][8]

That should be it. I am thinking about pushing the existing users of <code>bddify</code> to <code>BDDfy</code> in a more seamless way perhaps using some PowerShell love - no promises there yet.

###What does that mean for us?
The new nuget package unfortunately means the loss of the download history. bddify has been downloaded around 2100 times since inception; but that number and more importantly the history of it cannot be ported AFAIK.

###What else is in BDDfy?
Although the rename and the move was a huge part V3.0 it is not just about that. We have also introduced some new features:

**Added support for filtering out html report based on the test result:**

Now in the html report you can filter based on the test result. That is very handy if you have got a big test suite and for example want to see only the broken or pending tests:

![Html report filtering][9]

**Added support for tabular reports:**

This is just the first cut; but BDDfy now supports Gherkin style tabular reports. So now, if you put line breaks in your step title it gets reported as tabular data. I have changed the TicTacToe sample to show this behavior. In the new sample the console report looks like:

![Tabular Console Report][10]

... and the html report:

![Tabular Html Report][11]

To see how you can achieve that you may have a look at TicTacToe sample now downloadable as [TestStack.BDDfy.Samples nuget package][12]:

<code style="background-color: #202020;border: 4px solid silver;border-radius: 5px;-moz-border-radius: 5px;-webkit-border-radius: 5px;box-shadow: 2px 2px 3px #6e6e6e;color: #E2E2E2;display: block;font: 1.5em 'andale mono', 'lucida console', monospace;line-height: 1.5em;overflow: auto;padding: 15px;
">PM&gt; Install-Package TestStack.BDDfy.Samples
</code>

For your convenience I am repeating a bit of code here:

    public class XWins : GameUnderTest
    {
        [RunStepWithArgs(
                new[] { X, X, O },
                new[] { X, X, O },
                new[] { O, O, N },
                StepTextTemplate = BoardStateTemplate)]
        void GivenTheFollowingBoard(string[] firstRow, string[] secondRow, string[] thirdRow)
        {
            Game = new Game(firstRow, secondRow, thirdRow);
        }

        void WhenXPlaysInTheBottomRight()
        {
            Game.PlayAt(2, 2);
        }

        void ThenTheWinnerShouldBeX()
        {
            Assert.AreEqual(X, Game.Winner);
        }
    }

where <code>GameUnderTest</code> is:

    public class GameUnderTest
    {
        protected const string BoardStateTemplate = "Given the board\r\n{0}\r\n{1}\r\n{2}";
    
        protected const string X = Game.X;
        protected const string O = Game.O;
        protected const string N = Game.N;
    
        protected Game Game { get; set; }
    }

As you can see the step title template has a line break per row which results to line breaks in the step title which in turns leads into tabular console and html reports.

<code>XWins</code> is written using Reflective API; but you can achieve the same result using Fluent API as long as you have line breaks in your step title.

This is just the very first cut of this feature and we are interested to hear your feedback on it.

##Conclusion
This was the second time and hopefully the last time <strike>bddify</strike> BDDfy moved home. I hope the users of this framework appreciate why we had to make this move and enjoy what BDDfy and TestStack will bring. That has been a big change but hopefully for the best.


  [1]: /bddify-in-action/introduction
  [2]: /migrating-from-mercurial-to-git
  [3]: http://teststack.github.com/TestStack.BDDfy/
  [4]: https://github.com/TestStack/TestStack.BDDfy
  [5]: https://github.com/TestStack/
  [6]: http://nuget.org/packages/TestStack.BDDfy
  [7]: /get/BlogPictures/bddify-to-BDDfy/api-rename.JPG
  [8]: /get/BlogPictures/bddify-to-BDDfy/namespace-fix.JPG
  [9]: /get/BlogPictures/bddify-to-BDDfy/html-report-filtering.JPG
  [10]: /get/BlogPictures/bddify-to-BDDfy/console-tabular-report.JPG
  [11]: /get/BlogPictures/bddify-to-BDDfy/html-tabular-report.JPG
  [12]: http://nuget.org/packages/TestStack.BDDfy.Samples