class MotionCheckCommon
  # 新タブで閲覧を実行する
  @run = (newWindow = false) ->
    # プレビュー停止

    _operation = ->
      # イベント存在チェック
      h = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT)
      if h? && Object.keys(h).length > 0
        # Runのキャッシュを削除
        LocalStorage.clearRun()
        # 実行用の新規タブを表示

        target = ''
        if newWindow
          size = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
          left = Number((window.screen.width - size.width)/2);
          top = Number((window.screen.height - size.height)/2);
          target = "_runwindow"
          window.open("about:blank", target, "top=#{top},left=#{left},width=#{size.width},height=#{size.height},menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no")
          document.run_form.action = '/motion_check/new_window'
        else
          target = "_runtab"
          window.open("about:blank", target)
          document.run_form.action = '/motion_check'
        document.run_form.target = target

        if window.isWorkTable
          # データ保存処理
          ServerStorage.save( ->
            # submit詰まり防止のため少し遅延させる
            setTimeout( ->
              document.run_form.submit()
            , 200)
          )
        else
          # submit詰まり防止のため少し遅延させる
          setTimeout( ->
            document.run_form.submit()
          , 200)

      else
        # イベントが存在しない場合は表示しない
        Message.showWarn('No event')

    if window.isWorkTable
      WorktableCommon.stopAllEventPreview(_operation)
    else
      _operation.call(@)

