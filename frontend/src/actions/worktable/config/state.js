export const changeBackgroundColor = (itemId, color) => {
  return {
    type: 'CHANGE_BACKGROUND_COLOR',
    item_id,
    color
  }
};

export const changeModeSelectFirstFocus = (itemId) => {
  return {
    type: 'CHANGE_MODE_SELECT_FIRST_FOCUS',
    itemId
  }
};

export const selectFirstFocus = (itemId, itemRect) => {
  return {
    type: 'SELECT_FIRST_FOCUS',
    itemId,
    itemRect
  }
};

export const applySelectedFirstFocus = (itemId, itemRect) => {
  return {
    type: 'APPLY_SELECTED_FIRST_FOCUS',
    itemId,
    itemRect
  }
};

export const cancelSelectedFirstFocus = (itemId) => {
  return {
    type: 'CANCEL_SELECTED_FIRST_FOCUS',
    itemId
  }
};

export const removeFirstFocus = (itemId) => {
  return {
    type: 'REMOVE_FIRST_FOCUS',
    itemId
  }
};
