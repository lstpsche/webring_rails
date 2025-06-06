module Webring
  class Member < ApplicationRecord
    extend Webring::Navigation

    UID_LENGTH = 16 # 32-character hex string

    validates :url, presence: true, uniqueness: true
    validates :name, presence: true, uniqueness: true
    validates :uid, presence: true, uniqueness: true, length: { is: UID_LENGTH * 2 }

    before_validation :generate_uid, if: -> { uid.blank? }

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
  end
end
