/** @jsx React.DOM */

$(document).ready(function() {
    var ChatBox = React.createClass({
      getInitialState: function() {
        var uuid = document.location.pathname.split('/').pop();
        console.log(uuid);
        return {uuid: uuid};
      },
      componentDidMount: function() {
        var bullet = $.bullet('ws://localhost:8080/rooms/' + this.state.uuid, {});
        console.log(this.state.uuid),
        bullet.onopen = function() {
          bullet.send('get history');
        };
        bullet.onmessage = function(){
          console.log(e);
        };
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
