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

    _type = ->
      type = ''
      if $(@).hasClass(GallerySidebar.USER)
        type = GallerySidebar.USER
      else if $(@).hasClass(GallerySidebar.VIEW)
        type = GallerySidebar.VIEW
      else if $(@).hasClass(GallerySidebar.SEARCH)
        type = GallerySidebar.SEARCH
      else if $(@).hasClass(GallerySidebar.LOGO)
        type = GallerySidebar.LOGO
      return ".#{type}"

    $('.wrapper .circle', root).hover((e) ->
      type = _type.call(@)
      if !$("#gallery_contents_wrapper .sidebar_popup#{type}").is(':visible')
        $(@).stop().animate({opacity: 0.7}, 200, 'linear')
    , (e) ->
      type = _type.call(@)
      if !$("#gallery_contents_wrapper .sidebar_popup#{type}").is(':visible')
        $(@).stop().animate({opacity: 0.3}, 100, 'linear')
    )

    $('.wrapper .circle', root).click((e) ->
      type = _type.call(@)
      popup = $("#gallery_contents_wrapper .sidebar_popup#{type}")
      if popup.is(':visible')
        type = _type.call(@)
        popup.stop(true, true).fadeOut(100, 'linear')
        $(@).stop().animate({opacity: 0.7}, 100, 'linear')
        $('#overlay').remove()
      else
        $("#gallery_contents_wrapper .sidebar_popup").hide()
        self = $(@)
        $('.wrapper .circle', root).filter((s) -> $(@).attr('class') != self.attr('class')).css('opacity', 0.3)
        popup.stop(true, true).fadeIn(200, 'linear')
        $(@).stop().animate({opacity: 1}, 200, 'linear')
        $('#gallery_contents_wrapper').append('<div id="overlay"></div>')
        $('#overlay').click( ->
          $('.wrapper .circle', root).css('opacity', 0.3)
          $("#gallery_contents_wrapper .sidebar_popup").fadeOut(100)
          $('#overlay').remove()
        )
    )

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
