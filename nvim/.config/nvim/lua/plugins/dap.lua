return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "jbyuki/one-small-step-for-vimkind" },
			{ "igorlfs/nvim-dap-view", version = "1.*" },
			"mfussenegger/nvim-dap-python",
			{ "jay-babu/mason-nvim-dap.nvim", dependencies = { "mason-org/mason.nvim" } },
		},
		keys = {
			-- stepping (mirrors pdb: c/n/s/r/q)
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Debug: continue / start",
			},
			{
				"<leader>dn",
				function()
					require("dap").step_over()
				end,
				desc = "Debug: next (step over)",
			},
			{
				"<leader>ds",
				function()
					require("dap").step_into()
				end,
				desc = "Debug:step into",
			},
			{
				"<leader>dr",
				function()
					require("dap").step_out()
				end,
				desc = "Debug: return (step out)",
			},
			{
				"<leader>dq",
				function()
					require("dap").terminate()
					-- true = also hide the terminal pane that "keep_terminal" would leave up
					require("dap-view").close(true)
				end,
				desc = "Debug: quit session",
			},
			{
				"<leader>du",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Debug: run until cursor",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Debug: run last config",
			},

			-- breakpoints
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Debug: toggle breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Condition: "))
				end,
				desc = "Debug: conditional breakpoint",
			},
			{
				"<leader>dH",
				function()
					require("dap").set_breakpoint(nil, vim.fn.input("Hit count: "))
				end,
				desc = "Debug: hit-count breakpoint",
			},

			{
				"<leader>dp",
				function()
					require("dap").set_breakpoint(nil, nil, vim.fn.input("Log: "))
				end,
				desc = "Debug: logpoint",
			},

			-- nvim-dap-view
			{
				"<leader>dv",
				function()
					require("dap-view").toggle()
				end,
				desc = "Debug: toggle view",
			},
			{
				"<leader>de",
				function()
					require("dap-view").add_expr()
				end,
				mode = { "n", "v" },
				desc = "Debug: watch expression",
			},
			{
				"<leader>dh",
				function()
					require("dap-view").hover()
				end,
				mode = { "n", "v" },
				desc = "Debug: hover eval",
			},
			{
				"<leader>dR",
				function()
					require("dap-view").jump_to_view("repl")
				end,
				desc = "Debug: REPL",
			},

			-- lua (neovim itself)
			{
				"<leader>dL",
				function()
					require("osv").launch({ port = 8086 })
				end,
				desc = "Debug: launch nvim lua server",
			},

			-- python
			{
				"<leader>dm",
				function()
					require("dap-python").test_method()
				end,
				ft = "python",
				desc = "Debug: test method",
			},
			{
				"<leader>dM",
				function()
					require("dap-python").test_class()
				end,
				ft = "python",
				desc = "Debug: test class",
			},
			{
				"<leader>dS",
				function()
					require("dap-python").debug_selection()
				end,
				mode = "v",
				ft = "python",
				desc = "Debug: selection",
			},
		},
		config = function()
			require("mason-nvim-dap").setup({
				-- dap adapter names, NOT mason package names
				ensure_installed = { "codelldb", "js", "delve", "bash" },
				handlers = {},
				-- plugin default; passed explicitly to satisfy its type annotation
				automatic_installation = false,
			})

			-- must run AFTER mason-nvim-dap so it owns dap.adapters.python
			require("dap-python").setup("uv")

			-- osv is not in mason-nvim-dap's adapter table, so wire it by hand
			local dap = require("dap")
			dap.adapters.nlua = function(callback, config)
				callback({
					type = "server",
					host = config.host or "127.0.0.1",
					port = config.port or 8086,
				})
			end
			dap.configurations.lua = {
				{
					type = "nlua",
					request = "attach",
					name = "Attach to running Neovim instance",
				},
			}
			dap.configurations.c = {
				{
					name = "Launch (pick binary)",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to binary: ", vim.fn.getcwd() .. "/build", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			dap.configurations.objc = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			dap.configurations.objcpp = dap.configurations.c
			dap.configurations.cpp = dap.configurations.c

			require("dap-view").setup({
				-- open on Scopes, not the empty Watches pane
				winbar = { default_section = "scopes" },
				-- "keep_terminal" leaves the output pane up after the session ends
				auto_toggle = "keep_terminal",
				windows = { size = 0.3 },
				-- built-in virtual text
				virtual_text = { enabled = true, position = "inline" },
			})

			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
			vim.fn.sign_define("DapLogPoint", { text = "◈", texthl = "DiagnosticInfo" })
			vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })
		end,
	},
}
