class LineLoginController < ApplicationController
    before_action :set_user, only: %i[callback]
    require 'json'
    require 'typhoeus'
    require 'securerandom'

    def login
      session[:state] = SecureRandom.urlsafe_base64

      base_authorization_url = 'https://access.line.me/oauth2/v2.1/authorize'
      response_type = 'code'
      client_id = ENV['LINE_KEY']
      redirect_uri = CGI.escape(line_login_callback_url)
      state = session[:state]
      scope = 'profile%20openid'

      authorization_url = "#{base_authorization_url}?response_type=#{response_type}&client_id=#{client_id}&redirect_uri=#{redirect_uri}&state=#{state}&scope=#{scope}"
      redirect_to authorization_url, allow_other_host: true
    end

    def callback
      if params[:state] == session[:state]
        line_user_id = get_line_user_id(params[:code])
        user = User.find_or_initialize_by(line_user_id: line_user_id)
        @user.line_user_id = user.line_user_id
        if @user.save
          redirect_to line_login_add_friend_path, success: t('.success')
        else
          redirect_to profile_path, danger: t('.fail')
        end
      else
        redirect_to profile_path, warning: t('.unauthorized_access')
      end
    end
  
    def add_friend; end
  
    private
  
    def get_line_user_id(code)
      line_user_id_token = get_line_user_id_token(code)
      if line_user_id_token.present?
        url = 'https://api.line.me/oauth2/v2.1/verify'
        options = {
          body: {
            id_token: line_user_id_token,
            client_id: ENV['LINE_KEY']
          }
        }
  
        response = Typhoeus::Request.post(url, options)
  
        if response.code == 200
          JSON.parse(response.body)['sub']
        else
          nil
        end
      else
        nil
      end
    end
  
    def get_line_user_id_token(code)
      url = 'https://api.line.me/oauth2/v2.1/token'
      redirect_uri = line_login_callback_url
  
      options = {
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        },
        body: {
          grant_type: 'authorization_code',
          code: code,
          redirect_uri: redirect_uri,
          client_id: ENV['LINE_KEY'],
          client_secret: ENV['LINE_SECRET']
        }
      }
      response = Typhoeus::Request.post(url, options)
  
      if response.code == 200
        JSON.parse(response.body)['id_token']
      else
        nil
      end
    end
  
    def set_user
      @user = User.find(current_user.id)
    end
  end