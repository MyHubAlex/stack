class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:destroy]
   
  authorize_resource

  def destroy
    #if current_user.belongs_to_obj(@attachment.attachable)
    @attachment.destroy
    #end   
  end

  private

  def load_answer
    @attachment = Attachment.find(params[:id])
  end
end
