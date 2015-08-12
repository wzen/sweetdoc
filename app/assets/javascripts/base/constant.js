// Generated by CoffeeScript 1.9.2
var Constant, constant;

if (typeof gon !== "undefined" && gon !== null) {
  constant = gon["const"];
  Constant = (function() {
    function Constant() {}

    Constant.OPERATION_STORE_MAX = constant.OPERATION_STORE_MAX;

    Constant.ITEM_PATH_LIST = constant.ITEM_PATH_LIST;

    Constant.TIMELINE_ITEM_SEPERATOR = "&";

    Constant.TIMELINE_COMMON_PREFIX = constant.TIMELINE_COMMON_PREFIX;

    Constant.Zindex = (function() {
      function Zindex() {}

      Zindex.GRID = 5;

      Zindex.EVENTBOTTOM = constant.Zindex.EVENTBOTTOM;

      Zindex.EVENTFLOAT = constant.Zindex.EVENTFLOAT;

      Zindex.MAX = constant.Zindex.MAX;

      return Zindex;

    })();

    Constant.Mode = (function() {
      function Mode() {}

      Mode.DRAW = constant.Mode.DRAW;

      Mode.EDIT = constant.Mode.EDIT;

      Mode.OPTION = constant.Mode.OPTION;

      return Mode;

    })();

    Constant.ItemId = (function() {
      function ItemId() {}

      ItemId.ARROW = constant.ItemId.ARROW;

      ItemId.BUTTON = constant.ItemId.BUTTON;

      return ItemId;

    })();

    Constant.ItemActionType = (function() {
      function ItemActionType() {}

      ItemActionType.MAKE = constant.ItemActionType.MAKE;

      ItemActionType.MOVE = constant.ItemActionType.MOVE;

      ItemActionType.CHANGE_OPTION = constant.ItemActionType.CHANGE_OPTION;

      return ItemActionType;

    })();

    Constant.ActionEventHandleType = (function() {
      function ActionEventHandleType() {}

      ActionEventHandleType.SCROLL = constant.ActionEventHandleType.SCROLL;

      ActionEventHandleType.CLICK = constant.ActionEventHandleType.CLICK;

      return ActionEventHandleType;

    })();

    Constant.ActionEventTypeClassName = (function() {
      function ActionEventTypeClassName() {}

      ActionEventTypeClassName.BLANK = constant.ActionEventTypeClassName.BLANK;

      ActionEventTypeClassName.SCROLL = constant.ActionEventTypeClassName.SCROLL;

      ActionEventTypeClassName.CLICK = constant.ActionEventTypeClassName.CLICK;

      return ActionEventTypeClassName;

    })();

    Constant.ActionEventChangeType = (function() {
      function ActionEventChangeType() {}

      ActionEventChangeType.DRAW = constant.ActionEventChangeType.DRAW;

      ActionEventChangeType.ANIMATION = constant.ActionEventChangeType.ANIMATION;

      ActionEventChangeType.CHANGE_OPTION = constant.ActionEventChangeType.CHANGE_OPTION;

      ActionEventChangeType.DELETE = constant.ActionEventChangeType.DELETE;

      return ActionEventChangeType;

    })();

    Constant.KeyboardKeyCode = (function() {
      function KeyboardKeyCode() {}

      KeyboardKeyCode.Z = constant.KeyboardKeyCode.Z;

      return KeyboardKeyCode;

    })();

    Constant.PageValueKey = (function() {
      function PageValueKey() {}

      PageValueKey.PV_ROOT = constant.PageValueKey.PV_ROOT;

      PageValueKey.TE_ROOT = constant.PageValueKey.TE_ROOT;

      PageValueKey.TE_PREFIX = constant.PageValueKey.TE_PREFIX;

      PageValueKey.TE_COUNT = constant.PageValueKey.TE_COUNT;

      PageValueKey.TE_CSS = constant.PageValueKey.TE_CSS;

      PageValueKey.PAGE_VALUES_SEPERATOR = constant.PageValueKey.PAGE_VALUES_SEPERATOR;

      PageValueKey.TE_NUM_PREFIX = constant.PageValueKey.TE_NUM_PREFIX;

      PageValueKey.ITEM_VALUE = 'item:@id:value';

      PageValueKey.ITEM_VALUE_CACHE = 'item:cache:@id:value';

      PageValueKey.ITEM_DEFAULT_METHODNAME = 'iteminfo:@item_id:default:methodname';

      PageValueKey.ITEM_DEFAULT_ACTIONTYPE = 'iteminfo:@item_id:default:actiontype';

      PageValueKey.CONFIG_OPENED_SCROLL = 'config_opened_scroll';

      PageValueKey.IS_RUNWINDOW_RELOAD = constant.PageValueKey.IS_RUNWINDOW_RELOAD;

      return PageValueKey;

    })();

    Constant.ElementAttribute = (function() {
      function ElementAttribute() {}

      ElementAttribute.DESIGN_CONFIG_ROOT_ID = 'design_config_@id';

      return ElementAttribute;

    })();

    Constant.CommonActionEventChangeType = (function() {
      function CommonActionEventChangeType() {}

      CommonActionEventChangeType.BACKGROUND = constant.CommonActionEventChangeType.BACKGROUND;

      CommonActionEventChangeType.SCREEN = constant.CommonActionEventChangeType.SCREEN;

      return CommonActionEventChangeType;

    })();

    Constant.StorageKey = (function() {
      function StorageKey() {}

      StorageKey.TIMELINE_PAGEVALUES = 'timeline_pagevalues';

      return StorageKey;

    })();

    return Constant;

  })();
}

//# sourceMappingURL=constant.js.map
