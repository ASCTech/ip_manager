class AddType < ActiveRecord::Migration
  def up
    change_table :devices do |t|
        t.references :type
    end
  end

  def down
  end
end
