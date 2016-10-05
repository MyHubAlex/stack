# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->   
   #$('.new_comment').bind 'ajax:success', (e, data, status, xhr) ->
    #comment = $.parseJSON(xhr.responseText);
    #$('.question-comments').append('<div class= "comment-"'+ comment.id+'> <p> '+ comment.body+' </p></div>'); 
  
  questionId = $('.answers').data('questionId');
  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    comment = $.parseJSON(data['comment']);
    console.log(comment.commentable_type)
    if comment.commentable_type == "Question" 
    	div = ".question-comments";
    else
        div = ".answer-comments-" + comment.commentable_id;    
    console.log(div)
    $(div).append('<div class= "comment-"'+ comment.id+'> <p> '+ comment.body+' </p></div>');   

$(document).on("turbolinks:load", ready)   

