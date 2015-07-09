// Generated by CoffeeScript 1.9.2
var Constant, constant;

if (typeof gon !== "undefined" && gon !== null) {
  constant = gon["const"];
  Constant = (function() {
    function Constant() {}

    Constant.ZINDEX_MAX = constant.ZINDEX_MAX;

    Constant.OPERATION_STORE_MAX = constant.OPERATION_STORE_MAX;

    Constant.ITEM_PATH_LIST = constant.ITEM_PATH_LIST;

    Constant.PAGE_VALUES_SEPERATOR = ":";

    Constant.TIMELINE_ITEM_SEPERATOR = "&";

    Constant.TIMELINE_COMMON_PREFIX = constant.TIMELINE_COMMON_PREFIX;

    Constant.TIMELINE_COMMON_ACTION_CLASSNAME = constant.TIMELINE_COMMON_ACTION_CLASSNAME;

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

      ActionEventTypeClassName.SCROLL = 'scroll';

      ActionEventTypeClassName.CLICK = 'click';

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

      PageValueKey.ITEM_VALUE = 'item:@id:value';

      PageValueKey.ITEM_VALUE_CACHE = 'item:cache:@id:value';

      PageValueKey.CONFIG_OPENED_SCROLL = 'config_opened_scroll';

      PageValueKey.TE_COUNT = 'timeline_event:count';

      PageValueKey.TE_ALL_LENGTH = 'timeline_event:all_length';

      return PageValueKey;

    })();

    Constant.ElementAttribute = (function() {
      function ElementAttribute() {}

      ElementAttribute.DESIGN_CONFIG_ROOT_ID = 'design_config_@id';

      return ElementAttribute;

    })();

    Constant.CommonActionEventChangeType = (function() {
      function CommonActionEventChangeType() {}

      CommonActionEventChangeType.BACKGROUNDCOLOR_CHANGE = constant.CommonActionEventChangeType.BACKGROUNDCOLOR_CHANGE;

      CommonActionEventChangeType.SCREENPOSITION_CHANGE = constant.CommonActionEventChangeType.SCREENPOSITION_CHANGE;

      return CommonActionEventChangeType;

    })();

    return Constant;

  })();
}

//# sourceMappingURL=constant.js.map
