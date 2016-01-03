class StateConfig
  if gon?
    # 定数
    constant = gon.const
    @ROOT_ID_NAME = constant.StateConfig.ROOT_ID_NAME

  # 設定値初期化
  @initConfig: ->
    # Background Color


    # ScreenEvent

