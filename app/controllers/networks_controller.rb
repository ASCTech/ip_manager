class NetworksController < ApplicationController
  require 'ipaddr'
  respond_to :js, :html, :xls
  
  def index
    respond_to do |format|
      #for xls, we actually want to export all devices from all networks
      format.xls do
        book = Spreadsheet::Workbook.new
        Network.all.each do |n|
          sheet = book.create_worksheet
          ToXls::Writer.new(n.devices, :name => n.cidr_and_description).write_sheet(sheet)
        end
        io = StringIO.new
        
        send_data book.write("export.xls")
      end
    end
  end
  
  def show
    begin
      @networks = Building.find(params[:building_id]).networks
      @network = @networks.first
      @building_id = params[:building_id]
    rescue
      @networks = Network.all
      @network = Network.find(params[:id])
      @building_id = ""
    end
    respond_to do |format|
      format.js do
      end
      format.html do
      end
    end
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
