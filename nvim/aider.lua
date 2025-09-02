return {
  -- The plugin repository on GitHub
  "joshuavial/aider.nvim",
  -- Configure dependencies or lazy-loading
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- Define key mappings
  keys = {
    { "<leader>ai", "<cmd>AiderOpen<cr>", desc = "Open Aider" },
    { "<leader>aa", "<cmd>AiderAddModifiedFiles<cr>", desc = "Aider: Add Modified Files" },
  },
  -- Plugin configuration options
  opts = {
    -- Automatically adds and removes buffers from the Aider context
    auto_manage_context = true,
  },
  -- Configure the plugin to be loaded only when its command is called
  cmd = "AiderOpen",

  lazy = false,
  config = function()
    require("aider").setup({
      default_model = "openrouter/meta-llama/llama-3-8b-instruct",
    })
  end,
}
