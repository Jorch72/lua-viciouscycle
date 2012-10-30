local libtcod = locatedofile("libtcod")
local term = locatedofile("terminal")

local compass = {
h = {-1, 0},
j = {0, 1},
k = {0, -1},
l = {1, 0},
y = {-1, -1},
u = {1, -1},
b = {-1, 1},
n = {1, 1}
}
local player = {x=6, y=6}

term.settitle "Vicious Cycle"


map = {}
for i = 1, 20 do
	map[i] = {}
	for j = 1, 80 do
		if i == 1 or i == 20 or j == 1 or j == 80 then
			map[i][j] = "#"
		else
			map[i][j] = "."
		end
	end
end

local function arena(term)
	local hasquit = false
	local command = nil
	local function interactiveinput()
		local key, code = term.nbgetch()
		-- playerturn(player, key)

		if key == "Q" then
			hasquit = true
			return
		end

		if key ~= nil then

			local lowerkey = string.lower(key)
			local dir = compass[lowerkey]
			local radius = 1.00
			
			if dir ~= nil and map[player.y + dir[2]][player.x + dir[1]] == "." then
				player.x = player.x + dir[1]
				if player.x < 0 then player.x = 0 end
				player.y = player.y + dir[2]
				if player.y < 0 then player.y = 0 end
			end
		end
	end

	repeat
		-- rotinplace(screen[1], screen[3], .001)
		
		interactiveinput()
		
		
		term.erase()
		term.clip(0, 0, nil, nil, "square")
		
		for i = 1, 20 do
			for j = 1, 80 do
				term.fg(255, 255, 255).bg(0,0,0).at(j, i).print(map[i][j])
			end
			term.cr()
		end
		term.fg(255,178,0).bg(0,0,0).at(player.x, player.y).print("@")

		local w, h = term.getsize() -- current "square" terminal
		term.clip(w, 0, nil, nil)

		term.at(0, 0).fg(255,255,255).bg(0,0,0).print("FPS: " .. term.tcod.TCOD_sys_get_fps()).cr()
		term.clip()

		term.refresh()
		term.napms(15)
	until hasquit
end

arena(term)
term.erase()
term.refresh()
term.endwin()

