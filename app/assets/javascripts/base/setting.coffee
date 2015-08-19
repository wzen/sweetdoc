class Setting
  if gon?
    # 定数
    constant = gon.const

    @ROOT_ID_NAME = constant.Setting.ROOT_ID_NAME

    class @PageValueKey
      @ROOT = constant.PageValueKey.ST_ROOT
      @PREFIX = constant.PageValueKey.ST_PREFIX

  # ConfigOpen時の初期化
  @initConfig: ->
    @Grid.initConfig()

  class @Grid

    @GRID_CLASS_NAME = constant.Setting.GRID_CLASS_NAME
    @GRID_STEP_CLASS_NAME = constant.Setting.GRID_STEP_CLASS_NAME
    @GRID_STEP_DIV_CLASS_NAME = constant.Setting.GRID_STEP_DIV_CLASS_NAME
    @SETTING_GRID_ELEMENT_ID = 'setting_grid_element'
    @SETTING_GRID_CANVAS_ID = 'setting_grid'
    @GRIDVIEW_SIZE = 10000
    @STEP_DEFAULT_VALUE = 12

    class @PageValueKey
      # @property [String] GRID グリッド線表示
      @GRID = 'grid'
      # @property [String] GRID グリッド線間隔
      @GRID_STEP = 'grid_step'

    @initConfig: ->
      root = $("##{Setting.ROOT_ID_NAME}")
      # グリッド線表示
      grid = $(".#{@GRID_CLASS_NAME}", root)
      key = "#{Setting.PageValueKey.PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}#{@PageValueKey.GRID}"
      gridValue = PageValue.getSettingPageValue(key)

      gridStep = $(".#{@GRID_STEP_CLASS_NAME}", root)
      key = "#{Setting.PageValueKey.PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}#{@PageValueKey.GRID_STEP}"
      gridStepValue = PageValue.getSettingPageValue(key)

      gridStepDiv = $(".#{@GRID_STEP_DIV_CLASS_NAME}", root)

      grid.prop('clicked', gridValue)
      grid.off('click')
      grid.on('click', =>
        key = "#{Setting.PageValueKey.PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}#{@PageValueKey.GRID}"
        gridValue = PageValue.getSettingPageValue(key)
        if gridValue?
          gridValue = gridValue == 'true'

        # グリッド間隔の有効無効を切り替え
        if !gridValue
          gridStepDiv.css('display', '')
        else
          gridStepDiv.css('display', 'none')

        @drawGrid(!gridValue)
      )

      # グリッド間隔の有効無効を切り替え
      if gridValue
        gridStepDiv.css('display', '')
      else
        gridStepDiv.css('display', 'none')

      # グリッド間隔
      if !gridStepValue?
        gridStepValue = @STEP_DEFAULT_VALUE
      $(".#{@GRID_STEP_CLASS_NAME}", root).val(gridStepValue)
      gridStep.change( =>
        key = "#{Setting.PageValueKey.PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}#{@PageValueKey.GRID}"
        value = PageValue.getSettingPageValue(key)
        if value?
          value = value == 'true'
        if value
          @drawGrid(true)
      )

    # グリッド線描画
    @drawGrid : (doDraw) ->
      canvas = document.getElementById("#{@SETTING_GRID_CANVAS_ID}")
      context = null
      key = "#{Setting.PageValueKey.PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}#{@PageValueKey.GRID}"
      if canvas?
        context = canvas.getContext('2d');
      if context? && doDraw == false
        # 削除
        $("##{@SETTING_GRID_ELEMENT_ID}").remove()
        PageValue.setSettingPageValue(key, false)
        LocalStorage.saveSettingPageValue()
      else if doDraw
        root = $("##{Setting.ROOT_ID_NAME}")
        stepInput = $(".#{@GRID_STEP_CLASS_NAME}", root)
        step = stepInput.val()
        step = parseInt(step)
        min = parseInt(stepInput.attr('min'))
        max = parseInt(stepInput.attr('max'))
        if step < min || step > max
          return

        stepx = step
        stepy = step

        if !context?
          # キャンパスを作成
          top = window.scrollContents.scrollTop() - @GRIDVIEW_SIZE * 0.5
          top -= top % stepy
          if top < 0
            top = 0
          left = window.scrollContents.scrollLeft() - @GRIDVIEW_SIZE * 0.5
          left -= left % stepx
          if left < 0
            left = 0
          $(ElementCode.get().createGridElement(top, left)).appendTo('#scroll_inside')
          context = document.getElementById("#{@SETTING_GRID_CANVAS_ID}").getContext('2d');
        else
          # 描画をクリア
          context.clearRect(0, 0, canvas.width, canvas.height)

        # 描画
        context.strokeStyle = 'black';
        context.lineWidth = 0.5;
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

        PageValue.setSettingPageValue(key, true)
        LocalStorage.saveSettingPageValue()
