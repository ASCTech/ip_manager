class NetworksController < ApplicationController
    def index
        @networks = Network.all
    end
    
    def show
        @network = Network.find(params[:id])
        
        respond_to do |format|
            format.html
            format.json {render :json => @network}
            format.xml {render :xml => @network}
        end
    end
    
    def new
        
    end
end
