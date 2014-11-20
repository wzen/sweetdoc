class ItemJsController < ApplicationController
  def index
    @item_name = params['itemName']
    render :layout => false
  end
end
