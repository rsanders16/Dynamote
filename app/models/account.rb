#CLASS: Account
#LAST UPDATED BY: RYAN K SANDERS
#LAST UPDATED ON: November 20, 2011
#DESCRIPTION: Defines functions for the Account model

class Account < ActiveRecord::Base

  #FUCTION: authenticate
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Given a username and password, this function checks to see if the username exists in the account table and if that accounts, password matches the password param.
  #RETURNS: TRUE if the username and password match an account the database
  def self.authenticate(username, password)
    where("username = ? AND password = ?", username, Digest::MD5.hexdigest(password)).first
  end

  #FUCTION: username_exists
  #LAST UPDATED BY: RYAN K SANDERS
  #LAST UPDATED ON: November 20, 2011
  #DESCRIPTION: Given a username this function checks to see if the username exists in the account table.
  #RETURNS: TRUE if the username match an account the database
  def self.username_exits(username)
    where("username = ?", username).first
  end

end
