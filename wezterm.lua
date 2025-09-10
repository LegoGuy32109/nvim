-- INFO: To set the wezterm config path on PowerShell:
-- `setx WEZTERM_CONFIG_FILE "\\wsl$\Ubuntu\home\joshhale\.config\nvim\wezterm.lua"`

local wezterm = require "wezterm"

-- This will hold the configuration.
local config = wezterm.config_builder()
config.default_domain = "WSL:Ubuntu"
config.color_scheme = "Catppuccin Mocha"

config.underline_thickness = "1pt"
config.underline_position = "-2pt"
config.force_reverse_video_cursor = true

config.font = wezterm.font("0xProto Nerd Font Mono")
config.font_size = 14
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1", }


-- config.default_prog = { "powershell.exe " }

-- local mux = wezterm.mux
-- local function getPowershellArgs(cmd)
--   return { "pwsh", "-NoExit", "-Command", cmd }
-- end

-- wezterm.on("start-joshagachi-dev", function(_, _)
--   local project_root = "C:/Users/Josh/Desktop/Godot/joshagachi/"
--   local rust_logic_dir = project_root .. "addons/joshagachi_logic/"
--   local web_server_dir = project_root .. "addons/web_server/"
--
--   local screens = wezterm.gui.screens()
--   local secondaryScreen = screens.active -- fallback to main if undefined
--   for _, screenInfo in pairs(screens.by_name) do
--     if screenInfo.name:find("DISPLAY3", 1, true) then
--       secondaryScreen = screenInfo
--     end
--   end
--
--   -- open up bacon commands in secondary screen
--   local tab1, pane1, windowBacon = mux.spawn_window {
--     cwd = rust_logic_dir,
--     args = getPowershellArgs "bacon web",
--     position = {
--       x = secondaryScreen.x,
--       y = secondaryScreen.y,
--       origin = "ActiveScreen",
--     },
--   }
--
--   pane1:split {
--     direction = "Right",
--     size = 0.5,
--     cwd = rust_logic_dir,
--     args = getPowershellArgs "bacon export",
--   }
--
--   windowBacon:spawn_tab {
--     cwd = web_server_dir,
--     -- Open page first, because bacon will not end
--     args = getPowershellArgs("cd " .. web_server_dir .. ' && Start-Process "http://127.0.0.1:8061" && bacon'),
--   }
--
--   tab1:activate()
--   windowBacon:gui_window():maximize()
--
--   -- Open up nvim in main screen
--   local _, _, windowNvim = mux.spawn_window {
--     cwd = project_root,
--     args = getPowershellArgs "nvim addons/joshagachi_logic/src/lib.rs",
--   }
--   windowNvim:gui_window():maximize()
-- end)

-- mods "SHIFT|CTRL|ALT"
config.keys = {
   {
      key = "E",
      mods = "CTRL|SHIFT",
      action = wezterm.action.SpawnCommandInNewTab {
         domain = { DomainName = "local" },
         args = { "powershell.exe" }
      }
   }
   -- {
   --   key = "J",
   --   mods = "SHIFT|CTRL|ALT",
   --   action = wezterm.action.EmitEvent "start-joshagachi-dev",
   -- },
}


-- and finally, return the configuration to wezterm
return config
