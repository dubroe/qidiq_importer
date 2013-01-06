class CreateFeedbackGroups < ActiveRecord::Migration
  def change
    create_table :feedback_groups do |t|
      t.integer :user_id
      t.string :url
      t.string :api_key
      t.string :explanation

      t.timestamps
    end
  end
end
