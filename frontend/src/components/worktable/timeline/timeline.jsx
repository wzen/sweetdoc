import React, { Component } from 'react';
import Common from '../../../base/common';
import PageValue from '../../../base/page_value';
import Sidebar from '../../sidebar_config/sidebar_ui';
import EventPageValueBase from '../../event_page_value/base/base';
import WorktableCommon from '../common/worktable_common';
import Indicator from '../../../base/indicator';
import {SortableContainer, SortableElement, arrayMove} from 'react-sortable-hoc';
import TimelineItemCmp from './timeline_item';

const Item = SortableElement(({value}) =>
  <TimelineItemCmp />
);

const TimelineList = SortableContainer(({items}) => {
  return (
    <div id="timeline_container" className="border">
      <div id="timeline_events_container" className="scroll_x_content">
        <div id="timeline_events">
          {items.map((value, index) => (
            <Item key={`item-${index}`} index={index} value={value} />
          ))}
        </div>
      </div>
    </div>
  );
});

export default class TimelineCmp extends Component {


  // タイムラインのイベント設定
  setupTimelineEventConfig(teNum = null) {
    const te = null;
    // 設定開始
    const _setupTimelineEvent = function() {
      let timelineEvents;
      const ePageValues = PageValue.getEventPageValueSortedListByNum();
      let emt = null;
      if(ePageValues.length > 0) {
        let idx;
        if(teNum) {
          idx = teNum - 1;
          _createEvent.call(this, ePageValues[idx], idx);
        } else {
          // 色、数値、Sync線を更新
          for(idx = 0; idx < ePageValues.length; idx++) {
            const pageValue = ePageValues[idx];
            _createEvent.call(this, pageValue, idx);
          }
          timelineEvents = $('#timeline_events').children('.timeline_event');
          // 不要なタイムラインイベントを削除
          if(ePageValues.length < (timelineEvents.length - 1)) {
            for(let i = ePageValues.length, end = timelineEvents.length - 1, asc = ePageValues.length <= end; asc ? i <= end : i >= end; asc ? i++ : i--) {
              emt = timelineEvents.get(i);
              emt.remove();
            }
          }
        }
      } else {
        this.createTimelineEvent(1);
      }

      // blankイベントを新規作成
      this.createTimelineEvent(ePageValues.length + 1);

      // 再取得
      timelineEvents = $('#timeline_events').children('.timeline_event');

      // イベントのクリック
      timelineEvents.off('click').on('click', e => {
        return _clickTimelineEvent.call(this, $(e.target));
      });
      // イベントのD&D
      $('#timeline_events').sortable({
        revert: true,
        axis: 'x',
        containment: $('#timeline_events_container'),
        items: '.sortable:not(.blank)',
        start(event, ui) {
          // 同期線消去
          $('#timeline_events .sync_line').remove();
          // コンフィグ非表示
          return Sidebar.closeSidebar();
        },
        update(event, ui) {
          // イベントのソート番号を更新
          const target = $(ui.item);
          const beforeNum = parseInt(target.find('.te_num:first').val());
          let afterNum = null;
          const tes = $('#timeline_events').children('.timeline_event');
          tes.each(function(idx) {
            if(parseInt($(this).find('.te_num:first').val()) === beforeNum) {
              return afterNum = idx + 1;
            }
          });
          if(afterNum !== null) {
            return Timeline.changeSortTimeline(beforeNum, afterNum);
          }
        }
      });
      // イベントの右クリック
      const menu = [{title: I18n.t('context_menu.preview'), cmd: "preview", uiIcon: "ui-icon-scissors"}];
      menu.push({
        title: I18n.t('context_menu.delete'),
        cmd: "delete",
        uiIcon: "ui-icon-scissors"
      });
      return timelineEvents.filter(function(idx) {
        return !$(this).hasClass('temp') && !$(this).hasClass('blank');
      }).contextmenu(
        {
          preventContextMenuForPopup: true,
          preventSelect: true,
          menu,
          select: (event, ui) => {
            const {target} = event;
            switch(ui.cmd) {
              case "preview":
                var te_num = $(target).find('input.te_num').val();
                return WorktableCommon.runPreview(te_num);
              case "delete":
                if(window.confirm(I18n.t('message.dialog.delete_event'))) {
                  return _deleteTimeline.call(this, target);
                }
                break;
              default:
                return;
            }
          }
        }
      );
    };

    // イベント作成
    var _createEvent = (pageValue, idx) => {
      let timelineEvents = $('#timeline_events').children('.timeline_event');
      teNum = idx + 1;
      let emt = timelineEvents.eq(idx);
      if(emt.length === 0) {
        // 無い場合は新規作成
        this.createTimelineEvent(teNum);
        timelineEvents = $('#timeline_events').children('.timeline_event');
        emt = timelineEvents.eq(idx);
      }
      $('.te_num', emt).val(teNum);
      $('.dist_id', emt).val(pageValue[EventPageValueBase.PageValueKey.DIST_ID]);
      const actionType = pageValue[EventPageValueBase.PageValueKey.ACTIONTYPE];
      this.changeTimelineColor(teNum, actionType);
      // 同期線
      if(pageValue[EventPageValueBase.PageValueKey.IS_SYNC]) {
        // 線表示
        return emt.before(`<div class='sync_line ${Common.getActionTypeClassNameByActionType(actionType)}'></div>`);
      } else {
        // 線消去
        return emt.prev('.sync_line').remove();
      }
    };

    // クリックイベント内容
    // @param [Object] e イベントオブジェクト
    var _clickTimelineEvent = (e) => {
      if($(e).is('.ui-sortable-helper')) {
        // ドラッグの場合はクリック反応なし
        return;
      }
      WorktableCommon.clearSelectedBorder();
      // コンフィグを開く
      _initEventConfig.call(this, e);
      // 選択枠
      return WorktableCommon.setSelectedBorder($(e), 'timeline');
    };

    // タイムライン削除
    var _deleteTimeline = (target) => {
      const eNum = parseInt($(target).find('.te_num:first').val());
      // EventPageValueを削除
      PageValue.removeEventPageValue(eNum);
      // キャッシュ更新
      window.lStorage.saveAllPageValues();
      // タイムライン表示更新
      this.refreshAllTimeline();
    };

    // コンフィグメニュー初期化&表示
    // @param [Object] e 対象オブジェクト
    var _initEventConfig = (e) => {
      // サイドメニューをタイムラインに切り替え
      Sidebar.switchSidebarConfig(Sidebar.Type.EVENT);
      teNum = $(e).find('input.te_num').val();
      const distId = $(e).find('input.dist_id').val();
      Sidebar.initEventConfig(distId, teNum);
      // イベントメニューの表示
      $('#event-config .event').hide();
      const eId = EventConfig.ITEM_ROOT_ID.replace('@distId', distId);
      $(`#${eId}`).show();
      // サイドバー表示
      Sidebar.openConfigSidebar();
    };

    _setupTimelineEvent.call(this);
  }

