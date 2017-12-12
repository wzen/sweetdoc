const loadState = (action) => {
  return action.json.settingPagevalueData;
};

const setting = (state = {}, action) => {
  switch(action.type) {
    case 'LOAD_STATE':
      return loadState(action);
    case 'UPDATE_GRID_ENABLE':
      state['gridEnable'] = action.gridEnable;
      break;
    case 'UPDATE_GRID_STEP':
      state['gridStep'] = action.gridStep;
      break;
    case 'AUTOSAVE_ENABLE':
      state['autosaveEnable'] = action.autosaveEnable;
      break;
    case 'AUTOSAVE_TIME':
      state['autosaveTime'] = action.autosaveTime;
      break;
    default:
      break;
  }
  return state;
};

export default setting;