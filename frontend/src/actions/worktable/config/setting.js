export const changeWorktablePosition = (x, y) => {
  return {
    type: 'CHANGE_WORKTABLE_POSITION',
    x,
    y
  }
};
export const changeWorktableScale = (scale) => {
  return {
    type: 'CHANGE_WORKTABLE_SCALE',
    scale
  }
};

export const showWorktableGrid = (enable) => {
  return {
    type: 'SHOW_WORKTABLE_GRID',
    enable
  }
};

export const enableAutosave = (enable) => {
  return {
    type: 'ENABLE_AUTOSAVE',
    enable
  }
};
