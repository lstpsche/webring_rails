module Webring
  class MembershipRequest < ApplicationRecord
    has_one :member, class_name: 'Webring::Member',
                     foreign_key: :webring_membership_request_id,
                     dependent: :nullify,
                     inverse_of: :membership_request

    validates :url, presence: true, uniqueness: true
    validates :name, presence: true
    validates :description, presence: true

    enum :status, { pending: 0, approved: 1, rejected: 2 }, default: :pending

    def approve!
      return if approved?

      transaction do
        update!(status: :approved)

        Webring::Member.create!(
          name: name,
          url: url,
          description: description,
          webring_membership_request_id: id
        )
      end
    end
  end
end
