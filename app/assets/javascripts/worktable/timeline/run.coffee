# 閲覧を実行する
run = ->
#  Function.prototype.toJSON = Function.prototype.toString
#  lstorage.setItem('timelineObjList', JSON.stringify(setupTimeLineObjects()))
#  lstorage.setItem('loadedItemTypeList', JSON.stringify(loadedItemTypeList))
#  lstorage.setItem('itemCssStyle', setupTimeLineCss())
  target = "_runwindow"
  window.open("about:blank", target)
  document.timeline_run_form.target = target
  document.timeline_run_form.submit()



