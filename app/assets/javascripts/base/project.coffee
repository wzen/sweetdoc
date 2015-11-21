class Project

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
    )

    # ウィンドウサイズ
    $('.default_window_size', modalEmt).html("#{window.mainWrapper.width()} X #{window.mainWrapper.height()}")

    # 作成済みプロジェクト一覧取得
    Project.load_data((data) ->
      user_pagevalue_list = data.user_pagevalue_list
      projectSelect = $('.project_select', modalEmt)
      if user_pagevalue_list.length > 0
        list = ''
        n = $.now()
        for p in user_pagevalue_list
          d = new Date(p['updated_at'])
          e = "<option value='#{p['id']}'>#{p['project_title']} - #{Common.displayDiffAlmostTime(n, d.getTime())}</option>"
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

      # PageValue設定
      PageValue.setGeneralPageValue(PageValue.Key.PROJECT_NAME, projectName)
      PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, {
        width: parseInt(width)
        height: parseInt(height)
      })
      # タイトル設定
      Common.setTitle(projectName)

      # 環境設定
      Common.applyEnvironmentFromPagevalue()

      # プロジェクト作成リクエスト
      Project.create(projectName, width, height, (data) ->
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
        # 最新更新日時設定
        Navbar.setLastUpdateTime(data.updated_at)
        # 環境設定
        Common.applyEnvironmentFromPagevalue()
        # ページ変更処理
        sectionClass = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum())
        $('#pages .section:first').attr('class', "#{sectionClass} section")
        $('#pages .section:first').css('z-index', Common.plusPagingZindex(0, PageValue.getPageNum()))
        $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT))
        window.scrollInside.css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + 1))
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

  @load_data: (successCallback = null, errorCallback = null) ->
    $.ajax(
      {
        url: "/page_value_state/user_pagevalue_last_updated_list"
        type: "GET"
        dataType: "json"
        success: (data)->
          if data.resultSuccess
            if successCallback?
              successCallback(data)
          else
            if errorCallback?
              errorCallback()
            console.log('/page_value_state/user_pagevalue_last_updated_list server error')
        error: (data)->
          if errorCallback?
            errorCallback()
          console.log('/page_value_state/user_pagevalue_last_updated_list ajax error')
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

