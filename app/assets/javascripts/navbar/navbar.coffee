class Navbar
  # @property [String] NAVBAR_ROOT ナビヘッダーRoot
  @NAVBAR_ROOT = constant.ElementAttribute.NAVBAR_ROOT
  # @property [String] ITEM_MENU_PREFIX アイテムメニュープレフィックス
  @ITEM_MENU_PREFIX = 'menu-item-'

  # Worktableナビバー初期化
  @initWorktableNavbar = ->
    fileMenuEmt = $('#header_items_file_menu .dropdown-menu > li')
    $('.menu-newcreate', fileMenuEmt).off('click')
    $('.menu-newcreate', fileMenuEmt).on('click', ->
      if Object.keys(window.instanceMap).length > 0 || PageValue.getPageCount() >= 2
        if window.confirm(I18n.t('message.dialog.new_project'))
          WorktableCommon.recreateMainContainer()
          # 初期モーダル表示
          Common.showModalView(Constant.ModalViewType.INIT_PROJECT, Project.initProjectModal, false)
      else
        WorktableCommon.recreateMainContainer()
        # 初期モーダル表示
        Common.showModalView(Constant.ModalViewType.INIT_PROJECT, Project.initProjectModal, false)
    )
    $('.menu-save', fileMenuEmt).off('click')
    $('.menu-save', fileMenuEmt).on('click', ->
      ServerStorage.save()
    )
    $('.menu-setting', fileMenuEmt).off('click')
    $('.menu-setting', fileMenuEmt).on('click', ->
      Sidebar.switchSidebarConfig(Sidebar.Type.SETTING)
      Setting.initConfig()
      Sidebar.openConfigSidebar()
    )

    etcMenuEmt = $('#header_etc_select_menu .dropdown-menu > li')
    $('.menu-about', etcMenuEmt).off('click')
    $('.menu-about', etcMenuEmt).on('click', ->
      Common.showModalView(Constant.ModalViewType.ABOUT)
    )

    itemsSelectMenuEmt = $('#header_items_select_menu .dropdown-menu > li')
    $('.menu-item', itemsSelectMenuEmt).click( ->
      # プレビューを停止して再描画
      WorktableCommon.reDrawAllInstanceItemIfChanging()

      emtId = $(this).attr('id')
      if emtId.indexOf(Navbar.ITEM_MENU_PREFIX) >= 0
        itemId = parseInt(emtId.replace(Navbar.ITEM_MENU_PREFIX, ''))
        itemsSelectMenuEmt.removeClass('active')
        $(@).parent('li').addClass('active')
        window.selectItemMenu = itemId
        WorktableCommon.changeMode(Constant.Mode.DRAW)
        Common.loadItemJs(itemId)
    )

    $('#header_items_select_menu .menu-item').click( ->
      selected = $(@).html()
      $('#header_items_selected_menu_span').html(selected)
    )

    $('#menu-action-edit').click( ->
      WorktableCommon.changeMode(Constant.Mode.EDIT)
    )

    $('#menu_sidebar_toggle').off('click')
    $('#menu_sidebar_toggle').on('click', ->
      Sidebar.switchSidebarConfig(Sidebar.Type.GENERAL)
      Sidebar.openConfigSidebar()
    )

  # Runナビバー初期化
  @initRunNavbar = ->
    navEmt = $('#nav')
    $('.menu-control-rewind-page', navEmt).off('click')
    $('.menu-control-rewind-page', navEmt).on('click', ->
      if window.eventAction?
        window.eventAction.thisPage().rewindAllChapters()
    )
    $('.menu-control-rewind-chapter', navEmt).off('click')
    $('.menu-control-rewind-chapter', navEmt).on('click', ->
      if window.eventAction?
        window.eventAction.thisPage().rewindChapter()
    )
    $('.menu-control-rewind-upload-gallery', navEmt).off('click')
    $('.menu-control-rewind-upload-gallery', navEmt).on('click', ->
      RunCommon.showUploadGalleryConfirm()
    )

  # ヘッダーにタイトルを設定
  @setTitle = (title_name) ->
    if !window.isWorkTable
      title_name += '(Preview)'
    $("##{Navbar.NAVBAR_ROOT}").find('.nav_title').html(title_name)
    document.title = title_name + '| Revolver'

  # ヘッダーにページ番号を設定
  # @param [Integer] value 設定値
  @setPageNum = (value) ->
    navEmt = $('#nav')
    e = $('.nav_page_num', navEmt)
    if e?
      e.html(value)
    else
      e.html('')

  # ヘッダーにチャプター番号を設定
  # @param [Integer] value 設定値
  @setChapterNum = (value) ->
    navEmt = $('#nav')
    e = $('.nav_chapter_num', navEmt)
    if e?
      e.html(value)
    else
      e.html('')

  # ヘッダーにページ総数を設定
  # @param [Integer] page_max 設定値
  @setPageMax = (page_max) ->
    navEmt = $('#nav')
    e = $('.nav_page_max', navEmt)
    if e?
      e.html(page_max)
    else
      e.html('')

  # ヘッダーにチャプター総数を設定
  # @param [Integer] chapter_max 設定値
  @setChapterMax = (chapter_max) ->
    navEmt = $('#nav')
    e = $('.nav_chapter_max', navEmt)
    if e?
      e.html(chapter_max)
    else
      e.html('')

  # フォーク番号を設定
  # @param [Integer] num 設定値
  @setForkNum = (num) ->
    navEmt = $('#nav')
    e = $('.nav_fork_num', navEmt)
    if e?
      e.html(num)
      e.closest('li').css('display', if num > 0 then 'block' else 'none')
    else
      e.html('')
      e.closest('li').css('display', 'none')

  # 保存されているデータ一覧を取得してNavbarに一覧で表示
  # FIXME: 現在未使用だが残しておく
