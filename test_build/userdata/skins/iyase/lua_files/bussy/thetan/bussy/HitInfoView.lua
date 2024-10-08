local class = require("class")
local gfx_util = require("gfx_util")
local spherefonts = require("sphere.assets.fonts")
local transform = require("gfx_util").transform

local HitInfoView = class()

local misc_score_system
local normalscore
local judgements

local mean
local maxError
local earlyLate

local x = 15
local y = 15
local w = math.huge
local r = 0
local s = 1
local fontObject
local fontColor

function HitInfoView:load()
	local score_system = self.game.rhythmModel.scoreEngine.scoreSystem
	misc_score_system = score_system.misc
	normalscore = score_system.normalscore
	judgements = score_system.judgements

	x = self.x or x
	y = self.y or y
	w = self.w or w
	r = self.rounding or r
	s = self.scale or 1

	fontColor = self.fontColor or { 1, 1, 1, 1 }

	local font = self.font

	-- bro what the hell I was thinking back then, but I will leave it as it is lol
	assert(font, "Give me the font, baka!!! - HitInfoView          (sorry)")

	if font.filename then
		font[1], font[2] = font.filename, font.size
	end
	fontObject = spherefonts.get(unpack(font))
end

function HitInfoView:update()
	mean = normalscore.normalscore.mean
	maxError = misc_score_system.maxDeltaTime
	earlyLate = judgements["soundsphere"].earlyLate
end

local gfx = love.graphics

function HitInfoView:draw()
	local tf = transform(self.transform)
	gfx.replaceTransform(tf)
	gfx.translate(x, y)

	gfx.setColor(fontColor)
	gfx.setFont(fontObject)
	gfx.scale(s, s)

	local spacing = fontObject:getHeight()

	gfx_util.printFrame(("Mean: %i"):format(mean * 1000), 0, 0, w, math.huge, "left", "top")
	gfx.translate(0, spacing)
	gfx_util.printFrame(("Max error: %i"):format(maxError * 1000), 0, 0, w, math.huge, "left", "top")
	gfx.translate(0, spacing)

	gfx_util.printFrame(("Early: %i"):format(earlyLate.early), 0, 0, w, math.huge, "left", "top")
	gfx.translate(0, spacing)
	gfx_util.printFrame(("Late: %i"):format(earlyLate.late), 0, 0, w, math.huge, "left", "top")
end

return HitInfoView
