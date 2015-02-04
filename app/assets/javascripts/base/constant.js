// Generated by CoffeeScript 1.7.1
var Constant, constant;

if (typeof gon !== "undefined" && gon !== null) {
  constant = gon["const"];
  Constant = (function() {
    function Constant() {}

    Constant.ZINDEX_MAX = constant.ZINDEX_MAX;

    Constant.OPERATION_STORE_MAX = constant.OPERATION_STORE_MAX;

    Constant.ITEM_PATH_LIST = constant.ITEM_PATH_LIST;

    Constant.PAGE_VALUES_SEPERATOR = ":";

    Constant.Mode = (function() {
      function Mode() {}

      Mode.DRAW = constant.Mode.DRAW;

      Mode.EDIT = constant.Mode.EDIT;

      Mode.OPTION = constant.Mode.OPTION;

      return Mode;

    })();

    Constant.ItemType = (function() {
      function ItemType() {}

      ItemType.ARROW = constant.ItemType.ARROW;

      ItemType.BUTTON = constant.ItemType.BUTTON;

      return ItemType;

    })();

    Constant.ItemActionType = (function() {
      function ItemActionType() {}

      ItemActionType.MAKE = constant.ItemActionType.MAKE;

      ItemActionType.MOVE = constant.ItemActionType.MOVE;

      ItemActionType.CHANGE_OPTION = constant.ItemActionType.CHANGE_OPTION;

      return ItemActionType;

    })();

    Constant.ActionEventType = (function() {
      function ActionEventType() {}

      ActionEventType.SCROLL = constant.ActionEventType.SCROLL;

      ActionEventType.CLICK = constant.ActionEventType.CLICK;

      return ActionEventType;

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

      PageValueKey.TE = 'timeline_event:@id';

      PageValueKey.TE_SORT = PageValueKey.TE + ':sort';

      PageValueKey.TE_METHODNAME = PageValueKey.TE + ':mn';

      PageValueKey.TE_DELAY = PageValueKey.TE + ':delay';

      PageValueKey.CONFIG_OPENED_SCROLL = 'config_opened_scroll';

      return PageValueKey;

    })();

    Constant.ElementAttribute = (function() {
      function ElementAttribute() {}

      ElementAttribute.ITEM_ID = '@it_@id';

      ElementAttribute.DESIGN_CONFIG_ROOT_ID = 'design_config_@id';

      ElementAttribute.TE_ITEM_ROOT_ID = 'timeline_event_@te_num';

      ElementAttribute.TE_ACTION_CLASS = 'timeline_event_action_@itemid';

      ElementAttribute.TE_VALUES_CLASS = constant.ElementAttribute.TE_VALUES_CLASS;

      return ElementAttribute;

    })();

    return Constant;

  })();
}

//# sourceMappingURL=constant.map
