$(document).ready(function(){
  var start = function(name, options) {
    var bullet;
    var open = function(){
      bullet = $.bullet('ws://localhost:8080/rooms/063a0a82-dc12-11e3-a3e3-10ddb1ba8b6c', options);

      bullet.onopen = function(){
        $('#status_' + name).text('online');
      };

      bullet.onclose = bullet.ondisconnect = function(){
        $('#status_' + name).text('offline');
      };

      bullet.onmessage = function(e){
        if (e.data != 'pong'){
          $('#time_' + name).text(e.data);
        }
      };

      bullet.onheartbeat = function(){
        console.log('ping: ' + name);
        bullet.send('ping: ' + name);
      };
    }

  open();

  // $('#send_' + name).on('click', function(){
  // if (bullet) {
  // bullet.send('time: ' + name + ' '
  // + $('#time_' + name).text());
  // }
  // });
  };

  start('best', {});
  });