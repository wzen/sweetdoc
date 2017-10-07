/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
$(function() {
  $('.upload.index').ready(function() {
    const u = new UploadContents();
    return UploadCommon.initEvent(u);
  });

  return $('.upload.item').ready(function() {
    const u = new UploadItem();
    return UploadCommon.initEvent(u);
  });
});
