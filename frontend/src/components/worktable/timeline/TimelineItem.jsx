import React, {Component} from 'react';
import {StyleSheet, css} from 'aphrodite';
import { selectTimeline, removeTimeline } from "../../../actions/worktable/timeline";
import { runEventPreview } from "../../../actions/worktable/config/event";
import PropTypes from 'prop-types';
import { ContextMenu, MenuItem, ContextMenuTrigger } from "react-contextmenu";

export default class TimelineItem extends Component {
  render() {
    if(this.props.actionType === 'blank') {
      return (
        <div className={css(styles.item, styles.blank)}
             onClick={this.props.dispatch(selectTimeline())}/>
      )
    } else {
      let sync = this.props.isSync ? 'sync' : '';
      return (
        <div>
          <ContextMenuTrigger id={`context-${this.props.distId}`}>
            <div className={css(styles.item, styles[this.props.actionType], styles[sync])}
                 onClick={() => this.props.dispatch(selectTimeline(this.props.distId))}/>
          </ContextMenuTrigger>
          <ContextMenu id={`context-${this.props.distId}`}>
            <MenuItem data={"preview"} onClick={() => this.props.dispatch(runEventPreview({distId: this.props.distId}))}>
              Preview Action
            </MenuItem>
            <MenuItem data={"remove"} onClick={() => this.props.dispatch(removeTimeline(this.props.distId))}>
              Remove
            </MenuItem>
          </ContextMenu>
        </div>
      )
    }
  }
}

TimelineItem.PropTypes = {
  distId: PropTypes.string,
  actionType: PropTypes.string.isRequired,
  isSync: PropTypes.string
};

const styles = StyleSheet.create({
  item: {
    cursor: 'pointer',
    position: 'relative',
    width: '30px',
    marginRight: '10px',
    height: '40px',
    boxSizing: 'border-box',
    fontSize: '12px',
    color: '#ffffff',
    borderRadius: '4px',
    textDecoration: 'none',
    boxShadow: 'inset 0 0 13px rgba(18, 18, 18, 0.7)',
    textShadow: '0px -1px 2px rgba(000, 000, 000, 0.9), 0 1px 2px rgba(000, 000, 000, 0.8)',
    float: 'left'
  },
  sync: {
    marginRight: 0
  },
  blank: {
    border: '1px solid #000000',
    backgroundColor: '#000000'
  },
  click: {
    border: '1px solid #7d0000',
    backgroundImage: 'linear-gradient(top, #bb0000 0%, #a80000 39%, #870000)'
  },
  scroll: {
    border: '1px solid #00007d',
    backgroundImage: 'linear-gradient(top, #0000bb 0%, #0000a8 39%, #000087)'
  }
});

export default connect()(TimelineItem);