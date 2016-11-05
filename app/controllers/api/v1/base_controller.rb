class Api::V1::BaseController <  ApplicationController
  before_action :doorkeeper_authorize!
  authorize_resource 
  skip_authorization_check

  respond_to :json
  
  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  protected

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end