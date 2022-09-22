require('peterchiang.base')
require('peterchiang.highlights')
require('peterchiang.maps')
require('peterchiang.plugins')

local has = function(x)
  return vim.fn.has(x) == 1
end
local is_mac = has "macunix"
local is_win = has "win32"

if is_mac then
  require('peterchiang.macos')
end
if is_win then
  require('peterchiang.windows')
end
