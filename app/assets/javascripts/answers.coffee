# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    id_answer = $(this).data('answerId')
    $('#edit-answer-'+ id_answer).show()

$(document).on("turbolinks:load", ready)   