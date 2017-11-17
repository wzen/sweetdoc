import React, {Component} from 'react';
import {StyleSheet, css} from 'aphrodite';

export default class TimelineItemCmp extends Component {
  render() {
    return (
      <div className={css(styles.timelineItem, styles[this.props.actionType])}/>
    )
  }
}

const styles = StyleSheet.create({
  timelineItem: {
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
    float: 'left',

    '&.sync': {
      marginRight: 0
    },
    '&.blank': {
      border: '1px solid #000000',
      backgroundColor: '#000000'
    },
    '&.click': {
      border: '1px solid #7d0000',
      backgroundImage: 'linear-gradient(top, #bb0000 0%, #a80000 39%, #870000)'
    },
    '&.scroll': {
      border: '1px solid #00007d',
      backgroundImage: 'linear-gradient(top, #0000bb 0%, #0000a8 39%, #000087)'
    }
  }
});