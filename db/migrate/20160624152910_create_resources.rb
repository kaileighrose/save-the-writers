class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name
      t.string :type
      t.string :link
      t.string :source
      t.string :cost
      t.string :notes
      t.integer :user_id
    end
  end
end
