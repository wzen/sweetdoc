import BaseComponent from '../../common/BaseComponent';
import Common from '../../../base/common';
import PageValue from '../../../base/page_value';
import Sidebar from '../../sidebar_config/sidebar_ui';
import WorktableCommon from '../common/worktable_common';
import Indicator from '../../../base/indicator';
import {SortableContainer, SortableElement, arrayMove} from 'react-sortable-hoc';
import TimelineItem from './TimelineItem';
import {StyleSheet, css} from 'aphrodite';

const SortableItem = SortableElement(({value}) =>
  <TimelineItem {...value} />
);

const TimelineList = SortableContainer(({items}) => {
  let list = [];
  items.forEach((value, index) => {
    if(i.isSync) { list.push(<div className={css(styles.syncLine, styles[this.props.actionType])} />) }
    list.push(<SortableItem key={`item-${index}`} index={index} value={value} />)
  });
  list.push(<TimelineItem value={{actionType: 'blank'}}/>);
  return (
    <div id="timeline_container" className={css(styles.timelineContainer, 'border')}>
      <div id="timeline_events_container" className={css(styles.timelineEventsContainer, 'scroll_x_content')}>
        <div id="timeline_events" className={css(styles.timelineEvents)}>
          {list}
        </div>
      </div>
    </div>
  );
});

export default class Timeline extends BaseComponent {


  // タイムラインのイベント設定
  setupTimelineEventConfig(teNum = null) {


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
      <TimelineList items={this.props.items} />
    )
  }
}

const styles = StyleSheet.create({
  // これは後で移動
  timeline: {
    height: '70px'
  },

  timelineContainer: {
    backgroundColor: '#fcf6ff'
  },
  timelineEventsContainer: {
    margin: '5px 0',
    padding: '0 3px',
    height: '40px'
  },
  timelineEvents: {
    paddingLeft: '10px',
    height: '100%'
  },
  syncLine: {
    position: 'relative',
    width: '10px',
    height: '20px',
    marginTop: '10px',
    marginLeft: '-10px',
    float: 'left'
  },
  click: {
    backgroundColor: '#7d0000'
  },
  scroll: {
    backgroundColor: '#00007d'
  }
});