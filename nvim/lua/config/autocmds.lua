-- highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- reload files changed outside of nvim (e.g. by Claude Code or git)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("auto-read", { clear = true }),
  command = "checktime",
})

-- .heex / .eex templates
vim.filetype.add({
  extension = {
    heex = "heex",
    eex = "eex",
  },
})
