# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
PrivatePub.subscribe "/messages/new", (data, channel) ->
  author = $('<strong>', text: "#{data.message.author}: ")
  message = $('<span>', text: data.message.content)

  newLi = $("<li>").append(author)
  newLi.append(message)

  $('ul#chat').append(newLi)
  $('input#message_content').val("")
