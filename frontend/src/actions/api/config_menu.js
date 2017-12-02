import fetch from 'cross-fetch'

export const getDesignConfig = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/config_menu/design_config`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in getDesignConfig.', error)
  ).then(json => dispatch({type: 'GET_DESIGN_CONFIG', json}));

export const getMethodValuesConfig = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/config_menu/method_values_config`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in getMethodValuesConfig.', error)
  ).then(json => dispatch({type: 'GET_DESIGN_CONFIG', json}));

export const getPreloadImagePathSelectConfig = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/config_menu/preload_image_path_select_config`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in getPreloadImagePathSelectConfig.', error)
  ).then(json => dispatch({type: 'GET_PRELOAD_IMAGE_PATH_SELECT_CONFIG', json}));
