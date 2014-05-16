function BulletWrapper(url) {
  this.callback_functions = {};
  this.bullet = $.bullet(url);
  this.bullet.onmessage = function(e) {
    var message = JSON.parse(e.data);
    var callback = this.callback_functions[message.event];
    if (callback) {
      callback(message.data);
    } else {
      console.log("callback '" + message.event + "' is missing");
      console.log("data: " + JSON.stringify(message.data));
    }
  }.bind(this);
};

BulletWrapper.prototype.on = function(event, callback) {
  var bulletEvents = ['open', 'close', 'disconnect', 'heartbeat'];
  if (bulletEvents.indexOf(event) != -1) {
    this.bullet['on' + event] = callback;
  } else {
    this.callback_functions[event] = callback;
  }
}

BulletWrapper.prototype.send = function(data) {
  var jsonData = JSON.stringify(data);
  this.bullet.send(jsonData);
}
