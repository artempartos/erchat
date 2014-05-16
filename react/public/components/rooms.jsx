/** @jsx React.DOM */

$(document).ready(function() {

    var Rooms = React.createClass({

        getInitialState: function() {
            var rooms = [];
            $.ajax({
                type: 'GET',
                data: "json",
                url: "http://localhost:8080/rooms",
                async: false,
                success: function(data) {
                    rooms = data;
                }
            });
            return {rooms: rooms};
        },

        // onChange: function(e) {
        //     this.setState({text: e.target.value});
        // },

        handleClick: function(e) {
          e.preventDefault();
          var room = {};
          $.ajax({
            type: 'POST',
            data: "json",
            url: "http://localhost:8080/rooms",
            success: function(data) {
              room = data;
              document.location = "/rooms/" + room.uuid;
            }
          });
          return false;
        },

        // changeItemStatus: function(item, status) {
        //     items = this.state.items;
        //     id = _.findKey(items, {id: item.id});
        //     items[id].status = status;
        //     this.setState({items: items});
        // },

//         handleItemEditText: function(item, text) {
//             items = this.state.items;
//             id = _.findKey(items, {id: item.id});
//             items[id].status = "uncompleted";
//             items[id].text = text;
//             this.setState({items: items});
// //            this.forceUpdate();
//         },

        // handleItemRemove: function(item) {
        //     items = _.without(this.state.items, item);
        //     item.status = "deleted"
        //     its = items.concat([item]);
        //     this.setState({items: its});
        // },

        render: function() {
            return (
                <div>
                    <input id="create" class="btn btn-primary" type="button" onClick={this.handleClick} value="Create Room"/>
                    <h1> Rooms</h1>
                    <RoomsList
                        rooms={this.state.rooms}
                    />

                </div>
                );
        }
    });

    React.renderComponent(<Rooms/>, document.getElementById("rooms"));
});


