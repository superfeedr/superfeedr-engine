class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :feed_id
      t.string :title
      t.string :link
      t.string :description

      t.timestamps null: false
    end
  end
end
