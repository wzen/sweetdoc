class StateConfig
  if gon?
    # 定数
    constant = gon.const
    @ROOT_ID_NAME = constant.Setting.ROOT_ID_NAME

  # コンフィグ初期化
  @initConfig = ->
