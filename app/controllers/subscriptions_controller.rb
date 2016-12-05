class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  respond_to :js  
  authorize_resource 
  def create
    @question.subscribe(current_user)     
  end

  def destroy
    Subscription.find(params[:id]).destroy
  end 

  private 

  def load_question
    @question = Question.find(params[:question_id])
  end
end
