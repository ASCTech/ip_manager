class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_shibboleth
  
  rescue_from CanCan::AccessDenied do |exception|
    render :text => "You are not authorized to view this page", :layout => 'application', :status => 403
  end
end
