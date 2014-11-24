class ItemJsController < ApplicationController

  def self.get_lack_js(item_path)
    return "#{Rails.application.config.assets.prefix}/item/#{item_path}.js"
  end

  def self.get_lack_js_list(item_path_list)
    item_js = []
    item_path_list.each do |item_path|
      item_js.push(self.get_lack_js(item_path))
    end
    return item_js
  end

  def index
    item_path = params['itemPath']
    render json: self.class.get_lack_js(item_path)
  end

end
