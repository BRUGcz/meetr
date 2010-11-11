class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id, :null => false
      t.integer :presentation_id, :null => false
      t.boolean :is_deleted, :default => false
      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, :presentation_id
  end

  def self.down
    drop_table :votes
  end
end
