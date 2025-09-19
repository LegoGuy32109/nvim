return {
   cmd = { "tailwindcss-language-server", "--stdio" },
   filetypes = {
      -- From lspconfig defaults (broad list so it works in mixed stacks)
      "aspnetcorerazor", "astro", "astro-markdown", "blade", "django-html", "edge", "eelixir", "ejs", "erb", "eruby",
      "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "jade", "leaf", "liquid",
      "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig",
      "css", "less", "postcss", "sass", "scss", "stylus", "sugarss",
      "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte",
   },
   capabilities = require("blink.cmp").get_lsp_capabilities(),
   -- Tailwind projects usually expose one of these config files; fall back to Node/gIT roots
   root_markers = {
      { "tailwind.config.js", "tailwind.config.ts" },
      { "postcss.config.js",  "postcss.config.ts" },
      "package.json",
      "deno.json",
      "node_modules",
      ".git",
   },
   settings = {
      tailwindCSS = {
         -- Helpful if you use utility classes in non-standard attributes or template tags
         experimental = {
            classRegex = {
               -- add your custom detectors here, e.g. for clsx/cva/tw:
               -- { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
               -- { "clsx\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
            },
         },
         classAttributes = { "class", "className" }, -- extend if needed
         validate = true,
         lint = {
            cssConflict = "warning",
            invalidApply = "error",
            invalidConfigPath = "error",
            invalidScreen = "error",
            invalidTailwindDirective = "error",
            invalidVariant = "error",
            recommendedVariantOrder = "warning",
         },
      },
   },
}
