import React, { Component } from 'react';
import { render } from 'react-dom'
import { createStore } from 'redux';
import worktableReducers from '../../reducers/worktable/index';
import Timeline from '../../containers/worktable/Timeline';

let store = createStore(worktableReducers);

class Worktable extends Component {
  render() {
    return (
      <div>
        <Timeline/>
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
