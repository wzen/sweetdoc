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
    @_doPreviewLoop = false
    @_enabledDirections = @_event[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS]
    @_forwardDirections = @_event[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS]
    @_specificMethodValues = @_event[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES]

    # スクロールイベント
    if @getEventActionType() == Constant.ActionType.SCROLL
      @scrollEvent = @scrollHandlerFunc
    # クリックイベント
    else if @getEventActionType() == Constant.ActionType.CLICK
      @clickEvent = @clickHandlerFunc

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

  # プレビュー開始
  # @param [Object] event 設定イベント
  preview: (event, loopFinishCallback = null) ->
    if window.runDebug
      console.log('EventBase preview id:' + @id)

    _preview = (event) ->
      @_runningPreview = true
      drawDelay = @constructor.STEP_INTERVAL_DURATION * 1000
      loopDelay = 1000 # 1秒毎イベント実行
      loopMaxCount = 5 # ループ5回
      progressMax = @progressMax()
      @willChapter()
      # イベントループ
      @_doPreviewLoop = true
      loopCount = 0
      @_previewTimer = null
      # FloatView表示
      FloatView.show(FloatView.displayPositionMessage(), FloatView.Type.PREVIEW)
      if !@isDrawByAnimationMethod()
        p = 0
        _draw = =>
          if @_doPreviewLoop
            if @_previewTimer?
              clearTimeout(@_previewTimer)
              @_previewTimer = null
            @_previewTimer = setTimeout( =>
              if @_runningPreview
                @execMethod({
                  isPreview: true
                  progress: p
                  progressMax: progressMax
                })
                p += 1
                if p >= progressMax
                  p = 0
                  _loop.call(@)
                else
                  _draw.call(@)
            , drawDelay)
          else
            @stopPreview(loopFinishCallback)

        _loop = =>
          if @_doPreviewLoop
            loopCount += 1
            if loopCount >= loopMaxCount
              @stopPreview(loopFinishCallback)

            if @_previewTimer?
              clearTimeout(@_previewTimer)
              @_previewTimer = null
            @_previewTimer = setTimeout( =>
              if @_runningPreview
                # 状態を変更前に戻す
                @resetEvent()
                #@willChapter()
                _draw.call(@)
            , loopDelay)
            if !@_doPreviewLoop
              @stopPreview(loopFinishCallback)
          else
            @stopPreview(loopFinishCallback)

        _draw.call(@)

      else
        _loop = =>
          if @_doPreviewLoop
            loopCount += 1
            if loopCount >= loopMaxCount
              @stopPreview(loopFinishCallback)

            if @_previewTimer?
              clearTimeout(@_previewTimer)
              @_previewTimer = null
            @_previewTimer = setTimeout( =>
              if @_runningPreview
                # 状態を変更前に戻す
                @resetEvent()
                #@willChapter()
                @execMethod({
                  isPreview: true
                  complete: _loop
                })
            , loopDelay)
          else
            @stopPreview(loopFinishCallback)

        @execMethod({
          isPreview: true
          complete: _loop
        })

    @stopPreview(loopFinishCallback, =>
      _preview.call(@, event)
    )

  # プレビューを停止
  # @param [Function] callback コールバック
  stopPreview: (loopFinishCallback = null, callback = null) ->
    if window.runDebug
      console.log('EventBase stopPreview id:' + @id)

    if !@_runningPreview? || !@_runningPreview
      # 停止済み
      if callback?
        callback(false)
      return
    @_runningPreview = false

    do =>
      if @_previewTimer?
        clearTimeout(@_previewTimer)
        FloatView.hide()
        @_previewTimer = null
      if loopFinishCallback?
        loopFinishCallback()
      if callback?
        callback(true)

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
    if !@isDrawByAnimationMethod()
      # アイテム位置&サイズ更新
      @updateInstanceParamByStep(opt.progress)
    else
      setTimeout( =>
        @updateInstanceParamByAnimation()
      , 0)

  # スクロール基底メソッド
  # @param [Integer] x スクロール横座標
  # @param [Integer] y スクロール縦座標
  # @param [Function] complete イベント終了後コールバック
  scrollHandlerFunc: (x, y, complete = null) ->
    if @_isFinishedEvent || @_skipEvent
      # 終了済みorイベントを反応させない場合
      return

    # 動作済みフラグON
    if window.eventAction?
      window.eventAction.thisPage().thisChapter().doMoveChapter = true

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

    @scrollValue += plusX + plusY

    sPoint = parseInt(@_event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])
    ePoint = parseInt(@_event[EventPageValueBase.PageValueKey.SCROLL_POINT_END])

    # スクロール指定範囲外なら反応させない
    if @scrollValue < sPoint
      #@scrollValue = sPoint
      return
    else if @scrollValue >= ePoint
      @scrollValue = ePoint
      if !@_isFinishedEvent
        if !@isDrawByAnimationMethod()
          # 終了イベント
          @_isFinishedEvent = true
          ScrollGuide.hideGuide()
          if complete?
            complete()
        else
          # アニメーション実行は1回のみ
          @_skipEvent = true
          @execMethod({
            isPreview: false
            complete: ->
              @_isFinishedEvent = true
              ScrollGuide.hideGuide()
              if complete?
                complete()
          })
      return

    @canForward = @scrollValue < ePoint
    @canReverse = @scrollValue > sPoint

    if !@isDrawByAnimationMethod()
      # ステップ実行
      @execMethod({
        isPreview: false
        progress: @scrollValue - sPoint
        progressMax: @progressMax()
      })

  # スクロールの長さを取得
  # @return [Integer] スクロール長さ
  scrollLength: ->
    return parseInt(@_event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) - parseInt(@_event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])

  # クリック基底メソッド
  # @param [Object] e クリックオブジェクト
  # @param [Function] complete イベント終了後コールバック
  clickHandlerFunc: (e, complete = null) ->
    e.preventDefault()

    if @_isFinishedEvent || @_skipEvent
      # 終了済みorイベントを反応させない場合
      return

    # イベントは一回のみ実行
    @_skipEvent = true

    # 動作済みフラグON
    if window.eventAction?
      window.eventAction.thisPage().thisChapter().doMoveChapter = true

    if !@isDrawByAnimationMethod()
      # ステップ実行
      progressMax = @progressMax()
      count = 1
      timer = setInterval( =>
        @execMethod({
          isPreview: false
          progress: count
          progressMax: progressMax
        })
        count += 1
        if progressMax < count
          clearInterval(timer)
          # 終了イベント
          @_isFinishedEvent = true
          if complete?
            complete()
      , @constructor.STEP_INTERVAL_DURATION * 1000)
    else
      # アニメーション実行
      @execMethod({
        isPreview: false
        complete: ->
          @_isFinishedEvent = true
          if complete?
            complete()
      })

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
    actionType = @getEventActionType()
    if actionType == Constant.ActionType.SCROLL
      @scrollValue = 0

  # イベント後の表示状態にする
  updateEventAfter: ->
    if !@_event?
      # イベントが初期化されていない場合は無視
      return

    if window.runDebug
      console.log('EventBase updateEventAfter id:' + @id)

    actionType = @getEventActionType()
    if actionType == Constant.ActionType.SCROLL
      @scrollValue = @scrollLength()
    if !@isDrawByAnimationMethod()
      @updateInstanceParamByStep(null, true)
    else
      @updateInstanceParamByAnimation(true)
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
              if value.type == Constant.ItemDesignOptionType.NUMBER
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
              if value.type == Constant.ItemDesignOptionType.NUMBER
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

  # メソッドがアニメーションとして実行するか
  isDrawByAnimationMethod: ->
    if @getEventMethodName() != EventPageValueBase.NO_METHOD
      return @constructor.actionProperties.methods[@getEventMethodName()][EventPageValueBase.PageValueKey.IS_DRAW_BY_ANIMATION]? && @constructor.actionProperties.methods[@getEventMethodName()][EventPageValueBase.PageValueKey.IS_DRAW_BY_ANIMATION]
    else
      return false

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
    if methodName?
      if isDefault
        modifiableRoot = @actionProperties[methodName][@ActionPropertiesKey.MODIFIABLE_VARS]
      else
        modifiableRoot = @actionProperties.methods[methodName][@ActionPropertiesKey.MODIFIABLE_VARS]
    else
      modifiableRoot = @actionProperties[@ActionPropertiesKey.MODIFIABLE_VARS]

    return _actionPropertiesModifiableVars.call(@, modifiableRoot, ret)

