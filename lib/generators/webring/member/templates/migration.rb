class CreateWebringMembers < ActiveRecord::Migration<%= "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" %>
  def change
    create_table :webring_members do |t|
      t.string :uid, null: false, limit: 32
      t.string :name, null: false
      t.string :url, null: false
      t.text :description, null: false

      t.index :uid, unique: true
      t.index :name, unique: true
      t.index :url, unique: true

      t.timestamps
    end
  end
end
