module Webring
  class Member < ApplicationRecord
    STATUSES = {
      pending: 0,
      approved: 1,
      rejected: 2
    }.freeze

    enum :status, STATUSES, default: Webring.default_status, validate: true

    validates :url, presence: true, uniqueness: true
    validates :name, uniqueness: true, if: -> { name.present? }

    before_validation :set_name_from_url, if: -> { name.blank? && url.present? }

    private

    def set_name_from_url
      self.name = url
    end
  end
end
