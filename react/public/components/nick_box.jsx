/** @jsx React.DOM */

var NickBox = React.createClass({
  render: function() {
    var nick = ""

    if (this.props.nick == "") {
      nick = (
        <div id="nick_name">
          <h2> Please, set your nick </h2>
          <div class="input-group">
            <input id="field" class="form-control" type="text"/>
            <span class="input-group-btn">
              <input id="setnick" class="btn btn-primary" type='button' value='Set nickname!'/>
            </span>
          </div>
        </div>
      );
    } else {
        nick = <h2> You are logged as {this.props.nick} </h2>
    }

    return nick

  }
});