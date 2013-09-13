--- cson
title: "FunnelWeb on RavenDB"
metaTitle: "FunnelWeb on RavenDB"
description: "FunnelWeb on RavenDB is a port of FunnelWeb blog engine to work with RavenDB"
revised: "2011-09-29"
date: "2011-01-28"
tags: ["funnelweb","ravendb","oss"]
migrated: "true"
resource: "/funnelweb-on-ravendb"
summary: """
FunnelWeb is a great blog engine written with asp.net mvc and FunnelWeb on RavenDB is a port of FunnelWeb data access/store to RavenDB as an attempt for me to learn about RavenDB.
"""
---
###What is FunnelWeb?
[FunnelWeb][1] is a blog engine written using ASP.Net MVC3. I went through the source code and I quite liked it. So [I used it for my blog][2]. FunnelWeb uses nHibernate for data access over MSSQL.

###So what is FunnelWeb on RavenDB?
Ever since I heard about [RavenDB][3] (RDB) I was very interested to give it a go and learn about it. So I started reading about it; but reading alone was not enough to learn about database engine; I had to do something with it. I needed a project big enough to guarantee some exposure to the engine yet not too big to take a lot of time. [FunnelWeb on RavenDB][4] was my attempt to learn RDB. 

I tried to change as little as possible on the FunnelWeb itself; so what you see there is still more than %90 FunnelWeb. The reason I did not change FunnelWeb much was that I was hoping to keep the two versions compatible so that FunnelWeb on RavenDB can live next to FunnelWeb with little to no maintenance load. That attempt failed (more on this later), and I soon changed my goal and worked on the project only as a learning experience and nothing more.

####Is it working? 
I have tried the engine on my local machine and it works; but I must admit it is not production quality. After all, it was just for learning. 

You can access the code [here][5]. You can see that I have not merged from trunk for over a month.

###Some of the main changes
I removed everything NH related including NH mappings. All the references to NH, Castle proxy, Antlr, Iesi collection and so on and so forth are gone. 

I also removed quite a few classes from DatabaseDeployer project of FunnelWeb because I no longer needed to deal with SQL scripts. I then removed the project and moved the remaining classes to where they belonged: the website project. 

Well, I still needed to populate some default data; so I replaced the SQL scripts with the following class:

    public class InitialSetupScript : IScript
    {
        private readonly IDocumentSession _session;

        public InitialSetupScript(IDocumentSession session)
        {
            _session = session;
        }

        public string Name
        {
            get { return "The initial setup: adding settings and default feed"; }
        }

        public ScriptVersion Version
        {
            get { return ScriptVersion.InitialSetup; }
        }

        public void UpdateStore()
        {
            AddDefaultFeed();
            AddSettings();
        }

        private void AddDefaultFeed()
        {
            _session.Store(new Feed { Name = "default", Title = "Blog Feed" });
        }

        private void AddSettings()
        {
            AddDefaultPageSetting();
            AddFooterSetting();
            AddSpamBlacklistSetting();
            AddTitleSetting();
            AddIntroductionSetting();
            AddMainLinksSetting();
            AddAuthorSetting();
            AddKeywordsSetting();
            AddDescriptionSetting();
            AddThemeSetting();
        }

       //  the rest of the class removed for the sake of brevity

        private void AddThemeSetting()
        {
            _session.Store(
                new Setting
                    {
                        Name = "ui-theme",
                        DisplayName = "Theme",
                        Value = "Default",
                        Description = "Theme being used by the blog at the moment"
                    });
        }
    }

It still kind of works like FunnelWeb database deployer. You can implement IScript and version your scripts and the deployer will take care of the rest.

