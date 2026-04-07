require("dotfiles.set")
require("dotfiles.remap")
require("dotfiles.lazy")

-- Load custom configuration if it exists (not tracked in git)
local custom_ok, _ = pcall(require, "dotfiles.custom")
if not custom_ok then
  -- Custom config doesn't exist, that's fine
end

