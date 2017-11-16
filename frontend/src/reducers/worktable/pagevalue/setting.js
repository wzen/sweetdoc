const settingPagevalue = (state, action) => {
  switch(action.type) {
    case 'UPDATE_GRID_ENABLE':
      state['grid_enable'] = action.gridEnable;
      break;
    case 'UPDATE_GRID_STEP':
      state['grid_step'] = action.gridStep;
      break;
    default:
      break;
  }
  return state;
};

export default settingPagevalue;