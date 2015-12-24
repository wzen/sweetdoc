class Sidebar

  if gon?
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
          if target != null
            WorktableCommon.focusToTargetWhenSidebarOpen(target, selectedBorderType)

        # 閉じるイベント設定
        $(window.drawingCanvas).one('click.sidebar_close', (e) =>
          Sidebar.closeSidebar()
          # モードを変更以前に戻す
          WorktableCommon.putbackMode()
        )

  # サイドバーをクローズ
  # @param [Function] callback コールバック
  @closeSidebar = (callback = null) ->
    if window.isWorkTable
      # 選択枠を削除
      WorktableCommon.clearSelectedBorder()
      if !Sidebar.isClosedConfigSidebar()
        main = $('#main')
        $('#sidebar').fadeOut('500', ->
          main.removeClass('col-xs-9')
          main.addClass('col-xs-12')
          WorktableCommon.resizeMainContainerEvent()
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
    @initItemEditConfig(obj)
    if obj? && obj.showOptionMenu?
      # オプションメニュー表示処理
      obj.showOptionMenu()
    # オプションメニューを表示
    @openConfigSidebar(target)

  # アイテム編集メニュー初期化
  @initItemEditConfig = (obj) ->
    # カラーピッカー値を初期化
    ColorPickerUtil.initColorPickerValue()
    # オプションメニューの値を初期化
    if obj? && obj.setupOptionMenu?
      # 初期化関数を呼び出す
      obj.setupOptionMenu()

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


