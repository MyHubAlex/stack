class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :edit, :update]
  include Voted
  
  def index
    @questions = Question.all
  end

  def show    
    @answer = @question.answers.new
    @answer.attachments.build
  end

  def new
    @question = Question.new 
    @question.attachments.build
  end

  def create
    @question = current_user.questions.new(question_params)
    
    if @question.save
      flash[:notice] = 'Your question successfully created.' 
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    if  current_user.belongs_to_obj(@question)
      @question.destroy
      flash[:notice] = 'Your question was deleted'
      redirect_to questions_path
    else
      redirect_to @question    
    end  
  end

  def edit
    
  end

  def update
    if current_user.belongs_to_obj(@question) 
      @question.update(question_params)
    end  
  end

  private 

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :_destroy])
  end 
end
