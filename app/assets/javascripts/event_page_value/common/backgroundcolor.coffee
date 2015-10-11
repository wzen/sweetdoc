# EventPageValue Background
class EPVBackgroundColor extends EventPageValueBase
  @BASE_COLOR = 'b_color'
  @CHANGE_COLOR = 'c_color'

  # コンフィグ初期設定
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  @initConfigValue = (eventConfig) ->
    super(eventConfig)
    className = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum())
    section = $("##{Constant.Paging.ROOT_ID}").find(".#{className}:first")
    bgColor = section.css('backgroundColor')
    $(".baseColor", $("values_div", eventConfig.emt)).css('backgroundColor', bgColor)
    $(".colorPicker", eventConfig.emt).each( ->
      self = $(@)
      if !self.hasClass('temp') && !self.hasClass('baseColor')
        ColorPickerUtil.initColorPicker(self, bgColor, null)
    )

  # PageValueに書き込みデータを取得
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  # @return [String] エラーメッセージ
  @writeToPageValue = (eventConfig) ->
    errorMes = ""
    writeValue = super(eventConfig)
    emt = eventConfig.emt
    value = {}
    value[@BASE_COLOR] = $('.base_color:first', emt).css('backgroundColor')
    value[@CHANGE_COLOR] = $('.change_color:first', emt).css('backgroundColor')

    if value[@BASE_COLOR] == value[@CHANGE_COLOR]
      errorMes = "同じ色は選択できません"

    if errorMes.length == 0
      writeValue[@PageValueKey.VALUE] = value
      PageValue.setEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum), writeValue)
      PageValue.setEventPageValue(PageValue.Key.eventCount(), eventConfig.teNum)

      # Storageに保存
      LocalStorage.saveAllPageValues()

    return errorMes

  # PageValueからConfigにデータを読み込み
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  # @return [Boolean] 読み込み成功したか
  @readFromPageValue = (eventConfig) ->
    ret = super(eventConfig)
    if !ret
      return false
    emt = eventConfig.emt
    writeValue = PageValue.getEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum))
    value = writeValue[@PageValueKey.VALUE]
    ColorPickerUtil.initColorPicker($(".colorPicker.base_color", emt) ,value[@BASE_COLOR], null)
    ColorPickerUtil.initColorPicker($(".colorPicker.change_color", emt) ,value[@CHANGE_COLOR], null)
    #$('.base_color:first', emt).css('backgroundColor',value[@BASE_COLOR])
    #$('.change_color:first', emt).css('backgroundColor',value[@CHANGE_COLOR])
    return true
