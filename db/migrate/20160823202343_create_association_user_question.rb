class CreateAssociationUserQuestion < ActiveRecord::Migration[5.0]
  def change
    add_reference :questions, :user, index: true, foreign_key: { on_delete: :nullify }            
  end
end
