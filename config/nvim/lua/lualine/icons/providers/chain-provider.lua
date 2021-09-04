local IconsProvider = require('lualine.icons.providers.abstract')
local NullIconsProvider = require('lualine.icons.providers.null')
local NvimWebDevIconsProvider = require('lualine.icons.providers.nvim-devicons')
local VimWebDevIconsProvider = require('lualine.icons.providers.vim-devicons')

---Use the first available provider
---@class ChainIconsProvider : IconsProvider
---@field private candidates IconsProvider[] @ list of potential providers
ChainIconsProvider = IconsProvider:new { candidates = {
  NvimWebDevIconsProvider,
  VimWebDevIconsProvider,
  NullIconsProvider,
}, provider = false }

function ChainIconsProvider:is_available()
  return true
end

---Prepend some new candidates to the list of already managed ones
---@param candidates IconsProvider[]
function ChainIconsProvider:prepend_candidates(candidates)
  for i = #candidates, 1, -1 do
    table.insert(self.candidates, 1, candidates[i])
  end

  self.provider = false -- Reset to gave a shot to the new candidates
end

---Initialize the provider to use, automatically called
function ChainIconsProvider:_initialize()
  for _, candidate in ipairs(self.candidates) do
    local is_valid, is_available = pcall(candidate.is_available)

    if is_valid and is_available then
      self.provider = candidate

      return
    end
  end
end

setmetatable(ChainIconsProvider, {
  __index = function(self, key)
    if not self.provider then
      self:_initialize()
    end

    return self.provider[key]
  end,
})

return ChainIconsProvider
