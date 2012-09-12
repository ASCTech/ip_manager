class UsersController < ApplicationController
  load_and_authorize_resource
  
  #def index
  #  redirect_to :action => 'edit', :id => current_user.id
  #end
  
  def edit
    
  end
  
  def update
    if current_user.update_attributes(params[:user])
      redirect_to :action => 'edit', :id => current_user.id
    end
  end
  
end
