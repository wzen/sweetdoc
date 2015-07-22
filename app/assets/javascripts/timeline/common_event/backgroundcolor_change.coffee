class TLEBackgroundColorChange extends TimelineEvent
  @BASE_COLOR = 'b_color'
  @CHANGE_COLOR = 'c_color'

  @initConfigValue = (timelineConfig) ->
    @initCommonConfigValue(timelineConfig)
    bgColor = $('#main-wrapper.stage_container').css('backgroundColor')
    $(".baseColor", $("values_div", timelineConfig.emt)).css('backgroundColor', bgColor)
    $(".colorPicker", timelineConfig.emt).each( ->
      self = $(@)
      if !self.hasClass('temp') && !self.hasClass('baseColor')
        initColorPicker(self, bgColor, null)
    )

  @writeToPageValue = (timelineConfig) ->
    errorMes = ""
    writeValue = super(timelineConfig)
    emt = timelineConfig.emt
    value = {}
    value[@BASE_COLOR] = $('.base_color:first', emt).css('backgroundColor')
    value[@CHANGE_COLOR] = $('.change_color:first', emt).css('backgroundColor')

    if value[@BASE_COLOR] == value[@CHANGE_COLOR]
      errorMes = "同じ色は選択できません"

    if errorMes.length == 0
      writeValue[@PageValueKey.VALUE] = value
      setTimelinePageValue(@PageValueKey.te(timelineConfig.teNum), writeValue, timelineConfig.teNum)
      setTimelinePageValue(Constant.PageValueKey.TE_COUNT, timelineConfig.teNum)

    return errorMes

  @readFromPageValue = (timelineConfig) ->
    ret = super(timelineConfig)
    if !ret
      return false
    emt = timelineConfig.emt
    writeValue = getTimelinePageValue(@PageValueKey.te(timelineConfig.teNum))
    value = writeValue[@PageValueKey.VALUE]
    initColorPicker($(".colorPicker.base_color", emt) ,value[@BASE_COLOR], null)
    initColorPicker($(".colorPicker.change_color", emt) ,value[@CHANGE_COLOR], null)
    #$('.base_color:first', emt).css('backgroundColor',value[@BASE_COLOR])
    #$('.change_color:first', emt).css('backgroundColor',value[@CHANGE_COLOR])
    return true
