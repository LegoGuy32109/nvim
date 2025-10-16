return {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = {
		-- From lspconfig defaults (broad list so it works in mixed stacks)
		"ejs",
		"html",
		"markdown",
		"css",
		"sass",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	-- Tailwind projects usually expose one of these config files; fall back to Node/gIT roots
	root_markers = {
		{ "tailwind.config.js", "tailwind.config.ts" },
		{ "postcss.config.js", "postcss.config.ts" },
		"deno.json",
	},
	settings = {
		tailwindCSS = {
			-- Helpful if you use utility classes in non-standard attributes or template tags
			experimental = {
				classRegex = {
					-- add your custom detectors here, e.g. for clsx/cva/tw:
					{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
					{ "clsx\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
					{ "class\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
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
