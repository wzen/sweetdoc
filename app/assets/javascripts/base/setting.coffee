class Setting
  if gon?
    # 定数
    constant = gon.const

    class @PageValueKey
      @ROOT = 'setting'
      # @property [String] grid グリッド線
      @grid = 'grid'

  @SETTING_GRID_ID = 'setting_grid'

  # グリッド線描画
  @drawGrid : (doDraw) ->
    color = 'black'
    stepx = 50
    stepy = 50

    context = document.getElementById("#{@SETTING_GRID_ID}").getContext('2d');
    if context? && doDraw == false
      # 削除
      $("##{@SETTING_GRID_ID}").remove()
    else if !context? && doDraw
      # 描画
      $(ElementCode.get().createGridElement()).appendTo('#scroll_inside')
      context = document.getElementById("#{@SETTING_GRID_ID}").getContext('2d');
      context.strokeStyle = color;
      context.lineWidth = 0.5;
      emt = $("##{@SETTING_GRID_ID}")
      emt.css('z-index', Constant.Zindex.GRID)

      for i in [stepx + 0.5 .. context.canvas.width] by stepx
        context.beginPath()
        context.moveTo(i, 0)
        context.lineTo(i, context.canvas.height)
        context.stroke()

      for i in [stepy + 0.5 .. context.canvas.height] by stepy
        context.beginPath()
        context.moveTo(0, i)
        context.lineTo(context.canvas.width, i)
        context.stroke()
