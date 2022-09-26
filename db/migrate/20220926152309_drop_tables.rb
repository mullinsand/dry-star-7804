class DropTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :gardens, force: :cascade
    drop_table :plants, force: :cascade
    drop_table :plots, force: :cascade
    drop_table :plot_plants
  end
end
