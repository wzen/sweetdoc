import { combineReducers } from 'redux';
import user from '../common/user';
import modal from '../common/modal';
import indicator from '../common/indicator';
import screenFooter from '../common/screen_footer';
import temp from '../common/temp';
import config from './config';
import general from './general';
import instanceAndEvent from './instance_and_event';
import setting from './setting';
import footprint from './footprint';

const worktableReducers = combineReducers({
  user,
  modal,
  indicator,
  screenFooter,
  temp,
  config,
  general,
  instanceAndEvent,
  setting,
  footprint
});

export default worktableReducers;
