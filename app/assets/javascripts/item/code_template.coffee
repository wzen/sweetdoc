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
      if obj instanceof CanvasItemBase
        return """
          <div id="#{obj.id}" class="item draggable resizable" style="position: absolute;top:#{obj.itemSize.y}px;left:#{obj.itemSize.x}px;width:#{obj.itemSize.w }px;height:#{obj.itemSize.h}px;z-index:#{Common.plusPagingZindex(obj.zindex)}"><canvas id="#{obj.canvasElementId()}" class="arrow canvas" ></canvas></div>
        """
      else if obj instanceof CssItemBase
        return """
          <div id="#{obj.id}" class="item draggable resizable" style="position: absolute;top:#{obj.itemSize.y}px;left:#{obj.itemSize.x}px;width:#{obj.itemSize.w }px;height:#{obj.itemSize.h}px;z-index:#{Common.plusPagingZindex(obj.zindex)}"><div type="button" class="css3button"><div></div></div></div>
        """

    createGridElement: (top, left) ->
      return """
          <div class="#{Setting.Grid.SETTING_GRID_ELEMENT_CLASS}" style="position: absolute;top:#{top}px;left:#{left}px;width:#{Setting.Grid.GRIDVIEW_SIZE}px;height:#{Setting.Grid.GRIDVIEW_SIZE}px;z-index:#{Common.plusPagingZindex(Constant.Zindex.GRID)}"><canvas class="#{Setting.Grid.SETTING_GRID_CANVAS_CLASS}" class="canvas" width="#{Setting.Grid.GRIDVIEW_SIZE}" height="#{Setting.Grid.GRIDVIEW_SIZE}"></canvas></div>
        """
  @get: ->
    instance ?= new Temp()
    return instance
