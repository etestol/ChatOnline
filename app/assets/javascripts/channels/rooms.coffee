jQuery(document).on 'turbolinks:load', ->
  # messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))

  App.global_chat = App.cable.subscriptions.create {
      channel: "ChatRoomsChannel"
      chat_room_id: 1
    },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    userIsCurrentUser: (user_id) ->
      parseInt(user_id) == parseInt($('meta[name=current-user]').attr('id'))

    received: (data) ->
      message = $(data['message'])
      # if @userIsCurrentUser(data['user_id'])
      #   message = message.removeClass('card').addClass('right-card')
      # else
      #   message = message.removeClass('card').addClass('left-card')
      messages.append message
      messages_to_bottom()

    send_message: (message, chat_room_id) ->
      @perform 'send_message', message: message, chat_room_id: chat_room_id

  $('#new_message').submit (e) ->
    $this = $(this)
    textarea = $this.find('#message_body')
    if $.trim(textarea.val()).length > 0
      App.global_chat.send_message textarea.val(), messages.data('chat-room-id')
      textarea.val('')
    e.preventDefault()
    return false

  $('.new-conversation').click ->
    sender_id = $(this).data('sid');
    recipient_id = $(this).data('rip');
    $.post('/chat_rooms', { sender_id: sender_id, recipient_id: recipient_id })
    return false
