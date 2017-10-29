export const addWorktablePage = () => {
  return {
    type: 'ADD_WORKTABLE_PAGE'
  }
};

export const changeWorktablePage = (page_num) => {
  return {
    type: 'CHANGE_WORKTABLE_PAGE',
    page_num
  }
};

export const changeWorktablePageFork = (page_num, fork_num) => {
  return {
    type: 'CHANGE_WORKTABLE_PAGE_FORK',
    page_num,
    fork_num
  }
};

export const removeWorktablePage = (page_num) => {
  return {
    type: 'REMOVE_WORKTABLE_PAGE',
    page_num
  }
};

export const removeWorktablePageFork = (page_num, fork_num) => {
  return {
    type: 'REMOVE_WORKTABLE_PAGE_FORK',
    page_num,
    fork_num
  }
};