#  @get_load_list: ->
#    loadEmt = $("##{Navbar.NAVBAR_ROOT}").find(".#{@ElementAttribute.FILE_LOAD_CLASS}")
#    updateFlg = loadEmt.find(".#{@ElementAttribute.LOAD_LIST_UPDATED_FLG}").length > 0
#    if updateFlg
#      loadedLocalTime = loadEmt.find(".#{@ElementAttribute.LOADED_LOCALTIME}")
#      if loadedLocalTime?
#        diffTime = Common.calculateDiffTime($.now(), parseInt(loadedLocalTime.val()))
#        s = diffTime.seconds
#        if window.debug
#          console.log('loadedLocalTime diff ' + s)
#        if parseInt(s) <= @LOAD_LIST_INTERVAL_SECONDS
#          # 読み込んでX秒以内ならロードしない
#          return
#
#    loadEmt.children().remove()
#    $("<li><a class='menu-item'>Loading...</a></li>").appendTo(loadEmt)
#
#    ServerStorage.get_load_data((data) ->
#      user_pagevalue_list = data
#      if user_pagevalue_list.length > 0
#        list = ''
#        n = $.now()
#        for p in user_pagevalue_list
#          d = new Date(p.updated_at)
#          e = "<li><a class='menu-item'>#{Common.displayDiffAlmostTime(n, d.getTime())} (#{Common.formatDate(d)})</a><input type='hidden' class='user_pagevalue_id' value=#{p.user_pagevalue_id}></li>"
#          list += e
#        loadEmt.children().remove()
#        $(list).appendTo(loadEmt)
#        # クリックイベント設定
#        loadEmt.find('li').click((e) ->
#          user_pagevalue_id = $(@).find('.user_pagevalue_id:first').val()
#          ServerStorage.load(user_pagevalue_id)
#        )
#
#        # ロード済みに変更 & 現在時間を記録
#        loadEmt.find(".#{ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG}").remove()
#        loadEmt.find(".#{ServerStorage.ElementAttribute.LOADED_LOCALTIME}").remove()
#        $("<input type='hidden' class=#{ServerStorage.ElementAttribute.LOAD_LIST_UPDATED_FLG} value='1'>").appendTo(loadEmt)
#        $("<input type='hidden' class=#{ServerStorage.ElementAttribute.LOADED_LOCALTIME} value=#{$.now()}>").appendTo(loadEmt)
#
#      else
#        loadEmt.children().remove()
#        $("<li><a class='menu-item'>No Data</a></li>").appendTo(loadEmt)
#    ,
#    ->
#      if window.debug
#        console.log(data.responseText)
#      loadEmt.children().remove()
#      $("<li><a class='menu-item'>Server Access Error</a></li>").appendTo(loadEmt)
#    )
