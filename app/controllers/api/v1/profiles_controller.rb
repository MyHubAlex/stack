class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    respond_with current_resource_owner
  end

  def users
    respond_with User.all_user_without_current(current_resource_owner)
  end
end