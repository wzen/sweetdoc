import Common from '../../../base/common';

export default class RunFullScreen {
  static showCreatorInfo() {
    // Markdownを設定
    return Common.markdownToHtml();
  }

  //@showModalOverlay()
  //$('#main').find('.popup_creator_wrapper').fadeIn('200')
//    setTimeout(->
//      $('#main').find('.popup_creator_wrapper').fadeOut('200', ->
//        $('#modal-overlay').hide()
//      )
//    , 3000)

  static showPopupInfo() {
    $('#popup_info_wrapper').fadeIn('500');
    return this.showModalOverlay();
  }

  static hidePopupInfo() {
    return $('#popup_info_wrapper').fadeOut('500', () => $('#modal-overlay').hide());
  }

  static showModalOverlay() {
    $('#modal-overlay').show();
    return $("#modal-overlay").unbind().click(function() {
      // イベント無効
    });
  }
}