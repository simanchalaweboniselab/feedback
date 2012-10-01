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

var current;

$(document).ready(function(){
    $("#assign_user").live("click",function(){
        $("#assign_user_content").append('<div class="block-box"><div class="left-column"> <input type="text" class="large from_user" name="from_user" placeholder="Select User"/><input type="text" class="large to_user to_user_first" name="to_user_first" placeholder="Select User" disabled="disabled"/> <input type="text" class="large to_user to_user_second" name="to_user_second" placeholder="Select User" disabled="disabled"/> <input type="text" class="large to_user to_user_third" name="to_user_third" placeholder="Select User" disabled="disabled"/></div><div class="center-column"></div></div>') ;

        var ids1 = new Array();

        $( ".from_user" ).live("focusin",function(event){
            current = $("body");
            $(this).removeAttr("alt");
            ids1 = new Array();
            current.find(".from_user").each(function(){
                if($(this).attr("alt"))
                {
                    ids1.push($(this).attr("alt"));
                }
            });
        }).autocomplete({
                source: function( request, response ) {
                    $.ajax({
                        url: "/admin/users/get_from_user_list",
                        data: {"from_user": ids1},
                        dataType: "json",
                        success: function(data){
                            response( $.map( data, function( item ) {
                                return {
                                    label: item.name,
                                    value: item.name,
                                    id: item.id
                                }
                            }));
                        }
                    });
                },
                dataType: "json",
                select:function(event, ui) {
                    if (ui.item) {
                        $(this).attr("alt",ui.item.id);
                    }

                },
                change:function(event, ui) {
                    if (!ui.item) {
                        $(this).val('').parent().find(".to_user_first").prop("disabled",true);
                    }else{
                        $(this).removeClass("error");
                        $(this).attr("alt",ui.item.id);
                        $(this).parent().find(".to_user_first").prop("disabled",false).focus();

                    }

                }
            });

        var ids = new Array();

        $( ".to_user").live("focusin",function(event){
            current = $(this).parent();
            $(this).removeAttr("alt");
            ids = new Array();
            ids.push(current.find(".from_user").attr("alt"));
            current.find(".to_user").each(function(){
                if($(this).attr("alt"))
                {
                    ids.push($(this).attr("alt"));
                }
            })
        }).autocomplete({
                source: function( request, response) {
                    $.ajax({
                        url: "/admin/users/get_to_user_list",
                        dataType: "json",
                        data: {"from_user": ids},
                        success: function(data){
                            response( $.map( data, function( item ) {
                                return {
                                    label: item.name,
                                    value: item.name,
                                    id: item.id
                                }
                            }));
                        }
                    });
                },
                dataType: "json",
                select:function(event, ui) {
                    if (ui.item) {
                        $(this).attr("alt",ui.item.id);
                    }

                },
                change:function(event, ui) {
                    if (!ui.item) {
                        $(this).val('').next().prop("disabled",true);
                    }else{
                        $(this).next().prop("disabled",false).focus();
                        $(this).removeClass("error");
                        $(this).attr("alt",ui.item.id);
                    }

                }
            });
    });

    $("#save_all_user").live("click",function(){
        flag =0;
        $("body input[type='text']").each(function(){
            if($(this).val()==""){
                flag = 1;
                $(this).addClass("error");
                $(this).parent().parent().find(".center-column").html('<div class="cross"> </div> <div class="tooltip fade right in" style="display: block; "><div class="tooltip-arrow"></div><div class="tooltip-inner">All fields are mandatory!!!</div></div>');
            }
        });
        if(flag == 0){
            $(".block-box").each(function(){

            })
        }
    });


});