class CommonEventBase extends EventBase

  # イベントの初期化
  # @param [Object] event 設定イベント
  initEvent: (event) ->
    super(event)

  # メソッド実行
  execMethod: (opt) ->
    super(opt)
    (@constructor.prototype[@getEventMethodName()]).call(@, opt)

