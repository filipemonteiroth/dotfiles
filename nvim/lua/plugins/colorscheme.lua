-- Dracula Pro (licensed) is vendored into nvim/vendor/ by install.sh and
-- gitignored. On machines without it, the OSS dracula.nvim is used instead.
--
-- Variants: dracula_pro (default), dracula_pro_alucard (light), dracula_pro_blade,
-- dracula_pro_buffy, dracula_pro_lincoln, dracula_pro_morbius, dracula_pro_van_helsing.
-- Switch live with <leader>fc or :colorscheme dracula_pro_<variant>.
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
      vim.cmd.colorscheme("dracula_pro")
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
