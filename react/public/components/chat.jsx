/** @jsx React.DOM */

var Chat = React.createClass({
  render: function() {

    var disabled = this.props.nick==""

    return (
      <div>
        <div class="well col-md-10">
            <MessageBox
            history={[{content: "awrgaerg", nick: "Partos"}, {content: "sergesrg", nick: "Dima"}]}
              // history={this.props.history}
            />
        </div>
        <div class="well col-md-2">
            <UserBox
              // users={this.props.users}
              users={["asd", "etbteb", "adsfa"]}
            />
        </div>

        <div id="send_message">
          <div class="input-group">
            <input id="message" class="form-control" type="text"/>
            <span class="input-group-btn">
              <input id="send_message" class="btn btn-primary" type='button' disabled={disabled} value='Send message'/>
            </span>
          </div>
        </div>
      </div>
    )

  }
});

// sendButton.onclick = sendMessage;
//     key('⌘+enter,enter', sendMessage);
//     key.filter = function(event){
//         var tagName = (event.target || event.srcElement).tagName;
//         key.setScope(/^(INPUT|TEXTAREA|SELECT)$/.test(tagName) ? 'input' : 'other');
//         return true;
//     };

