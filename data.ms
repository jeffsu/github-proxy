var request = require('request');

var config = require('./config')[0];

var USERNAME = config.account.username;
var PASSWORD = config.account.password;

var auth = 'Basic ' + new Buffer(USERNAME + ':' + PASSWORD).toString('base64');
var headers = { Authorization: auth };

function url(u, r, tail) {
  return "https://api.github.com/repos/" + u + "/" + r + "/" + tail;
}

function req(u, cb) {
  request({ url: u, headers: headers }, cb);
}

class Data {
  function getMilestones(u, r, cb) {
    request({ url: url(u, r, "milestones"), headers: headers }, #(err, res, body) {
      cb(JSON.parse(body));
    });
  }

  function getTickets(u, r, label, cb) {
    request({ url: url(u, r, "issues"), headers: headers, qs: { labels: label } }, #(err, res, body) {
      cb(JSON.parse(body));
    });
  }

  function getLabels(u, r, cb) {
    request({ url: url(u, r, 'labels'), headers: headers }, #(err, res, body) {
      cb(JSON.parse(body));
    });
  }

  function getIssuesByMilestone(u, r, id, cb) {
    req(url(u, r, 'issues?milestone=' + id), #(err, res, body) {
      cb(JSON.parse(body));
    });
  }

  function getIssues(paths, cb) {
    var issues = [];
    var count = paths.length;
    for (var i=0; i<paths.length; i++) {
      var url = "https://api.github.com" + paths[i];
      req(url, #(err, res, body) {
        count--;
        if (!err) {
          try {
          foreach (var issue in JSON.parse(body)) {
            issue.labelHash = {};
            foreach (var l in issue.labels) {
              issue.labelHash[l.name] = true;
            }
            issues.push(issue);
          }
          } catch(e) { console.log(e) }
        }
        if (count == 0) cb(issues);
      });
    }
  }
}

module.exports = new Data();
