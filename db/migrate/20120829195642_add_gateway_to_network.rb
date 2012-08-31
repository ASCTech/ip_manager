class AddGatewayToNetwork < ActiveRecord::Migration
  def change
    add_column :networks, :gateway, :integer, :limit => 8
  end
end
