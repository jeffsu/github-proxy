var request = require('request');

var config = require('./config')[0];

var USERNAME = config.account.username;
var PASSWORD = config.account.password;

var auth = 'Basic ' + new Buffer(USERNAME + ':' + PASSWORD).toString('base64');
var headers = { Authorization: auth };

class Data {
  function getMilestones(cb) {
    var url = "https://api.github.com/repos/Factual/front/milestones";
    request({ url: url, headers: headers }, #(err, res, body) {
      cb(JSON.parse(body));
    });
  }

  function getTickets(label, cb) {
    var url = "https://api.github.com/repos/Factual/front/issues";
    request({ url: url, headers: headers, qs: { labels: label } }, #(err, res, body) {
      cb(JSON.parse(body));
    });
  }

  function getLabels(cb) {
    var url = "https://api.github.com/repos/Factual/front/labels";
    request({ url: url, headers: headers }, #(err, res, body) {
      cb(JSON.parse(body));
    });
  }

}

module.exports = new Data();
