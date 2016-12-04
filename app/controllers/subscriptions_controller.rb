class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  respond_to :js  
  authorize_resource 
  def create
    current_user.subscribe(@question)     
  end

  def destroy
    current_user.unsubscribe(Subscription.find(params[:id]))    
  end 

  private 

  def load_question
    @question = Question.find(params[:question_id])
  end
end
