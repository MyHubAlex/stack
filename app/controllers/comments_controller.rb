class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_commentable, only: [:create]
  before_action :get_comment, except: [:create]
  
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
    if @comment.commentable_type == "Question"
      @id_commentable = @commentable.id
      else
      @id_commentable = @commentable.question.id
    end
    PrivatePub.publish_to "/questions/#{@id_commentable}/comments", comment: @comment.to_json
    render nothing: true
  end

  private

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
    params.require(:comment).permit(:body)
  end

end
