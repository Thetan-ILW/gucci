local JustConfig = require("sphere.JustConfig")

local success, imgui = pcall(require, "thetan.irizz.imgui")

if not success then
	imgui = require("imgui")
end

local just = require("just")

local config = JustConfig()
local root = (...):match("(.+)/.-")

config.data = --[[data]]
	{
		accuracyAlign = "right",
		accuracyX = 1010,
		accuracyY = 42,
		acuracyAlign = "right",
		animatedJudge = true,
		autosave = true,
		cheatLns = false,
		circleProgressBar = true,
		circleProgressBarX = 877,
		circleProgressBarY = 54,
		comboPosition = 207,
		conveyorPosition = 130,
		earlyLatePosition = 240,
		hideUI = false,
		hitErrorBackground = 24,
		hitErrorCount = 10,
		hitErrorHeight = 20,
		hitErrorPosition = 460,
		hitErrorRadius = 2,
		hitErrorWidth = 222,
		hitposition = 450,
		judgeCountHide = false,
		judgeCountX = 29,
		judgeCountY = 260,
		judgePosition = 175,
		judgeScale = 0.5,
		keyboardHide = false,
		keyboardNumpad = false,
		keyboardSize = 0.46,
		keyboardX = 29,
		keyboardY = 262,
		measureLine = false,
		noteImages = "mania",
		ppCounterAnchor = "Right bottom",
		showLightings = true,
		stageImages = "mania-stage-right2.png",
	} --[[/data]]

local alignList = {
	"left",
	"center",
	"right",
}

local anchorList = {
	"Left top",
	"Right top",
	"Left bottom",
	"Right bottom",
}

local noteImagesList = {
	"mania",
	"mania2",
	"mania3",
}

local maniaStages = love.filesystem.getDirectoryItems(root .. "/Extra/mania-stage/")
table.insert(maniaStages, "Default")

function config:draw(w, h)
	local data = self.data

	just.text("iyase skin settings:")

	imgui.setSize(w, h, w / 2, 55)
	just.next(0, 10)
	data.noteImages = imgui.combo("noteImages", data.noteImages, noteImagesList, nil, "Note images")
	data.conveyorPosition =
		imgui.slider1("conveyorPosition", data.conveyorPosition, "%d", -240, 240, 1, "Conveyor position")
	data.hitposition = imgui.slider1("hitposition", data.hitposition, "%d", 240, 480, 1, "Hit position")
	data.comboPosition = imgui.slider1("comboPosition", data.comboPosition, "%d", 0, 480, 1, "Combo position")
	data.circleProgressBar = imgui.checkbox("circleProgressBar", data.circleProgressBar, "Circle progress bar")
	data.measureLine = imgui.checkbox("measureLine", data.measureLine, "Measure line")
	data.showLightings = imgui.checkbox("showLightings", data.showLightings, "Show lightings")
	data.hideUI = imgui.checkbox("hideUI", data.hideUI, "Hide UI")

	imgui.separator()
	just.text("Judgement:")
	just.next(0, 10)
	data.animatedJudge = imgui.checkbox("animatedJudge", data.animatedJudge, "Judge animation")
	data.judgePosition = imgui.slider1("judgePosition", data.judgePosition, "%d", 0, 480, 1, "Judge position")
	data.judgeScale = imgui.slider1("judgeScale", data.judgeScale * 100, "%d%%", 0, 200, 1, "Judge scale") / 100

	imgui.separator()
	just.text("Accuracy:")
	just.next(0, 10)
	data.accuracyAlign = imgui.combo("accuracyAlign", data.accuracyAlign, alignList, nil, "Accuracy align")
	data.accuracyX = imgui.slider1("accuracyX", data.accuracyX, "%d", 0, 1010, 1, "Accuracy X position")
	data.accuracyY = imgui.slider1("accuracyY", data.accuracyY, "%d", 0, 768, 1, "Accuracy Y position")

	imgui.separator()
	just.text("Hit error:")
	just.next(0, 10)
	data.hitErrorPosition =
		imgui.slider1("hitErrorPosition", data.hitErrorPosition, "%d", 0, 480, 1, "Hit error position")
	data.hitErrorWidth = imgui.slider1("hitErrorWidth", data.hitErrorWidth, "%d", 0, 720, 1, "Hit error width")
	data.hitErrorHeight = imgui.slider1("hitErrorHeight", data.hitErrorHeight, "%d", 0, 50, 1, "Hit error height")
	data.hitErrorBackground =
		imgui.slider1("hitErrorBackground", data.hitErrorBackground, "%d%%", 0, 100, 1, "Hit error BG alpha")
	data.hitErrorCount = imgui.slider1("hitErrorCount", data.hitErrorCount, "%d", 1, 64, 1, "Hit error count")
	data.hitErrorRadius = imgui.slider1("hitErrorRadius", data.hitErrorRadius, "%d", 1, 8, 1, "Hit error radius")

	imgui.separator()
	just.text("Judge counter:")
	just.next(0, 10)
	data.judgeCountHide = imgui.checkbox("judgeCountHide", data.judgeCountHide, "Hide")
	data.judgeCountX = imgui.slider1("judgeCountX", data.judgeCountX, "%d", 0, 240, 1, "Judge counter X")
	data.judgeCountY = imgui.slider1("judgeCountY", data.judgeCountY, "%d", 0, 480, 1, "Judge counter Y")

	imgui.separator()
	just.text("Keyboard overlay:")
	just.next(0, 10)
	data.keyboardHide = imgui.checkbox("keyboardHide", data.keyboardHide, "Hide")
	data.keyboardNumpad = imgui.checkbox("keyboardNumpad", data.keyboardNumpad, "Show numpad")
	data.keyboardX = imgui.slider1("keyboardX", data.keyboardX, "%d", 0, 1024, 1, "Keyboard X position")
	data.keyboardY = imgui.slider1("keyboardY", data.keyboardY, "%d", 0, 768, 1, "Keyboard Y position")
	data.keyboardSize = imgui.slider1("keyboardSize", data.keyboardSize * 100, "%d%%", 0, 100, 1, "Keyboard size") / 100

	imgui.separator()
	just.text("Other:")
	just.next(0, 10)
	data.earlyLatePosition =
		imgui.slider1("earlyLatePosition", data.earlyLatePosition, "%d", 0, 720, 1, "Early/Late position")

	data.circleProgressBarX =
		imgui.slider1("circleProgressBarX", data.circleProgressBarX, "%d", 0, 1280, 1, "Circle progress bar X")

	data.circleProgressBarY =
		imgui.slider1("circleProgressBarY", data.circleProgressBarY, "%d", 0, 1280, 1, "Circle progress bar Y")

	data.stageImages = imgui.combo("stageImages", data.stageImages, maniaStages, nil, "Stage images")
	data.ppCounterAnchor = imgui.combo("ppCounterAnchor", data.ppCounterAnchor, anchorList, nil, "osu!PP position")

	imgui.separator()
	just.next(0, 5)
	if imgui.button("Write config file", "Write") then
		self:write()
	end

	just.sameline()
	just.next(10)
	just.sameline()
	just.text("<< Don't forget to press this button!")
end

return config
