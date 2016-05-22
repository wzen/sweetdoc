class MotionCheckCommon
  # 新タブで閲覧を実行する
  @run = (newWindow = false) ->
    # イベント存在チェック
    #h = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT)
#      if h? && Object.keys(h).length > 0
    # Runのキャッシュを削除
    window.lStorage.clearRun()
    target = ''
    if newWindow
      # 実行確認ページを新規ウィンドウで表示
      size = Common.getScreenSize()
      navbarHeight = $("##{Navbar.NAVBAR_ROOT}").outerHeight(true)
      left = Number((window.screen.width - size.width)/2);
      top = Number((window.screen.height - (size.height + navbarHeight))/2);
      target = "_runwindow"
      window.open("about:blank", target, "top=#{top},left=#{left},width=#{size.width},height=#{size.height + navbarHeight},menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no")
      document.run_form.action = '/motion_check/new_window'
    else
      # 実行確認ページを新規タブで表示
      target = "_runtab"
      if window.name == target
        target = "_runtab2"
      window.open("about:blank", target)
      document.run_form.action = '/motion_check'
    document.run_form.target = target

    if window.isWorkTable && !Project.isSampleProject()
      # データ保存してから実行
      ServerStorage.save( (data) ->
        if data.resultSuccess
          PageValue.setGeneralPageValue(PageValue.Key.RUNNING_USER_PAGEVALUE_ID, data.updated_user_pagevalue_id)
          document.run_form.submit()
        else
          console.log('ServerStorage save error')
      )
    else
      document.run_form.submit()

#      else
#        # イベントが存在しない場合は表示しない
#        Message.showWarn('No event')
