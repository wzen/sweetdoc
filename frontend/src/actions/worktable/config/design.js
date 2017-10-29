export const changeItemDesignVarValue = (itemId, changeType, varName, value) => {
  return {
    type: 'CHANGE_DESIGN_VAR_VALUE',
    changeType,
    varName,
    value,
  }
};

export const changeItemDesignByTool = (itemId, designState) => {
  return {
    type: 'CHANGE_DESIGN_BY_TOOL',
    itemId,
    designState
  }
};