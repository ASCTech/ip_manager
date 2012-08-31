class AddDescriptionToNetwork < ActiveRecord::Migration
  def change
    add_column :networks, :description, :string
  end
end
