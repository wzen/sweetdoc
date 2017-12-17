window.constant = gon.const;
window.serverenv = gon.serverenv;
window.locale = gon.locale;
window.userLogined = gon.user_logined;
window.isMobileAccess = gon.is_mobile_access;
window.isIosAccess = gon.is_ios_access;
window.utoken = gon.u_token;
if (window.isWorkTable === undefined) {
  window.isWorkTable = false;
}

// アプリ共通定数
const Constant = {
  ITEM_PREVIEW_CLASS_DIST_TOKEN: 'dummy',
  CANVAS_ITEM_COORDINATE_VAR_SURFIX: 'Coord',
  DEFAULT_BACKGROUNDCOLOR: '#FAFAFA',
  BEFORE_MODIFY_VAR_SUFFIX: '__before',
  AFTER_MODIFY_VAR_SUFFIX: '__after',
  ADMIN_USER_ID: 1,
  SAMPLE_PROJECT_USER_PROJECT_MAP_ID: 2147483647, // MySQL Int max
  GRID_CONTENTS_DISPLAY_MIN: 30,
  THUMBNAIL_FILESIZE_MAX_KB: 500,
  // 操作モード
  MODE: {
    // 未選択
    NOT_SELECT: -1,
    // 描画
    DRAW: 0,
    // 画面編集
    EDIT: 1,
    // アイテムオプション
    OPTION: 2
  },

  EVENT_INPUT_POINTING_MODE: {
    NOT_SELECT: -1,
    DRAW: 0,
    ITEM_TOUCH: 1,
  },

  ITEM_DRAW_TYPE: {
    CANVAS: 0,
    CSS: 1
  },

  ITEM_DESIGN_OPTION_TYPE: {
    BOOLEAN: 'boolean',
    NUMBER: 'number',
    STRING: 'string',
    COLOR: 'color',
    SELECT: 'select',
    SELECT_FILE: 'selectFile',
    SELECT_IMAGE_FILE: 'selectImageFile',
    DESIGN_TOOL: 'designTool'
  },

  ITEM_OPTION_TEMP_TYPE: {
    FONTFAMILY: 'fontFamily'
  },

  ACTION_TYPE: {
    SCROLL: 0,
    CLICK: 1
  },

  TIMELINE_ACTION_TYPE_CLASS_NAME: {
    BLANK: 'blank',
    SCROLL: 'scroll',
    CLICK: 'click'
  },

  COMMON_ACTION_EVENT_CHANGE_TYPE: {
    BACKGROUND: 1,
    SCREEN: 2
  },

  KEYBOARD_KEY_CODE: {
    ENTER: 13,
    Z: 90,
    C: 67,
    X: 88,
    V: 86,
    PLUS: 186,
    SEMICOLON: 59,
    MINUS: 189,
    F_MINUS: 173
  },

  EVENT_BASE: {
    PREVIEW_STEP: 3
  },
  ZINDEX: {
    GRID: 5,
    EVENTBOTTOM: 10,
    EVENTFLOAT: 999
  },
  MODAL_VIEW: {
    HEIGHT_RATE: 0.7
  },

  CONFIG_TYPE: {
    DESIGN: 1,
    EVENT: 2
  },

  DESIGN_CONFIG: {
    ROOT_CLASSNAME: 'dc',
  },

  EVENT_CONFIG: {
    EVENT_COMMON_PREFIX: 'c_',
  },

  SETTING: {
    ROOT_ID_NAME: 'setting-config',
    KEY: {
      GRID_ENABLE: 'gridEnable',
      GRID_STEP: 'gridStep',
      AUTOSAVE: 'autosave',
      AUTOSAVE_TIME: 'autosaveTime'
    }
  },

  SERVER_STORAGE: {
    DIVIDE_INTERVAL_MINUTES: 15,

    KEY: {
      PROJECT_ID: 'projectId',
      PAGE_COUNT: 'pageCount',
      GENERAL_COMMON_PAGE_VALUE: 'cg',
      GENERAL_PAGE_VALUE: 'g',
      INSTANCE_PAGE_VALUE: 'i',
      EVENT_PAGE_VALUE: 'e',
      SETTING_PAGE_VALUE: 's',
      NEW_RECORD: 'nr'
    }
  },

  PROJECT: {
    USER_CREATE_MAX: 50,

    KEY: {
      PROJECT_ID: 'projectId',
      TITLE: 'title',
      IS_SAMPLE_PROJECT: 'isSampleProject',
      SCREEN_SIZE: 'screenSize',
      FIXED_SCREEN_SIZE: 'fixedScreenSize',
      USER_PAGEVALUE_ID: 'userPagevalueId',
      USER_PAGEVALUE_UPDATED_AT: 'userPagevalueUpdatedAt'
    }
  },

  GALLERY: {
    TAG_MAX: 5,

    KEY: {
      MESSAGE: 'message',
      GALLERY_ID: 'gid',
      GALLERY_ACCESS_TOKEN: 'gAt',
      PROJECT_ID: 'pid',
      SCREEN_SIZE: 'screenSize',
      SCREEN_SIZE_WIDTH: 'scrrenSizeW',
      SCREEN_SIZE_HEIGHT: 'scrrenSizeH',
      TAGS: 'tags',
      INSTANCE_PAGE_VALUE: 'i',
      EVENT_PAGE_VALUE: 'e',
      THUMBNAIL_IMG: 'tbimg',
      THUMBNAIL_URL: 'tburl',
      THUMBNAIL_IMG_WIDTH: 'tbimgW',
      THUMBNAIL_IMG_HEIGHT: 'tbimgH',
      THUMBNAIL: 'thumbnail',
      PAGE_MAX: 'pagemax',
      TITLE: 'title',
      CAPTION: 'caption',
      MARKDOWN_CAPTION: 'markdownCaption',
      ITEM_JS_LIST: 'itemJsList',
      RECOMMEND_SOURCE_WORD: 'recommendSourceWord',
      NOTE: 'note',
      SHOW_GUIDE: 'showGuide',
      SHOW_PAGE_NUM: 'showPageNum',
      SHOW_CHAPTER_NUM: 'showChapterNum',
      PAGE_NUM: 'p_n',
      SEARCH_TYPE: 'searchType',
      USER_CODING_ID: 'userCodingId',
      USER_ID: 'userId',
      USER_NAME: 'userName',
      USER_THUMBNAIL_IMG: 'userThumbnailImg',
      BOOKMARK_COUNT: 'bookmarkCount',
      VIEW_COUNT: 'viewCount',
      TAG_ID: 'tagId',
      TAG_NAME: 'tagName',
      GENERAL_PAGEVALUE_DATA: 'generalPagevalueData',
      INSTANCE_PAGEVALUE_DATA: 'instancePagevalueData',
      EVENT_PAGEVALUE_DATA: 'eventPagevalueData',
      FOOTPRINT_PAGE_NUM: 'footprintPageNum',
      BOOKMARK_ID: 'bookmarkId',
      UPLOAD_OVERWRITE_GALLERY_TOKEN: 'uploadOverwriteGalleryToken',
      FILTER_TYPE: 'ft',
      FILTER_DATE: 'fd',
      FILTER_TAGS: 'ftg',
      OVERWRITE_CONTENTS_SELECT: 'overwriteContentsContentsSelect',
      WORD: 'word'
    },

    SEARCH_KEY: {
      SHOW_HEAD: 'showHead',
      SHOW_LIMIT: 'showLimit',
      SEARCH_TYPE: 'searchType',
      TAG_ID: 'tagId',
      DATE: 'date'
    },

    SEARCH_TYPE: {
      ALL: 'all',
      VIEW_COUNT: 'vc',
      BOOKMARK_COUNT: 'bc',
      USER_BOOKMARK: 'ub',
      CREATED: 'cr',
      RECOMMEND: 'rc'
    },

    SIDEBAR: {
      USER: 'user',
      WORKTABLE: 'worktable',
      VIEW: 'view',
      SEARCH: 'search',
      LOGO: 'logo'
    }
  },


  ITEM_GALLERY: {
    TAG_MAX: 3,
    POPULAR_TAG_MENU_SHOW_MAX: 15,

    KEY: {
      MESSAGE: 'message',
      ITEM_GALLERY_ID: 'igid',
      ITEM_GALLERY_ACCESS_TOKEN: 'igAt',
      TAGS: 'tags',
      TITLE: 'title',
      CAPTION: 'caption',
      SEARCH_TYPE: 'searchType',
      USER_CODING_ID: 'userCodingId',
      TAG_ID: 'tagId',
      TAG_NAME: 'tagName',
      ITEM_GALLERY_COUNT: 'itemGalleryCount',
      USER_ITEM_GALLERY_ID: 'userItemGalleryId'
    },

    PUBLIC_TYPE: {
      PUBLIC: 1,
      PRIVATE: 2
    }
  },

  EVENT_PAGE_VALUE: {
    NO_METHOD: '__no_method',
    NO_JUMPPAGE: -1
  },

  EVENT_PAGE_VALUE_KEY: {
    DIST_ID: 'distId',
    ID: 'id',
    CLASS_DIST_TOKEN: 'classDistToken',
    ITEM_SIZE_DIFF: 'itemSizeDiff',
    DO_FOCUS: 'doFocus',
    SHOW_WILL_CHAPTER: 'showWillChapter',
    SHOW_WILL_CHAPTER_DURATION: 'showWillChapterDuration',
    HIDE_DID_CHAPTER: 'hideWillChapter',
    HIDE_DID_CHAPTER_DURATION: 'hideWillChapterDuration',
    COMMON_EVENT_ID: 'commonEventId',
    VALUE: 'value',
    IS_COMMON_EVENT: 'isCommonEvent',
    ORDER: 'order',
    FINISH_PAGE: 'finishpage',
    JUMPPAGE_NUM: 'jumppage_num',
    METHODNAME: 'methodname',
    ACTIONTYPE: 'actiontype',
    IS_SYNC: 'is_sync',
    SCROLL_POINT_START: 'scrollPointStart',
    SCROLL_POINT_END: 'scrollPointEnd',
    SCROLL_ENABLED_DIRECTIONS: 'scrollEnabledDirections',
    SCROLL_FORWARD_DIRECTIONS: 'scrollForwardDirections',
    CHANGE_FORKNUM: 'changeForknum',
    MODIFIABLE_VARS: 'modifiable_vars',
    EVENT_DURATION: 'eventDuration',
    SPECIFIC_METHOD_VALUES: 'specificMethodValues'
  },

  USER_PAGE_VALUE: {
    GET_LIMIT: 10
  },

  MODAL_VIEW_TYPE: {
    INIT_PROJECT: 'initProject',
    ADMIN_PROJECTS: 'adminProjects',
    CREATE_USER_CODE: 'createUserCode',
    ITEM_IMAGE_UPLOAD: 'itemImageUpload',
    ITEM_TEXT_EDITING: 'itemTextEditing',
    NOTICE_LOGIN: 'noticeLogin',
    ABOUT: 'about',
    MESSAGE: 'message',
    FLASH_MESSAGE: 'flashMessage',
    ENVIRONMENT_NOT_SUPPORT: 'environmentNotSupport',
    CHANGE_SCREEN_SIZE: 'changeScreenSize'
  },

  PAGING: {
    ROOT_ID: 'pages',
    MAIN_PAGING_SECTION_CLASS: 'pagesection-@pagenum',
    NAV_ROOT_ID: 'headerPageingMenu',
    NAV_SELECTED_CLASS: 'headerPageingMenuSelected',
    NAV_SELECT_ROOT_CLASS: 'headerPageingMenuRoot',
    PRELOAD_PAGEVALUE_NUM: 0
  },

  RUN_GUIDE: {
    TOP_ROOT_ID: 'guideTop',
    BOTTOM_ROOT_ID: 'guideBottom',
    LEFT_ROOT_ID: 'guideLeft',
    RIGHT_ROOT_ID: 'guideRight'
  },

  ITEM_ACTION_PROPERTIES_KEY: {
    TYPE: 'type',
    METHODS: 'methods',
    TEMP: 'temp',
    DEFAULT_EVENT: 'defaultEvent',
    METHOD: 'method',
    DEFAULT_METHOD: 'defaultMethod',
    SPECIFIC_METHOD_VALUES: 'specificValues',
    ACTION_TYPE: 'actionType',
    COLOR_TYPE: 'colorType',
    SCROLL_ENABLED_DIRECTION: 'scrollEnabledDirection',
    SCROLL_FORWARD_DIRECTION: 'scrollForwardDirection',
    OPTIONS: 'options',
    EVENT_DURATION: 'eventDuration',
    MODIFIABLE_VARS: 'modifiables',
    MODIFIABLE_CHILDREN: 'children',
    MODIFIABLE_CHILDREN_OPENVALUE: 'openChildrenValue',
    FINISH_WITH_HAND: 'finishWithHand'
  },

  RUN: {
    ATTRIBUTE_NAME: {
      CONTENTS_CREATOR_CLASSNAME: 'conCreatorCn',
      CONTENTS_TITLE_CLASSNAME: 'conTitleCn',
      CONTENTS_CAPTION_CLASSNAME: 'conCaptionCn',
      CONTENTS_PAGE_NUM_CLASSNAME: 'conPageNumCn',
      CONTENTS_PAGE_MAX_CLASSNAME: 'conPageMaxCn',
      CONTENTS_CHAPTER_NUM_CLASSNAME: 'conChapterNumCn',
      CONTENTS_CHAPTER_MAX_CLASSNAME: 'conChapterMaxCn',
      CONTENTS_FORK_NUM_CLASSNAME: 'conForkNumCn',
      CONTENTS_TAGS_CLASSNAME: 'conTagCn'
    },

    KEY: {
      TARGET_PAGES: 'targetpages',
      LOADED_CLASS_DIST_TOKENS: 'liat',
      PROJECT_ID: 'pid',
      ACCESS_TOKEN: 'at',
      RUNNING_USER_PAGEVALUE_ID: 'urpi',
      FOOTPRINT_PAGE_VALUE: 'f',
      LOAD_FOOTPRINT: 'l_f'
    }
  },

  CODING: {
    DEFAULT_FILENAME: 'untitled',
    KEY: {
      LANG: 'langType',
      PUBLIC: 'public',
      CODE: 'code',
      CODES: 'codes',
      USER_CODING_ID: 'userCodingId',
      TREE_DATA: 'treeData',
      SUB_TREE: 'subTree',
      NODE_PATH: 'nodePath',
      DRAW_TYPE: 'drawType',
      IS_OPENED: 'isOpened',
      IS_ACTIVE: 'isActive',
      PARENT_NODE_PATH: 'parentNodePath'
    },
    LANG: {
      JAVASCRIPT: 'js',
      COFFEESCRIPT: 'coffee'
    },
    CACHE_KEY: {
      TREE_STATE_KEY: 'user_id:@user_id-treestatekey',
      CODE_STATE_KEY: 'user_id:@user_id-codestatekey'
    }
  },

  USER: {
    KEY: {
      USER_ACCESS_TOKEN: 'u',
      NAME: 'name',
      USER_COUNT: 'count',
      THUMBNAIL: 'thumbnail'
    }
  },

  MY_PAGE: {
    KEY: {
      HEAD: 'h',
      LIMIT: 'l'
    }
  },

  CONFIG_MENU: {
    ROOT_ID: 'configMenuTemps',
    ACTION: {
      PRELOAD_IMAGE_PATH_SELECT: 'preloadImagePathSelectConfig'
    },
    MODIFIABLE: {
      CHILDREN_WRAPPER_CLASS: 'modifiableChildrenWrapper-@parentvarname-@childrenkey'
    }
  },

  PRELOAD_ITEM_IMAGE: {
    KEY: {
      PROJECT_ID: 'pid',
      ITEM_OBJ_ID: 'iobjid',
      GALLERY_ID: 'glid',
      EVENT_DIST_ID: 'edistid',
      SELECT_FILE: 'sef',
      SELECT_FILE_DELETE: 'sefDel',
      URL: 'url'
    }
  },

  PRELOAD_ITEM_TEXT: {
    BALLOON_TYPE: {
      NONE: 0,
      FREE: 999999,
      ARC: 1,
      RECT: 2,
      BROKEN_ARC: 3,
      BROKEN_RECT: 4,
      FLASH: 5,
      CLOUD: 6
    },
    WRITE_DIRECTION_TYPE: {
      HORIZONTAL: 0,
      VERTICAL: 1
    },
    WORD_ALIGN: {
      LEFT: 1,
      CENTER: 2,
      RIGHT: 3
    },
    SHOW_ANIMATION_TYPE: {
      POPUP: 1,
      FADE: 2
    }
  }

};