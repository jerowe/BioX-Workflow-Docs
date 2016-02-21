var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var url = require('url');
var json = require('json-file');
var engine = require('ejs-mate');

var app = express();
// use ejs-mate for all ejs templates:
app.engine('ejs', engine);

var config = json.read('./config.json');
console.log(config.data);

global.myuser = config.get('user');
global.myurl = '/' + myuser + '/static';

app.locals.config = config;

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());

//app.use('/', function(req, res, next) {
//  // GET 'http://www.example.com/admin/new'
//  console.log('OrigURL ' + req.originalUrl); // '/admin/new'
//  console.log('BaseURL ' + req.baseUrl); // '/admin'
//  console.log('ReqPath ' + req.path); // '/new'
//  next();
//});

app.use('/user1/static', express.static(__dirname + '/static'));
app.use('/user1/blog/', express.static(__dirname + '/blog'));
app.get('/user1/', function(req, res) {
var body = "Hello World!";
    res.render('home', {});
});
app.get('/user1/home', function(req, res) {
var body = "Hello World!";
    res.render('home', {});
});

app.get('/user1/jbrowse', function(req, res) {
    res.render('jbrowse', {});
});
app.get('/user1/samples', function(req, res) {
    res.render('samples', {});
});

app.get('/user1/python', function(req, res) {
      console.log('Redirecting to ipython notebook...');
      res.render('jupyterhub', {});
});

app.get('/user1/fastqc/:readtype/:sample/:read', function (req, res) {
  
console.log("req is" + JSON.stringify(req.params));
	//var samples = req.params.sample;
  //var read = req.params.read;
  //console.log('sample is ' + sample+ ' and read is ' + read);
  res.render('fastqc', {sample: req.params.sample, read: req.params.read, readtype: req.params.readtype});
});

app.enable('trust proxy');

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {}
  });
});


module.exports = app;
