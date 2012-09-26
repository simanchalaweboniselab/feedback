class CreateUserFeedbacks < ActiveRecord::Migration
  def change
    create_table :user_feedbacks do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.string :feedback

      t.timestamps
    end
  end
end
