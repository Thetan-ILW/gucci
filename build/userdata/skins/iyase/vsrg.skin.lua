local NoteSkinVsrg = require("sphere.models.NoteSkinModel.NoteSkinVsrg")
local BasePlayfield = require("sphere.models.NoteSkinModel.BasePlayfield")
local JustConfig = require("sphere.JustConfig")
local InputMode = require("ncdk.InputMode")

local root = (...):match("(.+)/.-")
local Bussy =
	love.filesystem.load(root .. "/lua_files/bussy/thetan/bussy/init.lua")(root .. "/lua_files/bussy/thetan/bussy/")

local function loadModule(path)
	return love.filesystem.load(root .. "/lua_files/" .. path)()
end

local config = JustConfig:fromFile(root .. "/vsrg.config.lua")

local getPP = loadModule("bussy/thetan/osuPP.lua")

local ValueView = require("sphere.views.ValueView")
local ImageView = loadModule("sphere/views/ImageView.lua")
local ImageValueView = loadModule("sphere/views/ImageValueView.lua")
local ImageProgressView = require("sphere.views.GameplayView.ImageProgressView")
local CircleProgressView = require("sphere.views.GameplayView.CircleProgressView")

local noteskin = NoteSkinVsrg({
	path = ...,
	name = "iyase",
	range = { -1, 1 },
	unit = 480,
	hitposition = config:get("hitposition"),
	config = config,
})

-- Column width for each input mode. If not defined in the table, defaultWidth will be used
local defaultWidth = 50
local inputModeWidth = {
	[1] = 50,
	[2] = 50,
	[3] = 50,
	[4] = 52,
	[5] = 44,
	[6] = 42,
	[7] = 40,
	[9] = 36,
	[10] = 35,
}

local noteHeight = 25

-- Which note to use on each column. 3 - yellow, 2 - blue, 1 - white
local columnNoteImage = {
	[1] = { 1 },
	[2] = { 2, 1 },
	[3] = { 2, 1, 2 },
	[4] = { 2, 1, 1, 2 },
	[5] = { 2, 1, 3, 1, 2 },
	[6] = { 2, 1, 3, 3, 1, 2 },
	[7] = { 1, 2, 1, 3, 1, 2, 1 },
	[8] = { 1, 2, 1, 3, 3, 1, 2, 1 },
	[9] = { 3, 1, 2, 1, 3, 1, 2, 1, 3 },
	[10] = { 3, 1, 2, 1, 3, 3, 1, 2, 1, 3 },
	[12] = { 3, 3, 1, 2, 1, 3, 3, 1, 2, 1, 3, 3 },
	[14] = { 3, 1, 2, 1, 2, 1, 3, 3, 1, 2, 1, 2, 1, 3 },
}

