class NetworksController < ApplicationController
    def index
        #@networks = Network.all
    end
    
    def show
        @network = Network.find(params[:id])
    end
    
    def new
        
    end
    
    def edit
        @network = Network.find(params[:id])
    end
end
