class AnswerRespondJob < ApplicationJob
  queue_as :default

  def perform(object)
    object.question.subscribers.find_each.each do |subscriber|
      AnswerRespondMailer.answers(subscriber, object).deliver_later
    end
  end
end
