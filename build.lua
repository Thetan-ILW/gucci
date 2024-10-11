---@param file string
---@return boolean
---@return string?
local function fileExists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end
	return ok, err
end

---@param path string
---@return boolean
---@return string?
local function dirExists(path)
	return fileExists(path .. "/")
end

local script_path = "/media/SSD/Dev/gucci_mania"
local function symlink(source, dest)
	os.execute(("ln -s %s/%s %s"):format(script_path, source, dest))
end

local function copyDir(source, dest)
	os.execute(("cp -rf %s %s"):format(source, dest))
end

local function copyFile(source, dest)
	os.execute(("cp %s %s"):format(source, dest))
end

local function mkdir(name)
	os.execute(("mkdir %s"):format(name))
end

local function replaceWithGucci(file)
	os.execute(("sed -i 's/soundsphere/gucci!mania/g' %s"):format(file))
end

local function help()
	print("Build script for gucci!mania\nAvailable options:")
	print("	-b build	Build the entire project and pack everything into one game.love archive")
	print(" -tb test-build	Build the project, but without packing files into game.love")
	print("	-r run		Run the test build")
	print("	-d download	Download base soundsphere with all required plugins.")
	print("	-u update	Update plugins")
	print("\nYou can use options sequentially: `luajit build.lua download build run`")
end

local plugins = {
	{ name = "osuUI", link = "https://github.com/Thetan-ILW/osu_ui" },
	{ name = "PlayerProfile", link = "https://github.com/Thetan-ILW/PlayerProfile-soundsphere" },
	{ name = "MinaCalc", link = "https://github.com/Thetan-ILW/MinaCalc-soundsphere" },
	{ name = "ManipFactor", link = "https://github.com/Thetan-ILW/ManipFactorEtterna-soundsphere" }
}

---@return boolean error
---@nodiscard
local function download()
	print("INFO: Downloading soundsphere")
	os.execute("curl --output soundsphere.zip https://dl.soundsphere.xyz/soundsphere.zip")

	if not fileExists("soundsphere.zip") then
		print("ERROR: Failed to download soundsphere.")
		return true
	end

	if dirExists("soundsphere") then
		print("INFO: Deleting previous soundsphere files")
		os.execute("rm -rf soundsphere")
	end

	os.execute("unzip soundsphere.zip")

	if not dirExists("soundsphere") then
		print("ERROR: Failed to unpack soundsphere.zip")
		return true
	end

	print("INFO: Downloading/Updating plugins")

	for i, v in ipairs(plugins) do
		if dirExists(("pkg/%s"):format(v.name)) then
			print("INFO: Updating", v.name)
			os.execute(("cd pkg/%s;git fetch;git pull"):format(v.name))
		else
			os.execute(("git clone %s pkg/%s"):format(v.link, v.name))
		end
	end

	return false
end

local function updatePlugins()
	for i, v in ipairs(plugins) do
		if dirExists(("pkg/%s"):format(v.name)) then
			print("INFO: Updating", v.name)
			os.execute(("cd pkg/%s;git fetch;git pull"):format(v.name))
		end
	end
end

local function build() -----------------------------------------------------------------
	if dirExists("build") then
		os.execute("rm -rf build")
	end
	if dirExists("temp") then
		os.execute("rm -rf temp")
	end

	mkdir("build")
	copyDir("soundsphere/bin", "build/bin")
	copyFile("pkg/MinaCalc/minacalc/bin/linux64/libminacalc.so", "build/bin/linux64/libminacalc.so")
	copyFile("pkg/MinaCalc/minacalc/bin/win64/libminacalc.dll", "build/bin/win64/libminacalc.dll")
	copyFile("soundsphere/conf.lua", "build/conf.lua")

	os.execute("unzip soundsphere/game.love -d temp/")
	copyDir("soundsphere/resources", "temp")
	copyDir("love/*", "temp")
	replaceWithGucci("temp/sphere/app/WindowModel.lua")
	replaceWithGucci("temp/sphere/persistence/CacheModel/LocationManager.lua")
	os.execute("sed -i 's/594443609668059149/1294208452503273483/g temp/sphere/app/DiscordModel.lua'")
	os.execute("cd temp && zip -r ../build/game.love .")

	mkdir("build/userdata")
	mkdir("build/userdata/pkg")
	copyDir("pkg/*", "build/userdata/pkg")
	copyDir("gucci", "build/userdata/pkg")
	copyDir("assets", "build/userdata/pkg/osuUI/osu_ui")
	replaceWithGucci("build/userdata/pkg/osuUI/osu_ui/localization/en.lua")
	replaceWithGucci("build/userdata/pkg/osuUI/osu_ui/localization/ru.lua")

	print("INFO: Build created")
end -----------------------------------------------------------------------------------

local function buildTest()
	if dirExists("test_build") then
		os.execute("rm -rf test_build")
	end

	mkdir("test_build")
	copyDir("soundsphere/bin", "test_build/bin")
	copyFile("pkg/MinaCalc/minacalc/bin/linux64/libminacalc.so", "test_build/bin/linux64/libminacalc.so")
	copyFile("pkg/MinaCalc/minacalc/bin/win64/libminacalc.dll", "test_build/bin/win64/libminacalc.dll")
	copyDir("soundsphere/resources", "test_build/resources")

	mkdir("test_build/userdata")
	copyDir("soundsphere/userdata/hitsounds", "test_build/userdata/hitsounds")
	copyDir("pkg", "test_build/userdata/pkg")
	copyDir("assets", "test_build/userdata/pkg/osuUI/osu_ui")
	copyDir("userdata", "test_build")

	copyFile("soundsphere/game.love", "test_build/game.love")
	copyFile("soundsphere/conf.lua", "test_build/conf.lua")
	copyFile("soundsphere/game-linux", "test_build/game-linux")
	copyFile("soundsphere/game-win64.bat", "test_build/game-win64.bat")
	print("INFO: Test build created")
end

local function run()
	os.execute("export SDL_VIDEODRIVER=wayland;sh test_build/game-linux")
end

local function processArguments()
	if #arg == 0 then
		print("ERROR: No command line arguments were provided. Type `build.lua -h` to see available options.")
	end

	for i, v in ipairs(arg) do
		if v == "-h" or v == "help" then
			help()
			break
		elseif v == "-d" or v == "download" then
			local err = download()
			if err then
				break
			end
		elseif v == "-u" or v == "update" then
			updatePlugins()
		elseif v == "-b" or v == "build" then
			build()
		elseif v == "-tb" or v == "test-build" then
			buildTest()
		elseif v == "-r" or v == "run" then
			run()
		end
	end
end

if jit.os ~= "Linux" then
	print("ERROR: This script can only run on the Linux OS")
	return
end

processArguments()
