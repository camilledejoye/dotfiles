-- Luacheck configuration for native-snippets
std = "lua51+busted"
globals = {"vim", "_G"}

-- For test files
files["tests/**/*.lua"] = {
  std = "lua51+busted",
  globals = {"describe", "it", "before_each", "after_each", "setup", "teardown"}
}