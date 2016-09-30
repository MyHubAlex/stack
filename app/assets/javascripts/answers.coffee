# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    id_answer = $(this).data('answerId')
    $('#edit-answer-'+ id_answer).show()

  $('.vote_up').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText);
    $('.rating-'+ vote.votable.id).html("rating: "+ vote.total);  

  $('.vote_down').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText);
    $('.rating-'+ vote.votable.id).html("rating: "+ vote.total);    

  $('.vote_cancel').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText);
    $('.rating-'+ vote.votable.id).html("rating: "+ vote.total);      

$(document).on("turbolinks:load", ready)   