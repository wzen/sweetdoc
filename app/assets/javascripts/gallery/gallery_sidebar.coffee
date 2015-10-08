class GallerySidebar
  if gon?
    # 定数
    constant = gon.const
    @USER = constant.Gallery.Sidebar.USER
    @VIEW = constant.Gallery.Sidebar.VIEW
    @SEARCH = constant.Gallery.Sidebar.SEARCH
    @LOGO = constant.Gallery.Sidebar.LOGO

  @initMenu = ->
    root = $('#sidebar_wrapper')
    $('.wrapper .circle', root).hover((e) ->
      popup = $('#gallery_contents_wrapper .sidebar_popup')
      popup.css(GallerySidebar.popupCss($(@)))
      GallerySidebar.addArrowClass($(@), popup)
      popup.stop(true, true).fadeIn(400, 'linear')
      $(@).stop().animate({opacity: 1}, 400, 'linear')
    , (e) ->
      $('#gallery_contents_wrapper .sidebar_popup').stop(true, true).fadeOut(200, 'linear')
      $(@).stop().animate({opacity: 0.3}, 200, 'linear')
    )

  @popupCss = (e) ->
    top = e.parent().position().top + 12

    if e.hasClass(@USER)
      return {
        top: "2px"
        bottom: ''
      }
    else if e.hasClass(@VIEW)
      return {
        top: "#{top}px"
        bottom: ''
      }
    else if e.hasClass(@SEARCH)
      return {
        top: "#{top}px"
        bottom: ''
      }
    else if e.hasClass(@LOGO)
      return {
        top: ''
        bottom: "2px"
      }

  @addArrowClass = (e, popup) ->
    wrapper = popup.find('.wrapper')
    if e.hasClass(@USER)
      wrapper.removeClass('arrow_middle arrow_bottom').addClass('arrow_top')
    else if e.hasClass(@LOGO)
      wrapper.removeClass('arrow_top arrow_middle').addClass('arrow_bottom')
    else
      wrapper.removeClass('arrow_top arrow_bottom').addClass('arrow_middle')

$ ->
  GallerySidebar.initMenu()