###The good
####The beauty of indexes
A few lines of code worth a thousand words!! FunnelWeb supports fulltext searching. Here is a bit of code from FunnelWeb:

        public IEnumerable<Entry> Search(string searchText)
        {
            if (string.IsNullOrEmpty(searchText) || searchText.Trim().Length == 0)
            {
                return new Entry[0];
            }

            var isFullTextEnabled = session.CreateSQLQuery("SELECT FullTextServiceProperty('IsFullTextInstalled')").List()[0];
            return (int) isFullTextEnabled == 0 
                ? SearchUsingLike(searchText) 
                : SearchUsingFullText(searchText);
        }

        private IEnumerable<Entry> SearchUsingFullText(string searchText)
        {
            var searchTerms = searchText.Split(' ', '-', '_').Where(x => !string.IsNullOrEmpty(x)).Select(x => "\"" + x + "*\"");
            var searchQuery = string.Join(" OR ", searchTerms.ToArray());
            var query = session.CreateSQLQuery(
                @"select {e.*} from [Entry] {e}
                    inner join (
                        select z.*, [Rank] from [Entry] z
                            inner join [Revision] rv on z.Id = rv.EntryId
                            inner join CONTAINSTABLE([Revision], *, :searchString) as searchTable1 on searchTable1.[Key] = rv.Id
                        union all 
                        select z.*, [Rank] from [Entry] z
                            inner join CONTAINSTABLE([Entry], *, :searchString) as searchTable2 on searchTable2.[Key] = z.Id
                    ) as Entries on Entries.Id = e.Id
                    order by [Rank] desc",
                "e",
                typeof(Entry))
                .SetMaxResults(300)
                .SetString("searchString", searchQuery)
                .SetReadOnly(true)
                .List()
                .OfType<Entry>().Distinct().Take(15).ToList();
            return query;
        }

        public IEnumerable<Entry> SearchUsingLike(string searchText)
        {
            var searchTerms = "%" + new string(searchText.Where(x => char.IsLetterOrDigit(x) || x == ' ').ToArray()) + "%";
            searchTerms.Replace(" ", "%");

            var entryQuery = (ArrayList)session.CreateCriteria<Entry>("entry")
                .CreateCriteria("entry.Revisions", "rev")
                .Add(Restrictions.EqProperty("rev.Id", Projections.SubQuery(
                    DetachedCriteria.For<Revision>("rv")
                        .SetProjection(Projections.Property("rv.Id"))
                        .AddOrder(Order.Desc("rv.Revised"))
                        .Add(Restrictions.EqProperty("rv.Entry.Id", "entry.Id"))
                        .SetMaxResults(1))))
                .Add(new OrExpression(
                    Restrictions.Like("entry.Title", searchTerms),
                    Restrictions.Like("rev.Body", searchTerms)
                    ))
                .SetFirstResult(0)
                .SetMaxResults(15)
                .SetResultTransformer(Transformers.AliasToEntityMap)
                .List();

            var results = new List<Entry>();
            foreach (var record in entryQuery.Cast<Hashtable>())
            {
                var entry = (Entry)record["entry"];
                var revision = (Revision)record["rev"];
                entry.LatestRevision = revision;
                results.Add(entry);
            }

            return results;
        }

which was replaced by 

        public IEnumerable<Entry> Search(string searchText)
        {
            if (string.IsNullOrEmpty(searchText) || searchText.Trim().Length == 0)
            {
                return new Entry[0];
            }

            return SearchUsingFullText(searchText);
        }

        private IEnumerable<Entry> SearchUsingFullText(string searchText)
        {
            var searchTerms = searchText.Split(' ', '-', '_').Where(x => !string.IsNullOrEmpty(x)).Select(x => "*" + x + "*");
            var searchQuery = string.Join(" OR ", searchTerms.ToArray());
            return _session
                .Advanced
                .LuceneQuery<Entry, Entry_ForFullTextSearch>()
                .Where("AllText:" + searchQuery);
        }

Well in all fairness, I also had to implement the index:

    public class Entry_ForFullTextSearch : AbstractIndexCreationTask<Entry>
    {
        public Entry_ForFullTextSearch()
        {
            Map = entries => from entry in entries
                             from revision in entry.Revisions
                             select new
                                        {
                                            AllText = 
                                                entry.MetaDescription + " " + 
                                                entry.MetaKeywords + " " + 
                                                entry.MetaTitle + " " + 
                                                entry.Name + " " +
                                                entry.Summary + " " + 
                                                entry.Title + " " +
                                                revision.Body
                                        };
        }
    }


