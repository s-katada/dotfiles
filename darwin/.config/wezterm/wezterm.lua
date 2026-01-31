-- WezTerm Ultra Modern Configuration
-- GPU-accelerated, Tokyonight themed, with built-in multiplexer

local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- =============================================================================
-- Plugin: tabline.wez
-- =============================================================================
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

-- =============================================================================
-- GPU Acceleration
-- =============================================================================
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- =============================================================================
-- Color Scheme: Tokyonight Night
-- =============================================================================
config.color_scheme = "tokyonight_night"

-- =============================================================================
-- Window Appearance
-- =============================================================================
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

-- =============================================================================
-- Font Configuration
-- =============================================================================
config.font = wezterm.font_with_fallback({
	{
		family = "Hack Nerd Font Mono",
		harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
	},
	{ family = "Hiragino Sans" },
	{ family = "Hiragino Kaku Gothic ProN" },
})
config.font_size = 14.0
config.line_height = 1.1

-- =============================================================================
-- IME Configuration (Japanese Input)
-- =============================================================================
config.use_ime = true
config.ime_preedit_rendering = "Builtin"

-- =============================================================================
-- Cursor Configuration
-- =============================================================================
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- =============================================================================
-- Tab Bar (using tabline.wez)
-- =============================================================================
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32

-- =============================================================================
-- Scrollback
-- =============================================================================
config.scrollback_lines = 10000
config.enable_scroll_bar = false

-- =============================================================================
-- Bell
-- =============================================================================
config.audible_bell = "Disabled"
config.visual_bell = {
	fade_in_duration_ms = 75,
	fade_out_duration_ms = 75,
	target = "CursorColor",
}

-- =============================================================================
-- Leader Key: CTRL+Space with 1.5s timeout
-- =============================================================================
config.leader = {
	key = "Space",
	mods = "CTRL",
	timeout_milliseconds = 1500,
}

-- Disable default keybindings to avoid Emacs-style bindings (CTRL+h, CTRL+d, etc.)
config.disable_default_key_bindings = true

