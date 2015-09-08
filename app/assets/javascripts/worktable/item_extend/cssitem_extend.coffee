# CSS
WorkTableCssItemExtend =
  # デザイン変更コンフィグを作成
  makeDesignConfig: ->
    @designConfigRoot = $('#' + @getDesignConfigId())
    if !@designConfigRoot? || @designConfigRoot.length == 0
      @designConfigRoot = $('#design-config .design_temp').clone(true).attr('id', @getDesignConfigId())
      @designConfigRoot.removeClass('design_temp')
      cssConfig = @designConfigRoot.find('.css-config')
      @designConfigRoot.find('.css-config').css('display', '')
      @designConfigRoot.find('.canvas-config').remove()
      $('#design-config').append(@designConfigRoot)

  # ドラッグ時のイベント
  drag: ->
    element = $('#' + @id)
    @itemSize.x = element.position().left
    @itemSize.y = element.position().top

  # ドラッグ完了時イベント
  dragComplete: ->
    @saveObj()

  # リサイズ時のイベント
  resize: ->
    element = $('#' + @id)
    @itemSize.w = element.width()
    @itemSize.h = element.height()

  # リサイズ完了時イベント
  resizeComplete: ->
    @saveObj()

  # 履歴データを取得
  # @param [ItemActionType] action アクション種別
  getHistoryObj: (action) ->
    obj = {
      obj: @
      action : action
      itemSize: Common.makeClone(@itemSize)
    }
    return obj

  # 履歴データを設定
  setHistoryObj: (historyObj) ->
    @itemSize = Common.makeClone(historyObj.itemSize)

  # ドラッグ描画
  # @param [Array] cood 座標
  draw: (cood) ->
    if @itemSize != null
      @restoreDrawingSurface(@itemSize)

    @itemSize = {x:null,y:null,w:null,h:null}
    @itemSize.w = Math.abs(cood.x - @moveLoc.x);
    @itemSize.h = Math.abs(cood.y - @moveLoc.y);
    if cood.x > @moveLoc.x
      @itemSize.x = @moveLoc.x
    else
      @itemSize.x = cood.x
    if cood.y > @moveLoc.y
      @itemSize.y = @moveLoc.y
    else
      @itemSize.y = cood.y
    drawingContext.strokeRect(@itemSize.x, @itemSize.y, @itemSize.w, @itemSize.h)