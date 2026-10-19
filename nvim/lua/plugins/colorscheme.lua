-- Dracula Pro (licensed) is vendored into nvim/vendor/ by install.sh and
-- gitignored. On machines without it, the OSS dracula.nvim is used instead.
--
-- Variants: dracula-pro (default), dracula-pro-alucard (light), dracula-pro-blade,
-- dracula-pro-buffy, dracula-pro-lincoln, dracula-pro-morbius, dracula-pro-van-helsing.
-- Switch live with <leader>fc or :colorscheme dracula-pro-<variant>.
local pro_dir = vim.fn.stdpath("config") .. "/vendor/dracula-pro"
local has_pro = vim.uv.fs_stat(pro_dir) ~= nil

return {
  {
    dir = pro_dir,
    name = "dracula-pro",
    enabled = has_pro,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("dracula-pro")
    end,
  },
  {
    "Mofiqul/dracula.nvim",
    enabled = not has_pro,
    lazy = false,
    priority = 1000,
    opts = { italic_comment = true },
    config = function(_, opts)
      require("dracula").setup(opts)
      vim.cmd.colorscheme("dracula")
    end,
  },
}
