class AjaxController < ApplicationController
layout "blank"  
  def devices
    
  end
  
  def remotes
  
  end
  
  def update
    require 'net/http'

    if params[:type] == 'button'
      if params[:user_action] == 'add'
        # update db with icon_id , pos_x and pos_y
        @confirmation = Button.create(:size_x=>0,:size_y=>0,:pos_x=>params[:pos_x],:pos_y=>params[:pos_y],:icon_id=>params[:icon_id],:macro_id=>0,:remote_id=>params[:remote_id]);
        # change 'update' view to display this button that was added 
        render :inline => "<id><%= @confirmation.id %></id>"
      end
      if params[:user_action] == 'move'
        @confirmation = Button.update(params[:button_id], :pos_x=>params[:pos_x], :pos_y=>params[:pos_y])
        render :inline => "<id><%= @confirmation.id %></id>"
      end
      if params[:user_action] == 'remove'
        @confirmation = Button.delete(params[:button_id])
        render :inline => "<empty></empty>"
      end
    end
  end
end