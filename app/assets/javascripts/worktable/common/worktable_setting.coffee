# 設定値
class WorktableSetting
  # 定数
  constant = gon.const
  @ROOT_ID_NAME = constant.Setting.ROOT_ID_NAME

  # 設定値初期化
  @initConfig: ->
    @Grid.initConfig()
    @IdleSaveTimer.initConfig()
    @PositionAndScale.initConfig()

  @clear: ->
    @Grid.clear()
    @IdleSaveTimer.clear()
    @PositionAndScale.clear()

  # グリッド線
  class @Grid
    @GRID_CLASS_NAME = constant.Setting.GRID_CLASS_NAME
    @GRID_STEP_CLASS_NAME = constant.Setting.GRID_STEP_CLASS_NAME
    @GRID_STEP_DIV_CLASS_NAME = constant.Setting.GRID_STEP_DIV_CLASS_NAME
    @SETTING_GRID_ELEMENT_CLASS = 'setting_grid_element'
    @SETTING_GRID_CANVAS_CLASS = 'setting_grid'
    @GRIDVIEW_SIZE = 10000
    @STEP_DEFAULT_VALUE = 12

    class @PageValueKey
      # @property [String] GRID グリッド線表示
      @GRID = "#{PageValue.Key.ST_PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}#{constant.Setting.Key.GRID_ENABLE}"
      # @property [String] GRID グリッド線間隔
      @GRID_STEP = "#{PageValue.Key.ST_PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}#{constant.Setting.Key.GRID_STEP}"

    # グリッド初期化
    @initConfig: ->
      root = $("##{WorktableSetting.ROOT_ID_NAME}")
      # グリッド線表示
      grid = $(".#{@GRID_CLASS_NAME}", root)
      gridValue = PageValue.getSettingPageValue(@PageValueKey.GRID)
      gridValue = gridValue? && gridValue == 'true'
      gridStepDiv = $(".#{@GRID_STEP_DIV_CLASS_NAME}", root)
      grid.prop('checked', if gridValue then 'checked' else false)
      grid.off('click').on('click', =>
        gridValue = PageValue.getSettingPageValue(@PageValueKey.GRID)
        if gridValue?
          gridValue = gridValue == 'true'
        # グリッド間隔の有効無効を切り替え
        if !gridValue
          gridStepDiv.show()
        else
          gridStepDiv.hide()
        @drawGrid(!gridValue)
        gridValue = PageValue.getSettingPageValue(@PageValueKey.GRID)
        grid.prop("checked",gridValue == 'true')
      )

      # グリッド間隔の有効無効を切り替え
      if gridValue
        gridStepDiv.show()
      else
        gridStepDiv.hide()

      # グリッド間隔
      gridStepValue = PageValue.getSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID_STEP)
      if !gridStepValue?
        gridStepValue = @STEP_DEFAULT_VALUE
      gridStep = $(".#{@GRID_STEP_CLASS_NAME}", root)
      gridStep.val(gridStepValue)
      gridStep.change( (e) =>
        value = PageValue.getSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID)
        if value?
          value = value == 'true'
        if value
          step = $(e.target).val()
          if step?
            step = parseInt(step)
            PageValue.setSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID_STEP, step)
            @drawGrid(true)
      )
      # 描画
      @drawGrid(gridValue)

    # 初期化
    @clear: ->
      root = $("##{WorktableSetting.ROOT_ID_NAME}")
      grid = $(".#{@GRID_CLASS_NAME}", root)
      grid.prop('checked', false)
      gridStepValue = @STEP_DEFAULT_VALUE
      gridStep = $(".#{@GRID_STEP_CLASS_NAME}", root)
      gridStep.val(gridStepValue)
      @drawGrid(false)

    # グリッド線描画
    # @param [Boolean] doDraw 描画するか
    @drawGrid : (doDraw) ->
      page = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum())
      canvas = $("#pages .#{page} .#{@SETTING_GRID_CANVAS_CLASS}:first")[0]
      context = null
      if canvas?
        context = canvas.getContext('2d');
      if context? && doDraw == false
        # 削除
        $(".#{@SETTING_GRID_ELEMENT_CLASS}").remove()
        PageValue.setSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID, false)
        window.lStorage.saveSettingPageValue()
      else if doDraw
        root = $("##{WorktableSetting.ROOT_ID_NAME}")
        stepInput = $(".#{@GRID_STEP_CLASS_NAME}", root)
        step = stepInput.val()
        if !step? || step.length == 0
          stepInput.val(@STEP_DEFAULT_VALUE)
          step = @STEP_DEFAULT_VALUE
        step = parseInt(step)
        min = parseInt(stepInput.attr('min'))
        max = parseInt(stepInput.attr('max'))
        if step < min || step > max
          return
        stepx = step
        stepy = step
        top = window.scrollContents.scrollTop() - @GRIDVIEW_SIZE * 0.5
        top -= top % stepy
        if top < 0
          top = 0
        left = window.scrollContents.scrollLeft() - @GRIDVIEW_SIZE * 0.5
        left -= left % stepx
        if left < 0
          left = 0
        if !context?
          # キャンパスを作成
          $(@createGridElement(top, left)).appendTo(window.scrollInside)
          canvas = $("#pages .#{page} .#{@SETTING_GRID_CANVAS_CLASS}:first")[0]
          context = canvas.getContext('2d');
        else
          emt = $("#pages .#{page} .#{@SETTING_GRID_ELEMENT_CLASS}:first")
          emt.css({top: "#{top}px", left: "#{left}px"})
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

        PageValue.setSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID, true)
        window.lStorage.saveSettingPageValue()

    # グリッド線のテンプレートHTMLを読み込み
    # @param [Integer] top HTMLを設置するY位置
    # @param [Integer] left HTMLを設置するX位置
    # @return [String] HTML
    @createGridElement: (top, left) ->
      return """
          <div class="#{@SETTING_GRID_ELEMENT_CLASS}" style="position: absolute;top:#{top}px;left:#{left}px;width:#{@GRIDVIEW_SIZE}px;height:#{@GRIDVIEW_SIZE}px;z-index:#{Common.plusPagingZindex(Constant.Zindex.GRID)}"><canvas class="#{@SETTING_GRID_CANVAS_CLASS}" class="canvas" width="#{@GRIDVIEW_SIZE}" height="#{@GRIDVIEW_SIZE}"></canvas></div>
        """

  # 自動保存
  class @IdleSaveTimer
    @AUTOSAVE_CLASS_NAME = constant.Setting.AUTOSAVE_CLASS_NAME
    @AUTOSAVE_TIME_CLASS_NAME = constant.Setting.AUTOSAVE_TIME_CLASS_NAME
    @AUTOSAVE_TIME_DIV_CLASS_NAME = constant.Setting.AUTOSAVE_TIME_DIV_CLASS_NAME
    @AUTOSAVE_TIME_DEFAULT = 10 # 10秒

    class @PageValueKey
      # @property [String] AUTOSAVE AutoSave
      @AUTOSAVE = "#{PageValue.Key.ST_PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}#{constant.Setting.Key.AUTOSAVE}"
      # @property [String] AUTOSAVE_TIME AutoSave間隔
      @AUTOSAVE_TIME = "#{PageValue.Key.ST_PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}#{constant.Setting.Key.AUTOSAVE_TIME}"


    @initConfig: ->
      root = $("##{WorktableSetting.ROOT_ID_NAME}")
      # Autosave表示
      enable = $(".#{@AUTOSAVE_CLASS_NAME}", root)
      enableValue = PageValue.getSettingPageValue(@PageValueKey.AUTOSAVE)
      if !enableValue?
        enableValue = 'true'
        PageValue.setSettingPageValue(@PageValueKey.AUTOSAVE, enableValue)
      enableValue = enableValue? && enableValue == 'true'
      autosaveTimeDiv = $(".#{@AUTOSAVE_TIME_DIV_CLASS_NAME}", root)
      enable.prop('checked', if enableValue then 'checked' else false)
      enable.off('click').on('click', =>
        enableValue = PageValue.getSettingPageValue(@PageValueKey.AUTOSAVE)
        if enableValue?
          enableValue = enableValue == 'true'
        # グリッド間隔の有効無効を切り替え
        if !enableValue
          autosaveTimeDiv.show()
        else
          autosaveTimeDiv.hide()
        PageValue.setSettingPageValue(@PageValueKey.AUTOSAVE, !enableValue)
      )

      # Autosaveの有効無効を切り替え
      if enableValue
        autosaveTimeDiv.show()
      else
        autosaveTimeDiv.hide()

      # Autosave間隔
      autosaveTimeValue = PageValue.getSettingPageValue(@PageValueKey.AUTOSAVE_TIME)
      if !autosaveTimeValue?
        autosaveTimeValue = @AUTOSAVE_TIME_DEFAULT
        PageValue.setSettingPageValue(@PageValueKey.AUTOSAVE_TIME, autosaveTimeValue)
      autosaveTime = $(".#{@AUTOSAVE_TIME_CLASS_NAME}", root)
      autosaveTime.val(autosaveTimeValue)
      autosaveTime.change( (e) =>
        value = PageValue.getSettingPageValue(WorktableSetting.IdleSaveTimer.PageValueKey.AUTOSAVE)
        if value?
          value = value == 'true'
        if value
          step = $(e.target).val()
          if step?
            step = parseInt(step)
            PageValue.setSettingPageValue(WorktableSetting.IdleSaveTimer.PageValueKey.AUTOSAVE_TIME, step)
      )

    # 初期化
    @clear: ->
      root = $("##{WorktableSetting.ROOT_ID_NAME}")
      # Autosave表示
      enable = $(".#{@AUTOSAVE_CLASS_NAME}", root)
      enable.prop('checked', true)
      PageValue.setSettingPageValue(@PageValueKey.AUTOSAVE, true)

    @isEnabled: ->
      enableValue = PageValue.getSettingPageValue(@PageValueKey.AUTOSAVE)
      if enableValue?
        return enableValue == 'true'
      else
        return false

    @idleTime: ->
      return PageValue.getSettingPageValue(@PageValueKey.AUTOSAVE_TIME)

  class @PositionAndScale
    # コンフィグ初期化
    @initConfig = ->
      if !Common.getScreenSize()?
        return

      rootEmt = $("##{WorktableSetting.ROOT_ID_NAME}")
      # 画面座標
      position = PageValue.getWorktableScrollContentsPosition()
      center = Common.calcScrollCenterPosition(position.top, position.left)
      $('.display_position_x', rootEmt).val(parseInt(center.left))
      $('.display_position_y', rootEmt).val(parseInt(center.top))
      leftMin = -window.scrollInsideWrapper.width() * 0.5
      leftMax = window.scrollInsideWrapper.width() * 0.5
      topMin = -window.scrollInsideWrapper.height() * 0.5
      topMax = window.scrollInsideWrapper.height() * 0.5
      # Inputイベント
      $('.display_position_x, .display_position_y', rootEmt).off('keypress focusout').on('keypress focusout', (e) ->
        if (e.type == 'keypress' && e.keyCode == constant.KeyboardKeyCode.ENTER) || e.type == 'focusout'
          # スクロール位置変更
          left = $('.display_position_x', rootEmt).val()
          top = $('.display_position_y', rootEmt).val()
          if left < leftMin
            left = leftMin
          else if left > leftMax
            left = leftMax
          if top < topMin
            top = topMin
          else if top > topMax
            top = topMax
          $('.display_position_x', rootEmt).val(left)
          $('.display_position_y', rootEmt).val(top)
          p = Common.calcScrollTopLeftPosition(top, left)
          PageValue.setGeneralPageValue(PageValue.Key.worktableDisplayPosition(), {top: p.top, left: p.left})
          WorktableCommon.initScrollContentsPosition()
          window.lStorage.saveGeneralPageValue()
      )

      # Zoom (0.1 〜 2.0)
      min = 0.1
      max = 2.0
      worktableScale = WorktableCommon.getWorktableViewScale()
      meterElement = $(".scale_meter:first", rootEmt)
      valueElement = meterElement.prev('input:first')
      v = parseInt(worktableScale * 100) + '%'
      valueElement.val(v)
      valueElement.html(v)
      try
        meterElement.slider('destroy')
      catch #例外は握りつぶす
      meterElement.slider({
        min: min,
        max: max,
        step: 0.1,
        value: worktableScale
        slide: (event, ui) =>
          v = parseInt(ui.value * 100) + '%'
          valueElement.val(v)
          valueElement.html(v)
          if window.scaleSliderTimer?
            clearTimeout(window.scaleSliderTimer)
            window.scaleSliderTimer = null
          window.scaleSliderTimer = setTimeout( =>
            WorktableCommon.setWorktableViewScale(ui.value, true)
            position = PageValue.getWorktableScrollContentsPosition()
            center = Common.calcScrollCenterPosition(position.top, position.left)
            $('.display_position_x', rootEmt).val(parseInt(center.left))
            $('.display_position_y', rootEmt).val(parseInt(center.top))
          , 100)
      })
      # limit
      $('.display_position_left_limit', rootEmt).html("(#{leftMin} 〜 #{leftMax})")
      $('.display_position_top_limit', rootEmt).html("(#{topMin} 〜 #{topMax})")
      $('.display_position_scale_limit', rootEmt).html("(10% 〜 200%)")

    @clear = ->
      scale = WorktableCommon.getWorktableViewScale()
      if scale?
        WorktableCommon.setWorktableViewScale(scale)
      WorktableCommon.initScrollContentsPosition()
      window.lStorage.saveGeneralPageValue()