class NetworksController < ApplicationController
    require 'ipaddr'
    
    def index
    end
    
    def show
        @network = Network.find(params[:id])
    end
    
    def new
        
    end
    
    def edit
        @network = Network.find(params[:id])
    end
    
    def update
        @network = Network.find(params[:id])
        params[:network][:gateway] = IPAddr.new(params[:network][:gateway],Socket::AF_INET).to_i
        
        if @network.update_attributes(params[:network])
            redirect_to :action => 'show', :id => @network
        else
            redirect_to :action => 'edit', :id => @network
        end
    end
    
    def destroy
        @network = Network.find(params[:id])
        @network.buildings.destroy_all
        @network.devices.destroy_all
        @network.destroy
        
        redirect_to :action => 'show', :id => Network.first
    end
end
