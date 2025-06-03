module Webring
  class NavigationController < ApplicationController
    before_action :find_member, only: %i[next previous]
    before_action :ensure_members_exist, :check_member_exists, only: [:random]
    before_action :set_cors_headers

    # GET /webring/next
    def next
      member = Webring::Member.find_next(@member.uid)

      redirect_to_member(member)
    end

    # GET /webring/previous
    def previous
      member = Webring::Member.find_previous(@member.uid)

      redirect_to_member(member)
    end

    # GET /webring/random
    def random
      member = Webring::Member.find_random(source_member_uid: permitted_params[:source_member_uid])

      redirect_to_member(member)
    end

    private

    def permitted_params
      params.permit(:source_member_uid)
    end

    def redirect_to_member(member)
      redirect_to member.url, allow_other_host: true
    end

    def find_member
      @member = Webring::Member.find_by(uid: permitted_params[:source_member_uid])
      return if @member

      render_member_not_found
    end

    def check_member_exists
      member_uid = permitted_params[:source_member_uid]
      return unless member_uid.present? && !Webring::Member.exists?(uid: member_uid)

      render_member_not_found
    end

    def ensure_members_exist
      return if Webring::Member.exists?

      render plain: 'No members in the webring', status: :not_found
    end

    def render_member_not_found
      render plain: 'Member not found', status: :not_found
    end

    def set_cors_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept'
      headers['Access-Control-Max-Age'] = '86400'
    end
  end
end
