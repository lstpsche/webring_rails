class CreateWebringMembers < ActiveRecord::Migration<%= "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" %>
  def change
    create_table :webring_members do |t|
      t.string :name
      t.string :url, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :webring_members, :name, unique: true
    add_index :webring_members, :url, unique: true
    add_index :webring_members, :status
  end
end
