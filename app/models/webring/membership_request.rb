module Webring
  class MembershipRequest < ApplicationRecord
    include Webring::MembershipRequestActions

    has_one :member, class_name: 'Webring::Member',
                     foreign_key: :webring_membership_request_id,
                     dependent: :nullify,
                     inverse_of: :membership_request

    validates :url, presence: true, uniqueness: true
    validates :name, presence: true
    validates :description, presence: true
    validates :callback_email, presence: true

    enum :status, { pending: 0, approved: 1, rejected: 2 }, default: :pending
  end
end
