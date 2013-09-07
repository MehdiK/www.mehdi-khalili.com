express = require('express')
app = express()
fs = require('fs')

app.get('/routes.json', (req, res) -> res.status(403).send('403 Forbidden'))
app.use(express.static(__dirname + '/out'))
app.use('/get', express.static(__dirname + '/src/files/get'))

routes = require('./out/routes.json').routes

var redirector = (dest) -> (req, res) -> res.redirect(301, dest)

routes.map((route) -> 
    if route.redirects then route.redirects.map((redirect) -> app.get(redirect, redirector(route.url))
)

app.get(/^\/tagged\/(\w+)$/, (req, res) -> res.redirect(301, req.path + '.html')

app.get('/feed', (req, res) ->
    fs.readFile(__dirname + '/out/atom.xml', 'utf8', (err, data) ->
        res.set('Content-Type', 'application/xml')
        res.send(data)))

app.get('/feeds/rss', (req, res) ->
    fs.readFile(__dirname + '/out/atom.xml', 'utf8', (err, data) ->
        res.set('Content-Type', 'application/xml')
        res.send(data)))

app.listen(process.env.PORT || 3000)