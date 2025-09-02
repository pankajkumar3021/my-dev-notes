return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  ft = { "org" },
  config = function()
    -- Setup orgmode
    require("orgmode").setup({
      org_agenda_files = "~/orgfiles/**/*",
      org_default_notes_file = "~/orgfiles/refile.org",
      org_todo_keywords = { "TODO", "WAITING", "|", "DONE", "DELEGATED" },
      org_hide_leading_stars = true,
      org_startup_indented = true,
      org_adapt_indentation = true,
      org_startup_folded = "inherit",
      org_capture_templates = {
        t = {
          description = "Task",
          template = "* TODO %?\n  SCHEDULED: %t",
          target = "~/orgfiles/inbox.org",
        },
        n = {
          description = "Note",
          template = "* %? :NOTE:\n  %U",
          target = "~/orgfiles/notes.org",
        },
      },
      -- Re-enable the orgmode tab mappings and let our smart functions handle them
      mappings = {
        disable_all = false,
        org = {
          org_cycle = "<Tab>", -- Re-enable for orgmode to handle
          org_global_cycle = "<S-Tab>", -- Re-enable for orgmode to handle
        },
      },
    })

    -- Smart tab functions for context-aware behavior
    local function smart_tab()
      if vim.bo.filetype == "org" then
        -- In org files, use orgmode's cycle
        require("orgmode").action("org_mappings.org_cycle")
      else
        -- In other files, use default tab behavior
        -- This preserves completion, snippets, etc.
        local keys = vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
        vim.api.nvim_feedkeys(keys, "n", false)
      end
    end

    local function smart_shift_tab()
      if vim.bo.filetype == "org" then
        -- In org files, use orgmode's global cycle
        require("orgmode").action("org_mappings.org_global_cycle")
      else
        -- In other files, use shift-tab (often unindent or reverse completion)
        local keys = vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true)
        vim.api.nvim_feedkeys(keys, "n", false)
      end
    end

    -- Insert mode smart tab for org files
    local function smart_tab_insert()
      if vim.bo.filetype == "org" then
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]

        -- If at beginning of line or only whitespace, indent
        if col == 0 or line:sub(1, col):match("^%s*$") then
          return "<C-t>"
        else
          -- Otherwise, regular tab
          return "<Tab>"
        end
      else
        -- Not in org file, use default behavior
        return "<Tab>"
      end
    end

    -- Set up the smart keybinds globally
    vim.keymap.set("n", "<Tab>", smart_tab, { desc = "Smart Tab (Org cycle or default)" })
    vim.keymap.set("n", "<S-Tab>", smart_shift_tab, { desc = "Smart Shift-Tab (Org global cycle or default)" })

    -- Insert mode smart tab only for org files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "org",
      callback = function()
        vim.keymap.set("i", "<Tab>", smart_tab_insert, {
          desc = "Smart tab in org insert mode",
          expr = true,
          buffer = true,
        })
        vim.keymap.set("i", "<S-Tab>", "<C-d>", {
          desc = "Unindent in org insert mode",
          buffer = true,
        })
      end,
    })

    -- Additional useful orgmode keybinds
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.silent = opts.silent ~= false
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Only active in org files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "org",
      callback = function()
        map(
          "n",
          "<Leader>oa",
          '<cmd>lua require("orgmode").action("agenda.prompt")<CR>',
          { desc = "Org Agenda", buffer = true }
        )
        map(
          "n",
          "<Leader>oc",
          '<cmd>lua require("orgmode").action("capture.prompt")<CR>',
          { desc = "Org Capture", buffer = true }
        )
        map(
          "n",
          "<Leader>or",
          '<cmd>lua require("orgmode").action("org_mappings.org_refile")<CR>',
          { desc = "Org Refile", buffer = true }
        )
        map(
          "n",
          "<Leader>ot",
          '<cmd>lua require("orgmode").action("org_mappings.org_todo")<CR>',
          { desc = "Org Todo", buffer = true }
        )
        map(
          "n",
          "<Leader>os",
          '<cmd>lua require("orgmode").action("org_mappings.org_schedule")<CR>',
          { desc = "Org Schedule", buffer = true }
        )
        map(
          "n",
          "<Leader>od",
          '<cmd>lua require("orgmode").action("org_mappings.org_deadline")<CR>',
          { desc = "Org Deadline", buffer = true }
        )
        map(
          "n",
          "<Leader>oi",
          '<cmd>lua require("orgmode").action("org_mappings.org_clock_in")<CR>',
          { desc = "Org Clock In", buffer = true }
        )
        map(
          "n",
          "<Leader>oo",
          '<cmd>lua require("orgmode").action("org_mappings.org_clock_out")<CR>',
          { desc = "Org Clock Out", buffer = true }
        )
      end,
    })
  end,
}
