
/**
 * Module dependencies.
 */


var express = require('express')
  , routes = require('./routes');

var app = module.exports = express.createServer();
var data = require('./data');
var config = require('./config')[0];
var u = config.user;
var r = config.repo;

// Configuration
app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));

app.get('/milestones', #(req, res) { 
  data.getMilestones(#(milestones) {
    res.render('milestones', { milestones: milestones, u: u, r: r });
  }); 
});

app.get('/labels/:label', #(req, res) { 
  data.getTickets(req.params.label, #(tickets) {
    res.render('label', { tickets: tickets, u: u, r: r }) 
  });
});

app.get('/', #{ $2.render('index'); });

app.get('/labels', #(req, res) { 
  data.getLabels(#(labels) {
    res.render('labels', { labels: labels, u: u, r: r }) 
  });
});



app.listen(3000);
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
