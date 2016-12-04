class AnswerRespondMailer < ApplicationMailer

 def answers(subscriber, answer)
    @question = answer.question
    mail to: subscriber.email
  end

end
