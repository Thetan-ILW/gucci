return {
	audio = {
		adjustRate = 0.1,
		device = {
			buffer = 40,
			period = 10
		},
		midi = {
			constantVolume = false
		},
		mode = {
			primary = "bass_fx_tempo",
			secondary = "bass_sample"
		},
		sampleGain = 0,
		volume = {
			effects = 1,
			master = 0.4,
			metronome = 1,
			music = 1
		},
		volumeType = "linear"
	},
	editor = {
		audioOffset = 0,
		lockSnap = true,
		showTimings = true,
		snap = 1,
		speed = 1,
		time = 0,
		tool = "Select",
		waveform = {
			opacity = 0.5,
			scale = 0.5
		},
		waveformOffset = 0
	},
	gameplay = {
		actionOnFail = "none",
		analog_scratch = {
			act_period = 0.1,
			act_w = 0.3333333333333333,
			deact_period = 0.05,
			deact_w = 0.1111111111111111
		},
		autoKeySound = false,
		bga = {
			image = false,
			video = false
		},
		eventBasedRender = false,
		hp = {
			notes = 20,
			shift = false
		},
		lastMeanValues = 10,
		longNoteShortening = 0,
		noteskin = "base",
		offset = {
			input = 0,
			visual = 0
		},
		offsetScale = {
			input = false,
			visual = false
		},
		offset_audio_mode = {
			bass_fx_tempo = -0.02,
			bass_sample = 0
		},
		offset_format = {
			bms = 0,
			ksh = 0,
			mid = 0,
			ojn = 0,
			osu = 0.02,
			qua = 0.02,
			sm = -0.05,
			sph = 0
		},
		primaryTempo = 120,
		rate_type = "linear",
		ratingHitTimingWindow = 0.032,
		scaleSpeed = false,
		selected_filters = {},
		skin_resources_top_priority = false,
		speed = 1,
		speedType = "default",
		swapVelocityType = false,
		tempoFactor = "average",
		time = {
			pausePlay = 0.5,
			pauseRetry = 0.5,
			playPause = 0,
			playRetry = 0.5,
			prepare = 2
		}
	},
	graphics = {
		asynckey = false,
		blur = {
			gameplay = 0,
			result = 0,
			select = 0
		},
		cursor = "circle",
		dim = {
			gameplay = 0.8,
			result = 0,
			select = 0
		},
		dwmflush = false,
		fps = 240,
		mode = {
			flags = {
				borderless = false,
				centered = true,
				display = 1,
				fullscreen = false,
				fullscreentype = "exclusive",
				highdpi = false,
				msaa = 0,
				resizable = true,
				usedpiscale = true,
				vsync = 1
			},
			fullscreen = {
				height = 720,
				width = 1280
			},
			window = {
				height = 720,
				width = 1280
			}
		},
		perspective = {
			camera = false,
			pitch = 0,
			rx = false,
			ry = true,
			x = 0.5,
			y = 0.5,
			yaw = 0,
			z = -0.71407400337106
		},
		userInterface = "osu_ui",
		vsyncOnSelect = true
	},
	input = {
		offset = {
			decrease = "-",
			increase = "=",
			reset = "delete"
		},
		pause = "escape",
		playSpeed = {
			decrease = "f3",
			increase = "f4"
		},
		quickRestart = "`",
		screenshot = {
			capture = "f12",
			open = "lshift"
		},
		selectRandom = "f2",
		skipIntro = "space",
		timeRate = {
			decrease = "f5",
			increase = "f6"
		}
	},
	miscellaneous = {
		autoUpdate = false,
		discordPresence = true,
		muteOnUnfocus = false,
		showDebugMenu = false,
		showFPS = false,
		showNonManiaCharts = false,
		showTasks = false
	},
	select = {
		chart_preview = true,
		chartdiffs_list = false,
		collapse = true,
		diff_column = "enps_diff",
		locations_in_collections = false
	}
}
