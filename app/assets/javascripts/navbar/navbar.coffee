class Navbar
  # 定数
  constant = gon.const
  # @property [String] NAVBAR_ROOT ナビヘッダーRoot
  @NAVBAR_ROOT = constant.ElementAttribute.NAVBAR_ROOT
  # @property [String] ITEM_MENU_PREFIX アイテムメニュープレフィックス
  @ITEM_MENU_PREFIX = 'menu-item-'
  # @property [String] FILE_LOAD_CLASS ファイル読み込み クラス名
  @FILE_LOAD_CLASS = constant.ElementAttribute.FILE_LOAD_CLASS
  # @property [String] LAST_UPDATE_TIME_CLASS 最新更新日 クラス名
  @LAST_UPDATE_TIME_CLASS = constant.ElementAttribute.LAST_UPDATE_TIME_CLASS

  # Worktableナビバー初期化
  @initWorktableNavbar = ->
    fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li')
    $('.menu-changeproject', fileMenuEmt).off('click').on('click', ->
      _cbk = ->
        # データを保存
        ServerStorage.save( =>
          WorktableCommon.resetWorktable()
          # ナビバーをプロジェクト作成前状態に
          Navbar.switchWorktableNavbarWhenProjectCreated(false)
          # 初期モーダル表示
          Common.showModalView(Constant.ModalViewType.INIT_PROJECT, true, Project.initProjectModal)
        )

      if Object.keys(window.instanceMap).length > 0 || PageValue.getPageCount() >= 2
        lastSaveTimeStr = ''
        lastSaveTime = Common.displayLastUpdateDiffAlmostTime()
        if lastSaveTime?
          lastSaveTimeStr = '\n' + I18n.t('message.dialog.last_savetime') + lastSaveTime
        if window.confirm(I18n.t('message.dialog.change_project') + lastSaveTimeStr)
          _cbk.call(@)
      else
        _cbk.call(@)
    )
    $('.menu-adminproject', fileMenuEmt).off('click').on('click', ->
      # モーダル表示
      Common.showModalView(Constant.ModalViewType.ADMIN_PROJECTS, true, Project.initAdminProjectModal)
    )
    menuSave = $('.menu-save', fileMenuEmt)
    menuSave.off('click').on('click', ->
      ServerStorage.save()
    )
    menuSave.off('mouseenter').on('mouseenter', (e) ->
      lastSaveTime = Common.displayLastUpdateDiffAlmostTime()
      if lastSaveTime?
        li = @closest('li')
        $(li).append($("<div class='pop' style='display:none'><p>Last Save #{lastSaveTime}</p></div>"))
        $('.pop', li).css({top: $(li).height() + 30, left: $(li).width()})
        $('.pop', li).show()
    )
    menuSave.off('mouseleave').on('mouseleave', (e) ->
      ul = @closest('ul')
      $('.pop', ul).remove()
    )
    $('.menu-load', fileMenuEmt).off('mouseenter').on('mouseenter', ->
      Navbar.get_load_list()
    )
    etcMenuEmt = $('#header_etc_select_menu .dropdown-menu > li')
    $('.menu-about', etcMenuEmt).off('click').on('click', ->
      Common.showModalView(Constant.ModalViewType.ABOUT)
    )
    $('.menu-backtomainpage', etcMenuEmt).off('click').on('click', ->
      window.location.href = '/'
    )
    itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li')
    $('.menu-item', itemsSelectMenuEmt).off('click').on('click', ->
      Sidebar.closeSidebar()
      selected = $(@).html()
      $('#header_items_selected_menu_span').html(selected)
      # プレビューを停止して再描画
      WorktableCommon.refreshAllItemsFromInstancePageValueIfChanging()
      # 選択枠削除
      WorktableCommon.clearSelectedBorder()
      emtId = $(this).attr('id')
      if emtId.indexOf(Navbar.ITEM_MENU_PREFIX) >= 0
        classDistToken = emtId.replace(Navbar.ITEM_MENU_PREFIX, '')
        Navbar.setModeDraw(classDistToken, =>
          WorktableCommon.changeMode(Constant.Mode.DRAW)
        )
    )
    $('#menu-action-edit').off('click').on('click', ->
      Sidebar.closeSidebar()
      Navbar.setModeEdit()
      WorktableCommon.changeMode(Constant.Mode.EDIT)
    )
    $('#menu_sidebar_toggle').off('click').on('click', ->
      if Sidebar.isOpenedConfigSidebar()
        Sidebar.closeSidebar()
      else
        Sidebar.switchSidebarConfig(Sidebar.Type.STATE)
        StateConfig.initConfig()
        WorktableSetting.initConfig()
        ItemStateConfig.initConfig()
        Sidebar.openStateConfig()
    )

  @switchWorktableNavbarWhenProjectCreated = (flg) ->
    if flg
      root = $('#header_items_file_menu')
      # プロジェクト作成後のナビバーに表示変更
      $(".menu-save-li", root).show()
      $('#header_items_select_menu').show()
      $('#header_items_motion_check').show()
      $('#menu_sidebar_toggle').show()
      $("##{Constant.Paging.NAV_ROOT_ID}").show()
      $('#menu_sidebar_toggle_li').show()
      $("##{@NAVBAR_ROOT} .#{@LAST_UPDATE_TIME_CLASS}").closest('li').show()
    else
      # プロジェクト作成前のナビバーに表示変更
      $(".menu-save-li", root).hide()
      $('#header_items_select_menu').hide()
      $('#header_items_motion_check').hide()
      $('#menu_sidebar_toggle').hide()
      $("##{Constant.Paging.NAV_ROOT_ID}").hide()
      $('#menu_sidebar_toggle_li').hide()
      $("##{@NAVBAR_ROOT} .#{@LAST_UPDATE_TIME_CLASS}").closest('li').hide()
  # Runナビバー初期化
  @initRunNavbar = ->
    navEmt = $('#nav')
    $('.menu-showguide', navEmt).off('click').on('click', ->
      RunSetting.toggleShowGuide()
    )
    $('.menu-control-rewind-page', navEmt).off('click').on('click', ->
      if window.eventAction?
        window.eventAction.thisPage().rewindAllChapters()
    )
    $('.menu-control-rewind-chapter', navEmt).off('click').on('click', ->
      if window.eventAction?
        window.eventAction.thisPage().rewindChapter()
    )
    $('.menu-upload-gallery', navEmt).off('click').on('click', ->
      RunCommon.showUploadGalleryConfirm()
    )

  # Codingナビバー初期化
  @initCodingNavbar = ->
    fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li')
    menuSave = $('.menu-save', fileMenuEmt)
    menuSave.off('click').on('click', ->
      CodingCommon.saveActiveCode()
    )
    fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li')
    menuSave = $('.menu-all-save', fileMenuEmt)
    menuSave.off('click').on('click', ->
      CodingCommon.saveAllCode()
    )

  # アイテムプレビューナビバー初期化
  @initItemPreviewNavbar = ->
    navEmt = $('#nav')
    $('.menu-upload-item', navEmt).off('click').on('click', ->
      ItemPreviewCommon.showUploadItemConfirm()
    )
    $('.menu-add-item', navEmt).off('click').on('click', ->
      ItemPreviewCommon.showAddItemConfirm()
    )

  # Drawモードに設定
  @setModeDraw = (classDistToken, callback = null) ->
    itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li')
    itemsSelectMenuEmt.removeClass('active')
    emtId = "menu-item-" + classDistToken
    menuItem = $("##{emtId}")
    menuItem.parent('li').addClass('active')
    $('#header_items_selected_menu_span').html(menuItem.html())
    window.selectItemMenu = classDistToken
    Common.loadItemJs(classDistToken, callback)

  # Editモードに設定
  @setModeEdit = ->
    selected = $('#menu-action-edit').html()
    $('#header_items_selected_menu_span').html(selected)
    itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li')
    itemsSelectMenuEmt.removeClass('active')
    $('#menu-action-edit').parent('li').addClass('active')

  # ヘッダーにタイトルを設定
  @setTitle = (title_name) ->
    if !window.isWorkTable
      title_name += '(Preview)'
    $("##{Navbar.NAVBAR_ROOT}").find('.nav_title').html(title_name)
    if title_name? && title_name.length > 0
      document.title = title_name
    else
      document.title = window.appName

  # 保存されているデータ一覧を取得してNavbarに一覧で表示
  @get_load_list: ->
    loadEmt = $("##{Navbar.NAVBAR_ROOT}").find(".#{ServerStorage.ElementAttribute.FILE_LOAD_CLASS}")
    updateFlg = loadEmt.find(".#{ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG}").length > 0
    if updateFlg
      loadedLocalTime = loadEmt.find(".#{ServerStorage.ElementAttribute.LOADED_LOCALTIME}")
      if loadedLocalTime?
        diffTime = Common.calculateDiffTime($.now(), parseInt(loadedLocalTime.val()))
        s = diffTime.seconds
        if window.debug
          console.log('loadedLocalTime diff ' + s)
        if parseInt(s) <= ServerStorage.ElementAttribute.LOAD_LIST_INTERVAL_SECONDS
          # 読み込んでX秒以内ならロードしない
          return

    loadEmt.children().remove()
    $("<li><a class='menu-item'>Loading...</a></li>").appendTo(loadEmt)

    ServerStorage.get_load_data((data) ->
      user_pagevalue_list = data.user_pagevalue_list
      if user_pagevalue_list.length > 0
        list = ''
        n = $.now()
        for p in user_pagevalue_list
          d = new Date(p['updated_at'])
          e = "<li><a class='menu-item'>#{Common.displayDiffAlmostTime(n, d.getTime())} (#{Common.formatDate(d)})</a><input type='hidden' class='user_pagevalue_id' value=#{p['id']}></li>"
          list += e
        loadEmt.children().remove()
        $(list).appendTo(loadEmt)
        # クリックイベント設定
        loadEmt.find('li').off('click')
        loadEmt.find('li').on('click', (e) ->
          user_pagevalue_id = $(@).find('.user_pagevalue_id:first').val()
          Project.load(user_pagevalue_id)
        )

        # ロード済みに変更 & 現在時間を記録
        loadEmt.find(".#{ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG}").remove()
        loadEmt.find(".#{ServerStorage.ElementAttribute.LOADED_LOCALTIME}").remove()
        $("<input type='hidden' class=#{ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG} value='1'>").appendTo(loadEmt)
        $("<input type='hidden' class=#{ServerStorage.ElementAttribute.LOADED_LOCALTIME} value=#{$.now()}>").appendTo(loadEmt)

      else
        loadEmt.children().remove()
        $("<li><a class='menu-item'>No Data</a></li>").appendTo(loadEmt)
    ,
    ->
      if window.debug
        console.log(data.responseText)
      loadEmt.children().remove()
      $("<li><a class='menu-item'>Server Access Error</a></li>").appendTo(loadEmt)
    )

  @setLastUpdateTime = (update_at) ->
    $("##{@NAVBAR_ROOT} .#{@LAST_UPDATE_TIME_CLASS}").html("#{I18n.t('header_menu.etc.last_update_date')} : #{Common.displayLastUpdateTime(update_at)}")

  # 操作不可にする
  @disabledOperation = (flg) ->
    if flg
      if $("##{@NAVBAR_ROOT} .cover_touch_overlay").length == 0
        $("##{@NAVBAR_ROOT}").append("<div class='cover_touch_overlay'></div>")
        $('.cover_touch_overlay').off('click').on('click', (e) ->
          e.preventDefault()
          return
        )
    else
      $("##{@NAVBAR_ROOT} .cover_touch_overlay").remove()
