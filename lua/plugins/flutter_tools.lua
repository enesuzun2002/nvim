return {
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
		config = function()
			local nvlsp = require("nvchad.configs.lspconfig")

			-- Resolve the Flutter SDK: local checkout first, then $PATH.
			local tried = {}

			local function sdk_from_dir(dir)
				local root = vim.fn.expand(dir)
				local flutter_bin = root .. "/bin/flutter"
				local dart_bin = root .. "/bin/cache/dart-sdk/bin/dart"
				if vim.fn.executable(flutter_bin) == 1 and vim.fn.executable(dart_bin) == 1 then
					return flutter_bin, dart_bin
				end
				table.insert(tried, root)
			end

			local flutter_bin, dart_bin = sdk_from_dir("~/Projects/flutter/sdk/flutter")

			if not flutter_bin then
				local path_flutter = vim.fn.exepath("flutter")
				if path_flutter ~= "" then
					local root = vim.fn.fnamemodify(path_flutter, ":h:h") -- strip /bin/flutter
					flutter_bin, dart_bin = sdk_from_dir(root)
				end
			end

			if not flutter_bin then
				vim.notify(
					"Flutter SDK not found. Tried: " .. table.concat(tried, ", ") .. " and $PATH.",
					vim.log.levels.ERROR
				)
				return
			end

			require("flutter-tools").setup({
				flutter_path = flutter_bin,

				fvm = false,

				emulator_args = {
					"--enable-gpu-libvulkan",
					"--gpu",
					"host",
				},
				executable = {
					env = {
						QT_QPA_PLATFORM = "xcb",
					},
				},
				ui = {
					border = "rounded",
				},
				decorations = {
					statusline = {
						app_version = true,
						device = true,
					},
				},
				debugger = {
					enabled = false,
					run_via_dap = false,
				},
				widget_guides = {
					enabled = true,
				},
				closing_tags = {
					highlight = "Comment",
					prefix = "///",
					enabled = true,
				},
				dev_log = {
					filter = nil,
					enabled = true,
					open_cmd = "15split",
				},
				outline = {
					auto_open = false,
					width = 100,
				},
				dev_tools = {
					autostart = false,
					auto_open_browser = false,
				},
				lsp = {
					cmd = { dart_bin, "language-server", "--protocol=lsp" },
					capabilities = nvlsp.capabilities,
					on_attach = nvlsp.on_attach,
					settings = {
						showTodos = true,
						completeFunctionCalls = true,
						renameFilesWithClasses = "prompt",
						updateImportsOnRename = true,
						dart_code_metrics = true,
					},
				},
			})

			local commands = require("flutter-tools.commands")

			local map = vim.keymap.set

			-- Profiling & run args -------------------------------------------

			-- Project root from the current buffer's pubspec.yaml, else cwd.
			local function flutter_root()
				local buf_path = vim.api.nvim_buf_get_name(0)
				local search_dir = buf_path ~= "" and vim.fs.dirname(buf_path) or vim.fn.getcwd()
				local pubspec = vim.fs.find({ "pubspec.yaml" }, { upward = true, path = search_dir })[1]
				return pubspec and vim.fs.dirname(pubspec) or vim.fn.getcwd()
			end

			-- dart-define-from-file flag when <project>/dart_defines.release.json exists.
			local function dart_define_flag()
				local define_file = flutter_root() .. "/dart_defines.release.json"
				if vim.uv.fs_stat(define_file) then
					return "--dart-define-from-file=" .. define_file
				end
				return nil
			end

			local function flutter_run(args)
				commands.run_command(args)
			end

			-- Profile-mode build & run (plain, no extra args).
			map("n", "<leader>rp", function()
				flutter_run("--profile")
			end, { desc = "Flutter Profile Run" })

			-- Run with <root>/dart_defines.release.json; mode picked from a menu.
			map("n", "<leader>rf", function()
				local define_flag = dart_define_flag()
				if not define_flag then
					vim.notify("No dart_defines.release.json in " .. flutter_root(), vim.log.levels.WARN)
					return
				end
				vim.ui.select({ "debug", "profile", "release" }, {
					prompt = "Run mode with dart_defines.release.json:",
				}, function(mode)
					if not mode then
						return
					end
					local args = mode == "debug" and define_flag or ("--" .. mode .. " " .. define_flag)
					flutter_run(args)
				end)
			end, { desc = "Flutter Run With Defines File" })

			-- Run with free-form args, nothing appended automatically.
			map("n", "<leader>ru", function()
				vim.ui.input({ prompt = "flutter run args: " }, function(input)
					if not input or input == "" then
						return
					end
					flutter_run(input)
				end)
			end, { desc = "Flutter Run With Args" })

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.dart",
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end,
	},
	{
		"sidlatau/flutter-icons.nvim",
		dependencies = { "folke/snacks.nvim" },
	},
}
