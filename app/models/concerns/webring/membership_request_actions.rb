module Webring
  module MembershipRequestActions
    extend ActiveSupport::Concern

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

    def reject!
      return if rejected?

      transaction do
        update!(status: :rejected)
      end
    end
  end
end
