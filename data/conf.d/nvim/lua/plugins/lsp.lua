return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {
          settings = {
            css = { validate = false },
            scss = { validate = true },
            less = { validate = true },
          },
        },
      },
    },
  },
}
