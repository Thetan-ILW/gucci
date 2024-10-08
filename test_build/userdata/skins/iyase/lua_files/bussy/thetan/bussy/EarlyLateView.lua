local class = require("class")
local gfx_util = require("gfx_util")
local spherefonts = require("sphere.assets.fonts")
local transform = require("gfx_util").transform

local EarlyLateView = class()

local judgements

local earlyLate

local x = 15
local y = 15
local w = math.huge
local r = 0
local s = 1
local fontObject
local fontColor

function EarlyLateView:load()
	local score_system = self.game.rhythmModel.scoreEngine.scoreSystem
	judgements = score_system.judgements

	x = self.x or x
	y = self.y or y
	w = self.w or w
	r = self.rounding or r
	s = self.scale or 1

	fontColor = self.fontColor or { 1, 1, 1, 1 }

	local font = self.font

	-- bro what the hell I was thinking back then, but I will leave it as it is lol
	assert(font, "Give me the font, baka!!! - EarlyLateView          (sorry)")

	if font.filename then
		font[1], font[2] = font.filename, font.size
	end
	fontObject = spherefonts.get(unpack(font))
end

function EarlyLateView:update()
	earlyLate = judgements["soundsphere"].earlyLate
end

local gfx = love.graphics

function EarlyLateView:draw()
	local tf = transform(self.transform)
	gfx.replaceTransform(tf)
	gfx.translate(x, y)

	gfx.setColor(fontColor)
	gfx.setFont(fontObject)
	gfx.scale(s, s)

	local text = ("-%i | +%i"):format(earlyLate.early, earlyLate.late)
	local width = fontObject:getWidth(text)

	gfx_util.printFrame(text, -width / 2, 0, w, math.huge, "left", "top")
end

return EarlyLateView
