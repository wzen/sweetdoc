class ClickGuide extends GuideBase

  # キーフレーム追加
  @addItemKeyFrams: (items) ->
    _itemKeyFrames = (item) ->
      kf = """
        click_focus_#{item.id} {
              0% {
                background-size: 100px 100px;
                opacity: 0;
              }
              100% {
                background-size: 80px 80px;
                opacity: 1;
              }
            }
      """
      anim =   """
        .click_guide_#{item.id}
        {
        -webkit-animation-name: click_focus_#{item.id};
        -moz-animation-name: click_focus_#{item.id};
        }
      """

      return """
          @-webkit-keyframes #{kf}
          @-moz-keyframes #{kf}
          #{anim}
        """

    css = ''
    for item in items
      css += _itemKeyFrames.call(@, item)
    @removeItemKeyFrames()
    window.cssCode.append($("<div class='chapter_itemkeyframes'><style type='text/css'>#{css}</style></div>"))

  # キーフレーム削除
  @removeItemKeyFrames: ->
    window.cssCode.find('.chapter_itemkeyframes').remove()

  # ガイド表示
  @showGuide: (items) ->
    @addItemKeyFrams(items)
    for item in items
      color = @focusColor(item)
      guideClassName = "click_guide_#{item.id}"
      style = '' # "width:#{item.itemSize.w}px;height:#{item.itemSize.h}px;"
      item.getJQueryElement().append($("<div class='guide_click #{color} #{guideClassName}' style='#{style}'></div>"))

  # ガイド非表示
  @hideGuide: ->
    @removeItemKeyFrames()
    $('.guide_click').remove()

  # フォーカス時の色を判定
  @focusColor: (item) ->
    background = item.getJQueryElement().find('.css3button:first').css('background')

    # gradient抜き出し
    startIndex = background.indexOf('gradient(') + 'gradient('.length
    endIndex = background.length - 1
    count = 1
    for i in [startIndex..background.length]
      c = background.charAt(i)
      if c == '('
        count += 1
      else if c == ')'
        count -= 1
      if count <= 0
        endIndex = i
        break
    background = background.substring(startIndex, endIndex)

    # カラーコード検索 rgb形式
    re = /((2[0-4]\d|25[0-5]|1\d{1,2}|[1-9]\d|\d)( ?, ?)){2}(2[0-4]\d|25[0-5]|1\d{1,2}|[1-9]\d|\d)/g
    colors = background.match(re)
    if !colors?
      # 見つからない場合は黒とする
      return 'black'

    # グラデーションの平均値計算
    average = 0
    for c in colors
      arr = c.split(',')
      sixteen = parseInt(arr[0]).toString(16) + parseInt(arr[1]).toString(16) + parseInt(arr[2]).toString(16)
      average += parseInt(sixteen, 16)
    average /= colors.length

    # 最も大きい差分の色を取得
    baseColors = {
      red: parseInt('FF0000'.toString(10))
      black: parseInt('000000'.toString(10))
      blue: parseInt('0000FF'.toString(10))
      yellow: parseInt('FFFF00'.toString(10))
    }
    maxDiff = 0
    targetKey = null
    for k, v of baseColors
      if Math.abs(v - average) > maxDiff
        targetKey = k
        maxDiff = Math.abs(v - average)

    return targetKey
