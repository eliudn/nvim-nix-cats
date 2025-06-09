return {
    {
        "zbirenbaum/copilot.lua",
        enabled = require("nixCatsUtils").enableForCategory("ia"),
        opts = {}
    },
    {
        "giuxtaposition/blink-cmp-copilot",
        enabled = require("nixCatsUtils").enableForCategory("ia"),
        dependencies = { "zbirenbaum/copilot.lua" },
    }
}
