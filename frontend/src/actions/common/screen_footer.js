export const showScreenFooter = (screenFooterType, applyType, message = null) => {
  return {
    type: 'SHOW_SCREEN_FOOTER',
    screenFooterType,
    applyType,
    message
  }
};

export const setScreenFooterParams = (params) => {
  return {
    type: 'SET_SCREEN_FOOTER_PARAMS',
    params: params
  }
};

export const hideScreenFooter = () => {
  return {
    type: 'HIDE_SCREEN_FOOTER'
  }
};

export const applyScreenFooter = (applyType, params) => {
  return {
    type: 'APPLY_SCREEN_FOOTER',
    applyType: applyType,
    params: params
  }
};