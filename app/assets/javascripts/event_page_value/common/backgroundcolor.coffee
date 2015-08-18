class EPVBackgroundColor extends EventPageValueBase
  @BASE_COLOR = 'b_color'
  @CHANGE_COLOR = 'c_color'

  @initConfigValue = (eventConfig) ->
    super(eventConfig)
    bgColor = $('#main-wrapper.stage_container').css('backgroundColor')
    $(".baseColor", $("values_div", eventConfig.emt)).css('backgroundColor', bgColor)
    $(".colorPicker", eventConfig.emt).each( ->
      self = $(@)
      if !self.hasClass('temp') && !self.hasClass('baseColor')
        initColorPicker(self, bgColor, null)
    )

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
      PageValue.setEventPageValue(@PageValueKey.te(eventConfig.teNum), writeValue)
      PageValue.setEventPageValue(PageValue.Key.E_COUNT, eventConfig.teNum)

      # Storageに保存
      st = new LocalStorage(LocalStorage.Key.WORKTABLE_EVENT_PAGEVALUES)
      st.saveEventPageValue()

    return errorMes

  @readFromPageValue = (eventConfig) ->
    ret = super(eventConfig)
    if !ret
      return false
    emt = eventConfig.emt
    writeValue = PageValue.getEventPageValue(@PageValueKey.te(eventConfig.teNum))
    value = writeValue[@PageValueKey.VALUE]
    initColorPicker($(".colorPicker.base_color", emt) ,value[@BASE_COLOR], null)
    initColorPicker($(".colorPicker.change_color", emt) ,value[@CHANGE_COLOR], null)
    #$('.base_color:first', emt).css('backgroundColor',value[@BASE_COLOR])
    #$('.change_color:first', emt).css('backgroundColor',value[@CHANGE_COLOR])
    return true
