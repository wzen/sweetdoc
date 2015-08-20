# ワークテーブル用アイテム拡張モジュール
# 共通
WorkTableCommonExtend =
  # ドラッグ描画開始
  startDraw: ->
    return

  # ドラッグ描画
  draw: (cood) ->
    return

  # 描画&コンフィグ作成
  drawAndMakeConfigsAndWritePageValue: (show = true) ->
    # ボタン設置
    @reDraw(show)
    # コンフィグ作成
    @makeDesignConfig()
    # イベント記述
    EPVItem.writeDefaultToPageValue(@)
    # タイムライン作成
    Timeline.setupTimelineEventConfig()

    return true

  # 描画&コンフィグ作成
  # @param [boolean] show 要素作成後に描画を表示するか
  # @return [Boolean] 処理結果
  drawAndMakeConfigs: (show = true) ->
    # ボタン設置
    @reDraw(show)
    # コンフィグ作成
    @makeDesignConfig()

    return true

  # オプションメニューを開く
  showOptionMenu: ->
    sc = $('.sidebar-config')
    sc.css('display', 'none')
    $('.dc', sc).css('display', 'none')
    $('#design-config').css('display', '')
    $('#' + @getDesignConfigId()).css('display', '')

