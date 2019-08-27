class Api::V1::GroupsController < ApplicationController
  before_action :set_group, only: [:show, :update, :destroy]

  # GET /groups
  def index
    if logged_in?
      @groups = current_user.groups
      render json: GroupSerializer.new(@groups), status: :ok
    else
      render json: {
        error: "You must be logged in to see groups"
      }
    end
  end

  # GET /groups/1
  def show

    render json: @group
  end

  # POST /groups
  def create
    @group = Group.new(group_params)
    @group.users << User.find_by_id(params[:group][:adminid])

    if @group.save
      render json: GroupSerializer.new(@group), status: :created
    else
      resp = {
        error: @group.errors.full_messages.to_sentence
      }
      render json: resp, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      render json: @group
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def group_params
      params.require(:group).permit(:name, :price, :code, :adminid)
    end
end
