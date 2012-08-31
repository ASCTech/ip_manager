class AddNameToBuilding < ActiveRecord::Migration
  def change
    add_column :buildings, :name, :string
  end
end
