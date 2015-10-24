class CodingController < ApplicationController
  def item
    # Constantの設定
    init_const

    lang = params[:lang]
    if lang == Const::Coding::Lang::JAVASCRIPT
      redirect_to action: 'item_by_javascript'
    elsif lang == Const::Coding::Lang::COFFEESCRIPT
      redirect_to action: 'itme_by_coffeescript'
    end

    # Default
    redirect_to action: 'item_by_javascript'
  end

  def item_by_javascript
    render action: 'coding/item'
  end

  def itme_by_coffeescript
    render action: 'coding/item'
  end
end
