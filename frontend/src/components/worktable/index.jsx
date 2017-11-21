import BaseComponent from '../common/BaseComponent';
import { render } from 'react-dom'
import { createStore } from 'redux';
import { Provider } from 'react-redux'
import { I18nextProvider } from 'react-i18next';
import i18n from '../../../i18n/i18n';
import worktableReducers from '../../reducers/worktable/index';
import Header from '../../containers/worktable/Header';
import Screen from '../../containers/worktable/Screen';
import Config from '../../containers/worktable/Config';
import Timeline from '../../containers/worktable/Timeline';
import '../../css/common.css';

let store = createStore(worktableReducers);

class Worktable extends BaseComponent {
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
    <I18nextProvider i18n={ i18n }>
      <Worktable/>
    </I18nextProvider>
  </Provider>,
  document.getElementById('root')
);
