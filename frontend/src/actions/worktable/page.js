export const addWorktablePage = () => {
  return {
    type: 'ADD_WORKTABLE_PAGE'
  }
};

export const addWorktablePageFork = (pageNum) => {
  return {
    type: 'ADD_WORKTABLE_PAGE_FORK',
    pageNum
  }
};

export const changeWorktablePage = (pageNum, forkNum) => {
  return {
    type: 'CHANGE_WORKTABLE_PAGE',
    page_num: pageNum,
    forkNum
  }
};

export const removeWorktablePage = (pageNum) => {
  return {
    type: 'REMOVE_WORKTABLE_PAGE',
    pageNum
  }
};

export const removeWorktablePageFork = (pageNum, forkNum) => {
  return {
    type: 'REMOVE_WORKTABLE_PAGE_FORK',
    pageNum,
    forkNum
  }
};