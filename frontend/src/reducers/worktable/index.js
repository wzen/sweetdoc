import { combineReducers } from 'redux';
import header from './header';
import contents from './contents';
import config from './config';
import timeline from './timeline';
import generalPagevalue from './pagevalue/general';
import instanceAndEventPagevalue from './pagevalue/instance_and_event';
import settingPagevalue from './pagevalue/setting';
import footprintPagevalue from './pagevalue/footprint';

const worktableReducers = combineReducers({
  header,
  contents,
  config,
  timeline,
  generalPagevalue,
  instanceAndEventPagevalue,
  settingPagevalue,
  footprintPagevalue
});

export default worktableReducers;
