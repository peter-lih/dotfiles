return {
  {
    "folke/sidekick.nvim",
    cmd = { "Sidekick" },
    keys = {
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select()
        end,
        desc = "Sidekick Select Tool",
      },
      {
        "<c-.>",
        function()
          require("sidekick.cli").focus()
        end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
    },
    opts = {
      cli = {
        tools = {
          antigravity = {
            cmd = { "agy" },
          },
        },
      },
    },
  },
}
