return {
  "nvim-orgmode/orgmode",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
  config = function()
    -- Treesitter parser setup (must be before .setup())
    require("nvim-treesitter.parsers").get_parser_configs().org = {
      install_info = {
        url = "https://github.com/nvim-orgmode/orgmode",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "org",
    }

    require("orgmode").setup({
      org_agenda_files = { "~/org/*", "~/org/**/*" },
      org_default_notes_file = "~/org/refile.org",
    })
  end,
  keys = {
    { "<leader>oa", "<cmd>OrgAgenda<cr>", desc = "Org Agenda", mode = "n" },
    { "<leader>oc", "<cmd>OrgCapture<cr>", desc = "Org Capture", mode = "n" },
  },
}
