class AddMembershipRequestToWebringMembers < ActiveRecord::Migration<%= "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" %>
  def change
    add_reference :webring_members, :webring_membership_request, null: true, foreign_key: true
  end
end
