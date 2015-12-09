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
