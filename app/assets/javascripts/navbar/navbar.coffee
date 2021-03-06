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
          Common.showModalView(constant.ModalViewType.INIT_PROJECT, true, Project.initProjectModal)
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
      Common.showModalView(constant.ModalViewType.ADMIN_PROJECTS, false, Project.initAdminProjectModal)
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
      Common.showModalView(constant.ModalViewType.ABOUT)
    )
    $('.menu-backtomainpage', etcMenuEmt).off('click').on('click', ->
      window.location.href = '/'
    )
    itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li')
    $('.menu-item', itemsSelectMenuEmt).off('click').on('click', (e) ->
      if $(@).hasClass('href')
        d = $(@).attr('disabled')
        if d?
          return false
        return
      Sidebar.closeSidebar()
      selected = $(@).html()
      $('#header_items_selected_menu_span').html(selected)
      # 選択枠削除
      WorktableCommon.clearSelectedBorder()
      emtId = $(this).attr('id')
      if emtId.indexOf(Navbar.ITEM_MENU_PREFIX) >= 0
        classDistToken = emtId.replace(Navbar.ITEM_MENU_PREFIX, '')
        Navbar.setModeDraw(classDistToken, =>
          WorktableCommon.changeMode(constant.Mode.DRAW)
        )
    )
    $('#menu-action-edit').off('click').on('click', ->
      Sidebar.closeSidebar()
      Navbar.setModeEdit()
      WorktableCommon.changeMode(constant.Mode.EDIT)
    )
    $('#menu_sidebar_toggle').off('click').on('click', ->
      if Sidebar.isOpenedConfigSidebar()
        Sidebar.closeSidebar()
      else
        Sidebar.switchSidebarConfig(Sidebar.Type.STATE)
        navTab = $('#tab-config .nav-tabs')
        # コンフィグ初期化
        activeConfig = navTab.find('li.active')
        if activeConfig.hasClass('beginning_event_state')
          StateConfig.initConfig()
        else if activeConfig.hasClass('worktable_setting')
          WorktableSetting.initConfig()
        else if activeConfig.hasClass('item_state')
          ItemStateConfig.initConfig()
        # タブ選択時イベントの設定
        navTab.find('li > a').off('click.init').on('click.init', (e) =>
          # 選択枠を削除
          WorktableCommon.clearSelectedBorder()
          # イベントポインタ削除
          WorktableCommon.clearEventPointer()
          activeConfig = $(e.target).closest('li')
          if activeConfig.hasClass('beginning_event_state')
            StateConfig.initConfig()
          else if activeConfig.hasClass('worktable_setting')
            WorktableSetting.initConfig()
          else if activeConfig.hasClass('item_state')
            ItemStateConfig.initConfig()
        )
        Sidebar.openStateConfig()
    )

  @switchWorktableNavbarWhenProjectCreated = (flg) ->
    if flg
      root = $('#header_items_file_menu')
      # プロジェクト作成後のナビバーに表示変更
      $(".menu-save-li", root).show()
      if Project.isSampleProject()
        $(".menu-save-li", root).addClass('disabled')
        $(".menu-save", root).attr('disabled', 'disabled')
        $(".last_update_time_li", root).hide()
      else
        $(".menu-save-li", root).removeClass('disabled')
        $(".menu-save", root).removeAttr('disabled')
        $(".last_update_time_li", root).show()
      $('#header_items_select_menu').show()
      $('#header_items_motion_check').show()
      $('#menu_sidebar_toggle').show()
      $("##{constant.Paging.NAV_ROOT_ID}").show()
      $('#menu_sidebar_toggle_li').show()
      $("##{@NAVBAR_ROOT} .#{@LAST_UPDATE_TIME_CLASS}").closest('li').show()
    else
      # プロジェクト作成前のナビバーに表示変更
      $(".menu-save-li", root).hide()
      $('#header_items_select_menu').hide()
      $('#header_items_motion_check').hide()
      $('#menu_sidebar_toggle').hide()
      $("##{constant.Paging.NAV_ROOT_ID}").hide()
      $('#menu_sidebar_toggle_li').hide()
      $("##{@NAVBAR_ROOT} .#{@LAST_UPDATE_TIME_CLASS}").closest('li').hide()
  # Runナビバー初期化
  @initRunNavbar = ->
    navEmt = $('#nav')
    $('.menu-screenSize', navEmt).off('click').on('click', ->
      Common.showModalView(constant.ModalViewType.CHANGE_SCREEN_SIZE, false, (modalEmt, params, callback = null) =>
        # 設定
        radio = $('.display_size_wrapper input[type=radio]', modalEmt)
        radio.val(if Common.isFixedScreenSize() then ['input'] else ['default'])
        if Common.isFixedScreenSize()
          size = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
          $('.display_size_input_width', modalEmt).val(size.width)
          $('.display_size_input_height', modalEmt).val(size.height)
        radio.off('change').on('change', ->
          $('.display_size_input_wrapper', modalEmt).css('display', if radio.filter(':checked').val() == 'input' then 'block' else 'none')
        ).trigger('change')
        $('.update_button', modalEmt).off('click').on('click', =>
          beforeSize = Common.getScreenSize()
          # PageValueに設定
          if radio.filter(':checked').val() == 'input'
            width = $('.display_size_input_width:first', modalEmt).val()
            height = $('.display_size_input_height:first', modalEmt).val()
            if width? && height? && width > 0 && height > 0
              size = {
                width: width
                height: height
              }
              PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, size)
            else
              FloatView.show('Please input size', FloatView.Type.ERROR, 3.0)
          else
            PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, {})
          # 変更反映
          Common.initScreenSize()
          # スクリーン位置調整
          RunCommon.adjustScrollPositionWhenScreenSizeChanging(beforeSize, Common.getScreenSize())
          Common.hideModalView()
        )
        $('.cancel_button', modalEmt).off('click').on('click', =>
          Common.hideModalView()
        )
        if callback?
          callback()
      )
    )
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
    $('.menu-upload-gallery', navEmt).off('click').on('click', (e) =>
      e.preventDefault()
      e.stopPropagation()
      if !$(e.target).closest('.menu-upload-gallery').hasClass('disabled')
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

  # アイテム選択をデフォルトに戻す
  @setDefaultItemSelect = ->
    window.mode = constant.Mode.NOT_SELECT
    $('#header_items_selected_menu_span').html(I18n.t('header_menu.action.select_action'))