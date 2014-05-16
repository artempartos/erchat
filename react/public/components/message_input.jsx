/** @jsx React.DOM */

var MessageInput = React.createClass({
  handleClick: function() {
    var message = this.refs.message.getDOMNode().value.trim()
    this.props.onSendMessage(message);
  },
  render: function() {
    return (
        <div id="send_message">
          <div class="input-group">
            <input id="message" class="form-control" ref="message" type="text"/>
            <span class="input-group-btn">
              <input id="send_message" class="btn btn-primary" onClick={this.handleClick} type='button' disabled={this.props.disabled} value='Send message'/>
            </span>
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
