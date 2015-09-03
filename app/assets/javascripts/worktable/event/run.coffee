# 閲覧を実行する
run = ->
  # イベント存在チェック
  h = PageValue.getEventPageValue(PageValue.Key.eventPagePrefix())
  if h?
    # Runのキャッシュを削除
    LocalStorage.clearRun()

    target = "_runwindow"
    window.open("about:blank", target)
    document.run_form.target = target
    document.run_form.submit()
  else
    Message.showWarn('No event')
