// Generated by CoffeeScript 1.9.2
var Constant, constant;

if (typeof gon !== "undefined" && gon !== null) {
  constant = gon["const"];
  Constant = (function() {
    function Constant() {}

    Constant.Zindex = (function() {
      function Zindex() {}

      Zindex.GRID = 5;

      Zindex.EVENTBOTTOM = constant.Zindex.EVENTBOTTOM;

      Zindex.EVENTFLOAT = constant.Zindex.EVENTFLOAT;

      return Zindex;

    })();

    Constant.Mode = (function() {
      function Mode() {}

      Mode.DRAW = constant.Mode.DRAW;

      Mode.EDIT = constant.Mode.EDIT;

      Mode.OPTION = constant.Mode.OPTION;

      return Mode;

    })();

    Constant.ActionType = (function() {
      function ActionType() {}

      ActionType.SCROLL = constant.ActionType.SCROLL;

      ActionType.CLICK = constant.ActionType.CLICK;

      return ActionType;

    })();

    Constant.TimelineActionTypeClassName = (function() {
      function TimelineActionTypeClassName() {}

      TimelineActionTypeClassName.BLANK = constant.TimelineActionTypeClassName.BLANK;

      TimelineActionTypeClassName.SCROLL = constant.TimelineActionTypeClassName.SCROLL;

      TimelineActionTypeClassName.CLICK = constant.TimelineActionTypeClassName.CLICK;

      return TimelineActionTypeClassName;

    })();

    Constant.ActionAnimationType = (function() {
      function ActionAnimationType() {}

      ActionAnimationType.JQUERY_ANIMATION = constant.ActionAnimationType.JQUERY_ANIMATION;

      ActionAnimationType.CSS3_ANIMATION = constant.ActionAnimationType.CSS3_ANIMATION;

      return ActionAnimationType;

    })();

    Constant.KeyboardKeyCode = (function() {
      function KeyboardKeyCode() {}

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

      ModalViewType.UPLOAD_GALLERY_CONFIRM = constant.ModalViewType.UPLOAD_GALLERY_CONFIRM;

      return ModalViewType;

    })();

    Constant.Paging = (function() {
      function Paging() {}

      Paging.ROOT_ID = constant.Paging.ROOT_ID;

      Paging.MAIN_PAGING_SECTION_CLASS = constant.Paging.MAIN_PAGING_SECTION_CLASS;

      Paging.NAV_ROOT_ID = constant.Paging.NAV_ROOT_ID;

      Paging.NAV_SELECTED_CLASS = constant.Paging.NAV_SELECTED_CLASS;

      Paging.NAV_SELECT_ROOT_CLASS = constant.Paging.NAV_SELECT_ROOT_CLASS;

      Paging.NAV_MENU_PAGE_NAME = 'Page @pagenum';

      Paging.NAV_MENU_FORK_NAME = 'Fork @forknum';

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

        Key.PROJECT_ID = constant.Gallery.Key.PROJECT_ID;

        Key.TAGS = constant.Gallery.Key.TAGS;

        Key.INSTANCE_PAGE_VALUE = constant.Gallery.Key.INSTANCE_PAGE_VALUE;

        Key.EVENT_PAGE_VALUE = constant.Gallery.Key.EVENT_PAGE_VALUE;

        Key.THUMBNAIL_IMG = constant.Gallery.Key.THUMBNAIL_IMG;

        Key.TITLE = constant.Gallery.Key.TITLE;

        Key.CAPTION = constant.Gallery.Key.CAPTION;

        Key.ITEM_JS_LIST = constant.Gallery.Key.ITEM_JS_LIST;

        Key.VIEW_COUNT = constant.Gallery.Key.VIEW_COUNT;

        Key.BOOKMARK_COUNT = constant.Gallery.Key.BOOKMARK_COUNT;

        Key.RECOMMEND_SOURCE_WORD = constant.Gallery.Key.RECOMMEND_SOURCE_WORD;

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

        SearchType.CREATED = constant.Gallery.SearchType.CREATED;

        return SearchType;

      })();

      return Gallery;

    })();

    return Constant;

  })();
}

//# sourceMappingURL=constant.js.map
