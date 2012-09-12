class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.column :activity, :string
      t.column :user_id, :integer
      t.timestamps
    end
  end
end
