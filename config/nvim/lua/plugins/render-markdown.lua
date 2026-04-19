return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown", "md", "codecompanion" },
  opts = {
    heading = {
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      signs = { "󰫎 " },
      width = "block",
      right_pad = 1,
    },
    code = {
      sign = true,
      width = "block",
      right_pad = 1,
      border = "thin",
      above = "▄",
      below = "▀",
    },
    bullet = {
      icons = { "●", "○", "◆", "◇" },
    },
    checkbox = {
      enabled = true,
      position = "inline",
      unchecked = { icon = "󰄱 ", highlight = "RenderMarkdownUnchecked" },
      checked = { icon = "󰱒 ", highlight = "RenderMarkdownChecked" },
    },
    quote = { icon = "▎" },
    pipe_table = { preset = "round" },
    callout = {
      note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
      tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
      important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
      warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
      caution = { raw = "[!CAUTION]", rendered = "󰳠 Caution", highlight = "RenderMarkdownError" },
    },
    link = {
      enabled = true,
      image = "󰥶 ",
      email = "󰀓 ",
      hyperlink = "󰌹 ",
      highlight = "RenderMarkdownLink",
    },
    sign = { enabled = true },
  },
  keys = {
    {
      "<leader>um",
      function()
        require("render-markdown").toggle()
      end,
      desc = "Toggle Markdown Render",
    },
  },
}
