class DevicesController < ApplicationController
    def index
        @devices = Devices.all
    end
    
    def show
        @device = Device.find(params[:id])
    end
    
    def new
        
    end
    
    def edit
        @device = Device.find(params[:id])
    end
    
    def update
        @device = Device.find(params[:id])
        if @device.update_attributes(params[:device])
            redirect_to(network_url(@device.network))
        end
    end
end
