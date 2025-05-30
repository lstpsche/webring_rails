module Webring
  class Member < ApplicationRecord
    extend Webring::Navigation

    UID_LENGTH = 16 # 32-character hex string

    validates :url, presence: true, uniqueness: true
    validates :name, uniqueness: true, if: -> { name.present? }
    validates :uid, presence: true, uniqueness: true, length: { is: UID_LENGTH * 2 }

    before_validation :generate_uid, if: -> { uid.blank? }
    before_validation :set_name_from_url, if: -> { name.blank? && url.present? }

    def to_param
      uid
    end

    private

    def generate_uid
      loop do
        self.uid = SecureRandom.hex(UID_LENGTH)
        break unless self.class.exists?(uid: uid)
      end
    end

    def set_name_from_url
      self.name = url
    end
  end
end
