class Sidebar
  # 定数
  constant = gon.const
  @SIDEBAR_TAB_ROOT = constant.ElementAttribute.SIDEBAR_TAB_ROOT

  class @Type
    @STATE = 'state'
    @EVENT = 'event'
    @SETTING = 'setting'

  # サイドバーをオープン
  # @param [Array] target フォーカス対象オブジェクト
  # @param [String] selectedBorderType 選択枠タイプ
  @openConfigSidebar = (target = null, selectedBorderType = "edit") ->
    if window.isWorkTable
      if !Sidebar.isOpenedConfigSidebar()
        # モードを変更
        WorktableCommon.changeMode(Constant.Mode.OPTION)
        main = $('#main')
        if !Sidebar.isOpenedConfigSidebar()
          main.removeClass('col-xs-12')
          main.addClass('col-xs-9')
          $('#sidebar').fadeIn('500', ->
            WorktableCommon.resizeMainContainerEvent()
          )
#          if target != null
#            WorktableCommon.focusToTargetWhenSidebarOpen(target, selectedBorderType, true)

        # 閉じるイベント設定
        $('#screen_wrapper').off('click.sidebar_close').on('click.sidebar_close', (e) =>
          if Sidebar.isOpenedConfigSidebar()
            # イベント用選択モードの場合は閉じない
            if window.eventPointingMode == Constant.EventInputPointingMode.NOT_SELECT
              Sidebar.closeSidebar()
              # モードを変更以前に戻す
              WorktableCommon.putbackMode()
              # イベントを消去
              $(window.drawingCanvas).off('click.sidebar_close')
        )

  # サイドバーをクローズ
  # @param [Function] callback コールバック
  @closeSidebar = (callback = null) ->
    if window.isWorkTable
      # 選択枠を削除
      WorktableCommon.clearSelectedBorder()
      # イベントポインタ削除
      WorktableCommon.clearEventPointer()
      # サイドビューのWidgetを全て非表示
      @closeAllWidget()
      if !Sidebar.isClosedConfigSidebar()
        main = $('#main')
        $('#sidebar').fadeOut('200', ->
          main.removeClass('col-xs-9')
          main.addClass('col-xs-12')
          WorktableCommon.resizeMainContainerEvent()
          # モード再設定
          if window.mode == Constant.Mode.OPTION
            WorktableCommon.changeMode(window.beforeMode)
          else
            WorktableCommon.changeMode(window.mode)
          if callback?
            callback()
          $('.sidebar-config').hide()
        )

  # サイドバーがオープンしているか
  # @return [Boolean] 判定結果
  @isOpenedConfigSidebar = ->
    return $('#main').hasClass('col-xs-9')

  # サイドバーがクローズしているか
  # @return [Boolean] 判定結果
  @isClosedConfigSidebar = ->
    return $('#main').hasClass('col-xs-12')

  # 全Widget非表示
  @closeAllWidget = ->
    $('.colorpicker:visible').hide()

  # サイドバー内容のスイッチ
  # @param [String] configType コンフィグタイプ
  # @param [Object] item アイテムオブジェクト
  @switchSidebarConfig = (configType, item = null) ->
    animation = @isOpenedConfigSidebar()
    $('.sidebar-config').hide()

    if configType == @Type.STATE || configType == @Type.SETTING
      sc = $("##{@SIDEBAR_TAB_ROOT}")
      if animation
        sc.fadeIn('fast')
      else
        sc.show()
    else if configType == @Type.EVENT
      if animation
        $('#event-config').fadeIn('fast')
      else
        $('#event-config').show()

  # アイテム編集メニュー表示
  @openItemEditConfig = (target) ->
    emt = $(target)
    obj = instanceMap[emt.attr('id')]
    # アイテム編集メニュー初期化
    @initItemEditConfig(obj, =>
      if obj? && obj.showOptionMenu?
        # オプションメニュー表示処理
        obj.showOptionMenu()
      # オプションメニューを表示
      @openConfigSidebar(target)
    )

  # 状態メニュー表示
  @openStateConfig = ->
    root = $('#tab-config')
    scrollBarWidths = 40;
    @openConfigSidebar()

    widthOfList = ->
      itemsWidth = 0
      $('.nav-tabs li', root).each( ->
        itemWidth = $(@).outerWidth();
        itemsWidth+=itemWidth
      )
      return itemsWidth

    widthOfHidden = ->
      return (($('.tab-nav-tabs-wrapper', root).outerWidth())-widthOfList()-getLeftPosi())-scrollBarWidths

    getLeftPosi = ->
      return $('.nav-tabs', root).position().left

    reAdjust = ->
      if ($('.tab-nav-tabs-wrapper', root).outerWidth()) < widthOfList()
        $('.scroller-right', root).show()
      else
        $('.scroller-right', root).hide()

      if getLeftPosi()<0
        $('.scroller-left', root).show()
      else
        $('.item', root).animate({left:"-="+getLeftPosi()+"px"},'fast')
        $('.scroller-left', root).hide();

    reAdjust();
    $('.scroller-right', root).off('click').on('click', ->
      $('.scroller-left', root).fadeIn('fast');
      $('.scroller-right', root).fadeOut('fast');
      $('.nav-tabs', root).animate({left:"+="+widthOfHidden()+"px"},'fast')
    )
    $('.scroller-left', root).off('click').on('click', ->
      $('.scroller-right', root).fadeIn('fast');
      $('.scroller-left', root).fadeOut('fast');
      $('.nav-tabs', root).animate({left:"-="+getLeftPosi()+"px"},'fast')
    )

  # アイテム編集メニュー初期化
  @initItemEditConfig = (obj, callback = null) ->
    # カラーピッカー値を初期化
    ColorPickerUtil.initColorPickerValue()
    # オプションメニューの値を初期化
    if obj? && obj.setupOptionMenu?
      # 初期化関数を呼び出す
      obj.setupOptionMenu(callback)

  # イベントコンフィグ初期化
  @initEventConfig = (distId, teNum = 1)->
    eId = EventConfig.ITEM_ROOT_ID.replace('@distId', distId)
    emt = $("##{eId}")
    if emt.length == 0
      # イベントメニューの作成
      emt = $('#event-config .event_temp .event').clone(true).attr('id', eId)
      $('#event-config').append(emt)
    # イベントコンフィグメニュー初期化
    EventConfig.initEventConfig(distId, teNum)

  # 操作不可にする
  @disabledOperation = (flg) ->
    if flg
      if $('#sidebar .cover_touch_overlay').length == 0
        $('#sidebar').append("<div class='cover_touch_overlay'></div>")
        $('.cover_touch_overlay').off('click').on('click', (e) ->
          e.preventDefault()
          return
        )
    else
      $('#sidebar .cover_touch_overlay').remove()

  @resizeConfigHeight = ->
    contentsHeight = $('#contents').height()
    tabHeight = 39
    padding = 5
    $('#myTabContent').height(contentsHeight - tabHeight - padding * 2)
