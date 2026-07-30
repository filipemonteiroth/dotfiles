return {
  -- Cursor-style tabs: one per open buffer, clickable, with close buttons
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer tab" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer tab" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<CR>", desc = "Pin buffer tab" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", desc = "Close other buffer tabs" },
      { "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Buffer tab 1" },
      { "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Buffer tab 2" },
      { "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Buffer tab 3" },
      { "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Buffer tab 4" },
      { "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Buffer tab 5" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp", -- error/warning icons on tabs, like Cursor
        show_buffer_close_icons = true,
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        separator_style = "thin",
        always_show_bufferline = false, -- hide when only one file is open
        offsets = {
          { filetype = "neo-tree", text = "Files", text_align = "center", separator = true },
        },
      },
    },
  },
}
