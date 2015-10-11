class RunSetting
  if gon?
    # 定数
    constant = gon.const

    @ROOT_ID_NAME = constant.Setting.ROOT_ID_NAME

    class @PageValueKey
      @ROOT = constant.PageValueKey.ST_ROOT
      @PREFIX = constant.PageValueKey.ST_PREFIX
      @SHOW_GUIDE = 'show_guide'

  # ガイド表示
  @isShowGuide = ->
    showGuide = PageValue.getSettingPageValue(PageValue.setSettingPageValue(@PageValueKey.SHOW_GUIDE))
    if !showGuide? || showGuide
      return true
    else
      return false

  # ガイド切り替え
  @toggleShowGuide = ->
    showGuide = PageValue.getSettingPageValue(PageValue.setSettingPageValue(@PageValueKey.SHOW_GUIDE))
    PageValue.setSettingPageValue(@PageValueKey.SHOW_GUIDE)

