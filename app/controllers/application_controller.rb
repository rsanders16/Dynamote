# ACCOUNT CONTROLLER
# LAST UPDATED BY: JOHN P RYAN
# LAST UPDATED ON: November 20, 2011
# 
# This controller takes care of global actions.
# All other controllers inherit all methods/functions from this class

class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :detect_browser
  before_filter :check_connect
  before_filter :set_locale


  def check_connect
	if session[:is_authenticated] == false && params[:action] != "login" && params[:action] != "do_login" && params[:action] != "set_layout" && params[:action] != "add_admin" && params[:action] != "do_add_admin"
		redirect_to :controller => "account", :action => "login"
	end
  end

  #FUCTION: set_locale
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Sets the locale of the application based on the current logged in user

  def set_locale
    if session[:is_authenticated] == false|| I18n.locale = session[:account] == nil
      I18n.locale = I18n.default_locale
    else
      I18n.locale = session[:account].locale || I18n.default_locale
    end
  end
  
  #FUCTION: detect_browser
  #LAST UPDATED BY: SYLVAIN HEINIGER
  #LAST UPDATED ON: December 7, 2011
  #DESCRIPTION: Detects browser and set the right layout
  private
  MOBILE_BROWSERS = ["android", "ipod", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]

  def detect_browser
    layout = selected_layout
    return layout if layout
    agent = request.headers["HTTP_USER_AGENT"].downcase
    MOBILE_BROWSERS.each do |m|
      if agent.match(m)
		session["layout"] = "mobile"
		return "mobile" 
      end
    end
    session["layout"] = "normal"
    return "application"
  end
  
  #FUCTION: selected_layout
  #LAST UPDATED BY: SYLVAIN HEINIGER
  #LAST UPDATED ON: December 7, 2011
  #DESCRIPTION: returns selected layout (mobile or regular)
  def selected_layout
    session.inspect # force session load
    if session.has_key? "layout"
      return (session["layout"] == "mobile") ? 
        "mobile" : "application"
    end
    return nil
  end
end