-- Lines that separates columns
local columnLineWidth = {
	[8] = { 0, 0, 0, 0, 1, 0, 0, 0, 0 },
	[9] = { 0, 1, 0, 0, 0, 0, 0, 0, 1, 0 },
	[10] = { 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 },
	[12] = { 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	[14] = { 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
}

local columnLineColor = { 0.6, 0.6, 0.6, 1 }

------------------------------------------
-- You probably don't want to go below this line
------------------------------------------

function noteskin.inputMode(inputMode)
	return true
end

local function getColumnNoteImageIndex(inputMode, index)
	local keys = columnNoteImage[inputMode]

	if keys then
		return keys[index] or 1
	end

	local center = inputMode / 2
	local centerInt = math.floor(center)
	local centerLeft = math.floor(math.floor(center) / 2)
	local centerRight = inputMode - centerLeft

	local colorArray

	if index <= centerLeft then
		colorArray = columnNoteImage[centerLeft]
	elseif index > centerLeft and index <= center then
		colorArray = columnNoteImage[centerInt - centerLeft]
		index = index - centerLeft
	elseif index >= center and index <= centerRight then
		colorArray = columnNoteImage[centerRight - centerInt]
		index = math.abs(index - centerRight) + 1
	elseif index > centerRight then
		colorArray = columnNoteImage[centerLeft]
		index = index - centerRight
	end

	return colorArray[index]
end

local function getColumnLines(inputMode)
	local linesW = columnLineWidth[inputMode]

	if not linesW and inputMode > 10 then
		linesW = {}

		local center = inputMode / 2
		local centerLeft = math.floor(math.floor(center) / 2)
		local centerRight = inputMode - centerLeft

		for i = 1, inputMode do
			local _i = i - 1
			if _i == center or _i == centerLeft or _i == centerRight then
				table.insert(linesW, 1)
			else
				table.insert(linesW, 0)
			end
		end
	end

	local linesH = {}
	local linesY = {}

	for _ = 1, inputMode do
		table.insert(linesH, 2000)
		table.insert(linesY, 0)
	end

	return linesW, linesH, linesY
end

local judges = {
	{ "miss", "mania-hit0-0@2x.png" },
	{ "5", "mania-hit50-0@2x.png" },
	{ "4", "mania-hit100-0@2x.png" },
	{ "3", "mania-hit200-0@2x.png" },
	{ "2", "mania-hit300-0@2x.png" },
	{ "1", "mania-hit300g-0@2x.png" },
}

function noteskin:load(inputMode)
	local drawUI = not config:get("hideUI")

	noteskin.pauseScreen = {
		type = "osu",
		overlay = root .. "/pause-overlay",
		overlayFail = root .. "/fail-background",
		continue = root .. "/pause-continue",
		retry = root .. "/pause-retry",
		back = root .. "/pause-back",
		loop = root .. "/pause-loop",
	}

	local im = InputMode(inputMode)
	local keys = im:getColumns()

	noteskin:setInput(im:getInputs())

	local notePath = config:get("noteImages")

	noteskin:setTextures({
		{ lightingN = { "lightingN-%d.png", { 0, 11 } } },
		{ lightingL = { "lightingL-%d.png", { 0, 29 } } },
		{ measure = "" },
		{ body1 = notePath .. "/long1c.png" },
		{ body2 = notePath .. "/long2c.png" },
		{ body3 = notePath .. "/long3c.png" },
		{ note1 = notePath .. "/note1.png" },
		{ note2 = notePath .. "/note2.png" },
		{ note3 = notePath .. "/note3.png" },
		{ tail = notePath .. "/noteT.png" },
	})

	noteskin:setImages({
		lightingN = { "lightingN" },
		lightingL = { "lightingL" },
		measure = { "measure" },
		body1 = { "body1" },
		body2 = { "body2" },
		body3 = { "body3" },
		note1 = { "note1" },
		note2 = { "note2" },
		note3 = { "note3" },
		tail = { "tail" },
	})

	noteskin:setBlendModes({
		lightingN = { "add", "alphamultiply" },
		lightingL = { "add", "alphamultiply" },
	})

	local columnWidth = {}
	local columnSpacing = { 0 }
	local shortNote = {}
	local longNoteHead = {}
	local longNoteBody = {}
	local longNoteTail = {}
	local longNoteStyle = {}
	local columnsBackground = {}
	local lightingScale = {}

	local width = inputModeWidth[keys] and inputModeWidth[keys] or (defaultWidth - (keys * 1.1))
	local columnStart = config:get("conveyorPosition") - (keys * 8)

	if columnStart < 0 then
		columnStart = 0
	end

	for i = 1, keys do
		table.insert(columnWidth, width)
		table.insert(columnSpacing, 0)
		table.insert(shortNote, "note" .. getColumnNoteImageIndex(keys, i))
		table.insert(longNoteHead, "note" .. getColumnNoteImageIndex(keys, i))
		table.insert(longNoteBody, "body" .. getColumnNoteImageIndex(keys, i))
		table.insert(longNoteStyle, 1)
		table.insert(longNoteTail, "tail")
		table.insert(columnsBackground, { 0, 0, 0, 0.8 })
		table.insert(lightingScale, 1)
	end

	noteskin:setColumns({
		offset = columnStart,
		align = "left",
		width = columnWidth,
		space = columnSpacing,
	})

	local function getFrame(a, deltaTime)
		if not a.range then
			return
		end
		return math.floor(deltaTime * a.rate) % a.frames * (a.range[2] - a.range[1]) / (a.frames - 1) + a.range[1]
	end

	local lightingNPixels = 105
	local lightingLPixels = 100

	function noteskin:setLighting(params)
		if params.range then
			params.frames = math.abs(params.range[2] - params.range[1]) + 1
		else
			params.frames = 1
		end
		local note = {
			Head = {
				x = function(a, b, column)
					local imageWidth = params.long and lightingLPixels or lightingNPixels
					return self.columns[column] - imageWidth + (self.width[column] / 2) --self.columns[column] -- self.width[column]
				end,
				y = self.hitposition + params.offset,
				sx = params.scale,
				sy = params.scale,
				ox = 0.5,
				oy = 0.5,
				r = 0,
				color = function()
					return { 1, 1, 1, 1 }
				end,
				image = function(timeState, noteView)
					local pressedTime = noteView.graphicalNote:getPressedTime()
					if not pressedTime then
						return
					end
					local deltaTime = timeState.currentTime - pressedTime
					if not params.long and deltaTime >= params.frames / params.rate then
						return
					end
					return params.image, getFrame(params, deltaTime)
				end,
			},
		}

		if not params.long then
			self.notes.ShortNoteLighting = note
		else
			self.notes.LongNoteLighting = note
		end
	end

	local rate = 1000 / math.max(170 / (11 + 1), 1000 / 60)
	noteskin:setLighting({
		image = "lightingN",
		scale = lightingScale,
		rate = rate,
		range = { 0, 11 },
		offset = -105,
	})

	noteskin:setLighting({
		image = "lightingL",
		scale = lightingScale,
		rate = rate,
		range = { 0, 11 },
		offset = -105,
		long = true,
	})

	noteskin:setShortNote({
		image = shortNote,
		h = noteHeight,
	})

	noteskin:setLongNote({
		head = longNoteHead,
		body = longNoteBody,
		tail = longNoteTail,
		scale = 1 / 1.6,
		h = noteHeight,
	})

	if config:get("measureLine") then
		noteskin:addMeasureLine({
			h = 2,
			color = { 0.5, 0.5, 0.5, 1 },
			image = "measure",
		})
	end

	local playfield = BasePlayfield(noteskin)
	local bussy = Bussy(playfield)

	playfield:addBga({
		transform = { { 1 / 2, -16 / 9 / 2 }, { 0, -7 / 9 / 2 }, 0, { 0, 16 / 9 }, { 0, 16 / 9 }, 0, 0, 0, 0 },
	})

	playfield:enableCamera() -- Everything that is defined between enableCamera() and disableCamera() will be affected by 3D camera.

	playfield:addColumnsBackground({
		color = columnsBackground,
	})

	local linesW, linesH, linesY = getColumnLines(keys)

	local columnLines = {
		mode = "symmetric",
		both = false,
		color = columnLineColor,
		image = {
			"pixel.png",
		},
		w = linesW,
		h = linesH,
		y = linesY,
	}

	playfield:addGuidelines(columnLines)

	playfield:addNotes()

	playfield:add(ImageView({
		x = columnStart,
		y = self.hitposition,
		w = width * keys,
		sy = 1,
		oy = 0.5,
		transform = playfield:newNoteskinTransform(),
		image = "mania-stage-hint@2x.png",
	}))

	if config:get("showLightings") then
		playfield:addLightings()
	end

	local stageImage = config:get("stageImages")

	stageImage = stageImage == "Default" and "mania-stage-right.png" or "Extra/mania-stage/" .. stageImage

	playfield:add(ImageView({
		x = columnStart + (width * keys),
		y = 480,
		sx = 480 / 768,
		h = 480,
		oy = 1,
		transform = playfield:newNoteskinTransform(),
		image = stageImage,
	}))

	if drawUI then
		playfield:addCombo(ImageValueView({
			transform = self.playField:newLaneCenterTransform(480),
			x = 0,
			y = config:get("comboPosition"),
			oy = 0.5,
			align = "center",
			scale = 0.8,
			overlap = 1,
			files = bussy:getImageFont(root .. "/combo"),
			subscreen = "gameplay",
		}))
	end

	playfield:disableCamera()

	if not drawUI then
		return
	end

	playfield:addScore(ImageValueView({
		transform = self.playField:newTransform(1024, 768, "right"),
		x = 1016,
		y = 0,
		scale = 1,
		align = "right",
		overlap = 4,
		files = bussy:getImageFont(root .. "/score"),
		subscreen = "gameplay",
	}))

	local accuracy = playfield:addAccuracy(ImageValueView({
		transform = self.playField:newTransform(1024, 768, "right"),
		x = config:get("accuracyX"),
		y = config:get("accuracyY"),
		scale = 0.6,
		align = config:get("accuracyAlign"),
		format = "%0.2f%%",
		overlap = 4,
		files = bussy:getImageFont(root .. "/score"),
		subscreen = "gameplay",
	}))

	function accuracy:value()
		local judge = bussy:getJudge(self.game)
		return judge.accuracy or 1
	end

	accuracy.multiplier = 100

	local max_size = 1.12
	local min_size = 0.75

	if not config:get("animatedJudge") then
		max_size = 1
		min_size = 1
	end

	bussy:addOsuJudgement({
		x = 0,
		y = config:get("judgePosition"),
		ox = 0.5,
		oy = 0.5,
		maxSize = max_size,
		size = 1,
		minSize = min_size,
		scale = config:get("judgeScale"),
		transform = playfield:newLaneCenterTransform(480),
		rate = 1,
		judgements = judges,
		subscreen = "gameplay",
	})

	playfield:addHpBar(ImageProgressView({
		x = columnStart + (width * keys) + 8,
		y = 478,
		sx = 480 / 768 * 0.7,
		sy = 480 / 768 * 0.7,
		r = -math.pi / 2,
		transform = playfield:newNoteskinTransform(),
		direction = "left-right",
		mode = "+",
		image = "scorebar-colour@2x.png",
		subscreen = "gameplay",
	}))

	if config:get("circleProgressBar") then
		playfield:addCircleProgressBar({
			x = config:get("circleProgressBarX"),
			y = config:get("circleProgressBarY"),
			r = 10 * 1.6,
			transform = playfield:newTransform(1024, 768, "right"),
			backgroundColor = { 1, 1, 1, 0.6 },
			foregroundColor = { 1, 1, 1, 1 },
			subscreen = "gameplay",
		})
	else
		playfield:addBaseElements({ "progress" })
	end

	if not config:get("judgeCountHide") then
		bussy:addJudgeCounter({
			x = columnStart + (width * keys) + config:get("judgeCountX"),
			y = config:get("judgeCountY"),
			w = 260,
			scale = noteskin.unit / 1080,
			transform = playfield:newNoteskinTransform(),
			font = { root .. "/Comfortaa-font/static/Comfortaa-Medium.ttf", 24 },
			subscreen = "gameplay",
		})
	end

	bussy:addEarlyLate({
		x = 0,
		y = config:get("earlyLatePosition"),
		scale = 480 / 1080,
		font = { root .. "/Comfortaa-font/static/Comfortaa-Medium.ttf", 24 },
		transform = self.playField:newLaneCenterTransform(480),
		subscreen = "gameplay",
	})

	bussy:addHitError({
		transform = playfield:newLaneCenterTransform(480),
		x = 0,
		y = config:get("hitErrorPosition"),
		w = config:get("hitErrorWidth"),
		h = config:get("hitErrorHeight"),
		origin = {
			w = 2,
			h = config:get("hitErrorHeight") / 0.8,
			color = { 1, 1, 1, 1 },
		},
		background = {
			color = { 0.1, 0.1, 0.1, config:get("hitErrorBackground") / 100 },
		},
		unit = 0.12,
		radius = config:get("hitErrorRadius"),
		count = config:get("hitErrorCount"),
		subscreen = "gameplay",
	})

	local anchor = config:get("ppCounterAnchor")
	local x = 10
	local baseline = 35
	local align = "left"
	local transform = playfield:newTransform(1920, 1080, "left")

	if anchor == "Right bottom" then
		x = 1800
		baseline = 1070
		align = "right"
		transform = playfield:newTransform(1920, 1080, "right")
	elseif anchor == "Right top" then
		x = 1800
		baseline = 130
		align = "right"
		transform = playfield:newTransform(1920, 1080, "right")
	elseif anchor == "Left bottom" then
		baseline = 1070
	end

	local pp = ValueView({
		x = x,
		baseline = baseline,
		limit = 100,
		align = align,
		format = "%i PP",
		subscreen = "gameplay",
		color = { 1, 1, 1, 1 },
		transform = transform,
		font = { root .. "/Comfortaa-font/static/Comfortaa-Medium.ttf", 28 },
	})

	function pp:value()
		local score_engine = self.game.rhythmModel.scoreEngine
		local total_notes = score_engine.noteChart.chartmeta.notes_count
		local judgements = score_engine.scoreSystem.judgements
		local score = judgements["osu!legacy OD9"].score
		local chartdiff = self.game.playContext.chartdiff
		local time_rate = self.game.playContext.rate

		return getPP(total_notes, chartdiff.osu_diff * time_rate, 9, score)
	end

	if not config:get("keyboardHide") then
		bussy:addKeyboard({
			x = (columnStart + (width * keys)) * (1080 / noteskin.unit) + config:get("keyboardX"),
			y = config:get("keyboardY"),
			numpad = config:get("keyboardNumpad"),
			keySize = config:get("keyboardSize") * 100,
			font = { root .. "/Comfortaa-font/static/Comfortaa-Bold.ttf", 32 * config:get("keyboardSize") },
		})
	end

	playfield:add(pp)
end

return noteskin
