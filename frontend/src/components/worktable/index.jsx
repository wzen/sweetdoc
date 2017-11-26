import React from 'react';
import BaseComponent from '../common/BaseComponent';
import { createStore } from 'redux';
import { Provider } from 'react-redux'
import { I18nextProvider } from 'react-i18next';
import i18n from '../../../i18n/i18n';
import worktableReducers from '../../reducers/worktable/index';
import Header from '../../containers/worktable/Header';
import Screen from '../../containers/worktable/Screen';
import Config from '../../containers/worktable/Config';
import '../../css/common.css';

let store = createStore(worktableReducers);

export default class Worktable extends BaseComponent {
  render() {
    return (
      <Provider store={store}>
        <I18nextProvider i18n={ i18n }>
          <div>
            <Header/>
            <Screen/>
            <Config/>
          </div>
        </I18nextProvider>
      </Provider>
    )
  }
}
