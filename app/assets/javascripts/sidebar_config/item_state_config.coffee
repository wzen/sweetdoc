class ItemStateConfig
  if gon?
    # 定数
    constant = gon.const
    @ROOT_ID_NAME = constant.ItemStateConfig.ROOT_ID_NAME
    @ITEM_TEMP_CLASS_NAME = constant.ItemStateConfig.ITEM_TEMP_CLASS_NAME

  # 設定値初期化
  @initConfig: ->
    # 作成アイテム一覧
    createdItemList = $('.created_item_list', rootEmt)
    createdItemList.children().remove()
    items = PageValue.getCreatedItems()
    if Object.keys(items).length > 0
      createdItemList.closest('.configBox').show()
      for k, v of items
        temp = $(".#{@ITEM_TEMP_CLASS_NAME}", rootEmt).children(':first').clone(true)
        temp.find('.item_obj_id').val(k)
        temp.find('.name').html(v.value.name)
        if !$("##{k}").is(':visible')
          temp.find('.item_visible').hide()
          temp.find('.item_invisible').show()
        createdItemList.append(temp)

      $('.focus_enabled > a').off('click').on('click', (e) ->
        objId = $(@).closest('.wrapper').find('.item_obj_id').val()
        # アイテムにフォーカス
        Common.focusToTarget($("##{objId}"), ->
          rootEmt = $("##{StateConfig.ROOT_ID_NAME}")
          position = PageValue.getGeneralPageValue(PageValue.Key.displayPosition())
          $('.display_position_x', rootEmt).val(parseInt(position.left))
          $('.display_position_y', rootEmt).val(parseInt(position.top))
        )
      )

      $('a.item_edit', rootEmt).off('click').on('click', (e) ->
        e.preventDefault()
        objId = $(@).closest('.wrapper').find('.item_obj_id').val()
        Sidebar.openItemEditConfig($("##{objId}"))
      )

      $('.item_visible > a, .item_invisible > a', rootEmt).off('click').on('click', (e) ->
        e.preventDefault()
        ItemStateConfig.clickToggleVisible(@)
      )


  @clickToggleVisible = (target) ->
    objId = $(target).closest('.wrapper').find('.item_obj_id').val()
    emt = $("##{objId}")
    emt.toggle()
    parent = $(target.closest('.buttons'))
    if emt.is(':visible')
      parent.find('.item_visible').show()
      parent.find('.item_invisible').hide()
      parent.find('.focus_enabled').show()
      parent.find('.focus_disabled').hide()
    else
      parent.find('.item_visible').hide()
      parent.find('.item_invisible').show()
      parent.find('.focus_enabled').hide()
      parent.find('.focus_disabled').show()