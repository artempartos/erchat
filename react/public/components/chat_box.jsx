/** @jsx React.DOM */

$(document).ready(function() {
  var ChatBox = React.createClass({
    getInitialState: function() {
      var uuid = document.location.pathname.split('/').pop();
      return {uuid: uuid, nick: ""};
    },
    componentDidMount: function() {
      var bullet = new BulletWrapper('ws://localhost:8080/rooms/' + this.state.uuid, {});
      bullet.on('open', function() {
        console.log("open");
        bullet.send('get', 'history');
      });
      bullet.on('history', function(data){
        console.log(data);
      });
      bullet.on('heartbeat', function() {
        console.log("heartbeat");
      });
    },
    render: function() {
      return (
        <div class="col-md-8 col-md-offset-2">
          <NickBox
            nick={this.state.nick}
          />
          <Chat
            nick={this.state.nick}
            history={this.state.history}
          />
        </div>
      );
    }
  });

  React.renderComponent(<ChatBox/>, document.getElementById("chat"));
});
