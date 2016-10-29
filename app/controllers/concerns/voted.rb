module Voted
  extend ActiveSupport::Concern

  included do
    authorize_resource
    before_action :set_votable, only: [:vote_up, :vote_down, :vote_cancel]
  end

  def vote_up
    #if current_user != @votable.user
      @vote = @votable.votes.build(user: current_user, point: 1)
      if @vote.save
        render json: {votable: @votable, total: @votable.votes.total_vote }  
      else
        render json: @votable.errors.full_messages, status: :unprocessable_entity
      end
    #end
  end 

  def vote_down
    #if current_user != @votable.user
      @vote = @votable.votes.build(user: current_user, point: -1)
      if @vote.save
        render json: {votable: @votable, total: @votable.votes.total_vote } 
      else
        render json: @votable.errors.full_messages, status: :unprocessable_entity
      end
    #end
  end

  def vote_cancel
    #if current_user != @votable.user
      @votable.delete_vote(current_user)
      render json: {votable: @votable, total: @votable.votes.total_vote }
    #end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable 
    @votable = model_klass.find(params[:id])
  end

end 