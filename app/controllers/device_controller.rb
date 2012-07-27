#ACCOUNT CONTROLLER
#LAST UPDATED BY: RYAN K SANDERS
#LAST UPDATED ON: November 20, 2011
#DESCRIPTION
#This controller takes care of all actions that the device model will ever carry out.

#NOTE:  All methods/functions in this class are 'actions' of the account model.  The word action, function and method are used in this documentaion but mean the same thing.

#Notice that this class is a child of the Application controller, all actions (methods) of the applciation controller will also be for the use of the Account controller
class DeviceController < ApplicationController

  #Tells Rails to use the defualt layout defied in  ../views/layouts/dynamte_default_layout.html.erb
  #layout "application"

  #ACTION: do_add
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Adds a device to the database
  #ONLY ADMINS CAN COMPLETE ACTION: YES
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #they are not logged in - redirects to login
  #they are not an administrator - redirects to login_success
  #the data entered was empty -redirects to view_all
  #the device already exists in the database - redirects to view_all
  def do_add
    if session[:is_authenticated] == false
      flash[:error] = "You must be logged in to add a device"
      redirect_to :action => "login"
    elsif session[:account].is_admin == false
      flash[:error] = "You must be an administrator to add a device"
      redirect_to :action => "view_all"
    elsif params[:device_name] == "" or params[:device_type] == "0" or params[:model_number] == ""
      flash[:error] = "The data you entered was not valid"
      redirect_to :action => "view_all"
    elsif Device.device_exists(params[:model])
      flash[:error] = "The device already exists, try adding another one"
      redirect_to :action => "view_all"
    else
      device = Device.create do |a|
        a.name = params[:device_name]
        a.device_type = params[:device_type]
        a.model_number = params[:model_number]
      end
      flash[:notice] = "Device was added successfully"
      redirect_to :action => "view_all"
    end
  end

  #ACTION: edit
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Edits a device
  #ONLY ADMINS CAN COMPLETE ACTION: YES
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #they are not logged in - redirects to login
  #they are not an administrator - redirects to login_success
  #the data entered was empty -redirects to view_all
  def edit
    #Not implemetned yet
  end

  #ACTION: delete
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Deletes a device from the database
  #ONLY ADMINS CAN COMPLETE ACTION: YES
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #they are not logged in - redirects to login
  #they are not an administrator - redirects to login_success
  #the device could not be loaded - redirects to view_all
  def delete
    @device = Device.find(params[:id])
    if !@device
      flash[:error] = "An error happened while fetching account data, please try again"
      redirect_to :action => "view_all"
    end
    if session[:is_authenticated] == false
      flash[:error] = "You must be logged in to delete an account"
      redirect_to :action => "login"
    elsif session[:account].is_admin == false
      flash[:error] = "You must be an administrator to delete a device"
      redirect_to :action => "view_all"
    else
      @device.destroy()
      flash[:notice] = "Device was deleted!"
      redirect_to :action => "view_all"
    end
  end

  #ACTION: hide
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Hides a device
  #ONLY ADMINS CAN COMPLETE ACTION: NO
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #they are not logged in - redirects to login
  #the data entered was empty -redirects to view_all
  #decice could not be loaded - redirects to view_all
  def hide
    @device = Device.find(params[:id])
    if !@device
      flash[:error] = "An error happened while fetching account data, please try again"
      redirect_to :action => "view_all"
    end
    if session[:is_authenticated] == false
      flash[:error] = "You must be logged in to hide an account"
      redirect_to :action => "login"
    else
      @device.is_hidden = true
      @device.save()
      flash[:notice] = "Device was hidden"
      redirect_to :action => "view_all"
    end
  end

  #ACTION: unhide
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Unhides a device
  #ONLY ADMINS CAN COMPLETE ACTION: NO
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #they are not logged in - redirects to login
  #the data entered was empty -redirects to view_all
  #decice could not be loaded - redirects to view_all
  def unhide
    @device = Device.find(params[:id])
    if !@device
      flash[:error] = "An error happened while fetching account data, please try again"
      redirect_to :action => "view_all"
    end
    if session[:is_authenticated] == false
      flash[:error] = "You must be logged in to unhide an account"
      redirect_to :action => "login"
    else
      @device.is_hidden = false
      @device.save()
      flash[:notice] = "Device was unhidden"
      redirect_to :action => "view_all"
    end
  end

  #ACTION: view
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Preparis the view of the view device page
  #ONLY ADMINS CAN COMPLETE ACTION: NO
  def view
    #Not implemented yet
  end

  #ACTION: view_all
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Preparis the view of view_all
  #ONLY ADMINS CAN COMPLETE ACTION: NO
  #ERROR CHECKING:
  #throws an error to the user and does NOT complete the action if:
  #they are not logged in - redirects to login
  def view_all
    if session[:is_authenticated] == false
      flash[:error] = "You must be logged in to view all devices"
      redirect_to :action => "login"
    end
    @devices = Device.find(:all)
  end

  def ajax
    device_list = DeviceList.where(:modnum => params[:model_number]).first
    if(device_list == nil)
           @device_name = ""
           @device_type = ""
           render :layout => "blank"
      return
    end
    @device_name = device_list.device_name;
    @device_type = device_list.device_type;
    render :layout => "blank"
  end
end
