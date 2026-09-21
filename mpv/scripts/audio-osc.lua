local msg = require 'mp.msg'

local function update_osc()
	local tracks = mp.get_property_native("track-list", {})
	local has_video = false

	for _, track in ipairs(tracks) do
		msg.info("track type: ", track.type)
		if track.type == "video" and track.image ~= true then
			has_video = true
			break
		end
	end

	if not has_video then
		mp.commandv("script-message", "osc-visibility", "always")
	end
end

mp.register_event("file-loaded", update_osc)
