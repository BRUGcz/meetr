class CreatePresentations < ActiveRecord::Migration
  def self.up
    create_table :presentations do |t|
      t.string  :name, :null => false
      t.text    :description
      t.integer :duration, :default => 1800
      t.integer :user_id, :null => false
      t.integer :meetup_id, :null => false
      t.boolean :is_active, :default => true
      t.boolean :is_open_for_votes, :default => true
      t.timestamps
    end
    add_index :presentations, :user_id
    add_index :presentations, :meetup_id
    add_index :presentations, :is_active
    add_index :presentations, :is_open_for_votes
  end

  def self.down
    drop_table :presentations
  end
end
