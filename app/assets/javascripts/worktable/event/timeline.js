// Generated by CoffeeScript 1.9.2
var Timeline;

Timeline = (function() {
  function Timeline() {}

  Timeline.createTimelineEvent = function(teNum) {
    var emts, exist, newEmt, pEmt;
    emts = $('#timeline_events .timeline_event .te_num');
    exist = false;
    emts.each(function(e) {
      if (parseInt($(this).val()) === teNum) {
        return exist = true;
      }
    });
    if (exist) {
      return;
    }
    pEmt = $('#timeline_events');
    newEmt = $('.timeline_event_temp', pEmt).children(':first').clone(true);
    $("<input class='te_num' type='hidden' value='" + teNum + "' >").appendTo(newEmt);
    return pEmt.append(newEmt);
  };

  Timeline.setupTimelineEventConfig = function() {
    var _clickTimelineEvent, _doPreview, _initEventConfig, _setupTimelineEvent, self, te;
    self = this;
    te = null;
    _setupTimelineEvent = function() {
      var menu, tEmt, timelineEvents;
      timelineEvents = $('#timeline_events').children('.timeline_event');
      tEmt = $('.te_num', timelineEvents);
      tEmt.each(function(e) {
        var actionType, teNum;
        teNum = parseInt($(this).val());
        actionType = PageValue.getEventPageValue(EventPageValueBase.PageValueKey.te(teNum) + PageValue.Key.PAGE_VALUES_SEPERATOR + EventPageValueBase.PageValueKey.ACTIONTYPE);
        Timeline.changeTimelineColor(teNum, actionType);
        if (e === tEmt.length - 1 && actionType !== null) {
          self.createTimelineEvent(tEmt.length + 1);
          timelineEvents = $('#timeline_events').children('.timeline_event');
          return tEmt = $('.te_num', timelineEvents);
        }
      });
      timelineEvents.off('click');
      timelineEvents.on('click', function(e) {
        return _clickTimelineEvent.call(self, this);
      });
      $('#timeline_events').sortable({
        revert: true,
        axis: 'x',
        containment: $('#timeline_events_container'),
        items: '.sortable',
        stop: function(event, ui) {}
      });
      menu = [
        {
          title: "Edit",
          cmd: "edit",
          uiIcon: "ui-icon-scissors"
        }
      ];
      return timelineEvents.each(function(e) {
        var t;
        t = $(this);
        return t.contextmenu({
          preventContextMenuForPopup: true,
          preventSelect: true,
          menu: menu,
          select: function(event, ui) {
            var target;
            target = event.target;
            switch (ui.cmd) {
              case "edit":
                return _initEventConfig.call(self, target);
            }
          }
        });
      });
    };
    _clickTimelineEvent = function(e) {
      var te_num;
      if ($(e).is('.ui-sortable-helper')) {
        return;
      }
      clearSelectedBorder();
      setSelectedBorder(e, "timeline");
      if (Sidebar.isOpenedConfigSidebar() || $(e).hasClass(Constant.ActionEventTypeClassName.BLANK)) {
        _initEventConfig.call(this, e);
      }
      te_num = $(e).find('input.te_num').val();
      return _doPreview.call(this, te_num);
    };
    _doPreview = function(te_num) {
      return Common.clearAllEventChange(function() {
        var i, idx, item, len, results, tes;
        tes = PageValue.getEventPageValueSortedListByNum();
        te_num = parseInt(te_num);
        results = [];
        for (idx = i = 0, len = tes.length; i < len; idx = ++i) {
          te = tes[idx];
          item = window.createdObject[te.id];
          if (idx < te_num - 1) {
            item.setEvent(te);
            results.push(item.updateEventAfter());
          } else if (idx === te_num - 1) {
            item.setEvent(te);
            item.preview(te);
            break;
          } else {
            results.push(void 0);
          }
        }
        return results;
      });
    };
    _initEventConfig = function(e) {
      var eId, emt, te_num;
      Sidebar.switchSidebarConfig("timeline");
      te_num = $(e).find('input.te_num').val();
      eId = EventConfig.ITEM_ROOT_ID.replace('@te_num', te_num);
      emt = $('#' + eId);
      if (emt.length === 0) {
        emt = $('#event-config .event_temp .event').clone(true).attr('id', eId);
        $('#event-config').append(emt);
      }
      self.updateSelectItemMenu();
      self.setupTimelineEventHandler(te_num);
      $('#event-config .event').css('display', 'none');
      emt.css('display', '');
      return Sidebar.openConfigSidebar();
    };
    return _setupTimelineEvent.call(self);
  };

  Timeline.updateSelectItemMenu = function() {
    var items, selectOptions, teItemSelect, teItemSelects;
    teItemSelects = $('#event-config .te_item_select');
    teItemSelect = teItemSelects[0];
    selectOptions = '';
    items = $("#" + PageValue.Key.PV_ROOT + " .item");
    items.children().each(function() {
      var id, itemId, name;
      id = $(this).find('input.id').val();
      name = $(this).find('input.name').val();
      itemId = $(this).find('input.itemId').val();
      return selectOptions += "<option value='" + id + Constant.EVENT_ITEM_SEPERATOR + itemId + "'>\n  " + name + "\n</option>";
    });
    return teItemSelects.each(function() {
      $(this).find('option').each(function() {
        if ($(this).val().length > 0 && $(this).val().indexOf(Constant.EVENT_COMMON_PREFIX) !== 0) {
          return $(this).remove();
        }
      });
      return $(this).append($(selectOptions));
    });
  };

  Timeline.setupTimelineEventHandler = function(te_num) {
    var eId, emt, te;
    eId = EventConfig.ITEM_ROOT_ID.replace('@te_num', te_num);
    emt = $('#' + eId);
    te = new EventConfig(emt, te_num);
    return (function(_this) {
      return function() {
        var em;
        em = $('.te_item_select', emt);
        em.off('change');
        return em.on('change', function(e) {
          te.clearError();
          return te.selectItem(this);
        });
      };
    })(this)();
  };

  Timeline.setupEventCss = function() {
    var itemCssStyle;
    itemCssStyle = "";
    $('#css_code_info').find('.css-style').each(function() {
      return itemCssStyle += $(this).html();
    });
    if (itemCssStyle.length > 0) {
      return PageValue.setEventPageValue(PageValue.Key.E_CSS, itemCssStyle);
    }
  };

  Timeline.changeTimelineColor = function(teNum, actionType) {
    var k, ref, teEmt, v;
    if (actionType == null) {
      actionType = null;
    }
    teEmt = null;
    $('#timeline_events').children('.timeline_event').each(function(e) {
      if (parseInt($(this).find('input.te_num:first').val()) === parseInt(teNum)) {
        return teEmt = this;
      }
    });
    ref = Constant.ActionEventTypeClassName;
    for (k in ref) {
      v = ref[k];
      $(teEmt).removeClass(v);
    }
    if (actionType != null) {
      return $(teEmt).addClass(Common.getActionTypeClassNameByActionType(actionType));
    } else {
      return $(teEmt).addClass(Constant.ActionEventTypeClassName.BLANK);
    }
  };

  Timeline.removeAllTimeline = function() {
    var pEmt;
    pEmt = $('#timeline_events');
    pEmt.children().each(function(e) {
      var emt;
      emt = $(this);
      if (emt.hasClass('timeline_event_temp') === false) {
        return emt.remove();
      }
    });
    this.createTimelineEvent(1);
    return this.setupTimelineEventConfig();
  };

  return Timeline;

})();

//# sourceMappingURL=timeline.js.map
