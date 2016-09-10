class AddDefaultForBestAnswer < ActiveRecord::Migration[5.0]
  def up
    change_column(:answers, :best, :boolean, default: false)
  end

  def down
    change_column(:answers, :best, :boolean)
  end
end
