local Config = {}

--- @param config any
--- @return cdejoye.config
function Config:new(config)
  local this = config or {}

  setmetatable(this, self)
  self.__index = function(table, key)
    if not rawget(table, key) then
      table[key] = Config:new()
    end
    return table[key]
  end

  return this
end

--- @class cdejoye.config
local default = {
  coverage = {
    php = {
      coverage_file = 'coverage/cobertura.xml',
    },
  },
  null_ls = { sources = {} },
}

local t = Config:new(default)

return t
