# ワークテーブル用アイテム拡張モジュール
# 共通
WorkTableCommonExtend =
  # ドラッグ描画開始
  startDraw: ->
    return

  # ドラッグ描画
  draw: (cood) ->
    return

  # ドラッグ描画終了
  endDraw: (zindex, show = true) ->
    return

  # オプションメニューを開く
  showOptionMenu: ->
    sc = $('.sidebar-config')
    sc.css('display', 'none')
    $('.dc', sc).css('display', 'none')
    $('#design-config').css('display', '')
    $('#' + @getDesignConfigId()).css('display', '')

