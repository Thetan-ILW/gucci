local class = require("class")
local gfx_util = require("gfx_util")
local spherefonts = require("sphere.assets.fonts")
local transform = require("gfx_util").transform

local JudgeCountView = class()

JudgeCountView.judgeColors = {
	soundsphere = {
		perfect = { 1, 1, 1, 1 },
		["not perfect"] = { 1, 0.6, 0.4, 1 },
	},
	osuMania = {
		perfect = { 0.6, 0.8, 1, 1 },
		great = { 0.95, 0.796, 0.188, 1 },
		good = { 0.07, 0.8, 0.56, 1 },
		ok = { 0.1, 0.39, 1, 1 },
		meh = { 0.42, 0.48, 0.51, 1 },
	},
	osuLegacy = {
		perfect = { 0.6, 0.8, 1, 1 },
		great = { 0.95, 0.796, 0.188, 1 },
		good = { 0.07, 0.8, 0.56, 1 },
		ok = { 0.1, 0.39, 1, 1 },
		meh = { 0.42, 0.48, 0.51, 1 },
	},
	etterna = {
		marvelous = { 0.6, 0.8, 1, 1 },
		perfect = { 0.95, 0.796, 0.188, 1 },
		great = { 0.07, 0.8, 0.56, 1 },
		bad = { 0.1, 0.7, 1, 1 },
		boo = { 1, 0.1, 0.7, 1 },
	},
	quaver = {
		marvelous = { 1, 1, 0.71, 1 },
		perfect = { 1, 0.91, 0.44, 1 },
		great = { 0.38, 0.96, 0.47, 1 },
		good = { 0.25, 0.7, 0.75, 1 },
		okay = { 0.72, 0.46, 0.65, 1 },
	},
	lr2 = {
		pgreat = { 0.6, 0.8, 1, 1 },
		great = { 0.95, 0.796, 0.188, 1 },
		good = { 1, 0.69, 0.24, 1 },
		bad = { 1, 0.5, 0.24, 1 },
	},
}

local x = 200
local y = 500
local w = 300
local r = 12
local s = 1
local colors
local miss_color = { 0.8, 0.16, 0.16, 1 }
local font_color = { 1, 1, 1, 1 }
local background_color = { 0, 0, 0, 0.5 }
local font_object

local judge_name
local counters_count
local counters
local counter_names

function JudgeCountView:load()
	local judgements = self.game.rhythmModel.scoreEngine.scoreSystem.judgements
	judge_name = self.game.configModel.configs.select.judgements

	local judge = judgements[judge_name]

	assert(judge, ("Judge '%s' does not exists."):format(judge_name))

	counters = judge.counters
	counter_names = judge.orderedCounters
	counters_count = #counter_names + 1

	x = self.x or x
	y = self.y or y
	w = self.w or w
	r = self.rounding or r
	s = self.scale
	colors = self.colors or self.judgeColors[judge.scoreSystemName]
	miss_color = self.missColor or miss_color
	font_color = self.fontColor or font_color
	background_color = self.backgroundColor or background_color

	local font = self.font
	if font.filename then
		font[1], font[2] = font.filename, font.size
	end
	font_object = spherefonts.get(unpack(font))
end

---@param _ number
function JudgeCountView:update(_) end

local gfx = love.graphics

---@param k string
---@param v string
local function printKeyValue(k, v)
	gfx_util.printFrame(k:upper(), 0, 0, w, 200, "left", "top")
	gfx.setColor(font_color)
	gfx_util.printFrame(v, 0, 0, w, 200, "right", "top")
end

function JudgeCountView:draw()
	local tf = transform(self.transform)
	gfx.replaceTransform(tf)
	gfx.translate(x, y)

	gfx.setFont(font_object)
	local spacing = font_object:getHeight()
	local h = (counters_count + 1.5) * spacing

	gfx.scale(s, s)
	gfx.setColor(background_color)
	gfx.rectangle("fill", -15, -15, w + 30, h + 30, r, r)

	gfx.setColor({ 1, 1, 1, 1 })
	gfx_util.printFrame(judge_name, 0, 0, w, h)
	gfx.translate(0, spacing * 1.5)

	for _, name in ipairs(counter_names) do
		gfx.setColor(colors[name])
		printKeyValue(name, counters[name])
		gfx.translate(0, spacing)
	end

	gfx.setColor(miss_color)
	printKeyValue("miss", counters["miss"])
end

return JudgeCountView
