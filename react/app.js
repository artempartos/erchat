var express = require("express");
var cons = require("consolidate");
var app = express();
var port = process.env.PORT || 8082;

app.use(express.static(__dirname + '/public'));

app.set('views', __dirname + '/views');
app.set('view engine', "haml");
app.engine('haml', cons.haml);

app.get("/", function(req, res){
    res.render("home.html.haml");
});

app.get("/rooms/:roomId", function(req, res){
    res.render("room.html.haml");
});

var server = app.listen(port, function() {
    console.log('Listening on port %d', server.address().port);
});