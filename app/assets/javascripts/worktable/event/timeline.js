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
    newEmt.find('.te_num').val(teNum);
    newEmt.find('.dist_id').val(Common.generateId());
    return pEmt.append(newEmt);
  };

  Timeline.setupTimelineEventConfig = function() {
    var _clickTimelineEvent, _deleteTimeline, _doPreview, _initEventConfig, _setupTimelineEvent, self, te;
    self = this;
    te = null;
    _setupTimelineEvent = function() {
      var actionType, ePageValues, emt, i, idx, j, l, len, menu, pageValue, ref, ref1, teNum, timelineEvents;
      ePageValues = PageValue.getEventPageValueSortedListByNum();
      timelineEvents = $('#timeline_events').children('.timeline_event');
      emt = null;
      if (ePageValues.length > 0) {
        for (idx = j = 0, len = ePageValues.length; j < len; idx = ++j) {
          pageValue = ePageValues[idx];
          teNum = idx + 1;
          emt = timelineEvents.eq(idx);
          if (emt.length === 0) {
            self.createTimelineEvent(teNum);
            timelineEvents = $('#timeline_events').children('.timeline_event');
          }
          $('.te_num', emt).val(teNum);
          $('.dist_id', emt).val(pageValue[EventPageValueBase.PageValueKey.DIST_ID]);
          actionType = pageValue[EventPageValueBase.PageValueKey.ACTIONTYPE];
          Timeline.changeTimelineColor(teNum, actionType);
          if (pageValue[EventPageValueBase.PageValueKey.IS_SYNC]) {
            timelineEvents.eq(idx).before("<div class='sync_line " + (Common.getActionTypeClassNameByActionType(actionType)) + "'></div>");
          } else {
            timelineEvents.eq(idx).prev('.sync_line').remove();
          }
        }
        if (ePageValues.length < timelineEvents.length - 1) {
          for (i = l = ref = ePageValues.length, ref1 = timelineEvents.length - 1; ref <= ref1 ? l <= ref1 : l >= ref1; i = ref <= ref1 ? ++l : --l) {
            emt = timelineEvents.get(i);
            emt.remove();
          }
        }
      } else {
        this.createTimelineEvent(1);
      }
      self.createTimelineEvent(ePageValues.length + 1);
      timelineEvents = $('#timeline_events').children('.timeline_event');
      timelineEvents.off('click');
      timelineEvents.on('click', function(e) {
        return _clickTimelineEvent.call(self, this);
      });
      $('#timeline_events').sortable({
        revert: true,
        axis: 'x',
        containment: $('#timeline_events_container'),
        items: '.sortable',
        start: function(event, ui) {
          return $('#timeline_events .sync_line').remove();
        },
        update: function(event, ui) {
          var afterNum, beforeNum, target, tes;
          target = $(ui.item);
          beforeNum = parseInt(target.find('.te_num:first').val());
          afterNum = null;
          tes = $('#timeline_events').children('.timeline_event');
          tes.each(function(idx) {
            if (parseInt($(this).find('.te_num:first').val()) === beforeNum) {
              return afterNum = idx + 1;
            }
          });
          if (afterNum != null) {
            return Timeline.changeSortTimeline(beforeNum, afterNum);
          }
        }
      });
      menu = [
        {
          title: I18n.t('context_menu.edit'),
          cmd: "edit",
          uiIcon: "ui-icon-scissors"
        }
      ];
      menu.push({
        title: I18n.t('context_menu.delete'),
        cmd: "delete",
        uiIcon: "ui-icon-scissors"
      });
      return timelineEvents.filter(function(idx) {
        return !$(this).hasClass('temp') && !$(this).hasClass('blank');
      }).contextmenu({
        preventContextMenuForPopup: true,
        preventSelect: true,
        menu: menu,
        select: function(event, ui) {
          var target;
          target = event.target;
          switch (ui.cmd) {
            case "edit":
              return _initEventConfig.call(self, target);
            case "delete":
              return _deleteTimeline.call(self, target);
          }
        }
      });
    };
    _clickTimelineEvent = function(e) {
      var te_num;
      if ($(e).is('.ui-sortable-helper')) {
        return;
      }
      WorktableCommon.clearSelectedBorder();
      WorktableCommon.setSelectedBorder(e, "timeline");
      if (Sidebar.isOpenedConfigSidebar() || $(e).hasClass(Constant.TimelineActionTypeClassName.BLANK)) {
        _initEventConfig.call(this, e);
      }
      te_num = $(e).find('input.te_num').val();
      return _doPreview.call(this, te_num);
    };
    _doPreview = function(te_num) {
      return Common.clearAllEventAction(function() {
        var idx, item, j, len, results, tes;
        PageValue.removeAllFootprint();
        tes = PageValue.getEventPageValueSortedListByNum();
        te_num = parseInt(te_num);
        results = [];
        for (idx = j = 0, len = tes.length; j < len; idx = ++j) {
          te = tes[idx];
          item = window.instanceMap[te.id];
          if (item != null) {
            item.initEvent(te);
            PageValue.saveInstanceObjectToFootprint(item.id, true, item.event[EventPageValueBase.PageValueKey.DIST_ID]);
            if (idx < te_num - 1) {
              results.push(item.updateEventAfter());
            } else if (idx === te_num - 1) {
              item.preview(te);
              break;
            } else {
              results.push(void 0);
            }
          } else {
            results.push(void 0);
          }
        }
        return results;
      });
    };
    _deleteTimeline = function(target) {
      var eNum;
      eNum = parseInt($(target).find('.te_num:first').val());
      PageValue.removeEventPageValue(eNum);
      return Timeline.refreshAllTimeline();
    };
    _initEventConfig = function(e) {
      var distId, eId, teNum;
      Sidebar.switchSidebarConfig(Sidebar.Type.TIMELINE);
      teNum = $(e).find('input.te_num').val();
      distId = $(e).find('input.dist_id').val();
      Sidebar.initEventConfig(distId, teNum);
      $('#event-config .event').hide();
      eId = EventConfig.ITEM_ROOT_ID.replace('@distid', distId);
      $("#" + eId).show();
      return Sidebar.openConfigSidebar();
    };
    return _setupTimelineEvent.call(self);
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
    ref = Constant.TimelineActionTypeClassName;
    for (k in ref) {
      v = ref[k];
      $(teEmt).removeClass(v);
    }
    if (actionType != null) {
      return $(teEmt).addClass(Common.getActionTypeClassNameByActionType(actionType));
    } else {
      return $(teEmt).addClass(Constant.TimelineActionTypeClassName.BLANK);
    }
  };

  Timeline.refreshAllTimeline = function() {
    Indicator.showIndicator(Indicator.Type.TIMELINE);
    return setTimeout((function(_this) {
      return function() {
        var pEmt;
        pEmt = $('#timeline_events');
        pEmt.children().each(function(e) {
          var emt;
          emt = $(this);
          if (emt.hasClass('timeline_event_temp') === false) {
            return emt.remove();
          }
        });
        _this.setupTimelineEventConfig();
        return Indicator.hideIndicator(Indicator.Type.TIMELINE);
      };
    })(this), 0);
  };

  Timeline.changeSortTimeline = function(beforeNum, afterNum) {
    if (beforeNum !== afterNum) {
      PageValue.sortEventPageValue(beforeNum, afterNum);
    }
    return this.refreshAllTimeline();
  };

  return Timeline;

})();

//# sourceMappingURL=timeline.js.map
