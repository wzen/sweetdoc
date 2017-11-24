import React from 'react';
import BaseComponent from './BaseComponent';
import {StyleSheet, css} from 'aphrodite';

export default class Overlay extends BaseComponent {
  render() {
    if(this.props.show) {
      return null;
    } else {
      return <div className={css(styles.overlay)} onClick={e => {e.preventDefault(); this.props.hideModal()}} />
    }
  }
}

const styles = StyleSheet.create({
  overlay: {
    position: 'fixed',
    top: '0',
    left: '0',
    width: '100%',
    height: '100%',
    zIndex: '1999999998',
    backgroundColor: 'transparent',
    opacity: '0.3'
  }
});