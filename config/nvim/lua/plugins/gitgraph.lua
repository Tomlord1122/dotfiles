return {
  {
    "isakbm/gitgraph.nvim",
    opts = {
      format = {
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
    },
    keys = {
      {
        "<leader>gl",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph - Draw",
      },
    },
  },
}
