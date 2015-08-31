// Generated by CoffeeScript 1.9.2
var Constant, constant;

if (typeof gon !== "undefined" && gon !== null) {
  constant = gon["const"];
  Constant = (function() {
    function Constant() {}

    Constant.OPERATION_STORE_MAX = constant.OPERATION_STORE_MAX;

    Constant.ITEM_PATH_LIST = constant.ITEM_PATH_LIST;

    Constant.EVENT_ITEM_SEPERATOR = "&";

    Constant.EVENT_COMMON_PREFIX = constant.EVENT_COMMON_PREFIX;

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

    Constant.ActionAnimationType = (function() {
      function ActionAnimationType() {}

      ActionAnimationType.JQUERY_ANIMATION = constant.ActionAnimationType.JQUERY_ANIMATION;

      ActionAnimationType.CSS3_ANIMATION = constant.ActionAnimationType.CSS3_ANIMATION;

      return ActionAnimationType;

    })();

    Constant.KeyboardKeyCode = (function() {
      function KeyboardKeyCode() {}

      KeyboardKeyCode.Z = constant.KeyboardKeyCode.Z;

      return KeyboardKeyCode;

    })();

    Constant.ElementAttribute = (function() {
      function ElementAttribute() {}

      ElementAttribute.MAIN_TEMP_ID = constant.ElementAttribute.MAIN_TEMP_ID;

      ElementAttribute.DESIGN_CONFIG_ROOT_ID = 'design_config_@id';

      ElementAttribute.NAVBAR_ROOT = constant.ElementAttribute.NAVBAR_ROOT;

      return ElementAttribute;

    })();

    Constant.CommonActionEventChangeType = (function() {
      function CommonActionEventChangeType() {}

      CommonActionEventChangeType.BACKGROUND = constant.CommonActionEventChangeType.BACKGROUND;

      CommonActionEventChangeType.SCREEN = constant.CommonActionEventChangeType.SCREEN;

      return CommonActionEventChangeType;

    })();

    Constant.ModalViewType = (function() {
      function ModalViewType() {}

      ModalViewType.ABOUT = constant.ModalViewType.ABOUT;

      return ModalViewType;

    })();

    Constant.Paging = (function() {
      function Paging() {}

      Paging.ROOT_ID = constant.Paging.ROOT_ID;

      Paging.MAIN_PAGING_SECTION_CLASS = constant.Paging.MAIN_PAGING_SECTION_CLASS;

      Paging.NAV_ROOT_ID = constant.Paging.NAV_ROOT_ID;

      Paging.NAV_SELECTED_CLASS = constant.Paging.NAV_SELECTED_CLASS;

      Paging.NAV_SELECT_ROOT_CLASS = constant.Paging.NAV_SELECT_ROOT_CLASS;

      Paging.NAV_MENU_NAME = 'Page @pagenum';

      Paging.NAV_MENU_CLASS = 'paging-@pagenum';

      Paging.NAV_MENU_ADDPAGE_CLASS = 'paging-new';

      return Paging;

    })();

    return Constant;

  })();
}

//# sourceMappingURL=constant.js.map
