import React, { Component } from 'react';
import { render } from 'react-dom'
import { createStore } from 'redux';
import worktableReducers from '../../reducers/worktable/index';
import TimelineContainer from './timeline/timeline_container';

let store = createStore(worktableReducers);

class Worktable extends Component {
  render() {
    return (
      <div>
        <TimelineContainer/>
      </div>
    )
  }
}

render(
  <Provider store={store}>
    <Worktable/>
  </Provider>,
  document.getElementById('root')
);
