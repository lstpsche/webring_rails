module Webring
  class NavigationController < ApplicationController
    before_action :find_member, only: %i[next previous]
    before_action :ensure_members_exist, :check_member_exists, only: [:random]

    # GET /webring/next
    def next
      next_member = Webring::Member.find_next(@member.id)

      redirect_to next_member.url, allow_other_host: true
    end

    # GET /webring/previous
    def previous
      previous_member = Webring::Member.find_previous(@member.id)

      redirect_to previous_member.url, allow_other_host: true
    end

    # GET /webring/random
    def random
      random_member = Webring::Member.find_random(source_member_id: permitted_params[:source_member_id])
      redirect_to random_member.url, allow_other_host: true
    end

    private

    def permitted_params
      params.permit(:source_member_id)
    end

    def find_member
      @member = Webring::Member.find_by(id: permitted_params[:source_member_id])
      return if @member

      render plain: 'Member not found', status: :not_found
    end

    def check_member_exists
      member_id = permitted_params[:source_member_id]
      return unless member_id.present? && !Webring::Member.exists?(id: member_id)

      render plain: 'Member not found', status: :not_found
    end

    def ensure_members_exist
      return if Webring::Member.exists?

      render plain: 'No members in the webring', status: :not_found
    end
  end
end
