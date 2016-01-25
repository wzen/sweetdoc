class RunSetting
  # 定数
  constant = gon.const
  @ROOT_ID_NAME = constant.Setting.ROOT_ID_NAME
  class @PageValueKey
    @SHOW_GUIDE = PageValue.Key.ST_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + 'show_guide'

  # ガイド表示
  @isShowGuide = ->
    ret = PageValue.getSettingPageValue(@PageValueKey.SHOW_GUIDE)
    ret = !ret? || ret == 'true'
    return ret

  # ガイド切り替え
  @toggleShowGuide = ->
    PageValue.setSettingPageValue(@PageValueKey.SHOW_GUIDE, !@isShowGuide())
    if window.eventAction?
      if @isShowGuide()
        window.eventAction.thisPage().thisChapter().showGuide()
      else
        window.eventAction.thisPage().thisChapter().hideGuide()


