// Generated by CoffeeScript 1.9.2
var Constant, constant, locale, serverenv;

constant = gon["const"];

serverenv = gon.serverenv;

locale = gon.locale;

Constant = (function() {
  function Constant() {}

  Constant.DEFAULT_BACKGROUNDCOLOR = constant.DEFAULT_BACKGROUNDCOLOR;

  Constant.ITEM_CODING_TEMP_CLASS_NAME = constant.ITEM_CODING_TEMP_CLASS_NAME;

  Constant.ITEM_GALLERY_ITEM_CLASSNAME = constant.ITEM_GALLERY_ITEM_CLASSNAME;

  Constant.ITEM_PREVIEW_CLASS_DIST_TOKEN = 'dummy';

  Constant.CANVAS_ITEM_COORDINATE_VAR_SURFIX = 'Coord';

  Constant.Zindex = (function() {
    function Zindex() {}

    Zindex.GRID = 5;

    Zindex.EVENTBOTTOM = constant.Zindex.EVENTBOTTOM;

    Zindex.EVENTFLOAT = constant.Zindex.EVENTFLOAT;

    return Zindex;

  })();

  Constant.Mode = (function() {
    function Mode() {}

    Mode.NOT_SELECT = constant.Mode.NOT_SELECT;

    Mode.DRAW = constant.Mode.DRAW;

    Mode.EDIT = constant.Mode.EDIT;

    Mode.OPTION = constant.Mode.OPTION;

    return Mode;

  })();

  Constant.EventInputPointingMode = (function() {
    function EventInputPointingMode() {}

    EventInputPointingMode.NOT_SELECT = constant.EventInputPointingMode.NOT_SELECT;

    EventInputPointingMode.DRAW = constant.EventInputPointingMode.DRAW;

    EventInputPointingMode.ITEM_TOUCH = constant.EventInputPointingMode.ITEM_TOUCH;

    return EventInputPointingMode;

  })();

  Constant.ItemDrawType = (function() {
    function ItemDrawType() {}

    ItemDrawType.CANVAS = constant.ItemDrawType.CANVAS;

    ItemDrawType.CSS = constant.ItemDrawType.CSS;

    return ItemDrawType;

  })();

  Constant.ActionType = (function() {
    function ActionType() {}

    ActionType.SCROLL = constant.ActionType.SCROLL;

    ActionType.CLICK = constant.ActionType.CLICK;

    return ActionType;

  })();

  Constant.DesignConfig = (function() {
    function DesignConfig() {}

    DesignConfig.DESIGN_ROOT_CLASSNAME = constant.DesignConfig.ROOT_CLASSNAME;

    return DesignConfig;

  })();

  Constant.ItemDesignOptionType = (function() {
    function ItemDesignOptionType() {}

    ItemDesignOptionType.BOOLEAN = constant.ItemDesignOptionType.BOOLEAN;

    ItemDesignOptionType.NUMBER = constant.ItemDesignOptionType.NUMBER;

    ItemDesignOptionType.STRING = constant.ItemDesignOptionType.STRING;

    ItemDesignOptionType.COLOR = constant.ItemDesignOptionType.COLOR;

    ItemDesignOptionType.SELECT = constant.ItemDesignOptionType.SELECT;

    ItemDesignOptionType.DESIGN_TOOL = constant.ItemDesignOptionType.DESIGN_TOOL;

    ItemDesignOptionType.SELECT_FILE = constant.ItemDesignOptionType.SELECT_FILE;

    ItemDesignOptionType.SELECT_IMAGE_FILE = constant.ItemDesignOptionType.SELECT_IMAGE_FILE;

    return ItemDesignOptionType;

  })();

  Constant.TimelineActionTypeClassName = (function() {
    function TimelineActionTypeClassName() {}

    TimelineActionTypeClassName.BLANK = constant.TimelineActionTypeClassName.BLANK;

    TimelineActionTypeClassName.SCROLL = constant.TimelineActionTypeClassName.SCROLL;

    TimelineActionTypeClassName.CLICK = constant.TimelineActionTypeClassName.CLICK;

    return TimelineActionTypeClassName;

  })();

  Constant.KeyboardKeyCode = (function() {
    function KeyboardKeyCode() {}

    KeyboardKeyCode.ENTER = constant.KeyboardKeyCode.ENTER;

    KeyboardKeyCode.Z = constant.KeyboardKeyCode.Z;

    KeyboardKeyCode.C = constant.KeyboardKeyCode.C;

    KeyboardKeyCode.X = constant.KeyboardKeyCode.X;

    KeyboardKeyCode.V = constant.KeyboardKeyCode.V;

    return KeyboardKeyCode;

  })();

  Constant.CommonActionEventChangeType = (function() {
    function CommonActionEventChangeType() {}

    CommonActionEventChangeType.BACKGROUND = constant.CommonActionEventChangeType.BACKGROUND;

    CommonActionEventChangeType.SCREEN = constant.CommonActionEventChangeType.SCREEN;

    return CommonActionEventChangeType;

  })();

  Constant.ModalView = (function() {
    function ModalView() {}

    ModalView.HEIGHT_RATE = 0.7;

    return ModalView;

  })();

  Constant.ModalViewType = (function() {
    function ModalViewType() {}

    ModalViewType.INIT_PROJECT = constant.ModalViewType.INIT_PROJECT;

    ModalViewType.ABOUT = constant.ModalViewType.ABOUT;

    ModalViewType.ADMIN_PROJECTS = constant.ModalViewType.ADMIN_PROJECTS;

    ModalViewType.CREATE_USER_CODE = constant.ModalViewType.CREATE_USER_CODE;

    ModalViewType.ITEM_IMAGE_UPLOAD = constant.ModalViewType.ITEM_IMAGE_UPLOAD;

    ModalViewType.ITEM_TEXT_EDITING = constant.ModalViewType.ITEM_TEXT_EDITING;

    ModalViewType.NOTICE_LOGIN = constant.ModalViewType.NOTICE_LOGIN;

    return ModalViewType;

  })();

  Constant.Paging = (function() {
    function Paging() {}

    Paging.ROOT_ID = constant.Paging.ROOT_ID;

    Paging.MAIN_PAGING_SECTION_CLASS = constant.Paging.MAIN_PAGING_SECTION_CLASS;

    Paging.NAV_ROOT_ID = constant.Paging.NAV_ROOT_ID;

    Paging.NAV_SELECTED_CLASS = constant.Paging.NAV_SELECTED_CLASS;

    Paging.NAV_SELECT_ROOT_CLASS = constant.Paging.NAV_SELECT_ROOT_CLASS;

    Paging.NAV_MENU_PAGE_CLASS = 'paging-@pagenum';

    Paging.NAV_MENU_FORK_CLASS = 'fork-@forknum';

    Paging.NAV_MENU_ADDPAGE_CLASS = 'paging-new';

    Paging.NAV_MENU_ADDFORK_CLASS = 'fork-new';

    Paging.PRELOAD_PAGEVALUE_NUM = 0;

    return Paging;

  })();

  Constant.Project = (function() {
    function Project() {}

    Project.Key = (function() {
      function Key() {}

      Key.PROJECT_ID = constant.Project.Key.PROJECT_ID;

      Key.TITLE = constant.Project.Key.TITLE;

      Key.SCREEN_SIZE = constant.Project.Key.SCREEN_SIZE;

      Key.USER_PAGEVALUE_ID = constant.Project.Key.USER_PAGEVALUE_ID;

      Key.USER_PAGEVALUE_UPDATED_AT = constant.Project.Key.USER_PAGEVALUE_UPDATED_AT;

      return Key;

    })();

    return Project;

  })();

  Constant.Gallery = (function() {
    function Gallery() {}

    Gallery.TAG_MAX = constant.Gallery.TAG_MAX;

    Gallery.Key = (function() {
      function Key() {}

      Key.MESSAGE = constant.Gallery.Key.MESSAGE;

      Key.GALLERY_ID = constant.Gallery.Key.GALLERY_ID;

      Key.GALLERY_ACCESS_TOKEN = constant.Gallery.Key.GALLERY_ACCESS_TOKEN;

      Key.PROJECT_ID = constant.Gallery.Key.PROJECT_ID;

      Key.SCREEN_SIZE_WIDTH = constant.Gallery.Key.SCREEN_SIZE_WIDTH;

      Key.SCREEN_SIZE_HEIGHT = constant.Gallery.Key.SCREEN_SIZE_HEIGHT;

      Key.TAGS = constant.Gallery.Key.TAGS;

      Key.INSTANCE_PAGE_VALUE = constant.Gallery.Key.INSTANCE_PAGE_VALUE;

      Key.EVENT_PAGE_VALUE = constant.Gallery.Key.EVENT_PAGE_VALUE;

      Key.THUMBNAIL_IMG = constant.Gallery.Key.THUMBNAIL_IMG;

      Key.THUMBNAIL_IMG_CONTENTSTYPE = constant.Gallery.Key.THUMBNAIL_IMG_CONTENTSTYPE;

      Key.THUMBNAIL_IMG_WIDTH = constant.Gallery.Key.THUMBNAIL_IMG_WIDTH;

      Key.THUMBNAIL_IMG_HEIGHT = constant.Gallery.Key.THUMBNAIL_IMG_HEIGHT;

      Key.TITLE = constant.Gallery.Key.TITLE;

      Key.CAPTION = constant.Gallery.Key.CAPTION;

      Key.ITEM_JS_LIST = constant.Gallery.Key.ITEM_JS_LIST;

      Key.VIEW_COUNT = constant.Gallery.Key.VIEW_COUNT;

      Key.BOOKMARK_COUNT = constant.Gallery.Key.BOOKMARK_COUNT;

      Key.RECOMMEND_SOURCE_WORD = constant.Gallery.Key.RECOMMEND_SOURCE_WORD;

      Key.PAGE_MAX = constant.Gallery.Key.PAGE_MAX;

      Key.SHOW_GUIDE = constant.Gallery.Key.SHOW_GUIDE;

      Key.SHOW_PAGE_NUM = constant.Gallery.Key.SHOW_PAGE_NUM;

      Key.SHOW_CHAPTER_NUM = constant.Gallery.Key.SHOW_CHAPTER_NUM;

      Key.USER_CODING_ID = constant.Gallery.Key.USER_CODING_ID;

      return Key;

    })();

    Gallery.SearchKey = (function() {
      function SearchKey() {}

      SearchKey.SHOW_HEAD = constant.Gallery.SearchKey.SHOW_HEAD;

      SearchKey.SHOW_LIMIT = constant.Gallery.SearchKey.SHOW_LIMIT;

      SearchKey.SEARCH_TYPE = constant.Gallery.SearchKey.SEARCH_TYPE;

      SearchKey.TAG_ID = constant.Gallery.SearchKey.TAG_ID;

      SearchKey.DATE = constant.Gallery.SearchKey.DATE;

      return SearchKey;

    })();

    Gallery.SearchType = (function() {
      function SearchType() {}

      SearchType.VIEW_COUNT = constant.Gallery.SearchType.VIEW_COUNT;

      SearchType.BOOKMARK_COUNT = constant.Gallery.SearchType.BOOKMARK_COUNT;

      SearchType.USER_BOOKMARK = constant.Gallery.SearchType.USER_BOOKMARK;

      SearchType.CREATED = constant.Gallery.SearchType.CREATED;

      return SearchType;

    })();

    return Gallery;

  })();

  Constant.ItemGallery = (function() {
    function ItemGallery() {}

    ItemGallery.TAG_MAX = constant.ItemGallery.TAG_MAX;

    ItemGallery.Key = (function() {
      function Key() {}

      Key.ITEM_GALLERY_ID = constant.ItemGallery.Key.GALLERY_ID;

      Key.ITEM_GALLERY_ACCESS_TOKEN = constant.ItemGallery.Key.ITEM_GALLERY_ACCESS_TOKEN;

      Key.TAGS = constant.ItemGallery.Key.TAGS;

      Key.TITLE = constant.ItemGallery.Key.TITLE;

      Key.CAPTION = constant.ItemGallery.Key.CAPTION;

      Key.SEARCH_TYPE = constant.ItemGallery.Key.SEARCH_TYPE;

      Key.USER_CODING_ID = constant.ItemGallery.Key.USER_CODING_ID;

      return Key;

    })();

    return ItemGallery;

  })();

  return Constant;

})();

//# sourceMappingURL=constant.js.map
