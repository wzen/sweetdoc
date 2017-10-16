export default class UploadBase {
  // タグクリックイベント
  prepareUploadTagEvent(root) {
    const tags = $('.popular_tag a, .recommend_tag a', root);
    tags.off('click').on('click', e => {
      // 選択タグに追加
      return this.addUploadSelectTag(root, $(e.target).html());
    });

    // マウスオーバーイベント
    tags.off('mouseenter').on('mouseenter', e => {
      const li = $(e.target).closest('li');
      $(li).append($(`<div class='add_pop pop' style='display:none'><p>${I18n.t('upload_confirm.tag_add')}</p></div>`));
      $('.add_pop', li).css({top: $(li).height(), left: $(li).width()});
      return $('.add_pop', li).show();
    });
    return tags.off('mouseleave').on('mouseleave', e => {
      const ul = $(e.target).closest('ul');
      return $('.add_pop', ul).remove();
    });
  }

  addUploadSelectTag(root, tagname) {
    const ul = $('.select_tag ul', root);
    const tags = $.map(ul.children(), n => $('a', n).html());

    if((tags.length >= constant.Gallery.TAG_MAX) || ($.inArray(tagname, tags) >= 0)) {
      return;
    }
    ul.append($(`<li><a href='#'>${tagname}</a></li>`));

    // タグ クリックイベント
    $('a', ul).off('click');
    $('a', ul).on('click', function(e) {
      // タグ削除
      this.closest('li').remove();
      if($('.select_tag ul li', root).length < constant.Gallery.TAG_MAX) {
        return $('.select_tag_input', root).show();
      }
    });

    // タグ マウスオーバーイベント
    $('a', ul).off('mouseenter');
    $('a', ul).on('mouseenter', function(e) {
      const li = this.closest('li');
      $(li).append($(`<div class='delete_pop pop' style='display:none'><p>${I18n.t('upload_confirm.tag_remove')}</p></div>`));
      $('.delete_pop', li).css({top: $(li).height(), left: $(li).width()});
      return $('.delete_pop', li).show();
    });
    $('a', ul).off('mouseleave');
    $('a', ul).on('mouseleave', e => $('li .delete_pop', ul).remove());

    if($('.select_tag ul li', root).length >= constant.Gallery.TAG_MAX) {
      // タグ数が最大数になった場合, Inputを非表示
      return $('.select_tag_input', root).hide();
    }
  }

  removeAllUploadSelectTag(root) {
    $('.select_tag ul li', root).remove();
    return $('.select_tag_input', root).show();
  }

  // アップロード
  // @abstract
  upload(root, callback = null) {
  }
}
