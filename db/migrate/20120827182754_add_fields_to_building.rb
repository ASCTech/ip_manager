class AddFieldsToBuilding < ActiveRecord::Migration
  def change
    add_column :buildings, :code, :string 
    add_column :buildings, :osuid, :integer
  end
end
