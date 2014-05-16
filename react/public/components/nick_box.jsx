/** @jsx React.DOM */

var NickBox = React.createClass({
  handleClick: function() {
    var nick = this.refs.nick.getDOMNode().value.trim()
    this.props.onSetNickname(nick);
  },
  render: function() {
    var nick = ""

    if (this.props.nick == "") {
      nick = (
        <div id="nick_name">
          <h2> Please, set your nick </h2>
          <div class="input-group">
            <input id="field" class="form-control" type="text" ref='nick'/>
            <span class="input-group-btn">
              <input id="setnick" class="btn btn-primary" type='button' onClick={this.handleClick} value='Set nickname!'/>
            </span>
          </div>
        </div>
      );
    } else {
        nick = <h2> You are logged as {this.props.nick} </h2>
    }

    return nick;

  }
});
