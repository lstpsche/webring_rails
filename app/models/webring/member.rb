module Webring
  class Member < ApplicationRecord
    validates :url, presence: true, uniqueness: true
    validates :name, uniqueness: true, if: -> { name.present? }

    before_validation :set_name_from_url, if: -> { name.blank? && url.present? }

    # Find the next member in the webring after the current one
    # If current member is the last, return the first member (ring concept)
    def self.find_next(member)
      next_member = where('id < ?', member.id).order(id: :desc).first
      next_member || order(id: :desc).first
    end

    # Find the previous member in the webring before the current one
    # If current member is the first, return the last member (ring concept)
    def self.find_previous(member)
      previous_member = where('id > ?', member.id).order(id: :asc).first
      previous_member || order(id: :asc).first
    end

    # Find a random member, excluding the current one if provided
    # If current member is the only one, return it
    def self.find_random(source_member_id: nil)
      return order('RANDOM()').first if source_member_id.blank?

      members = where.not(id: source_member_id)

      if members.exists?
        members.order('RANDOM()').first
      else
        # If only one member exists (the current one), return it
        find_by(id: source_member_id)
      end
    end

    private

    def set_name_from_url
      self.name = url
    end
  end
end
