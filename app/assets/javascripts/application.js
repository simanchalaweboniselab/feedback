// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .


$(document).ready(function(){
    $("#assign_user").live("click",function(){
        alert("test");
    });
});
function auto_fill(users) {
    var data = $(users ).map(function() {
        return {
            value: $( "name", this ).text() ,
            id: $( "id", this ).text()
        };
    }).get();
//    alert(names);
    $( ".from_user" ).autocomplete({
        source: function( request, response ) {
            response( $.map( users, function( item ) {
                return {
                    label: item.name,
                    value: item.name,
                    id: item.id
                }
            }));
        },
        dataType: "json",
        select: function(event, ui) {
            alert(ui.item.id);
        }
    });
}
