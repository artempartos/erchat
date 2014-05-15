/** @jsx React.DOM */

$(document).ready(function() {

    var Rooms = React.createClass({

        getInitialState: function() {

            console.log("Start ajax");
            $.ajax({
                type: 'GET',
                data: "json",
                url: "http://localhost:8080/rooms",
                // headers: {'X-CSRFToken': $.cookie('csrftoken')},
                success: function(data) {
                    console.log(data);
                    // var links = this.state.data;
                    //I do this so the new added link will be on top of the array
                    // var newLinks = [data].concat(links);
                    // this.setState({data: newLinks});
                }
                // }.bind(this)
            });
            return {rooms: []};
        },

        // onChange: function(e) {
        //     this.setState({text: e.target.value});
        // },

        // handleSubmit: function(e) {
        //     e.preventDefault();
        //     var items =  this.state.items.concat([{text: this.state.text, id: this.state.id, status: "uncompleted"}]);
        //     this.setState({items: items, text: "", id: this.state.id + 1})
        // },

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
                    <h1> Rooms</h1>
                    <a href = "http://partos.me"> Partos.me </a>
                    // <TodoList
                    //     items={this.state.items}
                    //     changeItemStatus={this.changeItemStatus}
                    //     onItemRemove={this.handleItemRemove}
                    //     handleItemEditText={this.handleItemEditText}
                    // />

                </div>
                );
        }
    });

    React.renderComponent(<Rooms/>, document.getElementById("rooms"));
});


