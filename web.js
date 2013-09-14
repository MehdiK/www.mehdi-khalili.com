var express = require('express');
var app = express();
var fs = require('fs');

// catch all
app.use(express.static(__dirname + '/out'));

// Html files to urls
app.get('/routes.json', function (req, res) {
    res.status(403).send('403 Forbidden');
})

var routes = require('./out/routes.json').routes;
routes.map(function (route) { 
	app.get(route.url, function(req, res) { 
		res.sendfile(__dirname + '/out' + route.file); }); 
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