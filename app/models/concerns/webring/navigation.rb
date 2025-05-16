module Webring
  # Requires model to have `id` column
  module Navigation
    # Find the next member in the webring after the current one
    # If current member is the last, return the first member (ring concept)
    def find_next(source_member_id)
      where('id < ?', source_member_id).order(id: :desc).first || order(id: :desc).first
    end

    # Find the previous member in the webring before the current one
    # If current member is the first, return the last member (ring concept)
    def find_previous(source_member_id)
      where('id > ?', source_member_id).order(id: :asc).first || order(id: :asc).first
    end

    # Find a random member, excluding the current one if provided
    # If current member is the only one, return it
    def find_random(source_member_id: nil)
      return order('RANDOM()').first if source_member_id.blank?

      members = where.not(id: source_member_id)

      if members.exists?
        members.order('RANDOM()').first
      else
        # if only one member exists (the current one), return it
        find_by(id: source_member_id)
      end
    end
  end
end
