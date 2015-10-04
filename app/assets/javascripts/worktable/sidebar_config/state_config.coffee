class StateConfig
  if gon?
    # 定数
    constant = gon.const
    @ROOT_ID_NAME = constant.StateConfig.ROOT_ID_NAME
    @ITEM_TEMP_CLASS_NAME = constant.StateConfig.ITEM_TEMP_CLASS_NAME

  # コンフィグ初期化
  @initConfig = ->
    rootEmt = $("##{@ROOT_ID_NAME}")

    # 画面座標

    # 作成アイテム一覧
    createdItemList = $('.created_item_list', rootEmt)
    items = PageValue.getCreatedItems()
    if Object.keys(items).length > 0
      createdItemList.closest('.configBox').show()
      for k, v of items
        temp = $(".#{@ITEM_TEMP_CLASS_NAME}", rootEmt).children(':first').clone(true)
        temp.find('.name').html(v.value.name)
        if !$("##{k}").is(':visible')
          temp.find('.visible').hide()
          temp.find('.invisible').show()
        createdItemList.append(temp)

