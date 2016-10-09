class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :edit, :update]
  before_action :new_answer, only: [:show]
  after_action :publish_question, only: [:create]
  include Voted
  
  respond_to :js

  def index
    respond_with(@questions = Question.all)
  end

  def show      
    respond_with(@answer)
  end

  def new
    respond_with(@question = Question.new) 
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))  
  end

  def destroy
    if  current_user.belongs_to_obj(@question)
      respond_with(@question.destroy)
    else
      respond_with @question    
    end  
  end

  def update
    if current_user.belongs_to_obj(@question) 
      @question.update(question_params)
      respond_with @question
    end  
  end

  private 

  def publish_question
    PrivatePub.publish_to "/questions", question: @question.to_json    
  end
  def new_answer
    @answer = @question.answers.new
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy])
  end 
end
