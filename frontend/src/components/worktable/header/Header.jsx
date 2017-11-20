import React, {Component} from 'react';
import {StyleSheet, css} from 'aphrodite';
import Actions from './Actions';
import File from './File';
import LastUpdate from './LastUpdate';
import MotionCheck from './MotionCheck';
import Option from './Option';
import Others from './Others';
import Page from './Page';
import User from './User';

export default class Header extends Component {
  render() {
    return (
      <div className="navbar navbar-default navbar-fixed-top" role="navigation">
        <div className="container">
          <div className="navbar-header">
            <a className="navbar-brand nav_title">
              {this.props.projectTitle}
            </a>
          </div>
          <div className="collapse navbar-collapse">
            <ul className="nav navbar-nav">
              <File/>
              <Actions/>
              <Others/>
            </ul>
            <ul className="nav navbar-nav navbar-right">
              <LastUpdate/>
              <Page/>
              <MotionCheck/>
              <Option/>
              <User/>
            </ul>
          </div>
        </div>
      </div>
    )
  }
}