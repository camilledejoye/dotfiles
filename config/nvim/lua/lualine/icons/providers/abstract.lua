--
-- Provide an independent interface to retrieve icons
-- I used this as an exercise to learn Lua which explains why it might feel a bit overkill
-- ;)
--

---Provide an independent interface to retrieve icons
---@class IconsProvider
IconsProvider = {}

---Create a new icons provider
---@param o table
---@return IconsProvider
function IconsProvider:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self

  return o
end

---@return boolean #true if the provider is available, false otherwise
function IconsProvider:is_available()
  error('IconsProvider:is_available() not implemented')
end

---@param bufnr integer #number of a buffer
---@return string #the name associated to the buffer
function IconsProvider:buf_get_name(bufnr)
  return vim.api.nvim_buf_get_name(bufnr)
end

---@param filename string
---@return string
function IconsProvider:extension(filename)
  return vim.fn.fnamemodify(filename, ':e')
end

---@param bufnr integer #buffer number
---@return string #icon
---@return string #icon's highlight group
function IconsProvider:for_buffer(bufnr)
  return self:for_filename(self:buf_get_name(bufnr))
end

---@param filename string
---@return string #icon
---@return string #icon's highlight group
function IconsProvider:for_filename(filename)
  error('IconsProvider:for_filename() not implemented')
end

return IconsProvider
