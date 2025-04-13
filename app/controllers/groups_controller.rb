class GroupsController < ApplicationController
  before_action :group_auth_check, only: [ :edit, :update, :destroy ]
  before_action :noshow, only: [ :show ]

  def index
    @user_groups = current_user.groups

    @public_groups = Group.public_groups.where.not(id: @user_groups.select(:id))
  end

  def show
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner = current_user

    if @group.save
      redirect_to groups_path
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path
  end

  def join
    group = Group.find_by(joinCode: params[:joinCode])
    if group
      membership = GroupMembership.find_by(group: group, user: current_user)
      unless membership
        GroupMembership.create!(group: group, user: current_user, joined_at: DateTime.now)
        redirect_to groups_path
      end
    else
      redirect_to groups_path
    end
  end

  def leave
    group = Group.find(params[:id])
    if group
      membership = GroupMembership.find_by(group: group, user: current_user)
      if membership
        membership.destroy
        redirect_to groups_path
      end
    else
      redirect_to groups_path
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :description, :visibility)
  end

  def group_auth_check
    @group = Group.find(params[:id])
    unless @group.owner == current_user
      Rails.logger.warn("Illegal action attempted on group #{@group.id}!!")
      redirect_to groups_path
    end
  end

  def noshow
    redirect_to groups_path
  end

end
