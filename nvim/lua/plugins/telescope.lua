return {
  {
    "nvim-telescope/telescope.nvim",
    -- master, not 0.1.x: the pinned branch calls nvim-treesitter APIs
    -- that were removed on its main branch (ft_to_lang), breaking previews
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      -- <C-p> keeps the cmd+p quick-open habit from Cursor
      { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Grep word under cursor" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>fR", "<cmd>Telescope resume<CR>", desc = "Resume last picker" },
      { "<leader>fc", "<cmd>Telescope colorscheme enable_preview=true<CR>", desc = "Pick colorscheme (live preview)" },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules/", "%.git/", "_build/", "deps/", "dist/" },
      },
      pickers = {
        find_files = { hidden = true },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
  },
}
