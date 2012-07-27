class HomeController < ApplicationController
  def index
	if session[:is_authenticated] != true 
		redirect_to :controller => "account", :action => "login"
	elsif session["layout"] == "mobile"
		redirect_to :controller => "remote", :action => "index"
	else
		redirect_to :controller => "builder", :action => "index"
	end
  end
  
  #FUCTION: set_layout
  #LAST UPDATED BY: SYLVAIN HEINIGER
  #LAST UPDATED ON: December 15, 2011
  #DESCRIPTION: Sets the layout according to the value of mobile session field
  def set_layout
    session["layout"] = (params[:mobile] == "1" ? "mobile" : "normal")
    redirect_to :controller => "remote", :action => "index"
  end
end
