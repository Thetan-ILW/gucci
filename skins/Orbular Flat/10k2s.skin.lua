local NoteSkinVsrg = require("sphere.models.NoteSkinModel.NoteSkinVsrg")
local BasePlayfield = require("sphere.models.NoteSkinModel.BasePlayfield")
local noteskin = NoteSkinVsrg({
	path = ...,
	name = "Orbular Flat - 10K",
	inputMode = "10key",
	range = {-1, 1},
	unit = 480,
	hitposition = 467,
})
local root = (...):match("(.+)/.-")

noteskin:setInput({
	"key1",
	"key2",
	"key3",
	"key4",
	"key5",
	"key6",
	"key7",
	"key8",
	"key9",
	"key10",
})

noteskin:setColumns({
	offset = 0,
	align = "center",
	width = {54,54,54,54,54,54,54,54,54,54},
	space = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
})

noteskin:setTextures({
	{pixel = "pixel.png"},
	{L1 = "L1.png"},
	{L2 = "L2.png"},
	{L3 = "L3.png"},
	{L4 = "L4.png"},
	{B1 = "B1.png"},	
	{N1 = "N1.png"},
	{N2 = "N2.png"},
	{N3 = "N3.png"},
	{N4 = "N4.png"},
	{H1 = "H1.png"},
	{H2 = "H2.png"},
	{H3 = "H3.png"},
	{H4 = "H4.png"},

	
})

noteskin:setImagesAuto()

noteskin:setShortNote({
	image = {
		"N2",
		"N1",
		"N2",
		"N1",
		"N3",
		"N4",
		"N1",
		"N2",
		"N1",
		"N2",
	},
	h = 54,
})

noteskin:setLongNote({
	body = {
		"L2",
		"L1",
		"L2",
		"L1",
		"L3",
		"L4",
		"L1",
		"L2",
		"L1",
		"L2",
	},	
	head = {
		"N2",
		"N1",
		"N2",
		"N1",
		"N3",
		"N4",
		"N1",
		"N2",
		"N1",
		"N2",
	},

	tail = {
		"B1",
		"B1",
		"B1",
		"B1",
		"B1",
		"B1",
		"B1",
		"B1",
		"B1",
		"B1",
	},
	style = "stretch",
	h = 54,
})

local playfield = BasePlayfield(noteskin)


playfield:addColumnsBackground({
    color = {{.0157, .0157, .0157, 1}, 
			 {.0353, .0353, .0353, 1}, 
			 {.0157, .0157, .0157, 1}, 
			 {.0353, .0353, .0353, 1}, 
			 {.0157, .0157, .0157, 1},  
			 {.0157, .0157, .0157, 1}, 
			 {.0353, .0353, .0353, 1}, 
			 {.0157, .0157, .0157, 1}, 
			 {.0353, .0353, .0353, 1}, 
			 {.0157, .0157, .0157, 1}, }
})

playfield:enableCamera()
playfield:addNotes()
playfield:addKeyImages({
	h = 511,
	padding = 0,
	pressed = {
		"K2.png",
		"K2.png",
		"K2.png",
		"K2.png",
		"K2.png",
		"K2.png",
		"K2.png",
		"K2.png",
		"K2.png",
		"K2.png",
	},
	released = {
		"K1.png",
		"K1.png",
		"K1.png",
		"K1.png",
		"K1.png",
		"K1.png",
		"K1.png",
		"K1.png",
		"K1.png",
		"K1.png",
	},
})

playfield:addGuidelines({
    y = {0,0,0,0,0,0,0,0,0,0,0,0,0},
    w = {4,4,4,4,4,4,4,4,4,4,4,4},
    h = {480,0,0,0,0,0,0,0,0,0,480},
    image = {},
	color = {1,1,1,.7},
    both = true,
    mode = "symmetric",
})
playfield:disableCamera()

local function hitcolor(value, unit)	
    if value < -0.12 then
        return {0.1, 0.81, 0.5, 1}
    elseif value < -0.085 then
        return {0.1, 0.81, 0.5, 1}
    elseif value < -0.056 then
        return {0.1, 0.81, 0.5, 1}
	elseif value < -0.033 then
        return {0.1, 0.81, 0.5, 1}
    elseif value < -0.016 then
        return {0.1, 0.81, 0.5, 1}
    elseif value < -0.011 then
        return {0.33, 0.87, 1, 1}
    elseif value <= 0.011 then
        return {1, 1, 1, 1}
    elseif value <= 0.016 then
        return {0.33, 0.87, 1, 1}
	elseif value < 0.033 then
        return {1, 0.6, 0.4, 1}
    elseif value <= 0.056 then
        return {1, 0.6, 0.4, 1}
    elseif value <= 0.085 then
        return {1, 0.6, 0.4, 1}
    elseif value <= 0.12 then
        return {1, 0.6, 0.4, 1}
    else
        return {1, 0.6, 0.4, 1}
    end
end


playfield:addCombo({
	x = -540,
	baseline = 590,
	limit = 1080,
	align = "center",
	font = {
		filename = root .. "/SourceCodePro-Black.ttf",
		size = 60
	},
	transform = playfield:newLaneCenterTransform(1080),
	unit = 0.12,
	color = {1, 1, 1, 0.4},
})


playfield:addProgressBar({
	x = 0,
	y = 1072	,
	w = 1920,
	h = 50,
	color = {.78, .68, .42, .23},
	transform = playfield:newFullTransform(1920, 1080),
	direction = "left-right",
	mode = "+"
})

local hitH = 12
playfield:addHitError({
	transform = playfield:newLaneCenterTransform(480),
	x = 0,
	y = 473 - hitH / 2,
	w = 45 * 4,
	h = hitH+2,
	origin = {
		w = 2,
		h = hitH+3,
		color = {.18, .55, .84, 1}
	},
	background = {
		color = {0.25, 0.25, 0.25, 0}
	},
    unit = 0.12,
    color = hitcolor,
    radius = 4,
    count = 35,
	
})

playfield:addScore({
	x = 0,
	baseline = 52,
	limit = 1906,
	align = "right",
	
	font = {
	filename = root .. "/SourceCodePro-Black.ttf",
	size = 48
	},
	transform = playfield:newTransform(1920, 1080, "right")
})

playfield:addDeltaTimeJudgement({
	-- h was 75
	x = 0, y = 620, ox = 0.5, oy = 0.5,h = 75, w = 220,
	rate = .5,
	transform = playfield:newLaneCenterTransform(1080),
	judgements = {

		-0.050,
		"B1.png",
		-0.032,
		"judgements/-1.png",
		-0.016,
		"judgements/0.png",
		-0.011,
		"judgements/0.png",
		0.011,
		"judgements/0.png",
		0.016,
		"judgements/1.png",
		0.032,
		"B1.png",
		0.050,

	}
})


playfield:addBaseElements({"match players"})
return noteskin
