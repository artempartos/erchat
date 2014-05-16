/** @jsx React.DOM */

var MessageBox = React.createClass({


  componentDidUpdate: function() {
    var dom_messages = this.refs.message_list.getDOMNode()
    console.log(dom_messages);
    dom_messages.scrollTop = dom_messages.scrollHeight;
  },

  render: function() {
    message_items = this.props.history.map(function (message) {
        return (
          <p>
            <strong> { message.nick}:  </strong>
            <span> { message.content } </span>
          </p>
        )
    })

    return (
      <div id="message_list" ref='message_list'> {message_items} </div>
    )

    // content.scrollTop = content.scrollHeight;
  }
});