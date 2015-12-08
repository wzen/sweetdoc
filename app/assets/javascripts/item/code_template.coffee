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

    # アイテム用のテンプレートHTMLを読み込み
    # @param [Object] item アイテムオブジェクト
    # @return [String] HTML
    createItemElement: (item) ->
      contents = ''
      if item instanceof CanvasItemBase
        contents = """
          <canvas id="#{item.canvasElementId()}" class="canvas context_base" ></canvas>
        """
      else if item instanceof CssItemBase
        contents = """
          <div type="button" class="css_item_base context_base"><div></div></div>
        """
      else if item instanceof PreloadItemImage
        contents = """
          <img  />
        """

      return """
        <div id="#{item.id}" class="item draggable resizable" style="position: absolute;top:#{item.itemSize.y}px;left:#{item.itemSize.x}px;width:#{item.itemSize.w }px;height:#{item.itemSize.h}px;z-index:#{Common.plusPagingZindex(item.zindex)}"><div class="item_wrapper"><div class='item_contents'>#{contents}</div></div></div>
      """

    # グリッド線のテンプレートHTMLを読み込み
    # @param [Integer] top HTMLを設置するY位置
    # @param [Integer] left HTMLを設置するX位置
    # @return [String] HTML
    createGridElement: (top, left) ->
      return """
          <div class="#{WorktableSetting.Grid.SETTING_GRID_ELEMENT_CLASS}" style="position: absolute;top:#{top}px;left:#{left}px;width:#{WorktableSetting.Grid.GRIDVIEW_SIZE}px;height:#{WorktableSetting.Grid.GRIDVIEW_SIZE}px;z-index:#{Common.plusPagingZindex(Constant.Zindex.GRID)}"><canvas class="#{WorktableSetting.Grid.SETTING_GRID_CANVAS_CLASS}" class="canvas" width="#{WorktableSetting.Grid.GRIDVIEW_SIZE}" height="#{WorktableSetting.Grid.GRIDVIEW_SIZE}"></canvas></div>
        """
  @get: ->
    instance ?= new Temp()
    return instance
