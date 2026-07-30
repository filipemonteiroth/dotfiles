local parsers = {
  -- elixir
  "elixir", "heex", "eex", "erlang",
  -- typescript
  "typescript", "tsx", "javascript", "jsdoc",
  -- web
  "html", "css", "graphql", "json",
  -- misc
  "lua", "vim", "vimdoc", "bash", "yaml", "toml",
  "markdown", "markdown_inline", "sql", "terraform",
  "git_config", "git_rebase", "gitcommit", "gitignore", "diff",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      -- the jsonc grammar's tarball host is broken; the json parser handles jsonc fine
      vim.treesitter.language.register("json", "jsonc")

      require("nvim-treesitter").install(parsers)

      -- main branch no longer auto-starts highlighting; do it per buffer
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
          if pcall(vim.treesitter.start, ev.buf, lang) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
