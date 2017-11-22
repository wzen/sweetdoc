import { combineReducers } from 'redux';
import modal from './common/modal';
import header from './header';
import contents from './contents';
import config from './config';
import generalPagevalue from './pagevalue/general';
import instanceAndEventPagevalue from './pagevalue/instance_and_event';
import settingPagevalue from './pagevalue/setting';
import footprintPagevalue from './pagevalue/footprint';

const worktableReducers = combineReducers({
  modal,
  header,
  contents,
  config,
  generalPagevalue,
  instanceAndEventPagevalue,
  settingPagevalue,
  footprintPagevalue
});

export default worktableReducers;
