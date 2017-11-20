import React, {Component} from 'react';
import {StyleSheet, css} from 'aphrodite';
import { translate } from 'react-i18next';

class MotionCheck extends Component {
  render() {
    const {t} = this.props;
    return (
      <li id="header_items_motion_check">
        <a onClick={MotionCheckCommon.run()}>{image_tag("nav/motion_check.png", size:'36x36')}</a>
      </li>
    )
  }
}

export default translate()(MotionCheck);