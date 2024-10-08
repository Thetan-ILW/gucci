local transform = require("gfx_util").transform
local map = require("math_util").map
local class = require("class")
local inside = require("table_util").inside
local hitColors = love.filesystem.load(... .. "colors.lua")()

---@class sphere.HitErrorView
---@operator call: sphere.HitErrorView
local HitErrorView = class()

function HitErrorView:load()
	local judgeName = self.game.configModel.configs.select.judgements
	local judgements = self.game.rhythmModel.scoreEngine.scoreSystem.judgements

	self.judge = judgements[judgeName]
end

function HitErrorView:draw()
	if self.show and not self.show(self) then
		return
	end

	local tf = transform(self.transform):translate(self.x, self.y)
	love.graphics.replaceTransform(tf)

	if self.background then
		self:drawBackground()
	end

	local points = inside(self, self.key)
	local fade = 0
	for i = #points, #points - self.count, -1 do
		if not points[i] then
			break
		end
		self:drawPoint(points[i], fade)
		fade = fade + 1
	end

	if self.origin then
		self:drawOrigin()
	end
end

function HitErrorView:drawBackground()
	love.graphics.setColor(self.background.color)
	love.graphics.rectangle("fill", -self.w / 2, 0, self.w, self.h)
end

function HitErrorView:drawOrigin()
	local origin = self.origin

	love.graphics.setColor(origin.color)
	love.graphics.rectangle("fill", -origin.w / 2, -(origin.h - self.h) / 2, origin.w, origin.h)
end

---@param point table
---@param fade number
function HitErrorView:drawPoint(point, fade)
	local radius = self.radius

	local value = inside(point, self.value)
	local unit = inside(point, self.unit)
	if type(value) == "nil" then
		value = tonumber(self.value) or 0
	end
	if type(unit) == "nil" then
		unit = tonumber(self.unit) or 1
	end

	local counter = self.judge:getCounter(value, self.judge.windows)

	local color = hitColors[self.judge.scoreSystemName][counter] or { 1, 0, 0, 1 }

	local alpha = color[4]
	color[4] = color[4] * map(fade, 0, self.count, 1, 0)
	love.graphics.setColor(color)
	color[4] = alpha

	local x = map(value, 0, unit, 0, self.w / 2)
	love.graphics.rectangle("fill", x - radius, 0, radius * 2, self.h)
end

return HitErrorView
