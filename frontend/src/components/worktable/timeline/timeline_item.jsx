import React, { Component } from 'react';
// import PropTypes from 'prop-types';

export default class TimelineItemCmp extends Component {
  render() {
    return (
      <div className={`timeline_event ${this.props.value.type}`} />
    )
  }
}
