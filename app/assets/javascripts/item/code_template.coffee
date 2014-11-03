# Css雛形
class CssCode
  instance = null
  # テンプレート
  # @private
  class Temp
    # アイテム選択枠の色
    ITEM_EDIT_BORDER_COLOR = "#00FF00"

    # 選択枠スタイル
    styleSelectedBorder: ->
      return """
          border-style:solid;
          border-color:#{ITEM_EDIT_BORDER_COLOR};
       """
  @get: ->
    instance ?= new Temp()
    return instance


# HTML要素雛形
class ElementCode
  instance = null
  # テンプレート
  # @private
  class Temp
    createItemElement: (obj) ->
      if obj.constructor.ITEMTYPE == Constant.ItemType.ARROW
        return """
          <div id="#{obj.elementId()}" class="draggable resizable" style="position: absolute;top:#{obj.getSize().y}px;left:#{obj.getSize().x}px;width:#{obj.getSize().w }px;height:#{obj.getSize().h}px;z-index:#{obj.getZIndex()}"><canvas id="#{obj.canvasElementId()}" class="arrow canvas" ></canvas></div>
        """
      else if obj.constructor.ITEMTYPE == Constant.ItemType.BUTTON
        return """
          <div id="#{obj.elementId()}" class="draggable resizable" style="position: absolute;top:#{obj.getSize().y}px;left:#{obj.getSize().x}px;width:#{obj.getSize().w }px;height:#{obj.getSize().h}px;z-index:#{obj.getZIndex()}"><div type="button" class="css3button"><div></div></div></div>
        """
  @get: ->
    instance ?= new Temp()
    return instance