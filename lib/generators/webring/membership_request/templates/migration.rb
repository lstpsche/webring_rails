class CreateWebringMembershipRequests < ActiveRecord::Migration<%= "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" %>
  def change
    create_table :webring_membership_requests do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.text :description, null: false
      t.string :callback_email, null: false
      t.integer :status, default: 0

      t.index :url, unique: true

      t.timestamps
    end
  end
end
