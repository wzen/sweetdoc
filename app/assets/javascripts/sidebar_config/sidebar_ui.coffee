class Sidebar

  if gon?
    # 定数
    constant = gon.const
    @SIDEBAR_TAB_ROOT = constant.ElementAttribute.SIDEBAR_TAB_ROOT

  class @Type
    @STATE = 'state'
    @CSS = 'css'
    @CANVAS = 'canvas'
    @TIMELINE = 'timeline'
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
    else if configType == @Type.CSS && item? && item.cssConfig?
      if animation
        item.cssConfig.fadeIn('fast')
      else
        item.cssConfig.show()
    else if configType == @Type.CANVAS && item? && item.canvasConfig?
      if animation
        item.canvasConfig.fadeIn('fast')
      else
        item.canvasConfig.show()
    else if configType == @Type.TIMELINE
      if animation
        $('#event-config').fadeIn('fast')
      else
        $('#event-config').show()

  # アイテム編集メニュー表示
  @openItemEditConfig = (target) ->
    emt = $(target)
    obj = instanceMap[emt.attr('id')]
    # コンフィグ表示切り替え
    if obj instanceof CssItemBase
      @switchSidebarConfig(@Type.CSS)
    else if obj instanceof CanvasItemBase
      @switchSidebarConfig(@Type.CANVAS)
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

  @initEventConfig = (distId, teNum = 1)->
    eId = EventConfig.ITEM_ROOT_ID.replace('@distid', distId)
    emt = $("##{eId}")
    if emt.length == 0
      # イベントメニューの作成
      emt = $('#event-config .event_temp .event').clone(true).attr('id', eId)
      $('#event-config').append(emt)
    # アイテム選択メニュー更新
    EventConfig.updateSelectItemMenu()
    # イベントハンドラの設定
    EventConfig.setupTimelineEventHandler(distId, teNum)

