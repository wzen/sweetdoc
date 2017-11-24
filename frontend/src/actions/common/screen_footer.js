export const showScreenFooter = (screenFooterType, message = null) => {
  return {
    type: 'SHOW_SCREEN_FOOTER',
    screenFooterType,
    message
  }
};

export const hideScreenFooter = () => {
  return {
    type: 'HIDE_SCREEN_FOOTER'
  }
};