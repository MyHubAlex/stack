class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_commentable, only: [:create]
  before_action :get_comment, except: [:create]
  after_action :publish_comment, only: [:create]

  respond_to :js
  
  authorize_resource
  
  def create
    respond_with(@comment = @commentable.comments.create(comment_params))    
  end

  private

  def publish_comment
    if @comment.commentable.is_a? Question
      id_commentable = @commentable.id
    else
      id_commentable = @commentable.question.id
    end
    PrivatePub.publish_to "/questions/#{id_commentable}/comments", comment: @comment.to_json
  end

  def get_answer
    @comment = Comment.find(params[:id])
  end

  def get_commentable
    @commentable = commentable_type.classify.constantize.find(params["#{ commentable_type }_id"])
  end

  def commentable_type
    params[:commentable_type]
  end

  def comment_params    
    params.require(:comment).permit(:body).merge(user: current_user)
  end

end
