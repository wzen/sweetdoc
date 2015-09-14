class Indicator
  class @Type
    @TIMELINE = 0

  # インジケータ表示
  # @param [Integer] type 設定するインジケータのタイプ
  @showIndicator: (type) ->
    @hideIndicator(type)

    rootEmt = null
    if type == @Type.TIMELINE
      rootEmt = $('#timeline_events_container')

    if rootEmt?
      temp = $('.indicator_overlay_temp').clone(true).attr('class', 'indicator_overlay').css('display', 'block')
      rootEmt.append(temp)
      $('.indicator_overlay', rootEmt).off('click')
      $('.indicator_overlay', rootEmt).on('click', ->
        return false;
      )

  # インジケータ非表示
  # @param [Integer] type 設定するインジケータのタイプ
  @hideIndicator: (type) ->
    rootEmt = null
    if type == @Type.TIMELINE
      rootEmt = $('#timeline_events_container')

    if rootEmt?
      $('.indicator_overlay', rootEmt).remove()