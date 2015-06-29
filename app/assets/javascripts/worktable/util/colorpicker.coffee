# カラーピッカーの設定
# @param [Object] element HTML要素
# @param [Color] changeColor 変更色
# @param [Function] onChange 変更時に呼ばれるメソッド
settingColorPicker = (element, changeColor, onChange) ->
  emt = $(element)
  emt.ColorPickerSetColor(changeColor)
  emt.ColorPickerResetOnChange(onChange)

#カラーピッカー値の初期化(アイテムのコンテキスト表示時に設定)
initColorPickerValue = ->
  $('.colorPicker', sidebarWrapper).each( ->
    id = $(this).attr('id')
    color = $('.' + id, cssCode).html()
    $(this).css('backgroundColor', '#' + color)
    inputEmt = sidebarWrapper.find('#' + id + '-input')
    inputEmt.attr('value', color)
  )