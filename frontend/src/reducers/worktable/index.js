import { combineReducers } from 'redux';
import header from './header';
import contents from './contents';
import config from './config';
import timeline from './timeline';
import generalPagevalue from './pagevalue/general';
import instancePagevalue from './pagevalue/instance';
import eventPagevalue from './pagevalue/event';
import settingPagevalue from './pagevalue/setting';
import footprintPagevalue from './pagevalue/footprint';

const worktableReducers = combineReducers({
  header,
  contents,
  config,
  timeline,
  generalPagevalue,
  instancePagevalue,
  eventPagevalue,
  settingPagevalue,
  footprintPagevalue
});

export default worktableReducers;
