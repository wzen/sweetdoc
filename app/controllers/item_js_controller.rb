class ItemJsController < ApplicationController

  def index
    item_path = params['itemPath']
    render json: ItemJs.new.get_lack_js(item_path)
  end

end
