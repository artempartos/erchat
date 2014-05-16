/** @jsx React.DOM */

var MessageInput = React.createClass({

  componentDidMount: function() {
    key('⌘+enter,enter', this.handleClick);
    key.filter = function(event){
      var tagName = (event.target || event.srcElement).tagName;
      key.setScope(/^(INPUT|TEXTAREA|SELECT)$/.test(tagName) ? 'input' : 'other');
      return true;
    };
  },

  componentWillUnmount: function() {
    key.unbind('⌘+enter,enter', this.handleClick)
  },

  handleClick: function() {
    var dom_message = this.refs.message.getDOMNode()
    var message = dom_message.value.trim()
    console.log(message);
    if (message != "" && !this.props.disabled) {
      this.props.onSendMessage(message);
      dom_message.value = '';
    }
  },
  render: function() {
    return (
        <div id="send_message">
          <div class="input-group">
            <input id="message" class="form-control" ref="message" type="text" disabled={this.props.disabled}/>
            <span class="input-group-btn">
              <input id="send_message" class="btn btn-primary" onClick={this.handleClick} type='button' disabled={this.props.disabled} value='Send message'/>
            </span>
          </div>
        </div>
    )
  }
});