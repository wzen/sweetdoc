class Setting
  if gon?
    # 定数
    constant = gon.const

    @ROOT_ID_NAME = constant.Setting.ROOT_ID_NAME
    @GRID_CLASS_NAME = constant.Setting.GRID_CLASS_NAME

    class @PageValueKey
      @ROOT = constant.PageValueKey.ST_ROOT
      @PREFIX = constant.PageValueKey.ST_PREFIX
      # @property [String] GRID グリッド線
      @GRID = 'grid'

    @SETTING_GRID_CANVAS_ID = 'setting_grid'

  # ConfigOpen時の初期化
  @initConfig: ->
    root = $("##{Setting.ROOT_ID_NAME}")

    # グリッド線
    grid = $(".#{@GRID_CLASS_NAME}", root)
    if grid? && grid.length > 0
      key = "#{@PageValueKey.PREFIX}#{Constant.PageValueKey.PAGE_VALUES_SEPERATOR}#{@PageValueKey.GRID}"
      gridValue = getSettingPageValue(key)
      grid.prop('clicked', gridValue)
      grid.off('click')
      grid.on('click', =>
        key = "#{@PageValueKey.PREFIX}#{Constant.PageValueKey.PAGE_VALUES_SEPERATOR}#{@PageValueKey.GRID}"
        gridValue = getSettingPageValue(key)
        if gridValue?
          gridValue = gridValue == 'true'
        @drawGrid(!gridValue)
      )


  # グリッド線描画
  @drawGrid : (doDraw) ->
    color = 'black'
    stepx = 12
    stepy = 12

    canvas = document.getElementById("#{@SETTING_GRID_CANVAS_ID}")
    context = null
    key = "#{@PageValueKey.PREFIX}#{Constant.PageValueKey.PAGE_VALUES_SEPERATOR}#{@PageValueKey.GRID}"
    if canvas?
      context = canvas.getContext('2d');
    if context? && doDraw == false
      # 削除
      $("##{@SETTING_GRID_CANVAS_ID}").remove()
      setSettingPageValue(key, false)

    else if !context? && doDraw
      # 描画
      $(ElementCode.get().createGridElement()).appendTo('#scroll_inside')
      context = document.getElementById("#{@SETTING_GRID_CANVAS_ID}").getContext('2d');
      context.strokeStyle = color;
      context.lineWidth = 0.5;
      emt = $("##{@SETTING_GRID_CANVAS_ID}")
      emt.css('z-index', Constant.Zindex.GRID)
      emt.attr('width', window.scrollViewSize)
      emt.attr('height', window.scrollViewSize)

      for i in [(stepx + 0.5) .. context.canvas.width] by stepx
        context.beginPath()
        context.moveTo(i, 0)
        context.lineTo(i, context.canvas.height)
        context.stroke()

      for i in [(stepy + 0.5) .. context.canvas.height] by stepy
        context.beginPath()
        context.moveTo(0, i)
        context.lineTo(context.canvas.width, i)
        context.stroke()

      setSettingPageValue(key, true)

    else
      setSettingPageValue(key, false)