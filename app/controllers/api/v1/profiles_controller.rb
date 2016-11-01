class Api::V1::ProfilesController <  ApplicationController
  before_action :doorkeeper_authorize!
  skip_authorization_check

  respond_to :json
  def me
    respond_with current_resource_owner
  end

  def users
    respond_with User.all_user_without_current(current_resource_owner)
  end

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end