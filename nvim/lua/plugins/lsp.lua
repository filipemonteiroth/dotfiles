return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          local tb = require("telescope.builtin")
          map("gd", tb.lsp_definitions, "Goto definition")
          map("gr", tb.lsp_references, "References")
          map("gI", tb.lsp_implementations, "Goto implementation")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("<leader>D", tb.lsp_type_definitions, "Type definition")
          map("<leader>ds", tb.lsp_document_symbols, "Document symbols")
          map("<leader>ws", tb.lsp_dynamic_workspace_symbols, "Workspace symbols")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          -- K (hover) is a native default, matching the shift+k habit from Cursor
        end,
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- server settings (0.11+ style; merged with nvim-lspconfig defaults)
      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("elixirls", {
        settings = {
          elixirLS = {
            dialyzerEnabled = true,
            dialyzerFormat = "dialyxir_short", -- matches Cursor setting
            suggestSpecs = true,
          },
        },
      })

      vim.lsp.config("vtsls", {
        settings = {
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            preferences = { importModuleSpecifier = "non-relative" },
          },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            format = { printWidth = 10000, proseWrap = "preserve", singleQuote = false },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "elixirls",
          "vtsls",
          "eslint",
          "tailwindcss",
          "graphql",
          "jsonls",
          "yamlls",
          "lua_ls",
        },
        automatic_enable = true,
      })
    end,
  },

  -- readable TypeScript errors (replaces pretty-ts-errors from Cursor)
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact" },
    opts = {},
  },
}
