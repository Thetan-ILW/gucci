local class = require("class")
local gfx_util = require("gfx_util")
local spherefonts = require("sphere.assets.fonts")
local transform = require("gfx_util").transform

local KeyboardView = class()

local x = 0
local y = 0
local lineWidth = 3
local keySize = 60
local fontObject

local keyboardW = 0
local keyboardH = 0

local updateCanvas = true

local keysDown = {}

local keyMap = {
	{ "`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=" },
	{ "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]" },
	{ "a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'" },
	{ "z", "x", "c", "v", "b", "n", "m", ",", ".", "/" },
}

local row_offset = {
	0,
	1.5,
	1.75,
	2,
}

local keyAlias = {
	capslock = "caps",
	lshift = "shift",
	lctrl = "ctr",
	lgui = "*",
	lalt = "alt",
	ralt = "alt",
	rctrl = "ctr",
	["return"] = "enter",
	rshift = "shift",
	backspace = "<-",
	left = "<",
	right = ">",
	down = "v",
	up = "^",
	kp0 = "0",
	kp1 = "1",
	kp2 = "2",
	kp3 = "3",
	kp4 = "4",
	kp5 = "5",
	kp6 = "6",
	kp7 = "7",
	kp8 = "8",
	kp9 = "9",
	["kp."] = ".",
	["kp+"] = "+",
	["kp-"] = "+",
	["kp*"] = "+",
	["kp/"] = "+",
	["kp="] = "=",
	kpenter = "->",
}

local key = {}

function KeyboardView:load()
	keysDown = {}

	x = self.x or x
	y = self.y or y
	lineWidth = self.lineWitdh or lineWidth
	keySize = self.keySize or keySize

	local font = self.font
	assert(font, "Give me the font, baka!!! - KeyboardView          (sorry)")

	for row_i, row in ipairs(keyMap) do
		for column_i, k in ipairs(row) do
			local kx = column_i * keySize + (keySize * row_offset[row_i])
			local ky = row_i * keySize
			key[k] = { kx, ky, keySize * 0.8, keySize * 0.8 }
		end
	end

	local ks = keySize * 0.8

	key["tab"] = { keySize, 2 * keySize, ks * 1.55, ks }
	key["capslock"] = { keySize, 3 * keySize, ks * 1.9, ks }
	key["lshift"] = { keySize, 4 * keySize, ks * 2.2, ks }

	local ky = keySize * 5
	local kx = keySize
	local modk_o = (keySize * 2.2) - keySize
	key["lctrl"] = { kx, ky, ks * 1.3, ks }
	key["lgui"] = { kx + modk_o, ky, ks * 1.3, ks }
	key["lalt"] = { kx + modk_o * 2, ky, ks * 1.3, ks }
	key["space"] = { keySize * 4.7, ky, ks * 7, ks }
	key["ralt"] = { kx * 10.55, ky, ks, ks }
	key["fnc"] = { kx * 11.55, ky, ks, ks }
	key["rctrl"] = { kx * 12.55, ky, ks, ks }
	key["left"] = { kx * 13.55, ky, ks, ks }
	key["down"] = { kx * 14.55, ky, ks, ks }
	key["right"] = { kx * 15.55, ky, ks, ks }
	key["up"] = { kx * 14.55, 4 * keySize, ks, ks }
	key["rshift"] = { kx * 13, 4 * keySize, ks * 1.7, ks }
	key["return"] = { kx * 13.75, 3 * keySize, ks * 2, ks }
	key["\\"] = { kx * 14.5, 2 * keySize, ks * 1.05, ks }
	key["backspace"] = { kx * 14, keySize, ks * 1.7, ks }

	keyboardW = ks * 19.2
	keyboardH = ks * 6

	if self.numpad then
		key["kp0"] = { kx * 16.55, ky, ks * 2.25, ks }
		key["kp."] = { kx * 18.55, ky, ks, ks }
		key["kpenter"] = { kx * 19.55, 4 * keySize, ks, ks * 2.25 }
		key["kp+"] = { kx * 19.55, 2 * keySize, ks, ks * 2.25 }
		key["kp1"] = { kx * 16.55, 4 * keySize, ks, ks }
		key["kp2"] = { kx * 17.55, 4 * keySize, ks, ks }
		key["kp3"] = { kx * 18.55, 4 * keySize, ks, ks }
		key["kp4"] = { kx * 16.55, 3 * keySize, ks, ks }
		key["kp5"] = { kx * 17.55, 3 * keySize, ks, ks }
		key["kp6"] = { kx * 18.55, 3 * keySize, ks, ks }
		key["kp7"] = { kx * 16.55, 2 * keySize, ks, ks }
		key["kp8"] = { kx * 17.55, 2 * keySize, ks, ks }
		key["kp9"] = { kx * 18.55, 2 * keySize, ks, ks }
		key["kp="] = { kx * 16.55, 1 * keySize, ks, ks }
		key["kp/"] = { kx * 17.55, 1 * keySize, ks, ks }
		key["kp*"] = { kx * 18.55, 1 * keySize, ks, ks }
		key["kp-"] = { kx * 19.55, 1 * keySize, ks, ks }
		keyboardW = ks * 24.2
		keyboardH = ks * 6
	end

	if font.filename then
		font[1], font[2] = font.filename, font.size
	end
	fontObject = spherefonts.get(unpack(font))

	updateCanvas = true
end

function KeyboardView:receive(event)
	if event.name == "resize" then
		updateCanvas = true
	end

	if event.name == "keypressed" then
		keysDown[event[2] or event[1]] = true
		return
	end

	if event.name == "keyreleased" then
		keysDown[event[2] or event[1]] = false
		return
	end
end

function KeyboardView:update() end

local gfx = love.graphics

function KeyboardView:draw()
	if not love.window.hasFocus() then
		return
	end

	gfx.setColor({ 1, 1, 1, 1 })
	gfx.setFont(fontObject)
	gfx.setLineWidth(lineWidth)

	local prev_canvas = gfx.getCanvas()
	local canvas = gfx_util.getCanvas("keyboardView")

	if updateCanvas then
		gfx.setCanvas({ canvas, stencil = true })
		gfx.clear()
		gfx.origin()
		for k, key_rect in pairs(key) do
			gfx.rectangle("line", key_rect[1], key_rect[2], key_rect[3], key_rect[4], 4, 4)
			k = keyAlias[k] or k
			gfx_util.printFrame(k:upper(), key_rect[1], key_rect[2], key_rect[3], key_rect[4], "center", "center")
		end
		gfx.setCanvas({ prev_canvas, stencil = true })
		updateCanvas = false
	end

	local tf = transform(self.transform)
	gfx.replaceTransform(tf)
	gfx.translate(x, y)

	gfx.setColor({ 1, 1, 1, 0.5 })
	gfx.draw(canvas)

	gfx.setColor({ 1, 1, 1, 1 })

	for k, down in pairs(keysDown) do
		local key_rect = key[k]

		if key_rect and down then
			gfx.rectangle("line", key_rect[1], key_rect[2], key_rect[3], key_rect[4], 4, 4)
			k = keyAlias[k] or k
			gfx_util.printFrame(k:upper(), key_rect[1], key_rect[2], key_rect[3], key_rect[4], "center", "center")
		end
	end

	gfx.rectangle("line", keySize - 10, keySize - 10, keyboardW + 20, keyboardH + 20, 8, 8)
end

return KeyboardView
