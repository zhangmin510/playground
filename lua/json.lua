local cjson = require "cjson"
local cjson2 = cjson.new()
local cjson_safe = require "cjson.safe"

local t = {}
t[1] = "hello"
print(t)
print(cjson.encode(t))