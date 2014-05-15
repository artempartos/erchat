/** @jsx React.DOM */

var RoomsList = React.createClass({
    render: function() {
        room_items = this.props.rooms.map(function (room) {
            return <RoomListItem room={room} />
        })
        return <div id="room_list"> {room_items} </div>

    }
});