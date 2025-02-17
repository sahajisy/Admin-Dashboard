class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast("chat_channel", message: process_message(data['message']))
  end

  private

  def process_message(message)
    # Implement logic to fetch applicant details based on the message
    applicant = Applicant.find_by(name: message)
    if applicant
      "Applicant Details:\nName: #{applicant.name}\nEmail: #{applicant.mail_id}\nJLPT Level: #{applicant.jlpt_level}\nAmount: #{applicant.amount}\nBalance: #{applicant.current_balance}"
    else
      "No applicant found with the name '#{message}'"
    end
  end
end
