module Webring
  class MembersController < ApplicationController
    before_action :set_member, only: %i[show edit update destroy]

    # GET /webring/members
    def index
      @members = Member.all.order(id: :desc)
    end

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
        redirect_to @member, notice: 'Member was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /webring/members/1
    def update
      if @member.update(member_params)
        redirect_to @member, notice: 'Member was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /webring/members/1
    def destroy
      @member.destroy

      redirect_to members_url, notice: 'Member was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:name, :url)
    end
  end
end