  // タイムラインイベントの色を変更
  // @param [Integer] teNum イベント番号
  // @param [Integer] actionType アクションタイプ
  changeTimelineColor(teNum, actionType = null) {
    // イベントの色を変更
    let teEmt = null;
    $('#timeline_events').children('.timeline_event').each(function(e) {
      if(parseInt($(this).find('input.te_num:first').val()) === parseInt(teNum)) {
        return teEmt = this;
      }
    });

    for(let k in constant.TimelineActionTypeClassName) {
      const v = constant.TimelineActionTypeClassName[k];
      $(teEmt).removeClass(v);
    }

    if(actionType !== null) {
      return $(teEmt).addClass(Common.getActionTypeClassNameByActionType(actionType));
    } else {
      return $(teEmt).addClass(constant.TimelineActionTypeClassName.BLANK);
    }
  }

  // EventPageValueを参照してタイムラインを更新
  refreshAllTimeline() {
    Indicator.showIndicator(Indicator.Type.TIMELINE);

    // 非同期で実行
    setTimeout(() => {
        // 全消去
        const pEmt = $('#timeline_events');
        pEmt.children().each(function(e) {
          const emt = $(this);
          if(emt.hasClass('timeline_event_temp') === false) {
            return emt.remove();
          }
        });
        this.setupTimelineEventConfig();
        // ビューの幅更新
        this.updateTimelineContainerWidth();
        return Indicator.hideIndicator(Indicator.Type.TIMELINE);
      }
      , 0);
  }

  // イベントを追加or更新
  updateEvent(teNum) {
    this.setupTimelineEventConfig(teNum);
  }

  // タイムラインソートイベント
  changeSortTimeline(beforeNum, afterNum) {
    if(beforeNum !== afterNum) {
      // PageValueのタイムライン番号を入れ替え
      PageValue.sortEventPageValue(beforeNum, afterNum);
    }
    // タイムライン再作成
    this.refreshAllTimeline();
  }

  // 操作不可にする
  disabledOperation(flg) {
    if(flg) {
      if($('#timeline_container .cover_touch_overlay').length === 0) {
        $('#timeline_container').append("<div class='cover_touch_overlay'></div>");
        return $('.cover_touch_overlay').off('click').on('click', function(e) {
          e.preventDefault();
        });
      }
    } else {
      return $('#timeline_container .cover_touch_overlay').remove();
    }
  }

  updateTimelineContainerWidth() {
    const paddingLeft = 10;
    const eachTimeEventWidth = 30 + 10;
    const timelineEvents = $('#timeline_events');
    const num = timelineEvents.children('.timeline_event').length;
    const width = paddingLeft + (eachTimeEventWidth * num);
    return timelineEvents.css('width', width + 'px');
  }

  addTimelineContainerWidth() {
    const eachTimeEventWidth = 30 + 10;
    const timelineEvents = $('#timeline_events');
    const width = parseInt(timelineEvents.css('width')) + eachTimeEventWidth;
    return timelineEvents.css('width', width + 'px');
  }

  render() {
    return (
      <TimelineList items={this.props.timeline_items} />
    )
  }
}
