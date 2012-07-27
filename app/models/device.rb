#CLASS: Account
#LAST UPDATED BY: RYAN K SANDERS
#LAST UPDATED ON: November 20, 2011
#DESCRIPTION: Defines functions for the Device model

class Device < ActiveRecord::Base

  #FUCTION: device_exists
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Given a model_number, this function checks to see if the device exists in the device table.
  #RETURNS: TRUE if the device exists in the device table in the database
  def self.device_exists(model_number)
    where("model_number = ?", model_number).first
  end

end
