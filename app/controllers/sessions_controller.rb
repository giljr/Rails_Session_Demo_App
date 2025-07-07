class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    # just render the form
  end

  def create
    username = params[:username]
    token    = params[:token]

    unless token.present?
      render plain: "❌ No token provided", status: :bad_request and return
    end

    cookies[:kc_access_token_plain] = {
      value: token,
      httponly: true,
      secure: Rails.env.production?
    }

    session[:username] = username
    session[:kc_access_token_signed] = token

    redirect_to root_path
    # render plain: "✅ Logged in as #{username}. JWT stored in cookies & session."
  end

  def show
    @username = session[:username]
    @token    = session[:kc_access_token_signed]

    respond_to do |format|
      if @username && @token
        format.html { render :show }
      else
        format.html { render :show, status: :unauthorized }
      end
    end
  end


  def destroy
    reset_session
    cookies.delete(:kc_access_token_plain)
    cookies.delete(:_session_demo_app_session)
    redirect_to root_path, notice: "✅ Logged out. Session & cookies cleared."
  end
end
