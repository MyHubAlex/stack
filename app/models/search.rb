class Search < ApplicationRecord
  AREAS = ['Question', 'Answer', 'Comment', 'User']
  AREAS_FOR_SELECT = ['Everywhere'] | AREAS

  def self.find(params)
    classes = []
    classes << params[:a].constantize if AREAS.include?(params[:a])
    ThinkingSphinx.search ThinkingSphinx::Query.escape(params[:q]), classes: classes
  end
end
