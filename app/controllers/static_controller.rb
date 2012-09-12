class StaticController < ApplicationController
  
  def home
    redirect_to current_user.network_id.nil? ? Network.first : Network.find(current_user.network_id)
  end
    
  def admin
    
  end
  
  def export
    
  end
  
  def logout
    reset_session
    @current_user = nil
  end
end
