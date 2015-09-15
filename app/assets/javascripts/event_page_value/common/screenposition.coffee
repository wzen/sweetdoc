class EPVScreenPosition extends EventPageValueBase
  @X = 'x'
  @Y = 'y'
  @Z = 'z'

  # コンフィグ初期設定
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  @initConfigValue = (eventConfig) ->
    super(eventConfig)
    $('.screenposition_change_x:first', eventConfig.emt).val(0)
    $('.screenposition_change_y:first', eventConfig.emt).val(0)
    $('.screenposition_change_z:first', eventConfig.emt).val(0)

  # PageValueに書き込みデータを取得
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  # @return [String] エラーメッセージ
  @writeToPageValue = (eventConfig) ->
    errorMes = ""
    emt = eventConfig.emt
    writeValue = super(eventConfig)
    value = {}
    value[@X] = $('.screenposition_change_x:first', emt).val()
    value[@Y] = $('.screenposition_change_y:first', emt).val()
    value[@Z] = $('.screenposition_change_z:first', emt).val()
    writeValue[@PageValueKey.VALUE] = value

    if errorMes.length == 0
      PageValue.setEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum), writeValue)
      PageValue.setEventPageValue(PageValue.Key.eventCount(), eventConfig.teNum)

    return errorMes

  # PageValueからConfigにデータを読み込み
  # @param [Object] eventConfig イベントコンフィグオブジェクト
  # @return [Boolean] 読み込み成功したか
  @readFromPageValue = (eventConfig) ->
    ret = super(eventConfig)
    if !ret
      return false
    emt = eventConfig.emt
    writeValue = PageValue.getEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum))
    value = writeValue[@PageValueKey.VALUE]
    $('.screenposition_change_x:first', emt).val(value[@X])
    $('.screenposition_change_y:first', emt).val(value[@Y])
    $('.screenposition_change_z:first', emt).val(value[@Z])
    return true
