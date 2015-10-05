# 設定値
class Setting
  if gon?
    # 定数
    constant = gon.const

    @ROOT_ID_NAME = constant.Setting.ROOT_ID_NAME

    class @PageValueKey
      @ROOT = constant.PageValueKey.ST_ROOT
      @PREFIX = constant.PageValueKey.ST_PREFIX

  # 設定値初期化
  @initConfig: ->
    @Grid.initConfig()
    @IdleSaveTimer.initConfig()

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
      @GRID = "#{Setting.PageValueKey.PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}grid_enable"
      # @property [String] GRID グリッド線間隔
      @GRID_STEP = "#{Setting.PageValueKey.PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}grid_step"

    # グリッド初期化
    @initConfig: ->
      root = $("##{Setting.ROOT_ID_NAME}")
      # グリッド線表示
      grid = $(".#{@GRID_CLASS_NAME}", root)
      gridValue = PageValue.getSettingPageValue(@PageValueKey.GRID)
      gridValue = gridValue? && gridValue == 'true'
      gridStepDiv = $(".#{@GRID_STEP_DIV_CLASS_NAME}", root)

      grid.prop('checked', if gridValue then 'checked' else false)
      grid.off('click')
      grid.on('click', =>
        gridValue = PageValue.getSettingPageValue(@PageValueKey.GRID)
        if gridValue?
          gridValue = gridValue == 'true'

        # グリッド間隔の有効無効を切り替え
        if !gridValue
          gridStepDiv.show()
        else
          gridStepDiv.hide()

        @drawGrid(!gridValue)
      )

      # グリッド間隔の有効無効を切り替え
      if gridValue
        gridStepDiv.show()
      else
        gridStepDiv.hide()

      # グリッド間隔
      gridStepValue = PageValue.getSettingPageValue(Setting.Grid.PageValueKey.GRID_STEP)
      if !gridStepValue?
        gridStepValue = @STEP_DEFAULT_VALUE
      gridStep = $(".#{@GRID_STEP_CLASS_NAME}", root)
      gridStep.val(gridStepValue)
      self = @
      gridStep.change( ->
        value = PageValue.getSettingPageValue(Setting.Grid.PageValueKey.GRID)
        if value?
          value = value == 'true'
        if value
          step = $(@).val()
          if step?
            step = parseInt(step)
            PageValue.setSettingPageValue(Setting.Grid.PageValueKey.GRID_STEP, step)
            self.drawGrid(true)
      )

      # 描画
      @drawGrid(gridValue)

    # グリッド線描画
    # @param [Boolean] doDraw 描画するか
    @drawGrid : (doDraw) ->
      page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum())
      canvas = $("#pages .#{page} .#{@SETTING_GRID_CANVAS_CLASS}:first")[0]
      context = null
      if canvas?
        context = canvas.getContext('2d');
      if context? && doDraw == false
        # 削除
        $(".#{@SETTING_GRID_ELEMENT_CLASS}").remove()
        PageValue.setSettingPageValue(Setting.Grid.PageValueKey.GRID, false)
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
          $(ElementCode.get().createGridElement(top, left)).appendTo(window.scrollInside)
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

        PageValue.setSettingPageValue(Setting.Grid.PageValueKey.GRID, true)
        LocalStorage.saveSettingPageValue()

  # 自動保存
  class @IdleSaveTimer
    @AUTOSAVE_CLASS_NAME = constant.Setting.AUTOSAVE_CLASS_NAME
    @AUTOSAVE_TIME_CLASS_NAME = constant.Setting.AUTOSAVE_TIME_CLASS_NAME
    @AUTOSAVE_TIME_DIV_CLASS_NAME = constant.Setting.AUTOSAVE_TIME_DIV_CLASS_NAME
    @AUTOSAVE_TIME_DEFAULT = 10 # 10秒

    class @PageValueKey
      # @property [String] AUTOSAVE AutoSave
      @AUTOSAVE = "#{Setting.PageValueKey.PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}autosave"
      # @property [String] AUTOSAVE_TIME AutoSave間隔
      @AUTOSAVE_TIME = "#{Setting.PageValueKey.PREFIX}#{PageValue.Key.PAGE_VALUES_SEPERATOR}autosave_time"


    @initConfig: ->
      root = $("##{Setting.ROOT_ID_NAME}")
      # Autosave表示
      enable = $(".#{@AUTOSAVE_CLASS_NAME}", root)
      enableValue = PageValue.getSettingPageValue(@PageValueKey.AUTOSAVE)
      if !enableValue?
        enableValue = 'true'
        PageValue.setSettingPageValue(@PageValueKey.AUTOSAVE, enableValue)
      enableValue = enableValue? && enableValue == 'true'
      autosaveTimeDiv = $(".#{@AUTOSAVE_TIME_DIV_CLASS_NAME}", root)

      enable.prop('checked', if enableValue then 'checked' else false)
      enable.off('click')
      enable.on('click', =>
        enableValue = PageValue.getSettingPageValue(@PageValueKey.AUTOSAVE)
        if enableValue?
          enableValue = enableValue == 'true'

        # グリッド間隔の有効無効を切り替え
        if !enableValue
          autosaveTimeDiv.show()
        else
          autosaveTimeDiv.hide()
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
      self = @
      autosaveTime.change( ->
        value = PageValue.getSettingPageValue(Setting.IdleSaveTimer.PageValueKey.AUTOSAVE)
        if value?
          value = value == 'true'
        if value
          step = $(@).val()
          if step?
            step = parseInt(step)
            PageValue.setSettingPageValue(Setting.IdleSaveTimer.PageValueKey.AUTOSAVE_TIME, step)
      )

    @isEnabled: ->
      enableValue = PageValue.getSettingPageValue(@PageValueKey.AUTOSAVE)
      if enableValue?
        return enableValue == 'true'
      else
        return false

    @idleTime: ->
      return PageValue.getSettingPageValue(@PageValueKey.AUTOSAVE_TIME)