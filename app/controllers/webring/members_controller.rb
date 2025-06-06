module Webring
  class MembersController < ::ApplicationController
    before_action :members, only: %i[index]
    before_action :member, only: %i[show edit update destroy]

    # GET /webring/members
    def index; end

    # GET /webring/members/1
    def show; end

    # GET /webring/members/new
    def new
      @member = Member.new
    end

    # GET /webring/members/1/edit
    def edit; end

    # POST /webring/members
    def create
      @member = Member.new(member_params)

      if @member.save
        redirect_to admin_panel_member_path(@member), notice: 'Member was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /webring/members/1
    def update
      if member.update(member_params)
        redirect_to admin_panel_member_path(member), notice: 'Member was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /webring/members/1
    def destroy
      member.destroy

      redirect_to admin_panel_members_url, notice: 'Member was successfully destroyed.'
    end

    private

    def members
      @members ||= Member.all.order(created_at: :desc)
    end

    def member
      @member ||= Member.find_by!(uid: params[:id])
    end

    def member_params
      params.require(:member).permit(:name, :url, :description)
    end
  end
end
