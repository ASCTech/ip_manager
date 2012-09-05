class AddOsuInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :emplid, :string
    add_column :users, :name_n, :string
  end
end
