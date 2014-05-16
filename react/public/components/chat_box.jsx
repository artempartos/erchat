/** @jsx React.DOM */

$(document).ready(function() {
  var ChatBox = React.createClass({
    getInitialState: function() {
      var uuid = document.location.pathname.split('/').pop();
      return {uuid: uuid, nick: "", history: [], users: []};
    },
    componentDidMount: function() {
      var bullet = new BulletWrapper('ws://localhost:8080/rooms/' + this.state.uuid, {});
      bullet.on('open', function() {
        console.log("open");
        bullet.send('get', 'history');
        bullet.send('get', 'users');
      });

      bullet.on('history', function(history){
        this.setState({history: history})
      }.bind(this));

      bullet.on('users', function(users){
        this.setState({users: users})
      }.bind(this));

      bullet.on('kick', function(nick){
        var history = this.state.history;
        var users = this.state.users;
        history.push({nick: "SERVER", content: "User " + nick + " has gone from room."});
        users = users.filter(function(user) { return user !== nick });
        this.setState({users: users, history: history})
      }.bind(this));
      
      bullet.on('login', function(nick) {
        var users = this.state.users;
        var history = this.state.history;
        history.push({nick: "SERVER", content: "New user is login: " + nick});
        users.push(nick);
        this.setState({users: users, history: history})
      }.bind(this));
      
      bullet.on('message', function(message) {
        var history = this.state.history;
        history.push({nick: message.nick, content: message.content});
        this.setState({history: history})
      }.bind(this));
      
      bullet.on('you_logged', function(nick) {
        this.setState({nick: nick});
      }.bind(this));
      this.bullet = bullet;
    },
    onSetNickname: function(nick) {
      console.log(nick);
      this.bullet.send('nickname', nick);
    },
    onSendMessage: function(message) {
      this.bullet.send('message', message);
    },
    render: function() {
      return (
        <div class="col-md-8 col-md-offset-2">
          <NickBox
            nick={this.state.nick}
            onSetNickname={this.onSetNickname}
          />
          <Chat
            nick={this.state.nick}
            history={this.state.history}
            users={this.state.users}
            onSendMessage={this.onSendMessage}
          />
          <br/>
        </div>
      );
    }
  });

  React.renderComponent(<ChatBox/>, document.getElementById("chat"));
});
