class GroupsController < ApplicationController
  before_action :group_auth_check, only: [ :edit, :update, :destroy ]

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
      flash[:success] = "#{@group.name} successfully created."
      redirect_to groups_path
    else
      flash[:alert] = "Failed to create group!"
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      flash[:success] = "#{@group.name} successfully updated."
      redirect_to groups_path
    else
      flash[:alert] = "Failed to update the group!"
      render :edit
    end
  end

  def destroy
    if @group.destroy
      flash[:success] = "Group successfully deleted."
    else
      flash[:alert] = "Failed to delete group."
    end
    redirect_to groups_path
  end

  def join
    group = Group.find_by(join_code: params[:joinCode])
    if group
      membership = GroupMembership.find_by(group: group, user: current_user)
      unless membership
        GroupMembership.create!(group: group, user: current_user, joined_at: DateTime.now)
        flash[:success] = "#{group.name} successfully joined!"
      else
        flash[:notice] = "You are already part of #{group.name}!"
      end
    else
      flash[:alert] = "Invalid join code!"
    end
    redirect_to groups_path
  end

  def leave
    group = Group.find(params[:id])
    if group
      membership = GroupMembership.find_by(group: group, user: current_user)
      if membership
        membership.destroy
        flash[:success] = "You have successfully left #{group.name}!"
      end
    else
      flash[:alert] = "Group not found. Please try again."
    end
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :description, :visibility)
  end

  def group_auth_check
    @group = Group.find(params[:id])
    unless @group.owner == current_user
      flash[:alert] = "You aren't authorized to perform this action!"
      Rails.logger.warn("Illegal action attempted on group #{@group.id}!!")
      redirect_to groups_path
    end
  end

end
