# Css雛形
class CssCode
  instance = null
  # テンプレート
  # @private
  class Temp

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
      if obj.constructor.ITEM_ID == Constant.ItemId.ARROW
        return """
          <div id="#{obj.id}" class="item draggable resizable" style="position: absolute;top:#{obj.itemSize.y}px;left:#{obj.itemSize.x}px;width:#{obj.itemSize.w }px;height:#{obj.itemSize.h}px;z-index:#{obj.zindex}"><canvas id="#{obj.canvasElementId()}" class="arrow canvas" ></canvas></div>
        """
      else if obj.constructor.ITEM_ID == Constant.ItemId.BUTTON
        return """
          <div id="#{obj.id}" class="item draggable resizable" style="position: absolute;top:#{obj.itemSize.y}px;left:#{obj.itemSize.x}px;width:#{obj.itemSize.w }px;height:#{obj.itemSize.h}px;z-index:#{obj.zindex}"><div type="button" class="css3button"><div></div></div></div>
        """

    createGridElement: ->
      return """
          <canvas id="#{Setting.SETTING_GRID_CANVAS_ID}" class="canvas"></canvas>
        """
  @get: ->
    instance ?= new Temp()
    return instance