class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :user_id
      t.string  :name
      t.string  :url, :unique => true
      t.text    :bio
      t.integer :num_of_votes, :default => 0
      t.integer :num_of_presentations, :default => 0
      t.timestamps
    end
    add_index :accounts, :user_id
  end

  def self.down
    drop_table :accounts
  end
end
