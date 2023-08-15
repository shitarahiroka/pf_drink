class ProfilesController < ApplicationController
  before_action :set_user
  def show
    @caffeine_limit = @user.calculate_caffeine_limit
  end

  def edit; end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, success: t('.success')
    else
      flash.now['danger'] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :name, :weight, :age, :gender, :area)
  end
end
