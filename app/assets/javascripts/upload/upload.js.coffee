$ ->
  $('.upload.index').ready ->
    u = new UploadContents()
    UploadCommon.initEvent(u)

  $('.upload.item').ready ->
    u = new UploadItem()
    UploadCommon.initEvent(u)
