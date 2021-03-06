class ColorPickerUtil

  # カラーピッカーの設定
  # @param [Object] element HTML要素
  # @param [Color] colorValue 変更色
  # @param [Function] onChange 変更時に呼ばれるメソッド
  @initColorPicker = (element, colorValue, onChange) ->
    setColor = null
    if typeof colorValue == 'string'
      if colorValue.indexOf('rgb') == 0
        colorValue = Common.colorFormatChangeRgbToHex(colorValue)
        setColor = colorValue
      else
        setColor = colorValue.replace('#', '')
        setColor = "##{setColor}"
    else
      setColor = "rgb(#{colorValue.r}, #{colorValue.g}, #{colorValue.b})"
    element.css("backgroundColor", setColor)
    element.ColorPicker({})
    element.ColorPickerSetColor(colorValue)
    element.ColorPickerResetOnChange( (a, b, d, e) ->
      element.css("backgroundColor", "#" + b)
      if onChange?
        onChange(a, b, d, e)
    )
    element.unbind()
    element.mousedown( (e) ->
      e.stopPropagation()
      WorktableCommon.clearAllItemStyle()
      element.ColorPickerHide()
      element.ColorPickerShow()
    )


  #カラーピッカー値の初期化(アイテムのコンテキスト表示時に設定)
  @initColorPickerValue = ->
    $('.colorPicker', sidebarWrapper).each( ->
      id = $(this).attr('id')
      color = $('.' + id, cssCode).html()
      $(this).css('backgroundColor', '#' + color)
      inputEmt = sidebarWrapper.find('#' + id + '-input')
      inputEmt.attr('value', color)
    )
