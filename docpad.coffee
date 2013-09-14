# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
marked = require('marked')
moment = require('moment')
path = require('path')

docpadConfig = 
  templateData: 
    site: 
      title: 'Mehdi Khalili'
      subtitle: 'My musings around software programming and architecture'
      author: 'Mehdi Khalili'
      email: 'me@mehdi-khalili.com'
      github: 'MehdiK'
      twitter: 'MehdiKhalili'
      description: '.net, C#, asp.net, ruby, javascript'
      url: 'http://www.mehdi-khalili.com'
    
    contentTrim: (str) -> if str.length > 200 then str.slice(0, 197) + '...' else str
    
    resourcePath: (url) -> @site.url + url;

    relatedPosts: (post) -> 
      return [] if !post.tags

      posts = @getCollection('posts').findAll({ url: {'$ne': post.url}}, [{ date: -1 }]).toJSON()

      posts
        .map((p) -> 
          matches = post.tags
          .map((tag) -> if p.tags and p.tags.indexOf(tag) >= 0 then 1 else 0)
          .reduce((x, y) -> x + y)

          post: p
          matches: matches)
        .filter((x) -> x.matches > 0)
        .sort((x, y) -> 
          if x.matches < y.matches then return -1 
          else if x.matches > y.matches then return 1

          if x.post.date < y.post.date then return 1 
          else if x.post.date > y.post.date then return -1 

          return 0)
        .map((x) -> x.post)

    parseMarkdown: (str) -> marked(str)

    formatDate: (date) -> moment(date).format('Do MMMM YYYY')

    generateSummary: (post) -> 
      description = post.description
      if description then @parseMarkdown(description) else @contentTrim(@parseMarkdown(post.content))
    
  collections: 
    posts: () -> 
      @getCollection('html')
      .findAllLive({ relativeOutDirPath: 'posts' }, [{ date: -1 }])
      .on('add', (model) -> model.setMetaDefaults({ layout: 'post' }))

  events: 
    serverExtend: (opts) -> 
      docpadServer = opts.server

      docpadServer.use((req, res, next) ->
        if req.headers.host == 'mehdi-khalili.com' 
          return res.redirect(301, 'http://www.mehdi-khalili.com' + req.url)

        next()
      )
      
  plugins: 
    tagging: 
      indexPagePath: 'tagged'
    ghpages:
      deployBranch: 'master'
      deployRemote: 'upstream'
    rss:
      collection: 'posts'
      url: '/feed.xml' 
# Export the DocPad Configuration
module.exports = docpadConfig