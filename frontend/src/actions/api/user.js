import fetch from 'cross-fetch'

export const signIn = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/user/sign_in`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in signIn.', error)
  ).then(json => dispatch({type: 'LOGIN', json}));

// 使わないかも
export const signOut = () => (dispatch) =>
  fetch(`${window.apiUrl}/user/sign_out`, {method: 'DELETE'}).then(
    response => response.json(),
    error => console.log('An error occurred in signOut.', error)
  ).then(json => dispatch({type: 'LOGOUT', json}));

export const getProfile = () => (dispatch) =>
  fetch(`${window.apiUrl}/user/edit`).then(
    response => response.json(),
    error => console.log('An error occurred in updatePassword.', error)
  ).then(json => dispatch({type: 'GET_USER_PROFILE', json}));

export const updatePassword = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/user/password`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in updatePassword.', error)
  ).then(json => dispatch({type: 'UPDATE_USER_PASSWORD', json}));

export const signUp = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/user/sign_up`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in createUser.', error)
  ).then(json => dispatch({type: 'CREATE_USER', json}));

export const updateProfile = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/user`, {method: 'PATCH', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in updateProfile.', error)
  ).then(json => dispatch({type: 'UPDATE_USER', json}));

export const getConfirmation = () => (dispatch) =>
  fetch(`${window.apiUrl}/user/confirmation`).then(
    response => response.json(),
    error => console.log('An error occurred in getConfirmation.', error)
  ).then(json => dispatch({type: 'CONFIRMATION_USER', json}));

export const updateConfirmation = (data) => (dispatch) =>
  fetch(`${window.apiUrl}/user/confirmation`, {method: 'POST', body: data}).then(
    response => response.json(),
    error => console.log('An error occurred in updateConfirmation.', error)
  ).then(json => dispatch({type: 'UPDATE_CONFIRMATION_USER', json}));
