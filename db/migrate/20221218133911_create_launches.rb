class CreateLaunches < ActiveRecord::Migration[7.0]
  def change
    create_table :launches do |t|
      t.string :rocket_id
      t.string :site_name
      t.string :customer
      t.string :periapsis_km
      t.string :launch_time
      t.integer :cost_per_launch

      t.timestamps
    end
  end
end
