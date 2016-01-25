class GallerySidebar
  # 定数
  constant = gon.const
  @USER = constant.Gallery.Sidebar.USER
  @WORKTABLE = constant.Gallery.Sidebar.WORKTABLE
  @VIEW = constant.Gallery.Sidebar.VIEW
  @SEARCH = constant.Gallery.Sidebar.SEARCH
  @LOGO = constant.Gallery.Sidebar.LOGO

  @initMenu = ->
    root = $('#sidebar_wrapper')

    _type = ->
      type = ''
      if $(@).hasClass(GallerySidebar.USER)
        type = GallerySidebar.USER
      else if $(@).hasClass(GallerySidebar.WORKTABLE)
        type = GallerySidebar.WORKTABLE
      else if $(@).hasClass(GallerySidebar.VIEW)
        type = GallerySidebar.VIEW
      else if $(@).hasClass(GallerySidebar.SEARCH)
        type = GallerySidebar.SEARCH
      else if $(@).hasClass(GallerySidebar.LOGO)
        type = GallerySidebar.LOGO
      return ".#{type}"

    $('.wrapper .circle', root).hover((e) ->
      type = _type.call(@)
      if !$("#sidebar_wrapper .sidebar_popup#{type}").is(':visible')
        $(@).stop().animate({opacity: 1}, 200, 'linear')
    , (e) ->
      type = _type.call(@)
      if !$("#sidebar_wrapper .sidebar_popup#{type}").is(':visible')
        $(@).stop().animate({opacity: 0.7}, 100, 'linear')
    )

    $(".wrapper .circle.#{GallerySidebar.SEARCH}", root).click((e) ->
      type = _type.call(@)
      popup = $("#sidebar_wrapper .sidebar_popup#{type}")
      if popup.is(':visible')
        type = _type.call(@)
        popup.stop(true, true).fadeOut(100, 'linear')
        $(@).stop().animate({opacity: 1}, 100, 'linear')
        $('.overlay').remove()
      else
        $("#sidebar_wrapper .sidebar_popup").hide()
        self = $(@)
        $('.wrapper .circle', root).filter((s) -> $(@).attr('class') != self.attr('class')).css('opacity', 0.7)
        popup.stop(true, true).fadeIn(200, 'linear')
        $(@).stop().animate({opacity: 1}, 200, 'linear')
        $('.sidebar_overlay_parent').append('<div class="overlay"></div>')
        $('.overlay').click( ->
          $('.wrapper .circle', root).css('opacity', 0.7)
          $("#sidebar_wrapper .sidebar_popup").fadeOut(100)
          $('.overlay').remove()
        )
    )

$ ->
  GallerySidebar.initMenu()
