# Canvas
WorkTableCanvasItemExtend =
  # 描画終了
  # @param [Int] zindex z-index
  # @param [boolean] show 要素作成後に描画を表示するか
  endDraw: (zindex, show = true) ->
    @zindex = zindex

    # TODO: 汎用的に修正
    # 座標を新規キャンパス用に修正
    do =>
      @coodRegist.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )
      @coodLeftBodyPart.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )
      @coodRightBodyPart.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )
      @coodHeadPart.forEach((e) =>
        e.x -= @itemSize.x
        e.y -= @itemSize.y
      )

    # スクロールビュー分のxとyを追加
    @itemSize.x += scrollContents.scrollLeft()
    @itemSize.y += scrollContents.scrollTop()
    @applyDefaultDesign()
    @drawAndMakeConfigsAndWritePageValue(show)
    # Canvas状態を保存
    @saveNewDrawedSurface()
    return true

  # デザイン変更を反映
  applyDesignStyleChange: (doStyleSave = true) ->

    # TODO: 修正

    @cssStyle.text(@cssCode.text())
    if doStyleSave
      # 頻繁に呼ばれるためタイマーでPageValueに書き込む
      if @cssStypeReflectTimer?
        clearTimeout(@cssStypeReflectTimer)
        @cssStypeReflectTimer = null
      @cssStypeReflectTimer = setTimeout( =>
        # 0.5秒後に反映
        # ページに状態を保存
        @setItemAllPropToPageValue()
        # キャッシュに保存
        LocalStorage.saveAllPageValues()
        @cssStypeReflectTimer = setTimeout( ->
          # 1秒後に操作履歴に保存
          OperationHistory.add()
        , 1000)
      , 500)

  # グラデーションデザイン変更を反映
  applyGradientStyleChange: (index, designKeyName, value, doStyleSave = true) ->


  # グラデーション方向変更を反映
  applyGradientDegChange: (designKeyName, value, doStyleSave = true) ->


  applyGradientStepChange: (target) ->
    # TODO: 修正


  applyColorChangeByPicker: (designKeyName, value, doStyleSave = true) ->
    # TODO: 修正


  applyDesignTool: (drawingContext) ->
