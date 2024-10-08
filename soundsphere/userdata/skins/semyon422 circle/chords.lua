local chords = {}

local start_type_to_suffix = {
	[0] = 1,
	[1] = 2,
	[-1] = 0,
}

local end_type_to_suffix = {
	[0] = 0,
	[1] = 0,
	[-1] = 3,
}

function chords.get_suffix(c, column)
	local l, m, r = c[column - 1], c[column], c[column + 1]
	if not m then
		return "_00"
	end

	local tts = start_type_to_suffix
	if m.weight == -1 then
		tts = end_type_to_suffix
	end

	local a, b = 0, 0
	if l then
		a = tts[l.weight] or 0
	end
	if r then
		b = tts[r.weight] or 0
	end

	return "_" .. a .. b
end

local noChord = {}
function chords.get_start_chord(noteView)
	local startTime = noteView.graphicalNote.startNote:getTime()
	local chord = noteView.chords[startTime]
	if not chord then
		return noChord
	end

	local sc = {}

	for i, nds in pairs(chord) do
		local head = nds[1]
		if head.startNote:getTime() == startTime then
			sc[i] = head.startNote
		end
	end

	return sc
end

function chords.get_middle_chord(noteView)
	local startTime = noteView.graphicalNote.startNote:getTime()
	local endTime = noteView.graphicalNote.endNote:getTime()

	local sc = noteView.chords[startTime] or noChord
	local ec = noteView.chords[endTime] or noChord

	local mc = {}

	for i, nds in pairs(sc) do
		local head = nds[1]
		local tail = ec[i] and ec[i][1]
		if head == tail then
			mc[i] = tail.endNote
		end
	end

	return mc
end

return chords
