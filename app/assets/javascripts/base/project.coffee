class Project

  # プロジェクト更新
  @updateProjectInfo = (info) ->
    projectName = info.projectName
    width = info.screenWidth
    height = info.screenHeight
    # プロジェクト情報初期化
    Project.initProjectValue(projectName, width, height)
    # プロジェクト名設定
    Common.setTitle(projectName)
    # 環境更新
    Common.applyEnvironmentFromPagevalue()

  # プロジェクト作成時モーダルビュー初期化
  @initProjectModal = (modalEmt, params, callback = null) ->

    _modalSize = (type) ->
      if type == 'new'
        width = 424
        height = 179
      else
        width = 424
        height = 118
      return {width: width, height: height}

    # ラジオボタンイベント
    $('.project_create_wrapper input[type=radio]', modalEmt).off('click')
    $('.project_create_wrapper input[type=radio]', modalEmt).on('click', ->
      $('.display_project_new_wrapper', modalEmt).css('display', if $(@).val() == 'new' then 'block' else 'none')
      $('.display_project_select_wrapper', modalEmt).css('display', if $(@).val() == 'select' then 'block' else 'none')
      size = _modalSize($(@).val())
      modalEmt.animate({width: "#{size.width}px", height: "#{size.height}px"}, {duration: 300, queue: false})
      Common.modalCentering(true, size)
      $('.button_wrapper span', modalEmt).hide()
      $(".button_wrapper .#{$(@).val()}", modalEmt).show()
    )

    $('.display_size_wrapper input[type=radio]', modalEmt).off('click')
    $('.display_size_wrapper input[type=radio]', modalEmt).on('click', ->
      $('.display_size_input_wrapper', modalEmt).css('display', if $(@).val() == 'input' then 'block' else 'none')
      if $(@).val() == 'input'
        height = 199
      else
        height = 179
      modalEmt.animate({height: "#{height}px"}, {duration: 300})
    )

    # ウィンドウサイズ
    $('.default_window_size', modalEmt).html("#{window.mainWrapper.width()} X #{window.mainWrapper.height()}")

    # 作成済みプロジェクト一覧取得
    Project.load_data_order_last_updated((data) ->
      user_pagevalue_list = data.user_pagevalue_list
      projectSelect = $('.project_select', modalEmt)
      if user_pagevalue_list.length > 0
        list = ''
        n = $.now()
        for p in user_pagevalue_list
          d = new Date(p['up_updated_at'])
          e = "<option value='#{p['up_id']}'>#{p['p_title']} - #{Common.displayDiffAlmostTime(n, d.getTime())}</option>"
          list += e
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
    $('.create_button', modalEmt).off('click')
    $('.create_button', modalEmt).on('click', ->
      # プロジェクト新規作成
      projectName = $('.project_name').val()
      width = $('#screen_wrapper').width()
      height = $('#screen_wrapper').height()
      if !projectName? || projectName.length == 0
        # エラー
        return
      if $('.display_size_wrapper input[value=input]').is(':checked')
        width = $('.display_size_input_width', modalEmt).val()
        height = $('.display_size_input_height', modalEmt).val()
        if !width? || width.length == 0 || !height? || height.length == 0
          # エラー
          return

      # プロジェクト更新
      Project.updateProjectInfo({
        projectName: projectName
        screenWidth: width
        screenHeight: height
      })

      # プロジェクト作成リクエスト
      Project.create(projectName, width, height, (data) ->
        # 共通イベントのインスタンス作成
        WorktableCommon.createCommonEventInstancesIfNeeded()
        # 更新日時設定
        Navbar.setLastUpdateTime(data.updated_at)
        # 初期化終了
        window.initDone = true
        # モーダルを削除
        Common.hideModalView()
      )
    )
    # Openボタンイベント
    $('.open_button', modalEmt).off('click')
    $('.open_button', modalEmt).on('click', ->
      # プロジェクト選択
      user_pagevalue_id = $('.project_select', modalEmt).val()
      ServerStorage.load(user_pagevalue_id, (data) ->
        # 共通イベントのインスタンス作成
        WorktableCommon.createCommonEventInstancesIfNeeded()
        # 最新更新日時設定
        Navbar.setLastUpdateTime(data.updated_at)
        # ページ変更処理
        sectionClass = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum())
        $('#pages .section:first').attr('class', "#{sectionClass} section")
        $('#pages .section:first').css({'backgroundColor': Constant.DEFAULT_BACKGROUNDCOLOR, 'z-index': Common.plusPagingZindex(0, PageValue.getPageNum())})
        $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT))
        window.scrollInsideWrapper.css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + 1))
        # 初期化終了
        window.initDone = true
        # モーダルを削除
        Common.hideModalView()
      )
    )

    # MainPageに遷移
    $('.back_button', modalEmt).off('click')
    $('.back_button', modalEmt).on('click', ->
      window.location.href = '/'
    )

  # プロジェクト一覧を更新順に取得
  @load_data_order_last_updated: (successCallback = null, errorCallback = null) ->
    $.ajax(
      {
        url: "/page_value_state/user_pagevalues_and_projects_sorted_updated"
        type: "GET"
        dataType: "json"
        success: (data)->
          if data.resultSuccess
            if successCallback?
              successCallback(data)
          else
            if errorCallback?
              errorCallback()
            console.log('/page_value_state/user_pagevalues_and_projects_sorted_updated server error')
        error: (data)->
          if errorCallback?
            errorCallback()
          console.log('/page_value_state/user_pagevalues_and_projects_sorted_updated ajax error')
      }
    )

  # プロジェクト新規作成リクエスト
  @create = (title, screenWidth, screenHeight, callback = null) ->
    data = {}
    data[Constant.Project.Key.TITLE] = title
    data[Constant.Project.Key.SCREEN_SIZE] = {
      width: screenWidth
      height: screenHeight
    }
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
            if callback?
              callback(data)
          else
            console.log('project/create server error')
        error: (data) ->
          console.log('project/create ajax error')
      }
    )

  @initProjectValue = (name, width, height) ->
    # PageValue設定
    PageValue.setGeneralPageValue(PageValue.Key.PROJECT_NAME, name)
    PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, {
      width: parseInt(width)
      height: parseInt(height)
    })

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
          error: (data)->
            console.log('/project/admin_menu ajax error')
        }
      )

    _loadEditInput = (target, callback) ->
      data = {}
      data[Constant.Project.Key.USER_PAGEVALUE_ID] = $(target).closest('.am_row').find(".#{Constant.Project.Key.USER_PAGEVALUE_ID}:first").val()
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
          error: (data)->
            console.log('/project/get_project_by_user_pagevalue_id ajax error')
        }
      )

    _update = (target, callback) ->
      data = {}
      data[Constant.Project.Key.PROJECT_ID] = $(target).closest('.am_input_wrapper').find(".#{Constant.Project.Key.PROJECT_ID}:first").val()
      inputWrapper = modalEmt.find('.am_input_wrapper:first')
      data.value = {
        p_title: inputWrapper.find('.project_name:first').val()
        p_screen_width: inputWrapper.find('.display_size_input_width:first').val()
        p_screen_height: inputWrapper.find('.display_size_input_height:first').val()
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
          error: (data)->
            console.log('/project/remove ajax error')
        }
      )

    _delete = (target, callback) ->
      data = {}
      data[Constant.Project.Key.PROJECT_ID] = $(target).closest('.am_row').find(".#{Constant.Project.Key.PROJECT_ID}:first").val()
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
          error: (data)->
            console.log('/project/remove ajax error')
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
            screenWidth: updated_project_info.screen_width
            screenHeight: updated_project_info.screen_height
          })
          # 非表示
          Common.hideModalView()
        )
      )
      modalEmt.find('.button_wrapper .cancel_button').off('click').on('click', (e) =>
        # 左にスライド
        modalEmt.find('.am_scroll_wrapper:first').animate({scrollLeft: 0}, 200)
      )

    _updateActive = ->
      modalEmt.find('.am_row').each( ->
        openedProjectId = PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID)
        if parseInt($(@).find(".#{Constant.Project.Key.PROJECT_ID}:first").val()) == parseInt(openedProjectId)
          $(@).find(".am_title:first").addClass('opened')
        else
          $(@).find(".am_title:first").removeClass('opened')
      )

    # 作成済みプロジェクト一覧取得
    _loadAdminMenu.call(@, (admin_html) =>
      modalEmt.find('.am_list:first').html(admin_html)
      # アクティブ設定
      _updateActive.call(@)
      # イベント設定
      modalEmt.find('.am_row .edit_button').off('click').on('click', (e) =>
        # 右にスライド
        scrollWrapper = modalEmt.find('.am_scroll_wrapper:first')
        scrollContents = scrollWrapper.children('div:first')
        scrollContentsSize = Common.scrollContentsSizeUnderScreenEventScale()
        scrollWrapper.animate({scrollLeft: scrollContentsSize.width}, 200)
        # プロジェクト情報初期化
        _initEditInput.call(@)
        # プロジェクト情報読み込み
        _loadEditInput($(e.target), (project) =>
          inputWrapper = modalEmt.find('.am_input_wrapper:first')
          inputWrapper.find('.project_name:first').val(project.title)
          inputWrapper.find('.display_size_input_width:first').val(project.screen_width)
          inputWrapper.find('.display_size_input_height:first').val(project.screen_height)
          inputWrapper.find(".#{Constant.Project.Key.PROJECT_ID}:first").val(project.id)
          _settingEditInputEvent.call(@)
          inputWrapper.show()
        )
      )
      modalEmt.find('.am_row .remove_button').off('click').on('click', (e) =>
        # 削除確認
        if window.confirm(I18n.t('message.dialog.delete_project'))
          deletedProjectId = $(e.target).closest('.am_row').find(".#{Constant.Project.Key.PROJECT_ID}:first").val()
          # 削除
          _delete.call(@, $(e.target), (admin_html) =>
            # アクティブ設定
            _updateActive.call(@)
            if parseInt(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID)) == parseInt(deletedProjectId)
              # 自身のプロジェクトを削除 -> プロジェクト選択
              Common.hideModalView()
              WorktableCommon.resetWorktable()
              # 初期モーダル表示
              Common.showModalView(Constant.ModalViewType.INIT_PROJECT, false, Project.initProjectModal)
            else
              # 削除完了 -> リスト再表示
              modalEmt.find('.am_list:first').empty().html(admin_html)
          )
      )
      Common.modalCentering()
      if callback?
        callback()
    )

