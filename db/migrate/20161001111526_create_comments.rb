class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.belongs_to :user, foreign_key: true
      t.references :commentable
      t.string :commentable_type
      t.text :body
    end
  
  add_index :comments, [:commentable_id, :commentable_type]
  end
end
