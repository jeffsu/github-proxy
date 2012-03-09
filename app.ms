
/**
 * Module dependencies.
 */


var express = require('express')
  , routes = require('./routes');

var app = module.exports = express.createServer();
var data = require('./data');
var config = require('./config')[0];

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

app.get('/:u/:r/milestones', #(req, res) { 
  var u = req.params.u;
  var r = req.params.r;

  data.getMilestones(u, r, #(milestones) {
    res.render('milestones', { milestones: milestones, u: u, r: r });
  }); 
});

app.get('/:u/:r/labels/:label', #(req, res) { 
  var u = req.params.u;
  var r = req.params.r;

  data.getTickets(u, r, req.params.label, #(tickets) {
    res.render('label', { tickets: tickets, u: u, r: r }) 
  });
});

app.get('/:u/:r/labels', #(req, res) { 
  var u = req.params.u;
  var r = req.params.r;

  data.getLabels(u, r, #(labels) {
    res.render('labels', { labels: labels, u: u, r: r }) 
  });
});

if (config.reports) {
  for (var name in config.reports) {
    var report = config.reports[name];
    app.get('/reports/' + name, #(req, res) {
      data.getIssues(report.paths, #(issues) {
        res.render('report' , { groups: order(report, issues), labelGroup: report.labelGroup });
      }); 
    });
  }
}

function order(config, issues) {
  return groupByLabels(config, issues);
}

function groupByLabels(config, issues) {
  if (! config.labelGroup) return [ sortBy(config, issues) ];

  var groups = [];
  var labels = config.labelGroup;
  foreach (var label in labels) {
    var group = [];

    foreach (var issue:i in issues) {
      if (!issue) continue;
      if (issue.labelHash[label]) {
        group.push(issue);
        issues[i] = null;
      }
    }
    groups.push(sortBy(config, group));
  }

  var rest = [];
  foreach (var issue in issues) {
    if (issue) rest.push(issue);
  }

  if (rest.length) groups.push(sortBy(rest));
  return groups;
}

function sortBy(config, issues) {
  return issues;
  if (!config.sortBy) return issues;
  if (config.order == 'desc') {
    return issues#sort { $2.config > $1.map };
  } else {
    return issues#sort { $2.config > $1.map };
  }
}


app.listen(3000);
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
