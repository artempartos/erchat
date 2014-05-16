/** @jsx React.DOM */

var Chat = React.createClass({
  render: function() {

    var disabled = this.props.nick=="";

    return (
      <div>
        <div class="well col-md-10">
            <MessageBox
            history={this.props.history}
            />
        </div>
        <div class="well col-md-2">
            <UserBox
              users={this.props.users}
            />
        </div>

        <MessageInput
          onSendMessage={this.props.onSendMessage}
          disabled={disabled}
          
        />
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

