class ItemEventBase extends EventBase

  # イベントの初期化
  # @param [Object] event 設定イベント
  initEvent: (event) ->
    super(event)
    @initEventPrepare()
    # 描画してアイテムを作成
    # 表示非表示はwillChapterで切り替え
    # 何故必要か調査中
    #@refresh(false)

  # initEvent前の処理
  # @abstract
  initEventPrepare: ->

  # メソッド実行
  execMethod: (opt) ->
    super(opt)
    methodName = @getEventMethodName()
    if methodName != EventPageValueBase.NO_METHOD
      (@constructor.prototype[methodName]).call(@, opt)
    else
      # 再描画してアイテム状態を反映
      @refresh()