local Buffers = require('lualine.components.buffers'):extend()
local Buffer = require('lualine.components.buffers.buffer')

function Buffers:new_buffer(bufnr)
  return Buffer {
    bufnr = bufnr,
    options = self.options,
    highlights = self.highlights,
  }
end

function Buffers:bufnrs()
  local buffers = {}

  for b = 1, vim.fn.bufnr '$' do
    if vim.fn.buflisted(b) ~= 0 and vim.api.nvim_buf_get_option(b, 'buftype') ~= 'quickfix' then
      buffers[#buffers + 1] = b
    end
  end

  return buffers
end

function Buffers:update_status()
  local data = {}
  local buffers = {}
  for _, bufnr in ipairs(self:bufnrs()) do
    buffers[#buffers + 1] = self:new_buffer(bufnr)
  end
  local current_bufnr = vim.fn.bufnr()
  local current = -2
  -- mark the first, last, current, before current, after current buffers
  -- for rendering
  if buffers[1] then
    buffers[1].first = true
  end
  if buffers[#buffers] then
    buffers[#buffers].last = true
  end
  for i, buffer in ipairs(buffers) do
    if buffer.bufnr == current_bufnr then
      buffer.current = true
      current = i
    end
  end
  if buffers[current - 1] then
    buffers[current - 1].beforecurrent = true
  end
  if buffers[current + 1] then
    buffers[current + 1].aftercurrent = true
  end

  local max_length = self.options.max_length
  if type(max_length) == 'function' then
    max_length = max_length(self)
  end

  if max_length == 0 then
    max_length = math.floor(2 * vim.o.columns / 3)
  end
  local total_length
  for i, buffer in pairs(buffers) do
    if buffer.current then
      current = i
    end
  end
  -- start drawing from current buffer and draw left and right of it until
  -- all buffers are drawn or max_length has been reached.
  if current == -2 then
    local b = self:new_buffer(vim.fn.bufnr())
    b.current = true
    if self.options.self.section < 'lualine_x' then
      b.last = true
      if #buffers > 0 then
        buffers[#buffers].last = nil
      end
      buffers[#buffers + 1] = b
      current = #buffers
    else
      b.first = true
      if #buffers > 0 then
        buffers[1].first = nil
      end
      table.insert(buffers, 1, b)
      current = 1
    end
  end
  local current_buffer = buffers[current]
  data[#data + 1] = current_buffer:render()
  total_length = current_buffer.len
  local i = 0
  local before, after
  while true do
    i = i + 1
    before = buffers[current - i]
    after = buffers[current + i]
    local rendered_before, rendered_after
    if before == nil and after == nil then
      break
    end
    -- draw left most undrawn buffer if fits in max_length
    if before then
      rendered_before = before:render()
      total_length = total_length + before.len
      if total_length > max_length then
        break
      end
      table.insert(data, 1, rendered_before)
    end
    -- draw right most undrawn buffer if fits in max_length
    if after then
      rendered_after = after:render()
      total_length = total_length + after.len
      if total_length > max_length then
        break
      end
      data[#data + 1] = rendered_after
    end
  end
  -- draw elipsis (...) on relevent sides if all buffers don't fit in max_length
  if total_length > max_length then
    if before ~= nil then
      before.ellipse = true
      before.first = true
      table.insert(data, 1, before:render())
    end
    if after ~= nil then
      after.ellipse = true
      after.last = true
      data[#data + 1] = after:render()
    end
  end

  return table.concat(data)
end

return Buffers
