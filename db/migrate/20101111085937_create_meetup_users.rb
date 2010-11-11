class CreateMeetupUsers < ActiveRecord::Migration
  def self.up
    create_table :meetup_users do |t|
      t.integer :user_id, :null => false
      t.integer :meetup_id, :null => false
      t.boolean :is_attending, :default => true
      t.timestamps
    end
    add_index :meetup_users, :user_id
    add_index :meetup_users, :meetup_id
    add_index :meetup_users, :is_attending
  end

  def self.down
    drop_table :meetup_users
  end
end
