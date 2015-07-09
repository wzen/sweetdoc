class TLEBackgroundColorChange extends TimelineEvent
  @BASE_COLOR = 'b_color'
  @CHANGE_COLOR = 'c_color'

  @initConfigValue = (timelineConfig) ->
    TimelineEvent.initConfigValue(timelineConfig)
    bgColor = $('#main-wrapper.stage_container').css('backgroundColor')
    $(".baseColor", $("values_div", timelineConfig.emt)).css('backgroundColor', bgColor)
    $(".colorPicker", timelineConfig.emt).each( ->
      self = $(@)
      if !self.hasClass('temp') && !self.hasClass('baseColor')
        initColorPicker(self, bgColor, null)
    )

  @writeToPageValue = (timelineConfig) ->
    errorMes = ""
    writeValue = TimelineEvent.commonWriteValue(timelineConfig)
    emt = timelineConfig.emt
    value[TimelineEvent.BASE_COLOR] = $('.base_color:first', emt).css('backgroundColor')
    value[TimelineEvent.CHANGE_COLOR] = $('.change_color:first', emt).css('backgroundColor')

    if value[TimelineEvent.BASE_COLOR] == value[TimelineEvent.CHANGE_COLOR]
      errorMes = "同じ色は選択できません"

    if errorMes.length == 0
      writeValue[TimelineEvent.PageValueKey.VALUE] = value
      setPageValue(TimelineEvent.PageValueKey.te(timelineConfig.teNum), writeValue)
      setPageValue(Constant.PageValueKey.TE_COUNT, timelineConfig.teNum)

    return errorMes

  @readFromPageValue = (timelineConfig) ->
    TimelineEvent.commonReadValue(timelineConfig)
    emt = timelineConfig.emt
    writeValue = getPageValue(TimelineEvent.PageValueKey.te(timelineConfig.teNum))
    value = writeValue[TimelineEvent.PageValueKey.VALUE]
    initColorPicker($(".colorPicker.base_color", emt) ,value[TimelineEvent.BASE_COLOR], null)
    initColorPicker($(".colorPicker.change_color", emt) ,value[TimelineEvent.CHANGE_COLOR], null)
    #$('.base_color:first', emt).css('backgroundColor',value[TimelineEvent.BASE_COLOR])
    #$('.change_color:first', emt).css('backgroundColor',value[TimelineEvent.CHANGE_COLOR])
