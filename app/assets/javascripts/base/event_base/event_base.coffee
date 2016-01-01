# イベントリスナー Extend
class EventBase extends Extend
  # @abstract
  # @property [String] CLASS_DIST_TOKEN クラス種別
  @CLASS_DIST_TOKEN = ""
  @STEP_INTERVAL_DURATION = 0.01

  if gon?
    constant = gon.const

    @BEFORE_MODIFY_VAR_SUFFIX = constant.BEFORE_MODIFY_VAR_SUFFIX
    @AFTER_MODIFY_VAR_SUFFIX = constant.AFTER_MODIFY_VAR_SUFFIX
    class @ActionPropertiesKey
      @TYPE = constant.ItemActionPropertiesKey.TYPE
      @METHODS = constant.ItemActionPropertiesKey.METHODS
      @DEFAULT_EVENT = constant.ItemActionPropertiesKey.DEFAULT_EVENT
      @METHOD = constant.ItemActionPropertiesKey.METHOD
      @DEFAULT_METHOD = constant.ItemActionPropertiesKey.DEFAULT_METHOD
      @ACTION_TYPE = constant.ItemActionPropertiesKey.ACTION_TYPE
      @SPECIFIC_METHOD_VALUES = constant.ItemActionPropertiesKey.SPECIFIC_METHOD_VALUES
      @SCROLL_ENABLED_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_ENABLED_DIRECTION
      @SCROLL_FORWARD_DIRECTION = constant.ItemActionPropertiesKey.SCROLL_FORWARD_DIRECTION
      @OPTIONS = constant.ItemActionPropertiesKey.OPTIONS
      @EVENT_DURATION = constant.ItemActionPropertiesKey.EVENT_DURATION
      @MODIFIABLE_VARS = constant.ItemActionPropertiesKey.MODIFIABLE_VARS
      @MODIFIABLE_CHILDREN = constant.ItemActionPropertiesKey.MODIFIABLE_CHILDREN
      @MODIFIABLE_CHILDREN_OPENVALUE = constant.ItemActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE

  constructor: ->
    # modifiables変数の初期化
    if @constructor.actionProperties? && @constructor.actionPropertiesModifiableVars()?
      for varName, value of @constructor.actionPropertiesModifiableVars()
        @[varName] = value.default

  # 変更を戻して再表示
  # @abstract
  refresh: (show = true, callback = null) ->

  # インスタンス変数で描画
  # データから読み込んで描画する処理に使用
  # @param [Boolean] show 要素作成後に表示するか
  refreshFromInstancePageValue: (show = true, callback = null) ->
    if window.runDebug
      console.log('EventBase refreshWithEventBefore id:' + @id)

    # インスタンス値初期化
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))
    if obj
      @setMiniumObject(obj)
    @refresh(show, callback)

  # イベントの初期化
  # @param [Object] event 設定イベント
  initEvent: (event) ->
    @_event = event
    @_isFinishedEvent = false
    @_skipEvent = true
    @_runningClickEvent = false
    @_doPreviewLoop = false
    @_handlerFuncComplete = null
    @_enabledDirections = @_event[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS]
    @_forwardDirections = @_event[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS]
    @_specificMethodValues = @_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES]

  # スクロールイベント
  scrollEvent: (x, y, complete = null) ->
    if !@_handlerFuncComplete?
      @_handlerFuncComplete = complete
    @scrollHandlerFunc(false, x, y)

  # クリックイベント
  clickEvent: (e, complete = null) ->
    if !@_handlerFuncComplete?
      @_handlerFuncComplete = complete
    @clickHandlerFunc(false, e)

  # 設定されているイベントメソッド名を取得
  # @return [String] メソッド名
  getEventMethodName: ->
    if @_event?
      methodName = @_event[EventPageValueBase.PageValueKey.METHODNAME]
      if methodName?
        return methodName
      else
        EventPageValueBase.NO_METHOD
    else
      return EventPageValueBase.NO_METHOD

  # 設定されているイベントアクションタイプを取得
  # @return [Integer] アクションタイプ
  getEventActionType: ->
    if @_event?
      return @_event[EventPageValueBase.PageValueKey.ACTIONTYPE]

  # 変更設定されているフォーク番号を取得
  # @return [Integer] フォーク番号
  getChangeForkNum: ->
    if @_event?
      num = @_event[EventPageValueBase.PageValueKey.CHANGE_FORKNUM]
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
    @_isFinishedEvent = false
    @_skipEvent = false
    @_runningClickEvent = false

  # プレビュー開始
  preview: (@loopFinishCallback = null) ->
    if window.runDebug
      console.log('EventBase preview id:' + @id)

    @stopPreview( =>
      @_runningPreview = true
      @willChapter()
      # イベントループ
      @_doPreviewLoop = true
      @_skipEvent = false
      @_loopCount = 0
      @_previewTimer = null
      # FloatView表示
      FloatView.show(FloatView.displayPositionMessage(), FloatView.Type.PREVIEW)
      @_progress = 0
      @previewStepDraw()
    )

  # プレビューStep実行
  previewStepDraw: ->
    if @_doPreviewLoop
      if @_previewTimer?
        clearTimeout(@_previewTimer)
        @_previewTimer = null
      @_previewTimer = setTimeout( =>
        if @getEventActionType() == Constant.ActionType.SCROLL
          @scrollHandlerFunc(true)
          @_progress += 1
          if @_progress >= @progressMax()
            @_progress = 0
            @previewLoop()
          else
            @previewStepDraw()
        else if @getEventActionType() == Constant.ActionType.CLICK
          @clickHandlerFunc(true)
      , @constructor.STEP_INTERVAL_DURATION * 1000)
    else
      @stopPreview()

  # プレビュー実行ループ
  previewLoop: ->
    loopDelay = 1000 # 1秒毎イベント実行
    loopMaxCount = 5 # ループ5回
    if @_doPreviewLoop
      @_loopCount += 1
      if @_loopCount >= loopMaxCount
        @stopPreview()
      if @_previewTimer?
        clearTimeout(@_previewTimer)
        @_previewTimer = null
      @_previewTimer = setTimeout( =>
        if @_runningPreview
          # 状態を変更前に戻す
          @resetEvent()
          @willChapter()
          @previewStepDraw()
      , loopDelay)
      if !@_doPreviewLoop
        @stopPreview()
    else
      @stopPreview()

  # プレビューを停止
  # @param [Function] callback コールバック
  stopPreview: (callback = null) ->
    if window.runDebug
      console.log('EventBase stopPreview id:' + @id)

    if !@_runningPreview? || !@_runningPreview
      # 停止済み
      if callback?
        callback(false)
      return
    @_runningPreview = false

    if @_previewTimer?
      clearTimeout(@_previewTimer)
      FloatView.hide()
      @_previewTimer = null
    if @_clickIntervalTimer?
      clearInterval(@_clickIntervalTimer)
      @_clickIntervalTimer = null
    if @loopFinishCallback?
      @loopFinishCallback()
      @loopFinishCallback = null
    if callback?
      callback(true)

  # JQueryエレメントを取得
  # @abstract
  getJQueryElement: ->
    return null

  # チャプター開始前イベント
  willChapter: ->
    # インスタンスの状態を保存
    PageValue.saveInstanceObjectToFootprint(@id, true, @_event[EventPageValueBase.PageValueKey.DIST_ID])
    # 状態をイベント前に戻す
    @updateEventBefore()
    # イベント前後の変数の設定
    @setModifyBeforeAndAfterVar()

  # チャプター終了時イベント
  didChapter: ->
    # キャッシュ用の「__Cache」と付くインスタンス変数を削除
    for k, v of @
      if k.lastIndexOf('__Cache') >= 0
        delete @[k]
    # インスタンスの状態を保存
    PageValue.saveInstanceObjectToFootprint(@id, false, @_event[EventPageValueBase.PageValueKey.DIST_ID])

  # メソッド実行
  execMethod: (opt) ->
    # メソッド共通処理
    # アイテム位置&サイズ更新
    @updateInstanceParamByStep(opt.progress)

  # スクロール基底メソッド
  # @param [Integer] x スクロール横座標
  # @param [Integer] y スクロール縦座標
  scrollHandlerFunc: (isPreview = false, x = 0, y = 0) ->
    if @_isFinishedEvent || @_skipEvent
      # 終了済みorイベントを反応させない場合
      return

    # 動作済みフラグON
    if window.eventAction?
      window.eventAction.thisPage().thisChapter().doMoveChapter = true

    if isPreview
      # プレビュー時は1ずつ実行
      @stepValue += 1
    else
      # スクロール値更新
      #if window.debug
        #console.log("y:#{y}")
      plusX = 0
      plusY = 0
      if x > 0 && @_enabledDirections.right
        plusX = parseInt((x + 9) / 10)
      else if x < 0 && @_enabledDirections.left
        plusX = parseInt((x - 9) / 10)
      if y > 0 && @_enabledDirections.bottom
        plusY = parseInt((y + 9) / 10)
      else if y < 0 && @_enabledDirections.top
        plusY = parseInt((y - 9) / 10)

      if (plusX > 0 && !@_forwardDirections.right) ||
        (plusX < 0 && @_forwardDirections.left)
          plusX = -plusX
      if (plusY > 0 && !@_forwardDirections.bottom) ||
        (plusY < 0 && @_forwardDirections.top)
          plusY = -plusY

      @stepValue += plusX + plusY

    sPoint = parseInt(@_event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])
    ePoint = parseInt(@_event[EventPageValueBase.PageValueKey.SCROLL_POINT_END])

    # スクロール指定範囲外なら反応させない
    if @stepValue < sPoint
      #@stepValue = sPoint
      return
    else if @stepValue >= ePoint
      @stepValue = ePoint
      if !@_isFinishedEvent
        # 終了イベント
        @finishEvent()
        if !isPreview
          ScrollGuide.hideGuide()
      return

    @canForward = @stepValue < ePoint
    @canReverse = @stepValue > sPoint

    # ステップ実行
    @execMethod({
      isPreview: isPreview
      progress: @stepValue - sPoint
      progressMax: @progressMax()
    })

  # スクロールの長さを取得
  # @return [Integer] スクロール長さ
  scrollLength: ->
    return parseInt(@_event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) - parseInt(@_event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])

  # クリック基底メソッド
  # @param [Object] e クリックオブジェクト
  clickHandlerFunc: (isPreview = false, e = null) ->
    if e?
      e.preventDefault()

    if @_isFinishedEvent || @_skipEvent || @_runningClickEvent
      # 終了済みorイベントを反応させない場合
      return

    # クリックイベントは一回のみ実行
    @_runningClickEvent = true

    # 動作済みフラグON
    if window.eventAction?
      window.eventAction.thisPage().thisChapter().doMoveChapter = true

    # ステップ実行
    progressMax = @progressMax()
    @stepValue = 1
    @_clickIntervalTimer = setInterval( =>
      if !@_skipEvent
        @execMethod({
          isPreview: isPreview
          progress: @stepValue
          progressMax: progressMax
        })
        @stepValue += 1
        if progressMax < @stepValue
          clearInterval(@_clickIntervalTimer)
          # 終了イベント
          @finishEvent()
    , @constructor.STEP_INTERVAL_DURATION * 1000)

  # Step値を戻す
  resetProgress: (withResetFinishedEventFlg = true) ->
    @stepValue = 0
    if withResetFinishedEventFlg
      @_isFinishedEvent = false

  # UIの反応を有効にする
  enableHandleResponse: ->
    @_skipEvent = false

  # UIの反応を無効にする
  disableHandleResponse: ->
    @_skipEvent = true

  # イベントを終了する
  finishEvent: ->
    @_isFinishedEvent = true
    if @_clickIntervalTimer?
      clearInterval(@_clickIntervalTimer)
      @_clickIntervalTimer = null
    if @_runningPreview
      @previewLoop()
    else
      if window.eventAction?
        if @_event[EventPageValueBase.PageValueKey.FINISH_PAGE]
          # ページ遷移
          if @_event[EventPageValueBase.PageValueKey.JUMPPAGE_NUM] != EventPageValueBase.NO_JUMPPAGE
            window.eventAction.thisPage().finishAllChapters(@_event[EventPageValueBase.PageValueKey.JUMPPAGE_NUM] - 1)
          else
            window.eventAction.thisPage().finishAllChapters()
        else
          if @_handlerFuncComplete?
            @_handlerFuncComplete()
            @_handlerFuncComplete = null

  # イベント前のインスタンスオブジェクトを取得
  getMinimumObjectEventBefore: ->
    diff = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceDiffBefore(@_event[EventPageValueBase.PageValueKey.DIST_ID], @id))
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))
    return $.extend(true, obj, diff)

  # イベント前の表示状態にする
  updateEventBefore: ->
    if !@_event?
      # イベントが初期化されていない場合は無視
      return

    if window.runDebug
      console.log('EventBase updateEventBefore id:' + @id)

    @setMiniumObject(@getMinimumObjectEventBefore())
    @resetProgress()

  # イベント後の表示状態にする
  updateEventAfter: ->
    if !@_event?
      # イベントが初期化されていない場合は無視
      return

    if window.runDebug
      console.log('EventBase updateEventAfter id:' + @id)

    actionType = @getEventActionType()
    if actionType == Constant.ActionType.SCROLL
      @stepValue = @scrollLength()
    @updateInstanceParamByStep(null, true)
    # インスタンスの状態を保存
    PageValue.saveInstanceObjectToFootprint(@id, false, @_event[EventPageValueBase.PageValueKey.DIST_ID])

  # ステップ実行によるアイテム状態更新
  updateInstanceParamByStep: (progressValue, immediate = false)->
    if @getEventMethodName() == EventPageValueBase.NO_METHOD
      return

    progressMax = @progressMax()
    if !progressMax?
      progressMax = 1
    # NOTICE: varAutoChange=falseの場合は(変数)_xxxの形で変更前、変更後、進捗を渡してdraw側で処理させる
    progressPercentage = progressValue / progressMax
    eventBeforeObj = @getMinimumObjectEventBefore()
    mod = @constructor.actionPropertiesModifiableVars(@getEventMethodName())
    for varName, value of mod
      if @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS]? && @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]?
        before = eventBeforeObj[varName]
        after = @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
        if before? && after?
          if immediate
            @[varName] = after
          else
            if value.varAutoChange
              # 変数自動変更
              if value.type == Constant.ItemDesignOptionType.INTEGER
                @[varName] = before + (after - before) * progressPercentage
              else if value.type == Constant.ItemDesignOptionType.COLOR
                colorCacheVarName = "#{varName}ColorChange__Cache"
                if !@[colorCacheVarName]?
                  colorType = @constructor.actionPropertiesModifiableVars()[varName].colorType
                  if !colorType?
                    colorType = 'hex'
                  @[colorCacheVarName] = Common.colorChangeCacheData(before, after, progressMax, colorType)
                @[varName] = @[colorCacheVarName][progressValue]

  # アニメーションによるアイテム状態更新
  updateInstanceParamByAnimation: (immediate = false) ->
    if @getEventMethodName() == EventPageValueBase.NO_METHOD
      return

    # NOTICE: varAutoChange=falseの場合は(変数)_xxxの形で変更前、変更後、進捗を渡してdraw側で処理させる
    ed = @eventDuration()
    progressMax = @progressMax()
    eventBeforeObj = @getMinimumObjectEventBefore()
    mod = @constructor.actionPropertiesModifiableVars(@getEventMethodName())
    if immediate
      for varName, value of mod
        if @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS]? && @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]?
          after = @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
          if after?
            @[varName] = after
      return

    count = 1
    timer = setInterval( =>
      progressPercentage = @constructor.STEP_INTERVAL_DURATION * count / ed
      for varName, value of mod
        if @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS]? && @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]?
          before = eventBeforeObj[varName]
          after = @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
          if before? && after?
            if value.varAutoChange
              if value.type == Constant.ItemDesignOptionType.INTEGER
                @[varName] = before + (after - before) * progressPercentage
              else if value.type == Constant.ItemDesignOptionType.COLOR
                colorCacheVarName = "#{varName}ColorChange__Cache"
                if !@[colorCacheVarName]?
                  colorType = @constructor.actionPropertiesModifiableVars()[varName].colorType
                  if !colorType?
                    colorType = 'hex'
                  @[colorCacheVarName] = Common.colorChangeCacheData(before, after, progressMax, colorType)
                @[varName] = @[colorCacheVarName][count]
      count += 1
      if count > progressMax
        clearInterval(timer)
        for varName, value of mod
          if @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS]? && @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]?
            after = @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
            if after?
              @[varName] = after
    , @constructor.STEP_INTERVAL_DURATION * 1000)

  # イベント前後の変数を設定 [xxx__before] & [xxx__after]
  setModifyBeforeAndAfterVar: ->
    if !@_event?
      return

    beforeObj = @getMinimumObjectEventBefore()
    mod = @constructor.actionPropertiesModifiableVars(@getEventMethodName())
    for varName, value of mod
      if beforeObj?
        @[varName + @constructor.BEFORE_MODIFY_VAR_SUFFIX] = beforeObj[varName]
      if @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS]?
        afterObj = @_event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
        if afterObj?
          @[varName + @constructor.AFTER_MODIFY_VAR_SUFFIX] = afterObj

  # アイテムの情報をページ値に保存
  # @property [Boolean] isCache キャッシュとして保存するか
  setItemAllPropToPageValue: (isCache = false)->
    prefix_key = if isCache then PageValue.Key.instanceValueCache(@id) else PageValue.Key.instanceValue(@id)
    obj = @getMinimumObject()
    PageValue.setInstancePageValue(prefix_key, obj)

  # ステップ数最大値
  progressMax: ->
    return if @_event[EventPageValueBase.PageValueKey.ACTIONTYPE] == Constant.ActionType.SCROLL then @scrollLength() else @clickDurationStepMax()

  # クリック時間ステップ数最大値
  clickDurationStepMax: ->
    ed = @eventDuration()
    return Math.ceil(ed / @constructor.STEP_INTERVAL_DURATION)

  # クリック実行時間
  eventDuration: ->
    d = @_event[EventPageValueBase.PageValueKey.EVENT_DURATION]
    if d == 'undefined'
      d = null
    return d

  # 保存用の最小限のデータを取得 保存不要なタイプの判定は適宜追加
  # @return [Object] 取得データ
  getMinimumObject: ->
    obj = {}
    for k, v of @
      if v?
        if k.indexOf('_') != 0 &&
          (v instanceof ImageData) == false &&
          !Common.isElement(v) &&
          typeof v != 'function'
            obj[k] = Common.makeClone(v)
    return obj

  # 最小限のデータを設定 保存不要なタイプの判定は適宜追加
  # @param [Object] obj 設定データ
  setMiniumObject: (obj) ->
    # ID変更のため一度instanceMapから削除
    delete window.instanceMap[@id]
    for k, v of obj
      if v?
        if k.indexOf('_') != 0 &&
          (v instanceof ImageData) == false &&
          !Common.isElement(v) &&
          typeof v != 'function'
            @[k] = Common.makeClone(v)
    window.instanceMap[@id] = @

  # 独自コンフィグのイベント初期化
  # @abstract
  @initSpecificConfig = (specificRoot) ->

  # 編集可能変数プロパティを取得(childrenを含む)
  @actionPropertiesModifiableVars = (methodName = null, isDefault = false) ->
    _actionPropertiesModifiableVars = (modifiableRoot, ret) ->
      if modifiableRoot?
        for k, v of modifiableRoot
          ret[k] = v
          if v[EventBase.ActionPropertiesKey.MODIFIABLE_CHILDREN]?
            # Childrenを含める
            ret = $.extend(ret, _actionPropertiesModifiableVars.call(@, v[EventBase.ActionPropertiesKey.MODIFIABLE_CHILDREN], ret))
      return ret

    ret = {}
    modifiableRoot = null
    if methodName?
      if isDefault
        modifiableRoot = @actionProperties[methodName][@ActionPropertiesKey.MODIFIABLE_VARS]
      else
        modifiableRoot = @actionProperties.methods[methodName][@ActionPropertiesKey.MODIFIABLE_VARS]
    else
      modifiableRoot = @actionProperties[@ActionPropertiesKey.MODIFIABLE_VARS]

    return _actionPropertiesModifiableVars.call(@, modifiableRoot, ret)

