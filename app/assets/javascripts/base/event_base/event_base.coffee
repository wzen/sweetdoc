# イベントリスナー Extend
class EventBase extends Extend

  @CLICK_INTERVAL_DURATION = 0.01

  # イベントの初期化
  # @param [Object] event 設定イベント
  initEvent: (event) ->
    @event = event
    @isFinishedEvent = false
    @skipEvent = false
    @doPreviewLoop = false
    @enabledDirections = @event[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS]
    @forwardDirections = @event[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS]

    # アクションメソッドの設定
    if !@constructor.prototype[@getEventMethodName()]?
      # メソッドが見つからない場合は終了
      return

    # スクロールイベント
    if @getEventActionType() == Constant.ActionType.SCROLL
      @scrollEvent = @scrollHandlerFunc
    # クリックイベント
    else if @getEventActionType() == Constant.ActionType.CLICK
      @clickEvent = @clickHandlerFunc

  # 設定されているイベントメソッド名を取得
  # @return [String] メソッド名
  getEventMethodName: ->
    if @event?
      return @event[EventPageValueBase.PageValueKey.METHODNAME]

  # 設定されているイベントアクションタイプを取得
  # @return [Integer] アクションタイプ
  getEventActionType: ->
    if @event?
      return @event[EventPageValueBase.PageValueKey.ACTIONTYPE]

  # 変更設定されているフォーク番号を取得
  # @return [Integer] フォーク番号
  getChangeForkNum: ->
    if @event?
      num = @event[EventPageValueBase.PageValueKey.CHANGE_FORKNUM]
      if num?
        return parseInt(num)
      else
        # forkNumが無い場合はNULL
        return null
    else
      return null

  # リセット(アクション前に戻す)
  resetEvent: ->
    @updateEventBefore()
    @isFinishedEvent = false
    @skipEvent = false

  # プレビュー開始
  # @param [Object] event 設定イベント
  preview: (event) ->
    _preview = (event) ->
      drawDelay = 30 # 0.03秒毎スクロール描画
      loopDelay = 1000 # 1秒毎イベント実行
      loopMaxCount = 5 # ループ5回

      # イベント初期化
      @initEvent(event)
      @willChapter()
      if @ instanceof CssItemBase
        @appendAnimationCssIfNeeded()

      actionType = @getEventActionType()
      # イベントループ
      @doPreviewLoop = true
      loopCount = 0
      @previewTimer = null
      # FloatView表示
      FloatView.show(FloatView.displayPositionMessage(), FloatView.Type.PREVIEW)
      if actionType == Constant.ActionType.SCROLL
        p = 0
        _draw = =>
          if @doPreviewLoop
            if @previewTimer?
              clearTimeout(@previewTimer)
              @previewTimer = null
            @previewTimer = setTimeout( =>
              @execMethod(p)
              p += 1
              if p >= @scrollLength()
                p = 0
                _loop.call(@)
              else
                _draw.call(@)
            , drawDelay)
          else
            if @previewFinished?
              @previewFinished()
              @previewFinished = null

        _loop = =>
          if @doPreviewLoop
            loopCount += 1
            if loopCount >= loopMaxCount
              @stopPreview()

            if @previewTimer?
              clearTimeout(@previewTimer)
              @previewTimer = null
            @previewTimer = setTimeout( =>
              # 状態を変更前に戻す
              @resetEvent()
              @willChapter()
              _draw.call(@)
            , loopDelay)
            if !@doPreviewLoop
              @stopPreview()
          else
            if @previewFinished?
              @previewFinished()
              @previewFinished = null

        _draw.call(@)

      else if actionType == Constant.ActionType.CLICK
        _loop = =>
          if @doPreviewLoop
            loopCount += 1
            if loopCount >= loopMaxCount
              @stopPreview()

            if @previewTimer?
              clearTimeout(@previewTimer)
              @previewTimer = null
            @previewTimer = setTimeout( =>
              # 状態を変更前に戻す
              @resetEvent()
              @willChapter()
              @execMethod(null, _loop)
            , loopDelay)
          else
            if @previewFinished?
              @previewFinished()
              @previewFinished = null

        @execMethod(null, _loop)

    @stopPreview( =>
      window.runningPreview = true
      _preview.call(@, event)
    )

  # プレビューを停止
  # @param [Function] callback コールバック
  stopPreview: (callback = null) ->
    _stop = ->
      if @previewTimer?
        clearTimeout(@previewTimer)
        FloatView.hide()
        @previewTimer = null
      if callback?
        callback()

    if @doPreviewLoop
      @doPreviewLoop = false
      @previewFinished = =>
        _stop.call(@)

    else
      _stop.call(@)

  # JQueryエレメントを取得
  # @abstract
  getJQueryElement: ->
    return null

  # チャプターを進める
  nextChapter: ->
    if window.eventAction?
      window.eventAction.thisPage().progressChapter()

  # チャプター開始前イベント
  willChapter: ->
    # 状態をイベント前に戻す
    @updateEventBefore()

  # チャプター終了時イベント
  didChapter: ->
    # インスタンスの状態を保存
    PageValue.saveInstanceObjectToFootprint(@id, false, @event[EventPageValueBase.PageValueKey.DIST_ID])

  # メソッド実行
  execMethod: (params, complete = null) ->
    methodName = @getEventMethodName()
    if !methodName?
      # メソッドが無い場合
      return

    # メソッド共通処理
    if !@isDrawByAnimationMethod()
      # アイテム位置&サイズ更新
      @updateInstanceParamByStep(params)
    else
      setTimeout( =>
        @updateInstanceParamByAnimation()
      , 0)

    (@constructor.prototype[methodName]).call(@, params, complete)

  # スクロール基底メソッド
  # @param [Integer] x スクロール横座標
  # @param [Integer] y スクロール縦座標
  # @param [Function] complete イベント終了後コールバック
  scrollHandlerFunc: (x, y, complete = null) ->
    methodName = @getEventMethodName()
    if !methodName?
      # メソッドが無い場合
      return

    if @isFinishedEvent || @skipEvent
      # 終了済みorイベントを反応させない場合
      return

    # 動作済みフラグON
    if window.eventAction?
      window.eventAction.thisPage().thisChapter().doMoveChapter = true

    # スクロール値更新
    #console.log("y:#{y}")
    plusX = 0
    plusY = 0
    if x > 0 && @enabledDirections.right
      plusX = parseInt((x + 9) / 10)
    else if x < 0 && @enabledDirections.left
      plusX = parseInt((x - 9) / 10)
    if y > 0 && @enabledDirections.bottom
      plusY = parseInt((y + 9) / 10)
    else if y < 0 && @enabledDirections.top
      plusY = parseInt((y - 9) / 10)

    if (plusX > 0 && !@forwardDirections.right) ||
      (plusX < 0 && @forwardDirections.left)
        plusX = -plusX
    if (plusY > 0 && !@forwardDirections.bottom) ||
      (plusY < 0 && @forwardDirections.top)
        plusY = -plusY

    @scrollValue += plusX + plusY

    sPoint = parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])
    ePoint = parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_END])

    # スクロール指定範囲外なら反応させない
    if @scrollValue < sPoint
      @scrollValue = sPoint
      return
    else if @scrollValue >= ePoint
      @scrollValue = ePoint
      if !@isDrawByAnimationMethod() && !@isFinishedEvent
        # 終了イベント
        @isFinishedEvent = true
        ScrollGuide.hideGuide()
        if complete?
          complete()
      return

    @canForward = @scrollValue < ePoint
    @canReverse = @scrollValue > sPoint

    if !@isDrawByAnimationMethod()
      # ステップ実行
      @execMethod(@scrollValue - sPoint)
    else
      # アニメーション実行は1回のみ
      @skipEvent = true
      @execMethod( =>
        @isFinishedEvent = true
        ScrollGuide.hideGuide()
        if complete?
          complete()
      )

  # スクロールの長さを取得
  # @return [Integer] スクロール長さ
  scrollLength: ->
    return parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) - parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])

  # スクロール基底メソッド
  # @param [Object] e クリックオブジェクト
  # @param [Function] complete イベント終了後コールバック
  clickHandlerFunc: (e, complete = null) ->
    e.preventDefault()

    # 動作済みフラグON
    if window.eventAction?
      window.eventAction.thisPage().thisChapter().doMoveChapter = true

    if !@isDrawByAnimationMethod()
      # ステップ実行
      clickDuration = @constructor.actionProperties.methods[@getEventMethodName()][EventPageValueBase.PageValueKey.CLICK_DURATION]
      stepMax = @clickDurationStepMax()
      count = 1
      timer = setInterval( =>
        @execMethod(e, count)
        count += 1
        if stepMax > count
          clearInterval(timer)
          # 終了イベント
          @isFinishedEvent = true
          if complete?
            complete()
      , @constructor.CLICK_INTERVAL_DURATION)
    else
      # アニメーション実行
      @execMethod(e, ->
        if complete?
          complete()
      )

  # イベント前のインスタンスオブジェクトを取得
  getMinimumObjectEventBefore: ->
    diff = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceDiffBefore(@event[EventPageValueBase.PageValueKey.DIST_ID], @id))
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))
    return $.extend(true, obj, diff)

  # イベント前の表示状態にする
  updateEventBefore: ->
    @setMiniumObject(@getMinimumObjectEventBefore())
    actionType = @getEventActionType()
    if actionType == Constant.ActionType.SCROLL
      @scrollValue = 0

  # イベント後の表示状態にする
  updateEventAfter: ->
    if !@isDrawByAnimationMethod()
      @updateInstanceParamByStep(null, true)
    else
      @updateInstanceParamByAnimation(true)
    # インスタンスの状態を保存
    PageValue.saveInstanceObjectToFootprint(@id, false, @event[EventPageValueBase.PageValueKey.DIST_ID])

  # ステップ実行によるアイテム状態更新
  updateInstanceParamByStep: (stepValue, immediate = false)->
    actionType = Common.getActionTypeByCodingActionType(@constructor.actionProperties.methods[@getEventMethodName()].actionType)
    stepMax = if actionType == Constant.ActionType.SCROLL then @scrollLength() else @clickDurationStepMax()
    if !stepMax?
      stepMax = 1
    # TODO: varAutoChange=falseの場合は(変数)_xxxの形で変更前、変更後、進捗を渡してdraw側で処理させる
    progressPercentage = stepValue / stepMax
    eventBeforeObj = @getMinimumObjectEventBefore()
    mod = @constructor.actionProperties.methods[@getEventMethodName()].modifiables
    for varName, value of mod
      if @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS]? && @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]?
        before = eventBeforeObj[varName]
        after = @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
        if before? && after?
          if immediate
            @[varName] = after
          else
            if value.varAutoChange
              if value.type == Constant.ItemDesignOptionType.NUMBER
                @[varName] = before + (after - before) * progressPercentage
              else if value.type == Constant.ItemDesignOptionType.COLOR
                colorCacheVarName = "#{varName}ColorChangeCache"
                if !@[colorCacheVarName]?
                  @[colorCacheVarName] = Common.colorChangeCacheData(before, after, stepMax)
                @[varName] = @[colorCacheVarName][stepValue]

  # アニメーションによるアイテム状態更新
  updateInstanceParamByAnimation: (immediate = false) ->
    # TODO: varAutoChange=falseの場合は(変数)_xxxの形で変更前、変更後、進捗を渡してdraw側で処理させる
    clickDuration = @constructor.actionProperties.methods[@getEventMethodName()][EventPageValueBase.PageValueKey.CLICK_DURATION]
    loopMax = @clickDurationStepMax()
    eventBeforeObj = @getMinimumObjectEventBefore()
    mod = @constructor.actionProperties.methods[@getEventMethodName()].modifiables

    if immediate
      for varName, value of mod
        if @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS]? && @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]?
          after = @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
          if after?
            @[varName] = after
      return

    count = 1
    timer = setInterval( =>
      progressPercentage = @constructor.CLICK_INTERVAL_DURATION * count / clickDuration
      for varName, value of mod
        if @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS]? && @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]?
          before = eventBeforeObj[varName]
          after = @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
          if before? && after?
            if value.varAutoChange
              if value.type == Constant.ItemDesignOptionType.NUMBER
                @[varName] = before + (after - before) * progressPercentage
              else if value.type == Constant.ItemDesignOptionType.COLOR
                colorCacheVarName = "#{varName}ColorChangeCache"
                if !@[colorCacheVarName]?
                  @[colorCacheVarName] = Common.colorChangeCacheData(before, after, loopMax)
                @[varName] = @[colorCacheVarName][count]
      if count >= loopMax
        clearInterval(timer)
        for varName, value of mod
          if @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS]? && @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]?
            after = @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
            if after?
              @[varName] = after
      count += 1
    , @constructor.CLICK_INTERVAL_DURATION * 1000)

  # アイテムの情報をページ値に保存
  # @property [Boolean] isCache キャッシュとして保存するか
  setItemAllPropToPageValue: (isCache = false)->
    prefix_key = if isCache then PageValue.Key.instanceValueCache(@id) else PageValue.Key.instanceValue(@id)
    obj = @getMinimumObject()
    PageValue.setInstancePageValue(prefix_key, obj)

  # メソッドがアニメーションとして実行するか
  isDrawByAnimationMethod: ->
    return @event[EventPageValueBase.PageValueKey.IS_DRAW_BY_ANIMATION]? && @event[EventPageValueBase.PageValueKey.IS_DRAW_BY_ANIMATION]

  clickDurationStepMax: ->
    clickDuration = @constructor.actionProperties.methods[@getEventMethodName()][EventPageValueBase.PageValueKey.CLICK_DURATION]
    return Math.ceil(clickDuration / @constructor.CLICK_INTERVAL_DURATION)