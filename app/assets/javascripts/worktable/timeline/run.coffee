# 閲覧を実行する
run = ->
#  h = getTimelinePageValue(Constant.PageValueKey.TE_PREFIX)
#  v = JSON.stringify(h)
#  console.log(v)

  setupTimeLineCss()

  target = "_runwindow"
  window.open("about:blank", target)
  document.timeline_run_form.target = target
  document.timeline_run_form.submit()

preview = ->
  # TODO: preview機能 Storageに保存し、GETでrunページを表示


