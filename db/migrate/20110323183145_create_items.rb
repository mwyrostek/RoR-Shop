class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :category_id
      t.string :name
      t.text :description
      t.decimal :cost

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
