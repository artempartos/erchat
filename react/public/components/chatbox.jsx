/** @jsx React.DOM */

$(document).ready(function() {
    var ChatBox = React.createClass({
      getInitialState: function() {
        var uuid = document.location.pathname.split('/').pop();
        console.log(uuid);
        return {uuid: uuid};
      },
      componentDidMount: function() {
        var bullet = new BulletWrapper('ws://localhost:8080/rooms/' + this.state.uuid, {});
        console.log(this.state.uuid),
        bullet.on('open', function() {
          console.log("open");
          bullet.send({event: 'get', data: 'history'});
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
            <div>
            <input id="create" class="btn btn-primary" type="button" onClick={this.handleClick} value="Create Room"/>

          </div>
        );
      }
    });
  
  React.renderComponent(<ChatBox/>, document.getElementById("chat"));
});
