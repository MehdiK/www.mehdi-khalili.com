--- cson
title: "Definition of Done in an MVC project"
metaTitle: "Definition of Done in an MVC project"
description: "Definition of Done in an ASP.Net MVC project I just joined "
revised: "2011-10-31"
date: "2011-10-31"
tags: ["agile","scrum"]
migrated: "true"
urls: ["/definition-of-done-in-an-mvc-project"]
summary: """

"""
---
So I just joined a team to create a website using ASP.Net MVC and we are using Scrum. 

Here is a DoD I suggested based on my own experience, a good discussion I had on Readify's internal forum and Paul Stovell's [Done Criteria][1]:

 - Source code meets our coding standards.
 - High enough level of unit test coverage for routes, action methods and controllers.
 - High enough level of unit test coverage for business logic and repositories.
 - High enough level of automated UI and integration test coverage.
 - Code has been peer reviewed.
 - Code must be completely checked in to the source control system and the build and all the automated tests should be green.
 - UI looks nice and works on different resolutions on major browsers and browser editions.
 - UI fulfils the accessibility requirements.
 - UI works with and without javascript enabled.
 - End user help/documentation/tooltips are done
 - Any auditing/tracing code is added and the output is useful and readable
 - Security permission checks have been implemented and validated via automated tests
 - Automated database migration scripts are provided and tested
 - Sample data needed to test the feature is scripted, if required.
 - Users have tested the feature and are happy with it.

You may think that this is too extensive and may be a bit of overkill. One may say that DoD should be very simple - perhaps something like 'The story should be potentially shippable' or 'It is done if it meets the requirements and the user is happy with it' and that is kind of correct. After all, we are there to provide value to the business and nothing else should matter; however, I think you need to be more specific than that to provide long term value. A nice UI for a working application that meets the requirements makes the PO and users happy; but there is a good chance they do not see/test: 

 - the inner quality of the system; e.g. maintainability and readability
 - cross browser compatibility
 - website working with and without javascript.
 - ease of deployment including scripted database migration and so on
 - accessibility requirements 

... and so on and so forth. Sure, a very well versed tester could cover you in a lot of those cases; but some teams do not have support of a good QA team. Even if you are one of the luckier teams, it is still a good idea to cater for these during development instead of completely relying on the skills and excellence of your QA team. Also when you have testers as part of your team it is usually their responsibility to say whether a story is done or not. Having this done criteria then provides them with a checklist that they can use along with their acceptance criteria.  This way when they say it is 'Done' it is 'Done Done' :) 

Note that like anything else in Agile this is not set in stone. Do not try to come up with an ideal and perfect definition: come up with a definition that initially everyone is happy with and that matches your requirements and do a sprint or two with it. You can always add/remove items to/from the list or refine the items: that is what the inspection and adaptation in Agile is for.


  [1]: http://www.paulstovell.com/done-criteria