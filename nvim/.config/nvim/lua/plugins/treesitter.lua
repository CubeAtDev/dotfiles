return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    -- configuration de treesitter
    treesitter.setup({
      -- activation de la coloration syntaxique
      highlight = {
        enable = true,
      },
      -- activation de l'indentation améliorée
      indent = { enable = true },

      -- langages installés et configurés
      ensure_installed = {
        "bash",
        "csv",
        "diff",
        "dockerfile",
        "gitignore",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "nginx",
        "pem",
        "php",
        "phpdoc",
        "po",
        "pod",
        "powershell",
        "python",
        "regex",
        "rst",
        "rust",
        "sql",
        "ssh_config",
        "toml",
        "tsx",
        "twig",
        "typescript",
        "vim",
        "vue",
        "xml",
        "yaml",
      },
      -- lorse de l'appui sur <Ctrl-space> sélectionne le bloc
      -- courant spécifique au langage de programmation
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}

