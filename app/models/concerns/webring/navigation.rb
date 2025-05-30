module Webring
  # Requires model to have `uid` and `created_at` columns
  module Navigation
    # Find the next member in the webring after the current one
    # If current member is the last, return the first member (ring concept)
    def find_next(source_member_uid)
      source_member = find_by(uid: source_member_uid)
      return first_member_by_creation unless source_member

      find_next_member(source_member) || first_member_by_creation
    end

    # Find the previous member in the webring before the current one
    # If current member is the first, return the last member (ring concept)
    def find_previous(source_member_uid)
      source_member = find_by(uid: source_member_uid)
      return last_member_by_creation unless source_member

      find_previous_member(source_member) || last_member_by_creation
    end

    # Find a random member, excluding the current one if provided
    # If current member is the only one, return it
    def find_random(source_member_uid: nil)
      return order('RANDOM()').first if source_member_uid.blank?

      # Use exists? check to avoid loading records when not needed
      excluded_scope = where.not(uid: source_member_uid)

      if excluded_scope.exists?
        excluded_scope.order('RANDOM()').first
      else
        # if only one member exists (the current one), return it
        find_by(uid: source_member_uid)
      end
    end

    private

    def first_member_by_creation
      order(created_at: :asc).first
    end

    def last_member_by_creation
      order(created_at: :desc).first
    end

    def find_next_member(source_member)
      where('created_at > ?', source_member.created_at)
        .order(created_at: :asc)
        .first
    end

    def find_previous_member(source_member)
      where('created_at < ?', source_member.created_at)
        .order(created_at: :desc)
        .first
    end
  end
end
