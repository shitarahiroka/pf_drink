class ProfilesController < ApplicationController
    def show
        @user = User.find(current_user.id)
        @caffeine_limit = calculate_caffeine_limit(@user)
    end

    def edit
        @user = User.find(current_user.id)
    end

    def update
        @user = current_user
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

    def calculate_caffeine_limit(user)
        if user.weight.nil? || user.age.nil?
            '未設定'
        elsif user.age.between?(13, 18)
            '100mg'
        else
            weight_in_kg = user.weight.to_f
            caffeine_limit = (6 * weight_in_kg).round(2)
            "#{caffeine_limit}mg"
        end
    end
end
