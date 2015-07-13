# 閲覧を実行する
run = ->
  # preview機能用に残しておく
#  Function.prototype.toJSON = Function.prototype.toString
#  lstorage.setItem('timelineObjList', JSON.stringify(setupTimeLineObjects()))
#  lstorage.setItem('loadedItemTypeList', JSON.stringify(loadedItemTypeList))
#  lstorage.setItem('itemCssStyle', setupTimeLineCss())
#
#  h = getTimelinePageValue(Constant.PageValueKey.TE_PREFIX)
#  v = JSON.stringify(h)
#  console.log(v)

  setupTimeLineCss()

  target = "_runwindow"
  window.open("about:blank", target)
  document.timeline_run_form.target = target
  document.timeline_run_form.submit()



