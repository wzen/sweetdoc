import React from 'react';
import BaseComponent from '../../common/BaseComponent';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

export default translate()(class MotionCheck extends BaseComponent {
  render() {
    const {t} = this.props;
    return (
      <li id="header_items_motion_check">
        <a onClick={e => {e.preventDefault(); MotionCheckCommon.run()}}>{MotionCheck.imageTag({src: "nav/motion_check.png", size:'36x36'})}</a>
      </li>
    )
  }
})
