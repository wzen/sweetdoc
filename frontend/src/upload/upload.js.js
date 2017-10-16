import UploadCommon from './upload_common';
import UploadContents from './upload_contents';
import UploadItem from './upload_item';

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
