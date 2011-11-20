class ApplicationController < ActionController::Base
  protect_from_forgery

  # https://github.com/ryanb/cancan/wiki/Exception-Handling
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def layout
    request.xhr? ? false : 'application'
  end

  def logged_in?
    current_user.present?
  end
  helper_method :logged_in?

  # Required by cancan (https://github.com/ryanb/cancan) and Blog engine
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  # def redirect_unless_admin
  #   if !logged_in?
  #     set_session_redirect
  #     redirect_to main_app.login_path, :notice => 'Please log in.'
  #   elsif !current_user.admin?
  #     set_session_redirect
  #     redirect_to main_app.root_path, :notice => 'You do not have permission to view this page.'
  #   end
  # end

  # Blog engine requirement
  def blog_user_can?(action, object)
    # The blog can? is modeled after cancan which, ironically, is what we use. Hmm, how convenient
    can?(action, object)
  end
  helper_method :blog_user_can?

  # Team engine requirement...same thing as blog_user_can? above
  def team_user_can?(action, object)
    can?(action, object)
  end
  helper_method :team_user_can?


  def set_session_redirect
    session[:redirect] = [request.path, Time.now.to_i]
  end

  def get_session_redirect
    return unless session[:redirect].present?

    path, expiry = *session[:redirect]
    session[:redirect] = nil
    expiry.to_i > 10.minutes.ago.to_i ? path : nil
  end

end
