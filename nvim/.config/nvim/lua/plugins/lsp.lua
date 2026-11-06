local servers = {
	"lua_ls",
	"basedpyright",
	"ruff",
	"bashls",
	"jsonls",
	"yamlls",
	"taplo",
	"marksman",
	"vtsls",
	"rust_analyzer",
	"zls",
	"clangd",
	"dockerls",
	"docker_compose_language_service",
	"gopls",
	"golangci_lint_ls",
}

local external_servers = {
	"nil_ls",
}

local tools = {
	"stylua",
	"prettier",
	"shfmt",
	"clang-format",
	"sql-formatter",
	"gofumpt",
	"goimports",
	"golangci-lint",
}

return {
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		build = ":MasonUpdate",
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = tools,
			run_on_start = true,
			start_delay = 3000,
		},
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"saghen/blink.cmp",
			"b0o/SchemaStore.nvim",
			"mason-org/mason.nvim",
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
						},
						telemetry = { enable = false },
						diagnostics = {
							-- lazydev covers neovim globals; keep empty unless needed
							unusedLocalExclude = { "_*" },
						},
					},
				},
			})

			vim.lsp.config("basedpyright", {
				settings = {
					basedpyright = {
						analysis = {
							diagnosticMode = "openFilesOnly",
							typeCheckingMode = "standard",
							autoImportCompletions = true,
						},
					},
				},
			})

			vim.lsp.config("ruff", {
				init_options = {
					settings = {
						-- rely on basedpyright for type-ish stuff; ruff for lint/import
						lint = { enable = true },
					},
				},
			})

			vim.lsp.config("jsonls", {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						schemaStore = {
							enable = false,
							url = "",
						},
						schemas = require("schemastore").yaml.schemas(),
						validate = true,
						keyOrdering = false,
					},
				},
			})

			vim.lsp.config("vtsls", {
				settings = {
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = { completeFunctionCalls = true },
					},
				},
			})

			vim.lsp.config("gopls", {
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_markers = { "go.work", "go.mod", ".git" },
				settings = {
					gopls = {
						gofumpt = true,
						staticcheck = true,
						usePlaceholders = true,
						completeUnimported = true,
						-- treesitter owns highlighting; gopls tokens would win over it
						semanticTokens = false,
						directoryFilters = { "-.git", "-node_modules", "-vendor" },
						analyses = {
							unusedparams = true,
							unusedwrite = true,
							unusedvariable = true,
							nilness = true,
							useany = true,
							-- noisy; err shadowing is idiomatic Go
							shadow = false,
							-- only useful when optimizing struct layout
							fieldalignment = false,
						},
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
						codelenses = {
							generate = true,
							test = true,
							tidy = true,
							upgrade_dependency = true,
							run_govulncheck = true,
						},
						templateExtensions = { "tmpl", "gotmpl" },
					},
				},
			})

			vim.lsp.config("rust_analyzer", {
				settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						check = { command = "clippy" },
					},
				},
			})

			vim.lsp.config("clangd", {
				init_options = {
					fallbackFlags = { "-I/opt/homebrew/include" },
				},
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
				},
			})

			-- Objective-C-LSP (liuyanghejerry): cargo build --release, copy to ~/.local/bin
			-- vim.lsp.config("objc_lsp", {
			-- 	cmd = { vim.fn.expand("~/.local/bin/objc-lsp") },
			-- 	filetypes = { "objc", "objcpp" },
			-- 	root_markers = { "compile_commands.json", "*.xcodeproj", "Package.swift", ".git" },
			-- })
			-- if vim.fn.executable(vim.fn.expand("~/.local/bin/objc-lsp")) == 1 then
			-- 	vim.lsp.enable("objc_lsp")
			-- end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
				callback = function(ev)
					local buf = ev.buf
					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
					end
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if client and client:supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = buf })
					end

					map("n", "gd", vim.lsp.buf.definition, "LSP definition")
					map("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
					map("n", "gr", vim.lsp.buf.references, "LSP references")
					map("n", "gI", vim.lsp.buf.implementation, "LSP implementation")
					map("n", "gy", vim.lsp.buf.type_definition, "LSP type definition")
					map("n", "K", vim.lsp.buf.hover, "LSP hover")
					map("n", "<C-k>", vim.lsp.buf.signature_help, "LSP signature")
					map("n", "<leader>rn", vim.lsp.buf.rename, "LSP rename")
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
					map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
					map("n", "[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, "Prev diagnostic")
					map("n", "]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, "Next diagnostic")
				end,
			})

			vim.diagnostic.config({
				virtual_text = { spacing = 2, source = "if_many" },
				severity_sort = true,
				float = { border = "rounded", source = true, max_width = 80, max_height = 20 },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.INFO] = "",
						[vim.diagnostic.severity.HINT] = "",
					},
				},
			})
		end,
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = servers,
			-- auto vim.lsp.enable() for Mason-installed servers
			automatic_enable = {
				exclude = {
					"ts_ls", -- use vtsls instead
				},
			},
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)
			if vim.fn.executable("nil") == 1 then
				vim.lsp.enable("nil_ls")
			end
			local _ = external_servers
		end,
	},
}
