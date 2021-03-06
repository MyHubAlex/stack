# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('.edit-question-form').show()

  $('.question_vote_up').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText);
    $('.question_rating-'+ vote.votable.id).html("rating: "+ vote.total);  

  $('.question_vote_down').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText);
    $('.question_rating-'+ vote.votable.id).html("rating: "+ vote.total);    

  $('.question_vote_cancel').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText);
    $('.question_rating-'+ vote.votable.id).html("rating: "+ vote.total);  

  PrivatePub.subscribe "/questions", (data, channel) ->
    console.log(data);
    question = $.parseJSON(data['question']);
    $('.questions').append('<h3> <a href= "/questions/'+question.id+'">'+question.title+'</a></h3>');  

$(document).on("turbolinks:load", ready)   


