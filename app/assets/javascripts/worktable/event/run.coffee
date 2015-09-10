# 閲覧を実行する
run = ->
  WorktableCommon.stopAllEventPreview( ->
    # イベント存在チェック
    h = PageValue.getEventPageValue(PageValue.Key.eventPagePrefix())
    if h?
      # Runのキャッシュを削除
      LocalStorage.clearRun()

      target = "_runwindow"
      window.open("about:blank", target)
      document.run_form.target = target
      setTimeout( ->
        document.run_form.submit()
      , 150)

    else
      Message.showWarn('No event')
  )
