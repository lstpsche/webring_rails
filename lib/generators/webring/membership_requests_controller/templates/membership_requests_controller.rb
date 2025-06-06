module Webring
  class MembershipRequestsController < ApplicationController
    def new
      @membership_request = MembershipRequest.new
    end

    def create
      @membership_request = MembershipRequest.new(membership_request_params)

      if @membership_request.save
        redirect_to root_path, notice: 'Your membership request has been submitted!'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def membership_request_params
      params.require(:membership_request).permit(:name, :url, :callback_email, :description)
    end
  end
end
