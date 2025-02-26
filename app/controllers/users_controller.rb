class UsersController < ApplicationController
  def index
    head :unauthorized unless current_user&.admin?

    @users = User.order(:first_name, :last_name).page(params[:page]).per(20)
  end

  def update_role
    user = User.find(params[:id])
    role = params[:role]

    if user.update(role: role)
      redirect_to users_path, notice: "#{user.first_name} is now a #{role.capitalize}."
    else
      redirect_to users_path, alert: "Failed to update role for #{user.first_name}."
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      redirect_to users_path, notice: "#{user.first_name} is now #{user.active ? 'active' : 'inactive'}."
    else
      redirect_to users_path, alert: "Failed to update user status."
    end
  end

  def user_params
    params.require(:user).permit(:id, :active, :first_name, :last_name, :bio, :profile_picture)
  end
end