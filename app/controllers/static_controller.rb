class StaticController < ApplicationController
  def options
    
  end
  
  def admin
    
  end
  
  def logout
    reset_session
    @current_user = nil
  end
end
