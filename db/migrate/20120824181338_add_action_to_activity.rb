class AddActionToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :Action, :string
  end
end
