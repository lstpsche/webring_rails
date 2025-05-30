class CreateWebringMembers < ActiveRecord::Migration<%= "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" %>
  def change
    create_table :webring_members do |t|
      t.string :uid, null: false, limit: 32
      t.string :name
      t.string :url, null: false

      t.timestamps
    end

    add_index :webring_members, :uid, unique: true
    add_index :webring_members, :name, unique: true
    add_index :webring_members, :url, unique: true
  end
end
