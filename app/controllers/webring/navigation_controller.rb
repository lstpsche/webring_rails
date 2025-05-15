module Webring
  class NavigationController < ApplicationController
    # GET /webring/next
    def next
      # Add your navigation logic here
      # Example: @next_member = Webring::Member.approved.where("id > ?", params[:current_id]).first
    end

    # GET /webring/previous
    def previous
      # Add your navigation logic here
      # Example: @previous_member = Webring::Member.approved.where("id < ?", params[:current_id]).last
    end

    # GET /webring/random
    def random
      # Add your navigation logic here
      # Example: @random_member = Webring::Member.approved.order("RANDOM()").first
    end
  end
end
