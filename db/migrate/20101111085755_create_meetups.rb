class CreateMeetups < ActiveRecord::Migration
  def self.up
    create_table :meetups do |t|
      t.string  :name, :null => false
      t.text    :description
      t.datetime :happening_at, :null => false
      t.string  :location
      t.string  :geo_latitude
      t.string  :geo_longitude
      t.integer :user_id, :null => false
      t.boolean :is_active, :default => true
      t.timestamps
    end
    add_index :meetups, :user_id
    add_index :meetups, :is_active
  end

  def self.down
    drop_table :meetups
  end
end
