class RunFullScreen
  @showCreatorInfo = ->
    @showModalOverlay()
    $('#main').find('.popup_creator_wrapper').fadeIn('500')
    setTimeout(->
      $('#main').find('.popup_creator_wrapper').fadeOut('500', ->
        $('#modal-overlay').hide()
      )
    , 3000)

  @showPopupInfo = ->
    $('#popup_info_wrapper').fadeIn('500')
    @showModalOverlay()

  @hidePopupInfo = ->
    $('#popup_info_wrapper').fadeOut('500', ->
      $('#modal-overlay').hide()
    )

  @showModalOverlay = ->
    $('#modal-overlay').show()
    $("#modal-overlay").unbind().click( ->
      # イベント無効
      return
    )

$ ->
  # 作成者情報を表示
  RunFullScreen.showCreatorInfo()