import React, { Component } from 'react';
import { render } from 'react-dom'
import { createStore } from 'redux';
import { Provider } from 'react-redux'
import worktableReducers from '../../reducers/worktable/index';
import Header from '../../containers/worktable/Header';
import Screen from '../../containers/worktable/Screen';
import Config from '../../containers/worktable/Config';
import Timeline from '../../containers/worktable/Timeline';
import '../../css/common.css';

let store = createStore(worktableReducers);

class WorktableCmp extends Component {
  render() {
    return (
      <div>
        <Header/>
        <Screen/>
        <Config/>
        <Timeline/>
      </div>
    )
  }
}

render(
  <Provider store={store}>
    <WorktableCmp/>
  </Provider>,
  document.getElementById('root')
);
