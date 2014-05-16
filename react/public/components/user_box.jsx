/** @jsx React.DOM */

var UserBox = React.createClass({
render: function() {
    user_items = this.props.users.map(function (user) {
        return (
          <p>
            <strong> { user } </strong>
          </p>
        )
    })

    return (
      <div id="user_list"> {user_items} </div>
    )
  }
});