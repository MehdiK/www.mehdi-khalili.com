var express = require('express');
var app = express();
var fs = require('fs');

// redirect away from herokuapp
app.get('*', function(req, res, next) {
  if (req.headers.host.indexOf('mehdi-khalili.herokuapp.com') != -1) {
    res.redirect('http://www.mehdi-khalili.com' + req.url, 301);
  } else {
    next();
  }
});

// gzip
app.use(express.compress());

// caching static content
app.use(function (req, res, next) {
  if (req.url.match('/js') || req.url.match('/css') || req.url.match('/get') ) {
    res.setHeader('Cache-Control', "max-age=604800");
  }
  next()
});

// static resources
app.use('/get', express.static(__dirname + '/out/get'));
app.use('/js', express.static(__dirname + '/out/js'));
app.use('/css', express.static(__dirname + '/out/css'));

// Html files to urls
app.get('/routes.json', function (req, res) {
    res.status(403).send('403 Forbidden');
})

var routes = require('./out/routes.json').routes;
routes.map(function (route) { 
	app.get(route.url, function(req, res) { 
		res.sendfile(__dirname + '/out' + route.file); 
  }); 

  app.get(route.file, function(req, res) {
    res.redirect(301, route.url);  
  });
});

app.get(/^\/tagged\/(\w+)$/, function (req, res) {
    res.sendfile(__dirname + '/out' + req.path + '.html');
});

// Feed
var feed = function(req, res) {
  fs.readFile(__dirname + '/out/feed.xml', 'utf8', function (err, data) {
      res.set('Content-Type', 'application/xml');
      res.send(data);
  })
};

app.get('/feed', feed);
app.get('/feeds/rss', feed);

// Error Handling
app.use(function (err, req, res, next) {
  console.log('errored');
  res.status(404).sendfile('/out/404.html');
});

app.listen(process.env.PORT || 3000);