-- =============================================================================
-- Key Bindings
-- =============================================================================
config.keys = {
	-- =========================================================================
	-- macOS Standard Keybindings
	-- =========================================================================
	{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
	{ key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "n", mods = "CMD", action = act.SpawnWindow },
	{ key = "q", mods = "CMD", action = act.QuitApplication },
	{ key = "h", mods = "CMD", action = act.HideApplication },
	{ key = "m", mods = "CMD", action = act.Hide },
	{ key = "f", mods = "CMD", action = act.Search({ CaseInSensitiveString = "" }) },
	{ key = "k", mods = "CMD", action = act.ClearScrollback("ScrollbackAndViewport") },
	{ key = "=", mods = "CMD", action = act.IncreaseFontSize },
	{ key = "-", mods = "CMD", action = act.DecreaseFontSize },
	{ key = "0", mods = "CMD", action = act.ResetFontSize },
	{ key = "Enter", mods = "CMD", action = act.ToggleFullScreen },
	-- CMD + 1-9 for tab switching
	{ key = "1", mods = "CMD", action = act.ActivateTab(0) },
	{ key = "2", mods = "CMD", action = act.ActivateTab(1) },
	{ key = "3", mods = "CMD", action = act.ActivateTab(2) },
	{ key = "4", mods = "CMD", action = act.ActivateTab(3) },
	{ key = "5", mods = "CMD", action = act.ActivateTab(4) },
	{ key = "6", mods = "CMD", action = act.ActivateTab(5) },
	{ key = "7", mods = "CMD", action = act.ActivateTab(6) },
	{ key = "8", mods = "CMD", action = act.ActivateTab(7) },
	{ key = "9", mods = "CMD", action = act.ActivateTab(-1) },

	-- =========================================================================
	-- Pane Operations
	-- =========================================================================
	-- LEADER + | or \ → Horizontal split
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "\\",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- LEADER + - → Vertical split
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- LEADER + hjkl → Pane navigation (Vim-style)
	{
		key = "h",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
	-- LEADER + HJKL → Pane resize
	{
		key = "H",
		mods = "LEADER|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "J",
		mods = "LEADER|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "K",
		mods = "LEADER|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "L",
		mods = "LEADER|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	-- LEADER + z → Toggle zoom
	{
		key = "z",
		mods = "LEADER",
		action = act.TogglePaneZoomState,
	},
	-- LEADER + x → Close pane
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},

	-- =========================================================================
	-- Tab Operations
	-- =========================================================================
	-- LEADER + c → New tab
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- LEADER + n/p → Next/Previous tab
	{
		key = "n",
		mods = "LEADER",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},
	-- LEADER + , → Rename tab
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new tab title:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- =========================================================================
	-- Workspace Operations
	-- =========================================================================
	-- LEADER + w → Switch workspace
	{
		key = "w",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	-- LEADER + W → Create new workspace
	{
		key = "W",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new workspace name:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},

	-- =========================================================================
	-- Quick Select & Copy Mode
	-- =========================================================================
	-- LEADER + Space → Quick Select
	{
		key = "Space",
		mods = "LEADER",
		action = act.QuickSelect,
	},
	-- LEADER + [ → Copy mode
	{
		key = "[",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},
	-- LEADER + / → Search
	{
		key = "/",
		mods = "LEADER",
		action = act.Search({ CaseInSensitiveString = "" }),
	},

	-- =========================================================================
	-- Command Palette
	-- =========================================================================
	-- CMD+SHIFT+P → Command palette
	{
		key = "P",
		mods = "CMD|SHIFT",
		action = act.ActivateCommandPalette,
	},
	-- LEADER + : → Command palette (Vim-style)
	{
		key = ":",
		mods = "LEADER|SHIFT",
		action = act.ActivateCommandPalette,
	},
}

-- LEADER + 1-9 → Activate tab by number
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

-- =============================================================================
-- Quick Select Patterns
-- =============================================================================
config.quick_select_patterns = {
	-- URL
	"https?://[^\\s\"'<>]+",
	-- Git hash (short and long)
	"[0-9a-f]{7,40}",
	-- UUID
	"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}",
	-- IPv4 address
	"\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}",
	-- IPv6 address (simplified)
	"[0-9a-fA-F:]{2,39}",
	-- File paths
	"[~/]?[\\w.-]+(?:/[\\w.-]+)+",
}

-- =============================================================================
-- Hyperlinks
-- =============================================================================
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- GitHub issues/PRs: #123 → github.com/.../issues/123
table.insert(config.hyperlink_rules, {
	regex = "#(\\d+)",
	format = "https://github.com/search?q=$1&type=issues",
})

-- =============================================================================
-- tabline.wez Setup
-- =============================================================================
tabline.setup({
	options = {
		icons_enabled = true,
		theme = "tokyonight_night",
		section_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
		component_separators = {
			left = wezterm.nerdfonts.pl_left_soft_divider,
			right = wezterm.nerdfonts.pl_right_soft_divider,
		},
		tab_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = { "workspace" },
		tabline_c = { " " },
		tab_active = {
			"index",
			{ "parent", padding = 0 },
			"/",
			{ "cwd", padding = { left = 0, right = 1 } },
			{ "zoomed", padding = 0 },
		},
		tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
		tabline_x = { "ram", "cpu" },
		tabline_y = { "datetime", "battery" },
		tabline_z = { "hostname" },
	},
	extensions = {},
})

tabline.apply_to_config(config)

-- =============================================================================
-- Misc
-- =============================================================================
config.automatically_reload_config = true
config.check_for_updates = false
config.warn_about_missing_glyphs = false

-- Native fullscreen on macOS
config.native_macos_fullscreen_mode = true

-- Disable close confirmation for last pane
config.skip_close_confirmation_for_processes_named = {
	"bash",
	"sh",
	"zsh",
	"fish",
	"tmux",
	"nu",
	"cmd.exe",
	"pwsh.exe",
	"powershell.exe",
}

return config
