/** @jsx React.DOM */

var MessageBox = React.createClass({
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
      <div id="message_list"> {message_items} </div>
    )

    // content.scrollTop = content.scrollHeight;
  }
});