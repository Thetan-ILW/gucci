local winapi = require("winapi")

local gucci = {}

---@param path string
---@return table?
function gucci.readOsuConfig(path)
	local osu_config = winapi.open(path, "r")

	if osu_config == nil then
		return
	end

	---@type string?
	local line = osu_config:read()
	---@type {[string]: any}
	local c = {}

	while(line) do
		if line:sub(1, 1) ~= "#" then
			local kv_split = line:split("=")
			if #kv_split == 2 then
				local k = kv_split[1]:sub(1, -2)
				local v = kv_split[2]:sub(2)
				c[k] = v
			end
		end

		line = osu_config:read()
	end

	return {
		volume = {
			master = (c.VolumeUniversal or 100) / 100,
			music = (c.VolumeMusic or 80) / 100,
			effect = (c.VolumeEffect or 80) / 100,
		},
		osu = {
			cursorSize = c.CursorSize or 1,
		},
		gameplay = {
			dim = (c.DimLevel or 80) / 100,
			scrollSpeed = c.ManiaSpeed or 12,
			skin = c.Skin or "User"
		},
	}
end

function gucci.findOtherGames()
	local games = {}

	local osu_reg_path = winapi.get_reg_value_sz(
		winapi.hkey.HKEY_CLASSES_ROOT,
		"osu\\shell\\open\\command"
	)

	if osu_reg_path then
		local split = string.split(osu_reg_path, '"')
		if #split > 1 then
			games["osu!"] = split[2]:gsub("osu!.exe", ""):gsub("\\", "/")
		end
	end

	local etterna_reg_path = winapi.get_reg_value_sz(
		winapi.hkey.HKEY_LOCAL_MACHINE,
		"SOFTWARE\\WOW6432Node\\Etterna Team\\Etterna"
	)

	if etterna_reg_path then
		games["Etterna"] = etterna_reg_path
	end

	local quaver_reg_path = winapi.get_reg_value_sz(
		winapi.hkey.HKEY_CURRENT_USER,
		"SOFTWARE\\Classes\\quaver\\shell\\open\\command"
	)

	if quaver_reg_path then
		local split = string.split(quaver_reg_path, '"')
		if #split > 1 then
			games["Quaver"] = split[2]:gsub("Quaver.exe", ""):gsub("\\", "/")
		end
	end

	return games
end

function gucci.setDefaultSettings(configs)
	local settings = configs.settings
	local volume = settings.audio.volume
	volume.master = 0.5

	local gameplay = settings.gameplay
	gameplay.speed = 2.041666666666667
	gameplay.speedType = "osu"

	local graphics = settings.graphics
	graphics.dim.gameplay = 1
	graphics.dim.select = 0.35
	graphics.dim.result = 0.35

	settings.miscellaneous.autoUpdate = false
	settings.select.diff_column = "msd_diff"
	settings.select.chart_preview = false

	local osu = configs.osu_ui
	osu.scoreSystem = "osu!legacy"
	osu.judgement = 8
	osu.songSelect.scoreSource = "osuv1"

	configs.select.judgements = "osu!legacy OD8"
	configs.play.timings = {
		LongNoteEnd = {
			hit = {
				-0.127,
				0.103
			},
			miss = {
				-0.164,
				0.103
			}
		},
		LongNoteStart = {
			hit = {
				-0.127,
				0.103
			},
			miss = {
				-0.164,
				0.103
			}
		},
		ShortNote = {
			hit = {
				-0.127,
				0.103
			},
			miss = {
				-0.164,
				0.103
			}
		},
		nearest = false
	}
end

return gucci
