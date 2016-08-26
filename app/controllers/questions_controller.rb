class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_qusetion, only: [:show, :destroy]

  def index
    @questions = Question.all
  end

  def show    
    @answer = @question.answers.new
  end

  def new
    @question = Question.new 
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
    if @question.user == current_user
      @question.destroy
      flash[:notice] = 'Your question was deleted'
      redirect_to questions_path
    else
      redirect_to @question    
    end  
  end

  private 

  def load_qusetion
    @question = Question.find(params[:id])
  end
  def question_params
    params.require(:question).permit(:title, :body)
  end 
end
