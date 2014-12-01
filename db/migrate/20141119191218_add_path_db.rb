class AddPathDb < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :user
      t.string :photo_path
      t.string :latitude
      t.string :longitude
      t.timestamps
    end
  end
end
