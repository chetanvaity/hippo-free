class CreateStencils < ActiveRecord::Migration
  def change
    create_table :stencils do |t|
      t.integer :breed
      t.string :widgets

      t.timestamps
    end
  end
end
