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
//= require jquery-ui
//= require twitter/bootstrap
//= require bootstrap-datepicker
//= require_tree .



$(document).ready(function(){

    $("#assigned-search").live("click",function(event){
        if($("#datepicker").val()){
            $.ajax({
                url: "/admin/users/assigned_feedback_search",
                type: "GET",
                data: {"date": $("#datepicker").val(), "id": $(this).attr("rel") }
            });
        }
        else
        {
            alert("please enter date in search field");
        }
    });

    $("#given-search").live("click",function(event){
        if($("#datepicker").val()){
            $.ajax({
                url: "/admin/users/given_feedback_search",
                type: "GET",
                data: {"date": $("#datepicker").val(), "id": $(this).attr("rel") }
            });
        }
        else
        {
            alert("please enter date in search field");
        }
    });

    $("#received-search").live("click",function(event){
        if($("#datepicker").val()){
            $.ajax({
                url: "/admin/users/received_feedback_search",
                type: "GET",
                data: {"date": $("#datepicker").val(), "id": $(this).attr("rel") }
            });
        }
        else
        {
            alert("please enter date in search field");
        }
    });
    $("#received-search").live("click",function(event){
        if($("#datepicker").val()){
            $.ajax({
                url: "/admin/users/_feedback_search",
                type: "GET",
                data: {"date": $("#datepicker").val(), "id": $(this).attr("rel") }
            });
        }
        else
        {
            alert("please enter date in search field");
        }
    });

    $(function() {
        $( "#datepicker" ).datepicker({"format": "dd-mm-yyyy", "autoclose": true});
    });

    $("#remove-contributor-recipients").live("click",function(){
        $(this).parent().parent().parent().remove();
    });

    $("#remove-contributor-recipients1").live("click",function(){
        $(this).parent().parent().remove();
        if($("#feedback-box").length == 0){
            document.getElementById('save_all_user').style.visibility='hidden';
        }
    });

    $("#assign_user").live("click",function(){
        document.getElementById('contributor-recipients').style.visibility='visible';
        document.getElementById('save_all_user').style.visibility='visible';
        document.getElementById('message1').style.visibility='visible';
        $("#message").remove();
        $("#assign_user_content").append('<div class="block-box" id = "feedback-box"><div class="left-column"> <input type="text" class="large from_user" name="from_user" placeholder="Select User"/><input type="text" class="large to_user to_user_first" name="to_user_first" placeholder="Select User" disabled="disabled"/> <input type="text" class="large to_user to_user_second" name="to_user_second" placeholder="Select User" disabled="disabled"/> <input type="text" class="large to_user to_user_third" name="to_user_third" placeholder="Select User" disabled="disabled"/></div><div class="center-column" ><input type="image" src="/assets/cross.png" id="remove-contributor-recipients1"/></div></div>') ;

        var ids1 = new Array();

        $( ".from_user" ).live("focusin",function(event){
            current = $("#assign_user_content");
            ids1 = new Array();
            current.find(".from_user").each(function(){
                if($(this).attr("alt"))
                {
                    ids1.push($(this).attr("alt"));
                }
            });
            ids1.remByVal($(this).attr("alt"));
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
            ids = new Array();
            ids.push(current.find(".from_user").attr("alt"));
            current.find(".to_user").each(function(){
                if($(this).attr("alt"))
                {
                    ids.push($(this).attr("alt"));
                }
            });
            ids.remByVal($(this).attr("alt"));
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
                $(this).parent().parent().find(".center-column").html('<div style="float: left;"><input type="image" src="/assets/cross.png" id="remove-contributor-recipients"/> </div> <div class="tooltip fade right in" style="display: block; "><div class="tooltip-arrow"></div><div class="tooltip-inner">All fields are mandatory!!!</div></div>');
            }
        });
        if(flag == 0){
            $(".block-box").each(function(){
                current = $(this);
//                $(value).find(".center-column").html('<div class="load"> </div>');
                current.find(".center-column").html('<div class="check"> </div>');
                $.ajax({
                    url: "/admin/users/create_assign_user",
                    data: {"from_user": current.find(".from_user").attr("alt"), "to_user_0": current.find(".to_user_first").attr("alt"), "to_user_1": current.find(".to_user_second").attr("alt"), "to_user_2": current.find(".to_user_third").attr("alt")},
                    dataType: "json",
                    success: function(data){
                        if(data["success"]== true){
                            current.find(".center-column").html('<div class="check"> </div>');
                            document.getElementById('save_all_user').style.visibility='hidden';
                            document.getElementById('assign_user').style.visibility='hidden';
                        }
                        else
                            current.find(".center-column").html('<div style="float: left;"><input type="image" src="/assets/cross.png" id="remove-contributor-recipients"/></div> <div class="tooltip fade right in" style="display: block; "><div class="tooltip-arrow"></div><div class="tooltip-inner">Something Went Wrong!!!</div></div>');
                    }
                });
            })
        }
    });


    Array.prototype.remByVal = function(val) {
        for (var i = 0; i < this.length; i++) {
            if (this[i] === val) {
                this.splice(i, 1);
                i--;
            }
        }
        return this;
    }


});
