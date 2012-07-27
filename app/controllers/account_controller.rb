#ACCOUNT CONTROLLER
#LAST UPDATED BY: RYAN K SANDERS
#LAST UPDATED ON: November 20, 2011
#DESCRIPTION
#This controller takes care of all actions that the account model will ever carry out.

#Takes care of password encryption.  Encryption algoritum used is MD5 hashing (Message-Digest Algorithm is a widely used cryptographic hash function that produces a 128-bit (16-byte) hash value)
#see http://en.wikipedia.org/wiki/MD5 for more info
require 'digest/md5'

#NOTE:  All methods/functions in this class are 'actions' of the account model.  The word action, function and method are used in this documentaion but mean the same thing.

#Notice that this class is a child of the Application controller, all actions (methods) of the applciation controller will also be for the use of the Account controller
class AccountController < ApplicationController

  #Tells Rails to use the defualt layout defied in  ../views/layouts/dynamte_default_layout.html.erb
  #layout "application"

  #ACTION: add
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Adds an account to the database
  #ONLY ADMINS CAN COMPLETE ACTION: YES
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #they are not logged in - redirects to login
  #they are not an administrator - redirects to login_success
  #the data entered was empty -redirects to view_all
  #the username of the new account already exists in the database - redirects to view_all
  def add

    #BEGIN ERROR CHECKING
    if session[:is_authenticated] == false
      flash[:error] = t :you_must_be_logged_in_to_add_a_user
      redirect_to :action => "login"
    elsif session[:account].is_admin == false
      flash[:error] = t :you_must_be_an_administrator_to_add_a_user
      redirect_to :action => "login"
    elsif params[:name] == "" or params[:username] == "" or params[:password] == ""
      flash[:error] = t :the_data_you_entered_was_not_valid
      redirect_to :action => "view_all"
    elsif Account.username_exits(params[:username])
      flash[:error] = t :the_username_already_exists_try_another_one
      redirect_to :action => "view_all"
    else
      #END ERROR CHECKING

      #BEGIN ACTION
      account = Account.create do |a|
        a.name = params[:name]
        a.username = params[:username]
        a.password = Digest::MD5.hexdigest(params[:password])
        a.is_admin = params[:is_admin]
        a.theme = "black"
        if a.is_admin == true
          a.is_admin = true
        else
          a.is_admin = false
        end
      end

      #ACTION COMPLETED - INFORM USER AND REDIRECT
      flash[:notice] = t :account_was_created_successfully
      redirect_to :action => "view_all"

    end
  end

  #ACTION: view_all
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Adds an account to the database
  #ONLY ADMINS CAN COMPLETE ACTION: YES
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #they are not logged in - redirects to login
  def view_all

    #BEGIN ERROR CHECKING
    if session[:is_authenticated] == false
      flash[:error] = t :you_must_be_logged_in_to_preform_this_action
      redirect_to :action => "login"
    elsif session[:account].is_admin == false
      flash[:error] = t :you_must_be_an_administrator_to_view_all_accounts
      redirect_to :action => "login"
    end
    #ERROR CHECKING COMPLETE
    @accounts = Account.find(:all)
  end

  #ACTION: first_time_checker
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Checks to see if this is the first time Dynamote is being used.  If so the user is assumed to be the admin and is redirected to the Admin setup page.
  #ONLY ADMINS CAN COMPLETE ACTION: YES (Admin assumed)
  def first_time_checker
    begin
      account = Account.find(1)
      redirect_to(:controller => 'account', :action=>'login')
    rescue ActiveRecord::RecordNotFound => e
      redirect_to(:controller => 'account', :action=>'first_time')
    end
  end

  #ACTION: add_admin
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Prepairs the add_admin page (Does not carry out the action of adding the admin to the database)
  #ONLY ADMINS CAN COMPLETE ACTION: YES
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #there already is an account in the database - redirects to login
  def add_admin
    begin
      account = Account.find(1)
      flash[:error] = t :to_complete_this_action_no_account_may_be_in_the_database
      redirect_to :action => "login"
    rescue ActiveRecord::RecordNotFound => e
    end
  end

  #ACTION: do_add_admin
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Adds the first admin to the database.  This action can only be called once (unless Dynamote is reset)
  #ONLY ADMINS CAN COMPLETE ACTION: YES
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #there already is an account in the database - redirects to login
  def do_add_admin
    if params[:name] == "" or params[:username] == "" or params[:password] == ""
      flash[:error] = t :the_data_you_entered_was_not_valid
      redirect_to :action => "add_admin"
    else
      account = Account.create do |a|
        a.id = 1
        a.name = params[:name]
        a.username = params[:username]
        a.password = Digest::MD5.hexdigest(params[:password])
        a.is_admin = true
        a.theme = "black"
      end
      session[:is_authenticated] = true
      session[:account] = account
      flash[:notice] = t :admin_account_created
      redirect_to :action => "login_success"
    end
  end

  #ACTION: delete
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Removes an account to the database
  #ONLY ADMINS CAN COMPLETE ACTION: YES
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #they are not logged in - redirects to login
  #they are not an administrator - redirects to login_success
  #the account could not be loaded -redirects to view_all
  #the username of the new account already exists in the database - redirects to view_all
  #the user is trying to delete the first account created - this account has importance and can only be deleted by reset Dynamote - redirects to view_all
  #the user tries to delete there own account - redirects to view_all
  def delete
    @account = Account.find(params[:id])
    if !@account
      flash[:error] = t :an_error_happened_while_fetching_account_data
      redirect_to :action => "view_"
    end
    if session[:is_authenticated] == false
      flash[:error] = t :you_must_be_logged_in_to_delete_an_account
      redirect_to :action => "login"
    elsif session[:account].is_admin == false
      flash[:error] = t :you_must_be_an_administrator_to_delete_a_user
      redirect_to :action => "login_success"
    elsif @account.id == 1
      flash[:error] = t :you_cannot_delete_the_first_admin_account
      redirect_to :action => "view_all"
    elsif @account.id == session[:account].id
      flash[:error] = t :you_cannot_delete_your_own_account_logout_and_have_another_admin_complete_this_task
      redirect_to :action => "view_all"
    else
      @account.destroy()
      flash[:notice] = "Account was deleted"
      redirect_to :action => "view_all"
    end
  end

  #ACTION: edit
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Prepairs the view of the Edit action
  #ONLY ADMINS CAN COMPLETE ACTION: FALSE
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #the account of the current session user can not be found in the database - redirects to logout
  def edit
    begin
      @account = Account.find(session[:account].id)
      if !@account
        flash[:error] = t :an_error_happened_while_fetching_your_account_data_please_re_login
        redirect_to :action => "logout_no_flash"
      end
    rescue ActiveRecord::RecordNotFound => e
      flash[:error] = t :an_error_happened_you_are_being_logged_out
      redirect_to :action => "logout_no_flash"
    end
  end

  #ACTION: do_edit
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Edits the account of the current session user
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #they are not logged in - redirects to login
  #they are not an administrator - redirects to login_success
  #the data entered was empty -redirects to view_all
  #the username of the new account already exists in the database - redirects to view_all
  def do_edit
    @account = Account.find(session[:account].id)
    if session[:is_authenticated] == false
      flash[:error] = t :you_must_be_logged_in_to_edit_an_account
      redirect_to :action => "login"
    elsif !@account
      flash[:error] = t :an_error_happened_while_fetching_your_account_data_please_re_login
      redirect_to :action => "logout_no_flash"
    elsif params[:old_password] != "" && Digest::MD5.hexdigest(params[:old_password]) != @account.password
      flash[:error] = t :new_password_does_not_match_the_old_password
      redirect_to :action => "edit"
    elsif params[:name] == ""
      flash[:error] = t :name_field_must_not_be_empty
      redirect_to :action => "edit"
    else
      if params[:locale] == "en" || params[:locale] == "pirate" || params[:locale] == "sp" || params[:locale] == "fr"
        @account.locale = params[:locale]
        I18n.locale = params[:locale]
      end
      if params[:theme] == "black" || params[:theme] == "blue" || params[:theme] == "green" || params[:theme] == "white" || params[:theme] == "orange" || params[:theme] == "purple" || params[:theme] == "rainbow" || params[:theme] == "np"
        @account.theme = params[:theme]
      end
      if params[:old_password] != "" && Digest::MD5.hexdigest(params[:old_password]) == @account.password
        @account.password = Digest::MD5.hexdigest(params[:new_password])
      end
      if params[:name] != ""
        @account.name = params[:name]
      end
      @account.save()
      session[:account] = @account
      flash[:notice] = t :your_account_info_has_been_updated
      redirect_to :action => "edit"
    end
  end

  #ACTION: login
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Prepairs the view of the login page
  def login
    if session[:is_authenticated]
      redirect_to :controller=>"home", :action => "index"
    end
  end

  #ACTION: logout_no_flash
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Logouts out the current session user without telling them
  def logout_no_flash
    session[:account] = nil
    session[:is_authenticated] = false
    redirect_to :action => "login"
  end

  #ACTION: do_login
  #Author: Ryan K Sanders
  #DESCRIPTION: Logs the current session user in
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #login was not successful (perhaps username and password were wrong) - redirects to login
  def do_login
    account = Account.authenticate(params[:username], params[:password])
    if account
      session[:is_authenticated] = true
      session[:account] = account
      flash[:notice] = t :you_have_successfully_logged_in
      redirect_to :controller=>"home", :action => "index"
    else
      flash[:error] = t :login_unsuccessful
      redirect_to :back
    end
  end

  #ACTION: login_success
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Prepairs the home page for the current logged in user
  def login_success
	redirect_to :controller=>"home", :action => "index"
  end

  #ACTION: logout
  #Author: Ryan K Sanders
  #DESCRIPTION: Logs out the current session user
  def logout
    session[:account] = nil
    session[:is_authenticated] = false
    flash[:notice] = t :you_have_successfully_logged_out
    redirect_to :controller=>"home", :action => "index"
  end

  #ACTION: reset
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Resets Dynamote
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #they are not logged in - redirects to login
  #they are not an administrator - redirects to login_success
  def reset
    if session[:is_authenticated] == false
      flash[:error] = t :you_must_be_logged_in_to_reset_dynamote
      redirect_to :action => "login"
    elsif session[:account].is_admin == false
      flash[:error] = t :you_must_be_an_administrator_to_reset_dynamote
      redirect_to :action => "login"
    else
      session[:account] = nil
      session[:is_authenticated] = false
      @accounts = Account.find(:all)
      @accounts.each do |account|
        account.destroy
      end
      @accounts = Device.find(:all)
      @accounts.each do |account|
        account.destroy
      end
      flash[:notice] = "Dyanmote Was Reset"
      redirect_to root_url
    end
  end
end

