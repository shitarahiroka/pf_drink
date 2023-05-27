class ProfilesController < ApplicationController
    def show;end

    def edit;end

    def update
        if @user.update(user_params)
            redirect_to profile_path,  success: 'defaults.message.updated'
        else
            flash.now['danger'] = 'defaults.message.not_updated'
            render :edit
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
