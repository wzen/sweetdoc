export const visualizeItem = (itemId) => {
  return {
    type: 'VISUALIZE_ITEM',
    itemId
  }
};

export const invisualizeItem = (itemId) => {
  return {
    type: 'INVISUALIZE_ITEM',
    itemId
  }
};

export const focusInItem = (itemId) => {
  return {
    type: 'FOCUS_IN',
    itemId
  }
};

export const focusOutItem = (itemId) => {
  return {
    type: 'FOCUS_OUT',
    itemId
  }
};