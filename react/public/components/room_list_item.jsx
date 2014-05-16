/** @jsx React.DOM */

var RoomListItem = React.createClass({

    render: function() {
        return (
            <div class='room_item'>
                <span class= 'label'>
                    <a href={"/rooms/" + this.props.room.uuid}> {this.props.room.uuid} </a>
                </span>
                <span >
                    ({this.props.room.count})
                </span >
            </div>
        )
    }
});