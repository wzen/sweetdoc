class Project
  # プロジェクト更新
  @updateProjectInfo = (info) ->
    projectName = info.projectName
    # プロジェクト情報初期化
    Project.initProjectValue(projectName)
    # プロジェクト名設定
    Common.setTitle(projectName)
    # 環境更新
    Common.applyEnvironmentFromPagevalue()

  # プロジェクト作成時モーダルビュー初期化
  @initProjectModal = (modalEmt, params, callback = null) ->

    _modalSize = (type) ->
      if type == 'new'
        width = 424
      else
        width = 424
      return {width: width}

    # ラジオボタンイベント
    $('.project_create_wrapper input[type=radio]', modalEmt).off('click').on('click', ->
      $('.display_project_new_wrapper', modalEmt).css('display', if $(@).val() == 'new' then 'block' else 'none')
      $('.display_project_select_wrapper', modalEmt).css('display', if $(@).val() == 'select' then 'block' else 'none')
      size = _modalSize($(@).val())
      modalEmt.animate(null, {width: "#{size.width}px", height: "#{size.height}px"}, {duration: 300, queue: false})
      Common.modalCentering(true, size)
      $('.button_wrapper span', modalEmt).hide()
      $(".button_wrapper .#{$(@).val()}", modalEmt).show()
      Project.hideError(modalEmt)
    )
    # 作成済みプロジェクト一覧取得
    Project.load_data_order_last_updated((data) =>
      user_pagevalue_list = data.user_pagevalue_list
      projectSelect = $('.project_select', modalEmt)
      if user_pagevalue_list.length > 0
        list = _project_select_options.call(@, user_pagevalue_list)
        projectSelect.children().remove()
        $(list).appendTo(projectSelect)
        $('.project_create_wrapper input[type=radio][value=select]', modalEmt).prop('checked', true)
        $('.display_project_new_wrapper', modalEmt).hide()
        $('.display_project_select_wrapper', modalEmt).show()
        $(".button_wrapper .select", modalEmt).show()
        $('.button_wrapper span', modalEmt).hide()
        $(".button_wrapper .select", modalEmt).show()
        size = _modalSize('select')
        modalEmt.css({width: size.width, height: size.height})
        $('.project_create_wrapper', modalEmt).show()
        Common.modalCentering()
        if callback?
          callback()
      else
        projectSelect.children().remove()
        $('.project_create_wrapper input[type=radio][value=new]', modalEmt).prop('checked', true)
        $('.display_project_new_wrapper', modalEmt).show()
        $('.display_project_select_wrapper', modalEmt).hide()
        $(".button_wrapper .new", modalEmt).show()
        $('.button_wrapper span', modalEmt).hide()
        $(".button_wrapper .new", modalEmt).show()
        size = _modalSize('new')
        modalEmt.css({width: size.width, height: size.height})
        $('.project_create_wrapper', modalEmt).hide()
        Common.modalCentering()
        if callback?
          callback()
    )

    # Createボタンイベント
    $('.create_button', modalEmt).off('click').on('click', ->
      Common.hideModalView(true)
      Common.showModalFlashMessage('Creating...')

      # プロジェクト新規作成
      projectName = $('.project_name').val()
      if !projectName? || projectName.length == 0
        # エラー
        Project.showError(modalEmt, I18n.t('message.project.error.project_name'))
        return

      # Mainコンテナ作成
      Common.createdMainContainerIfNeeded(PageValue.getPageNum())
      # コンテナ初期化
      WorktableCommon.initMainContainer()
      # リサイズイベント
      Common.initResize(WorktableCommon.resizeEvent)
      # プロジェクト更新
      Project.updateProjectInfo({
        projectName: projectName
      })

      # プロジェクト作成リクエスト
      Project.create(projectName, (data) ->
        # 初期化終了
        window.initDone = true
        # モーダルを削除
        Common.hideModalView()
        # 通知
        FloatView.show('Project created', FloatView.Type.APPLY, 3.0)
      )
    )
    # Openボタンイベント
    $('.open_button', modalEmt).off('click').on('click', ->
      # プロジェクト選択
      user_pagevalue_id = $('.project_select', modalEmt).val()
      Project.load(user_pagevalue_id, (data) ->
        # 初期化終了
        window.initDone = true
      )
    )

    # MainPageに遷移
    $('.back_button', modalEmt).off('click').on('click', ->
      window.location.href = '/'
    )

    # Error非表示
    Project.hideError(modalEmt)

  _project_select_options = (user_pagevalue_list) ->
    list = ''
    n = $.now()
    l = $.grep(user_pagevalue_list, (u) -> u['p_is_sample'] == 0)
    if l.length > 0
      list += "<optgroup label='#{I18n.t('modal.not_sample_project')}'>"
      for p in l
        d = new Date(p['up_updated_at'])
        list += "<option value='#{p['up_id']}'>#{p['p_title']} - #{Common.displayDiffAlmostTime(n, d.getTime())}</option>"
      list += "</optgroup>"
    l = $.grep(user_pagevalue_list, (u) -> u['p_is_sample'] == 1)
    if l.length > 0
      list += "<optgroup label='#{I18n.t('modal.sample_project')}'>"
      for p in l
        d = new Date(p['up_updated_at'])
        list += "<option value='#{p['up_id']}'>#{p['p_title']}</option>"
      list += "</optgroup>"
    return list

  # プロジェクト一覧を更新順に取得
  @load_data_order_last_updated: (successCallback = null, errorCallback = null) ->
    $.ajax(
      {
        url: "/page_value_state/load_created_projects"
        type: "GET"
        dataType: "json"
        success: (data)->
          if data.resultSuccess
            if successCallback?
              successCallback(data)
          else
            if errorCallback?
              errorCallback()
            console.log('/page_value_state/load_created_projects server error')
            Common.ajaxError(data)
        error: (data)->
          if errorCallback?
            errorCallback()
          console.log('/page_value_state/load_created_projects ajax error')
          Common.ajaxError(data)
      }
    )

  # プロジェクト新規作成リクエスト
  @create = (title, callback = null) ->
    data = {}
    data[constant.Project.Key.TITLE] = title
    $.ajax(
      {
        url: "/project/create"
        type: "POST"
        data: data
        dataType: "json"
        success: (data) ->
          if data.resultSuccess
            # PageValue設定
            PageValue.setGeneralPageValue(PageValue.Key.PROJECT_ID, data.project_id)
            PageValue.setGeneralPageValue(PageValue.Key.IS_SAMPLE_PROJECT, false)
            # 共通イベントのインスタンス作成
            WorktableCommon.createCommonEventInstancesOnThisPageIfNeeded()
            # 更新日時設定
            Navbar.setLastUpdateTime(data.updated_at)
            # ナビバーをプロジェクト作成後状態に
            Navbar.switchWorktableNavbarWhenProjectCreated(true)
            if callback?
              callback(data)
          else
            Common.hideModalView(true)
            console.log('project/create server error')
            Common.ajaxError(data)
        error: (data) ->
          Common.hideModalView(true)
          console.log('project/create ajax error')
          Common.ajaxError(data)
      }
    )

  # プロジェクト読み込み
  @load = (user_pagevalue_id, callback = null) ->
    Common.hideModalView(true)
    Common.showModalFlashMessage('Loading...')
    ServerStorage.load(user_pagevalue_id, (data) =>
      # Mainコンテナ作成
      Common.createdMainContainerIfNeeded(PageValue.getPageNum())
      # コンテナ初期化
      WorktableCommon.initMainContainer()
      # リサイズイベント
      Common.initResize(WorktableCommon.resizeEvent)
      WorktableCommon.createAllInstanceAndDrawFromInstancePageValue( ->
        PageValue.updatePageCount()
        PageValue.updateForkCount()
        Paging.initPaging()
        Common.applyEnvironmentFromPagevalue()
        WorktableSetting.initConfig()
        # 共通イベントのインスタンス作成
        WorktableCommon.createCommonEventInstancesOnThisPageIfNeeded()
        # 最新更新日時設定
        Navbar.setLastUpdateTime(data.updated_at)
        # ページ変更処理
        sectionClass = constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum())
        $('#pages .section:first').attr('class', "#{sectionClass} section")
        $('#pages .section:first').css({'backgroundColor': constant.DEFAULT_BACKGROUNDCOLOR, 'z-index': Common.plusPagingZindex(0, PageValue.getPageNum())})
        $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTFLOAT))
        window.scrollInsideWrapper.css('z-index', Common.plusPagingZindex(constant.Zindex.EVENTBOTTOM + 1))
        # ナビバーをプロジェクト作成後状態に
        Navbar.switchWorktableNavbarWhenProjectCreated(true)
        # モーダルを削除
        Common.hideModalView()
        # 通知
        FloatView.show('Project loaded', FloatView.Type.APPLY, 3.0)
        if callback?
          callback(data)
      )
      Timeline.refreshAllTimeline()
    )

  @initProjectValue = (name) ->
    # PageValue設定
    PageValue.setGeneralPageValue(PageValue.Key.PROJECT_NAME, name)
    # プロジェクトのサイズは動作プレビューで指定させるため空
    PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, {})

  # プロジェクト管理モーダルビュー初期化
  @initAdminProjectModal = (modalEmt, params, callback = null) ->
    _loadAdminMenu = (callback) ->
      $.ajax(
        {
          url: "/project/admin_menu"
          type: "GET"
          dataType: "json"
          success: (data)->
            if data.resultSuccess
              callback(data.admin_html)
            else
              console.log('/project/admin_menu server error')
              Common.ajaxError(data)
          error: (data)->
            console.log('/project/admin_menu ajax error')
            Common.ajaxError(data)
        }
      )

    _loadEditInput = (target, callback) ->
      data = {}
      data[constant.Project.Key.USER_PAGEVALUE_ID] = $(target).closest('.am_row').find(".#{constant.Project.Key.USER_PAGEVALUE_ID}:first").val()
      $.ajax(
        {
          url: "/project/get_project_by_user_pagevalue_id"
          type: "POST"
          dataType: "json"
          data: data
          success: (data) ->
            if data.resultSuccess
              callback(data.project)
            else
              console.log('/project/get_project_by_user_pagevalue_id server error')
              Common.ajaxError(data)
          error: (data)->
            console.log('/project/get_project_by_user_pagevalue_id ajax error')
            Common.ajaxError(data)
        }
      )

    _update = (target, callback) ->
      data = {}
      data[constant.Project.Key.PROJECT_ID] = $(target).closest('.am_input_wrapper').find(".#{constant.Project.Key.PROJECT_ID}:first").val()
      inputWrapper = modalEmt.find('.am_input_wrapper:first')
      data.value = {
        p_title: inputWrapper.find('.project_name:first').val()
      }
      $.ajax(
        {
          url: "/project/update"
          type: "POST"
          dataType: "json"
          data: data
          success: (data)->
            if data.resultSuccess
              callback(data.updated_project_info, data.admin_html)
            else
              console.log('/project/remove server error')
              Common.ajaxError(data)
          error: (data)->
            console.log('/project/remove ajax error')
            Common.ajaxError(data)
        }
      )

    _delete = (target, callback) ->
      data = {}
      data[constant.Project.Key.PROJECT_ID] = $(target).closest('.am_row').find(".#{constant.Project.Key.PROJECT_ID}:first").val()
      $.ajax(
        {
          url: "/project/remove"
          type: "POST"
          dataType: "json"
          data: data
          success: (data)->
            if data.resultSuccess
              callback(data.admin_html)
            else
              console.log('/project/remove server error')
              Common.ajaxError(data)
          error: (data)->
            console.log('/project/remove ajax error')
            Common.ajaxError(data)
        }
      )

    _initEditInput = ->
      inputWrapper = modalEmt.find('.am_input_wrapper:first')
      inputWrapper.hide()
      inputWrapper.find('input[type=text]').val('')
      inputWrapper.find('input[type=number]').val('')

    _settingEditInputEvent = ->
      modalEmt.find('.button_wrapper .update_button').off('click').on('click', (e) =>
        _update.call(@, $(e.target), (updated_project_info, admin_html) =>
          # 更新完了 -> リスト再表示
          modalEmt.find('.am_list:first').empty().html(admin_html)
           # アクティブ & プロジェクト状態更新
          _updateActive.call(@)
          Project.updateProjectInfo({
            projectName: updated_project_info.title
          })
          # 非表示
          Common.hideModalView()
        )
      )
      modalEmt.find('.am_input_wrapper .button_wrapper .cancel_button').off('click').on('click', (e) =>
        # 左にスライド
        modalEmt.find('.am_scroll_wrapper:first').animate({scrollLeft: 0}, 200)
      )

    _updateActive = ->
      modalEmt.find('.am_row').each( ->
        openedProjectId = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID)
        if parseInt($(@).find(".#{constant.Project.Key.PROJECT_ID}:first").val()) == parseInt(openedProjectId)
          $(@).find(".am_title:first").addClass('opened')
        else
          $(@).find(".am_title:first").removeClass('opened')
      )

    # 作成済みプロジェクト一覧取得
    _loadAdminMenu.call(@, (admin_html) =>
      modalEmt.find('.am_list:first').html(admin_html)
      _setEvent = ->
        # アクティブ設定
        _updateActive.call(@)
        # イベント設定
        modalEmt.find('.am_row .edit_button').off('click').on('click', (e) =>
          # 右にスライド
          scrollWrapper = modalEmt.find('.am_scroll_wrapper:first')
          scrollContents = scrollWrapper.children('div:first')
          scrollContentsSize = {
            width: $('.am_list_wrapper:first').width()
            height: $('.am_list_wrapper:first').height()
          }
          scrollWrapper.animate({scrollLeft: scrollContentsSize.width}, 200)
          # プロジェクト情報初期化
          _initEditInput.call(@)
          # プロジェクト情報読み込み
          _loadEditInput($(e.target), (project) =>
            inputWrapper = modalEmt.find('.am_input_wrapper:first')
            inputWrapper.find('.project_name:first').val(project.title)
            inputWrapper.find(".#{constant.Project.Key.PROJECT_ID}:first").val(project.id)
            _settingEditInputEvent.call(@)
            inputWrapper.show()
          )
        )
        modalEmt.find('.am_row .remove_button').off('click').on('click', (e) =>
          # 削除確認
          if window.confirm(I18n.t('message.dialog.delete_project'))
            deletedProjectId = $(e.target).closest('.am_row').find(".#{constant.Project.Key.PROJECT_ID}:first").val()
            # 削除
            _delete.call(@, $(e.target), (admin_html) =>
              # アクティブ設定
              _updateActive.call(@)
              if parseInt(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID)) == parseInt(deletedProjectId)
                # 自身のプロジェクトを削除 -> プロジェクト選択
                Common.hideModalView(true)
                WorktableCommon.resetWorktable()
                # 初期モーダル表示
                Common.showModalView(constant.ModalViewType.INIT_PROJECT, true, Project.initProjectModal)
              else
                # 削除完了 -> リスト再表示
                modalEmt.find('.am_list:first').empty().html(admin_html)
                _setEvent.call(@)
            )
        )
        modalEmt.find('.am_list_wrapper .cancel_button').off('click').on('click', (e) =>
          Common.hideModalView()
        )
      _setEvent.call(@)
      Common.modalCentering()
      if callback?
        callback()
    )

  # Mainビューの高さ計算
  # TODO: デザインが変わったら修正
  @calcOriginalViewHeight = ->
    borderWidth = 5
    timelineTopPadding = 5
    return $('#screen_wrapper').height() - $('#timeline').height() - timelineTopPadding - (borderWidth * 2)

  # サンプルプロジェクトか
  @isSampleProject = ->
    p = PageValue.getGeneralPageValue(PageValue.Key.IS_SAMPLE_PROJECT)
    if p?
      if typeof p == 'string'
        return p == 'true'
      else
        return p
    return false

  @showError = (modalEmt, message) ->
    modalEmt.find('.error_wrapper .error:first').html(message)
    modalEmt.find('.error_wrapper').show()
  @hideError = (modalEmt) ->
    modalEmt.find('.error_wrapper').hide()
    modalEmt.find('.error_wrapper .error:first').html('')
