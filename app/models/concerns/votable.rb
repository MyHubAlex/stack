module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def delete_vote(user)
    votes.where(user: user).delete_all
  end
end