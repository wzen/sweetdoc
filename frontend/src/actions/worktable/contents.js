export const createItem = (itemType) => {
  return {
    type: 'CREATE_ITEM',
    mode
  }
};

export const switchMode = (mode) => {
  return {
    type: 'SWITCH_MODE',
    mode
  }
};

export const selectItem = (item_id) => {
  return {
    type: 'SELECT_ITEM',
    item_id
  }
};

export const editItem = (item_id) => {
  return {
    type: 'EDIT_ITEM',
    item_id
  }
};

export const copyItem = (item_id) => {
  return {
    type: 'COPY_ITEM',
    item_id
  }
};

export const cutItem = (item_id) => {
  return {
    type: 'CUT_ITEM',
    item_id
  }
};

export const floatItem = (item_id) => {
  return {
    type: 'FLOAT_ITEM',
    item_id
  }
};

export const sinkItem = (item_id) => {
  return {
    type: 'SINK_ITEM',
    item_id
  }
};

export const removeItem = (item_id) => {
  return {
    type: 'REMOVE_ITEM',
    item_id
  }
};

export const changeItemPosition = (item_id, x, y) => {
  return {
    type: 'CHANGE_POSITION',
    item_id,
    x,
    y
  }
};

export const changeItemSize = (item_id, width, height) => {
  return {
    type: 'CHANGE_POSITION',
    item_id,
    width,
    height
  }
};