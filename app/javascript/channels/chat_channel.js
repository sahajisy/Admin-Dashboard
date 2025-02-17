import consumer from "channels/consumer"

consumer.subscriptions.create("ChatChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Append message to the chat box
    const messages = document.getElementById('messages')
    messages.innerHTML += `<div class="message">${data.message}</div>`
  },

  speak(message) {
    return this.perform('speak', { message: message });
  }
});

// Handling the message input and sending messages
document.addEventListener('DOMContentLoaded', () => {
  const input = document.getElementById('message-input')
  const button = document.getElementById('send-button')

  button.addEventListener('click', () => {
    const message = input.value
    consumer.subscriptions.subscriptions[0].speak(message)
    input.value = ''
  })
})
