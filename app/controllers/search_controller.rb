class SearchController < ApplicationController
  skip_authorization_check
  def index
    respond_with(@result = Search.find(params))
   end
end
