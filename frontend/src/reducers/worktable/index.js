import { combineReducers } from 'redux';
import header from './header';
import contents from './contents';
import config from './config';
import timeline from './timeline';

const worktableReducers = combineReducers({
  header,
  contents,
  config,
  timeline
});

export default worktableReducers;
