class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.belongs_to :user, foreign_key: true
      t.references :votable
      t.string :votable_type
      t.integer :point
      t.timestamps

    end

    add_index :votes, [:user_id, :votable_id, :votable_type], unique: true
  end
end
