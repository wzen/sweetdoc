# 閲覧を実行する
run = ->
#  h = PageValue.getEventPageValue(PageValue.Key.E_PREFIX)
#  v = JSON.stringify(h)
#  console.log(v)

  Timeline.setupEventCss()

  target = "_runwindow"
  window.open("about:blank", target)
  document.run_form.target = target
  document.run_form.submit()

preview = ->
  # TODO: preview機能 Storageに保存し、GETでrunページを表示


