class ItemJsController < ApplicationController
  def index
    @item_path = params['itemPath']
    render json: render_to_string(partial: 'index', locals: { item_path: @item_path })
  end

  def get_lack_js(item_list)
    item_js = []
    item_list.each do |item|
      item_js.push(render_to_string(partial: 'index', locals: { item_path: @item_path }))
    end
    return item_js
  end
end
