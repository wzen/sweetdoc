constant = gon.const
serverenv = gon.serverenv
locale = gon.locale
userLogined = gon.user_logined
isMobileAccess = gon.is_mobile_access
isIosAccess = gon.is_ios_access
utoken = gon.u_token

# アプリ共通定数
class Constant
  @ITEM_PREVIEW_CLASS_DIST_TOKEN = 'dummy'
  @CANVAS_ITEM_COORDINATE_VAR_SURFIX = 'Coord'

  class @EventBase
    @PREVIEW_STEP = 3

  # ZIndex
  class @Zindex
    # @property GRID グリッド線
    @GRID = 5

  class @ModalView
    @HEIGHT_RATE = 0.7

  # ページング
  class @Paging
    @NAV_MENU_PAGE_CLASS = 'paging-@pagenum'
    @NAV_MENU_FORK_CLASS = 'fork-@forknum'
    @NAV_MENU_ADDPAGE_CLASS = 'paging-new'
    @NAV_MENU_DELETEPAGE_CLASS = 'paging-delete'
    @NAV_MENU_ADDFORK_CLASS = 'fork-new'
    @PRELOAD_PAGEVALUE_NUM = 0
