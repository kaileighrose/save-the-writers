class ChangeTypeColumnInResources < ActiveRecord::Migration
  def change
    add_column :resources, :category, :string
  end
end
