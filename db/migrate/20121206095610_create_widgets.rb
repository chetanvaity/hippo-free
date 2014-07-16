class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.integer :breed
      t.string :data

      t.timestamps
    end
  end
end
