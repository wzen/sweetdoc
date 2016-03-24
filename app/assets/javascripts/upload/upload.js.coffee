$ ->
  $('.upload.index').ready ->
    u = new UploadContents()
    UploadCommon.initEvent(u)
#    if window.opener?
#      setTimeout( ->
#        # オーバーレイ前の画面をキャプチャ
#        body = $(window.opener.document.getElementById('project_contents'))
#        html2canvas(body, {
#          onrendered: (canvas) ->
#            UploadCommon.makeCapture(canvas)
#        })
#      )

  $('.upload.item').ready ->
    u = new UploadItem()
    UploadCommon.initEvent(u)