####Easy data handling
I must admit it is kind of hard to compare the two due to difference in the models; but the fact is that using RDB I am achieving the same result with a much shorter and readable method. As an example, GetEntry in FunnelWeb:

        public Entry GetEntry(PageName name)
        {
            var entryQuery = (Hashtable)session.CreateCriteria<Entry>("entry")
                .Add(Restrictions.Eq("entry.Name", name))
                .CreateCriteria("Revisions", "rev")
                    .AddOrder(Order.Desc("rev.Revised"))
                .SetMaxResults(1)
                .SetResultTransformer(Transformers.AliasToEntityMap)
                .UniqueResult();

            if (entryQuery == null) return null;

            var entry = (Entry)entryQuery["entry"];
            entry.LatestRevision = (Revision)entryQuery["rev"];

            var comments = session.CreateFilter(entry.Comments, "")
                .SetFirstResult(0)
                .SetMaxResults(500)
                .List();
            entry.Comments = new HashedSet<Comment>(comments.Cast<Comment>().ToList());

            return entry;
        }

was replaced with:

        public Entry GetEntry(PageName name)
        {
            return _session.Query<Entry>().FirstOrDefault(e => e.Name == name);
        }

I am not getting the comments though as it is not part of my document. More on this below.

###The bad
RDB makes some assumptions about the objects it persists (by which I am a bit annoyed, and I hope that either I am wrong or it changes). One of the main changes I had to make on the PM was that ids had to changes from int (to support auto number in SQL) into string (to support auto string id in RDB). In addition to that, only the root class should have id. The other entities in the graph are stored and fetched as part of the graph. This meant that I had to make quite a few changes only to comply with RDB. I had to change PM because the whole persistence mechanism had changed and even repositories could not shield me from [the law of leaky abstractions][6]. 

Class dependencies had to change too. Key/value stores in general (and document databases in particular) store each object graph as one entry. This effectively means you cannot have very deep object graphs. [Your object graph also cannot include a lot of interrelated objects][7] or you will end up saving your entire model into one huge document. The rule of thumb is that you should have an object graph/document per aggregate, and there should not be any direct reference between aggregates (even to the aggregates roots). So the object model had to change to instead of having direct links to other entities have their ids. I had to do this only in one place (because in a blog engine everything is about blog entry):

    public class Comment
    {
        public Comment()
        {
            Id = "Comments/";
        }

        public string Id { get; set; }

        [DataType("Markdown")]
        public virtual string Body { get; set; }
        public string AuthorName { get; set; }
        public string AuthorCompany { get; set; }
        public string AuthorUrl { get; set; }
        public string AuthorEmail { get; set; }
        public DateTime Posted { get; set; }
        public int Status { get; set; }

        public virtual bool IsSpam
        {
            get { return Status == 0; }
            set { Status = value ? 0 : 1; }
        }

        public string EntryName { get; set; }
        public string EntryId { get; set; }
        public string EntryTitle { get; set; }
    }

Did you notice the three properties at the bottom? 

I had to make comment a different document because FunnelWeb deals with them as separate entities (from the admin section). I tried to store them as part of Entry graph; but [I had some technical issues][8]. It was still possible with a small hack (as mentioned in my response in the google group discussion); but I think this solution is ok.

So basically if you want to migrate an existing application written with relational mindset to RDB or any other document database you are in a rather big trouble. [From RDB documentation][9]:

"*The most typical error people make when trying to design the data model on top of a document database is to try to model it the same way you would on top of a relational database.
Raven is a non-relational data store. Trying to hammer a relational model on top of it will produce sub-optimal results. But you can get fantastic results by taking advantage of the documented oriented nature of Raven.*"

###Conclusion
This was a little playground for me to learn about RDB. There are some little samples here and there on the web, but I did not find any real example, and I hope this application helps someone get started with RDB.

You can checkout complete code from the project's homepage at google code [here][10].

Hope this helps.


  [1]: http://code.google.com/p/funnelweb/
  [2]: /installing-funnelweb
  [3]: http://ravendb.net/
  [4]: http://code.google.com/r/armkhalili-funnelweb-on-ravendb/
  [5]: http://code.google.com/r/armkhalili-funnelweb-on-ravendb/
  [6]: http://www.joelonsoftware.com/articles/LeakyAbstractions.html
  [7]: http://ravendb.net/faq/denormalized-references
  [8]: http://groups.google.com/group/ravendb/browse_thread/thread/7a68f2922d37b451
  [9]: http://ravendb.net/documentation/docs-document-design
  [10]: http://code.google.com/r/armkhalili-funnelweb-on-ravendb/source/checkout