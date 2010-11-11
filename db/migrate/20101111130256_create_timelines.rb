class CreateTimelines < ActiveRecord::Migration
  def self.up
    create_table :timelines do |t|
      t.integer :user_id, :null => false
      t.integer :meetup_id, :null => false
      t.string  :message
      t.timestamps
    end
    add_index :timelines, :meetup_id
    add_index :timelines, :user_id
  end

  def self.down
    drop_table :timelines
  end
end
