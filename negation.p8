pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
--this is the new ver.
--------------------------------------------------------------------------------
--------------------------------- global variables  ----------------------------
--------------------------------------------------------------------------------
player = {}
player.sprite = 0
player.x = 8
player.y = 8
player.speed = 1
player.current_speed = 0
player.angle = 0
player.turnspeed = 10
player.current_dash_speed = 0
player.dash_speed = 15
player.dash_threshold = {.05, .2}
player.bullet_spread = 5
player.health = 10
player.immune_time = 2
player.last_hit = 0
player.b_count = 0
player.tokens = 0

wall_fwd = false
wall_bck = false

cheats = {}
cheats.noclip = false
cheats.god = false

map_ = {}
map_.border = {}
map_.border.left = 0
map_.border.up = 0
map_.border.right = 120
map_.border.down = 120
map_.sx = 0
map_.sy = 0

wait = {}
wait.controls = false
wait.dialog_finish = false

-- controls
c = {}
c.left_arrow = 0
c.right_arrow = 1
c.up_arrow = 2
c.down_arrow = 3
c.z_button = 4
c.x_button = 5

title = {}
title.title_step = 0
title.startx = 20
title.starty = 20
title.text =    {{14,14,14,14, 0, 0, 0,14,14,14, 0,14,14,14,14,14,14,14, 0, 14,14,14,14,14,14,14,14, 0, 0,14,14,14,14,14, 0, 0,14,14,14,14,14,14,14, 0,14,14,14,14,14,14,14, 0, 0,14,14,14,14, 0, 0,14,14,14,14, 0, 0, 0,14,14,14},
                 {14, 1, 1, 1,14, 0, 0,14, 1,14, 0,14, 1, 1, 1, 1, 1,14, 0, 14, 1, 1, 1, 1, 1, 1,14, 0,14, 1, 1, 1, 1, 1,14, 0,14, 1, 1, 1, 1, 1,14, 0,14, 1, 1, 1, 1, 1,14, 0,14, 1, 1, 1, 1,14, 0,14, 1, 1, 1,14, 0, 0,14, 1,14},
                 {14, 1, 1, 1, 1,14, 0,14, 1,14, 0,14, 1,14,14,14,14,14, 0, 14, 1,14,14,14,14,14,14, 0,14, 1, 1,14, 1, 1,14, 0,14,14,14, 1,14,14,14, 0,14,14,14, 1,14,14, 0, 0,14, 1,14,14, 1,14, 0,14, 1, 1, 1, 1,14, 0,14, 1,14},
                 {14, 1,14,14, 1, 1,14,14, 1,14, 0,14, 1,14, 0, 0, 0, 0, 0, 14, 1,14, 0, 0, 0, 0, 0, 0,14, 1, 1, 1, 1, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0, 0, 0,14, 1,14, 0, 0, 0,14, 1,14,14, 1,14, 0,14, 1,14,14, 1, 1,14,14, 1,14},
                 {14, 1,14, 0,14, 1, 1, 1, 1,14, 0,14, 1,14,14,14, 0, 0, 0, 14, 1,14, 0,14,14,14,14, 0,14, 1, 1,14, 1, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0, 0, 0,14, 1,14, 0, 0, 0,14, 1,14,14, 1,14, 0,14, 1,14, 0,14, 1, 1, 1, 1,14},
                 {14, 1,14, 0,14, 1, 1, 1, 1,14, 0,14, 1, 1, 1,14, 0, 0, 0, 14, 1,14, 0,14, 1, 1,14, 0,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0, 0, 0,14, 1,14, 0, 0, 0,14, 1,14,14, 1,14, 0,14, 1,14, 0,14, 1, 1, 1, 1,14},
                 {14, 1,14, 0, 0,14, 1, 1, 1,14, 0,14, 1,14,14,14, 0, 0, 0, 14, 1,14, 0,14,14, 1,14, 0,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0, 0, 0,14, 1,14, 0, 0, 0,14, 1,14,14, 1,14, 0,14, 1,14, 0, 0,14, 1, 1, 1,14},
                 {14, 1,14, 0, 0, 0,14, 1, 1,14, 0,14, 1,14, 0, 0, 0, 0, 0, 14, 1,14, 0, 0,14, 1,14, 0,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0, 0, 0,14, 1,14, 0, 0, 0,14, 1,14,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1, 1,14},
                 {14, 1,14, 0, 0, 0,14, 1, 1,14, 0,14, 1,14,14,14,14,14, 0, 14, 1,14,14,14,14, 1,14, 0,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0,14,14,14, 1,14,14,14, 0,14, 1,14,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1, 1,14},
                 {14, 1,14, 0, 0, 0, 0,14, 1,14, 0,14, 1, 1, 1, 1, 1,14, 0, 14, 1, 1, 1, 1, 1, 1,14, 0,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0,14, 1, 1, 1, 1, 1,14, 0,14, 1, 1, 1, 1,14, 0,14, 1,14, 0, 0, 0, 0,14, 1,14},
                 {14,14,14, 0, 0, 0, 0, 0,14,14, 0,14,14,14,14,14,14,14, 0, 14,14,14,14,14,14,14,14, 0,14,14,14, 0,14,14,14, 0, 0, 0,14,14,14, 0, 0, 0,14,14,14,14,14,14,14, 0, 0,14,14,14,14, 0, 0,14,14,14, 0, 0, 0, 0, 0,14,14}}
title.height = #title.text
title.width = #title.text[1]
title.drawn = {}
title.row = 0
title.drawn.x = {}
title.drawn.y = {}
title.drawn.colors = {}

player.last_time = {[c.left_arrow] = 0,
                    [c.right_arrow] = 0,
                    [c.up_arrow] = 0,
                    [c.down_arrow] = 0}

player.dashing = {[c.left_arrow] = false,
                  [c.right_arrow] = false,
                  [c.up_arrow] = false,
                  [c.down_arrow] = false}

enemy_table  = {}
enemy_spawned = {}
player_bullets = {}
enemy_bullets = {}
destroyed_bosses = {}
destroyed_enemies = {}
boss_hit_anims = {}
exploding_enemies = {}

highlighted = 10
currently_selected = 1
skills_selected = {true, false, false}

-- define some constants
pi = 3.14159265359
inf = 32767.99 -- max number as defined in https://neko250.github.io/pico8-api/

--------------------------------------------------------------------------------
------------------------ object-like structures --------------------------------
--------------------------------------------------------------------------------
--[[
  node object
]]
function node(x, y)
  local n = {}
  n.x = x
  n.y = y
  n.distance = function(d)
                  return sqrt((n.x-d.x)*(n.x-d.x)+(n.y-d.y)*(n.y-d.y)) -- use euclidean distance for now
               end
  n.equals = function(onode)
                if n.x == onode.x and n.y == onode.y then
                  return true
                else
                  return false
                end
              end
  return n
end

--[[
  enemy object
]]
function enemy(spawn_x, spawn_y, type, time)
  local e = {}
  e.x = spawn_x
  e.y = spawn_y
  e.speed = .35
  e.time = time
  e.destroy_anim_length = 15
  e.destroyed_step = 0
  e.destroy_sequence = {135, 136, 135}
  e.shoot_distance = 50
  e.explode_distance = 15
  e.explode_wait = 15
  e.explode_step = 0
  e.bullet_spread = 5
  e.bullet_count = 0
  e.exploding = false
  e.dont_move = false

  -- if type == "basic" or type == "exploder" or type == "shooter" then
    e.sprite = 132
    e.angle = 360
    e.speed = .35
  -- end
  e.update_xy = function()
                    path = minimum_neighbor(node(e.x, e.y), node(player.x, player.y))
                    e.x = path.x
                    e.y = path.y
                end
  e.move = function()
              -- local next = a_star(e)
              -- if next ~= nil then
              --   local new_x = next[1]*8
              --   local new_y = next[2]*8
              --   local xsign = 1
              --   local ysign = 1
              --   if new_x > e.x then
              --     xsign = -1
              --   end
              --   if new_y > e.y then
              --     ysign = -1
              --   end
              --   e.x = e.x - (xsign*e.speed)
              --   e.y = e.y - (ysign*e.speed)
              -- else
                if type == "shooter" then
                  if node(e.x, e.y).distance(node(player.x, player.y)) >= e.shoot_distance then
                    e.update_xy()
                  else
                    local plyrx = player.x - e.x
                    local plyry = player.y - e.y
                    e.angle = ((atan2(plyry, plyrx) * 360)+180)%360
                    if e.angle <= 0 then
                      e.angle = (e.angle + 360)%360
                    end
                    e.bullet_count = e.bullet_count + 1
                    if e.bullet_count%e.bullet_spread == 0 then
                      add(enemy_bullets, bullet(e.x, e.y, e.angle, 130, false))
                    end
                  end
                elseif type == "exploder" then
                  if node(e.x, e.y).distance(node(player.x, player.y)) >= e.explode_distance and not e.dont_move then
                    e.update_xy()
                  else
                    e.dont_move = true
                    e.exploding = true
                    e.explode_step = e.explode_step + 1
                  end
                elseif type == "basic" then
                  e.update_xy()
                end
              -- end
           end

  return e
end


--[[
  bullet object
]]
function bullet(startx, starty, angle, sprite, friendly)
  local b = {}
  b.x = startx
  b.y = starty
  b.angle = angle
  b.sprite = sprite
  b.friendly = friendly
  b.speed = 2
  b.current_step = 0
  b.max_anim_steps = 5
  b.move = function()
              b.x = b.x - b.speed * sin(b.angle / 360)
              b.y = b.y - b.speed * cos(b.angle / 360)
           end

  return b
end

--[[
  boss object
]]
function boss(startx, starty, sprite)
  local b = {}
  b.x = startx
  b.y = starty
  b.dx = 0
  b.dy = 0
  b.mdx = 4
  b.mdy = 4
  b.angle = 0
  b.sprite = sprite
  b.bullet_speed = 2
  b.bullet_spread = 7
  b.destroyed_step = 0
  b.destroy_sequence = {135, 136, 135}
  b.destroy_anim_length = 30
  b.health = 50
  b.pattern = {90, 180, 270, 360}
  b.update = function()
                 b.angle = (b.angle+1)%360
                 for i=0,3 do
                   if b.angle%b.bullet_spread == 0 then
                     add(enemy_bullets, bullet(b.x, b.y, (b.angle + (90*i)), 130, false))
                   end
                 end
                --  local sx = 1
                --  local sy = 1
                --  if b.dx > 2 then sx = -1 end
                --  if b.dy > 2 then sy = -1 end
                --  b.dx = (b.dx + 1)%b.mdx
                --  b.dy = (b.dy + 1)%b.mdy
                --  b.x = b.x + b.dx*sx
                --  b.y = b.y + b.dy*sy
             end
  return b
end
--------------------------------------------------------------------------------
-------------------------------- helper functions ------------------------------
--------------------------------------------------------------------------------
function debug()
  print("px: " .. stat(32), 0, 0, 7)
  print("py: " .. stat(33), 45, 0, 7)

  print("ag: " .. player.angle, 0, 6, 7)
  --print("mem: ".. stat(0), 45, 6, 7)
  print("hp: ".. player.health, 45, 6, 7)

  -- stat(33) = y stat(32) = x
  print(costatus(game), 0, 12, 7)
  if boss1 ~= nil then
    print(boss1.health, 45, 12, 7)
  else
    print("dead", 45, 12, 7)
  end

end

function bump(x, y)
  local tx = flr((x - map_.sx) / 8)
  local ty = flr((y - map_.sy) / 8)
  local map_id = mget(tx, ty)

  return fget(map_id, 0)
end

function bump_all(x, y)
  return bump(x, y) or bump(x + 7, y) or bump(x, y + 7) or bump(x + 7, y + 7)
end

function collision()
  local fwd_tempx = player.x - player.speed * sin(player.angle / 360)
  local fwd_tempy = player.y - player.speed * cos(player.angle / 360)

  local bck_tempx = player.x + player.speed * sin(player.angle / 360)
  local bck_tempy = player.y + player.speed * cos(player.angle / 360)

  wall_fwd =  bump_all(fwd_tempx, fwd_tempy)

  wall_bck =  bump_all(bck_tempx, bck_tempy)
end

function enemy_collision(e, p)
  local other = (p or player)
  return (e.x > other.x+8 or e.x+8 < other.x or e.y > other.y+8 or e.y+8<other.y) == false
end

function bullet_collision(sp, b)
  return (b.x > sp.x+4 or b.x+4 < sp.x or b.y > sp.y+4 or b.y+4<sp.y) == false
end

function boss_collision(sp, b)
  return (b.x > sp.x+16 or b.x+4 < sp.x or b.y > sp.y+16 or b.y+4 < sp.y)==false
end

function collide_all_enemies()
  local e = enemy_spawned[1]
  for o in all(enemy_spawned) do
    if o~=e and enemy_collision(e, o) then
      fix_enemy(o, e)
    end
  end
end

function fix_enemy(o, e)
  if (o.x - e.x) < 0 then
    o.x = o.x - 8
  elseif (o.x - e.x) > 0 then
    o.x = o.x + 8
  elseif (o.x == e.y) then
    o.x = o.x + 8
  end

  if (o.y - e.y) < 0 then
    o.y = o.y - 8
  elseif (o.y - e.y) > 0 then
    o.y = o.y + 8
  elseif (o.y == e.y) then
    o.y = o.y + 8
  end
  --bump(x, y) or bump(x + 7, y) or bump(x, y + 7) or bump(x + 7, y + 7)
end

-- http://lua-users.org/wiki/simpleround
function round(num, numdecimalplaces)
  local mult = 10^(numdecimalplaces or 0)
  return flr(num * mult + 0.5) / mult
end

-- https://www.lexaloffle.com/bbs/?pid=22757
function spr_r(s,x,y,a,w,h)
 sw=(w or 1)*8
 sh=(h or 1)*8
 sx=(s%8)*8 --
 sy=(s%8)*8 --
 x0=flr(0.5*sw)
 y0=flr(0.5*sh)
 a=a/360
 sa=sin(a)
 ca=cos(a)
 for ix=0,sw-1 do
  for iy=0,sh-1 do
   dx=ix-x0
   dy=iy-y0
   xx=flr(dx*ca-dy*sa+x0)
   yy=flr(dx*sa+dy*ca+y0)
   if (xx>=0 and xx<sw and yy>=0 and yy<=sh) then
    if sget(sx+xx, sy+yy) == 0 or sget(sx+xx, sy+yy) == 5 then
      pset(x+ix, y+iy, pget(x+ix, y+iy))
    else
      pset(x+ix,y+iy, sget(sx+xx,sy+yy))
    end
   end
  end
 end
end

--[[
    implement dashing
]]
function dash(n)
  player.dashing[n] = true

  if n == c.down_arrow or n == c.left_arrow then
    player.current_dash_speed = -player.dash_speed
  else
    player.current_dash_speed = player.dash_speed
  end

  if player.dashing[c.up_arrow] or player.dashing[c.down_arrow] then
    player.x = player.x - player.current_dash_speed * sin(player.angle / 360)
    player.y = player.y - player.current_dash_speed * cos(player.angle / 360)
  else -- dash left right as defined on unit circle
    player.x = player.x - player.current_dash_speed * sin((player.angle/360)-(pi/4))
    player.y = player.y - player.current_dash_speed * cos((player.angle/360)-(pi/4))
  end
  player.current_dash_speed = 0
  player.dashing[n] = false

end

--[[
   detect whether the player double tapped to dash
]]
function dash_detect(n)
  if player.last_time[n] ~= 0 then
    if ((time() - player.last_time[n]) < player.dash_threshold[2]) and
       ((time() - player.last_time[n]) > player.dash_threshold[1]) then
         dash(n)
    end
  end
  player.last_time[n] = time()
end

function get_neighbors(x,y)
	local dirs = {{1,0}, {0,1}, {1,1}, {-1,0}, {0,-1}, {-1,-1}, {-1,1}, {1,-1}}
	local neighs = {}
	for d in all(dirs) do
		local neighbor = {x+d[1], y+d[2]}
		if check(neighbor[1], neighbor[2]) then
			add(neighs, neighbor)
		end
	end

	return neighs
end

function a_star(e, debug)
	local path={}
	local start={flr(e.x/8), flr(e.y/8)}
	local flood={start}

	local camefrom={}
	camefrom[idx(start)] = nil

	while #flood > 0 do
		local current = flood[1]

		if (current[1] == flr(player.x/8) and current[2] == flr(player.y/8)) then
      break
    end

		local neighbors = get_neighbors(current[1], current[2])

		if #neighbors > 0 then
			for n in all(neighbors) do
				if camefrom[idx(n)] == nil and not contains(camefrom, n) then
					add(flood,n)
					camefrom[idx(n)] = current

					if debug then
						rectfill(n[1]*8, n[2]*8, (n[1]*8)+7, (n[2]*8)+7)
						flip()
					end

				end
			end
		end

		del(flood,current)
	end

	local current = {flr(player.x/8), flr(player.y/8)}
	while camefrom[idx(current)] ~= nil do
    add(path,current)
		current = camefrom[idx(current)]
	end
  return path[#path-1]
end

function contains(t,v)
	for k,val in pairs(t) do
		if (val[1] == v[1] and val[2] == v[2]) return true
	end
	return false
end

function idx(t)
	return t[1].."_"..t[2]
end

function check(x,y)
	if x <= 15 and x > 0 and y <= 15 and y > 0 then
		local val = mget(x,y)
    return (not fget(val, 0))
  end
end

function minimum_neighbor(start, goal)
  local map = {}
  map.x = 128
  map.y = 120
  local minimum_dist = inf
  local min_node = start
    for i=-1,1 do
      for j=-1,1 do
        local nx = start.x+(i*enemy().speed)
        local ny = start.y+(j*enemy().speed)
        if 0 < nx and nx < map.x and 0 < ny and ny < map.y and not bump_all(nx, ny) then
          local current = node(nx, ny)
          local cur_distance = current.distance(goal)
          if cur_distance < minimum_dist then
            minimum_dist = cur_distance
            min_node = current
          end
        end
      end -- end j for
    end --end i for
    return min_node
end

--[[
  shoot: create bullet objects and add them to the 'bullets' table
]]
function shoot(x, y, a, spr, friendly)
  if friendly then
    local bx = x - 6*sin(player.angle/360)
    local by = y - 6*cos(player.angle/360)
    add(player_bullets, bullet(bx, by, a, spr, friendly))
  else
    add(enemy_bullets, bullet(x, y, a, spr, friendly))
  end
end

--[[
  delete offscreen objects
]]
function delete_offscreen(list, obj)
  if obj.x < 0 or obj.y < 0 or obj.x > 128 or obj.y > 128 then
    del(list, obj)
  end
end

function spawnenemies()
  for enemy in all(enemy_table) do
    if time() - wait.start_time >= enemy.time then
      add(enemy_spawned, enemy)
      del(enemy_table, enemy)
    end
  end

  if #enemy_table == 0 then
    spawn_enmies = false
    if not wait.timer then detect_killed_enemies = true end
  end
end

function detect_kill_enemies()
  if #enemy_spawned == 0 then
    detect_killed_enemies = false
    coresume(game)
  end
end

function kill_all_enemies()
  for e in all(enemy_table) do
    del(enemy_table, e)
  end

  for e in all(enemy_spawned) do
    del(enemy_spawned, e)
  end
end

function drawcountdown()
  local countdown = flr((wait.start_time + wait.end_time) - time())
  local hours = flr(countdown/3600);
  local mins = flr(countdown/60 - (hours * 60));
  local secs = flr(countdown - hours * 3600 - mins * 60);
  if secs < 10 then secs = "0" .. secs end

  print(mins .. ":" .. secs, 50, 50, 12)

  if countdown == 0 then
    wait.timer = false
    coresume(game)
  end
end

function draw_titlescreen()
  rectfill(0, 0, 127, 127, 0)

  if title.title_step%title.width == 0 then
    title.row = title.row+1
  end


  local nx = title.startx+(title.title_step%title.width)
  local ny = title.starty+title.row
  local nc = title.text[title.row][(title.title_step%title.width)+1]
  title.drawn.x[#title.drawn.x+1] = nx
  title.drawn.y[#title.drawn.y+1] = ny
  title.drawn.colors[#title.drawn.colors+1] = nc
  for i=1,#title.drawn.x do
    pset(title.drawn.x[i], title.drawn.y[i], title.drawn.colors[i])
  end
  pset(nx, ny, nc)

  title.title_step = title.title_step + 1
  if title.title_step == title.height*title.width then
    title.title_step = title.title_step - 1
  end
end

--[[
  print seraph dialog
]]
function dialog_seraph(dialog)
  wait.dialog_finish = true

  local bck_color = dialog.bck_color or 5
  local brd_color = dialog.brd_color or 0
  local fnt_color = dialog.fnt_color or 7
  local d = dialog.text

  if not titlescreen then
    draw_titlescreen()
  end

  rectfill(3, 99, 27, 105, bck_color) -- name rect
  rectfill(27, 99, 27, 126, bck_color) -- angle
  rectfill(28, 100, 28, 126, bck_color)
  rectfill(29, 101, 29, 126, bck_color)
  rectfill(30, 102, 30, 126, bck_color)
  rectfill(31, 103, 31, 126, bck_color)
  pset(32, 104, bck_color)

  -- text rect
  rectfill(3, 105, 124, 124, bck_color)
  rectfill(125, 106, 125, 124, bck_color)
  rectfill(4, 125, 124, 125, bck_color)

  -- border
  rectfill(2, 100, 2, 124, brd_color) -- left
  pset(3, 99, brd_color) -- top left
  rectfill(4, 98, 27, 98, brd_color) -- top of name
  pset(28, 99, brd_color) -- angle
  pset(29, 100, brd_color)
  pset(30, 101, brd_color)
  pset(31, 102, brd_color)
  pset(32, 103, brd_color)
  rectfill(33, 104, 124, 104, brd_color) -- top of text
  pset(125, 105, brd_color) -- top right
  rectfill(126, 106, 126, 124, brd_color) -- right
  pset(125, 125, brd_color) -- bottom right
  rectfill(124, 126, 4, 126, brd_color) -- bootom
  pset(3, 125, brd_color) -- bottom left

  print("seraph", 4, 100, fnt_color)
  print(sub(d, 0, 30), 5, 107, fnt_color) --30 character limit
  print(sub(d, 31, 60), 5, 113, fnt_color)
  print(sub(d, 61, 90), 5, 119, fnt_color)

  --print("z/x to continue", 69, 123, 7)
  wait.dialog_finish = false
end

function gameflow()
  -- start game
  seraph = {}
  seraph.brd_color = 12
  seraph.text = "READY TO GET TO WORK?"
  drawdialog = true -- show seraph's dialog
  wait.controls = true -- stop player controls
  yield()

  titlescreen = true -- stop showing titlescreen


  seraph = {} -- reset seraph table to defaults
  seraph.text = "ALRIGHT, I SEE A DOOR. GIVE MEA MINUTE AND I'LL TRY AND OPENIT."
  drawdialog = true -- show seraph's dialog
  wait.controls = true -- stop player controls
  yield()

  wait.controls = false  -- resume player controls
  drawdialog = false -- stop showing seraph's dialog

  -- add list of enemies to spawn_enmies
  --(spawn x position, spawn y position, type, time (in seconds) when the enemy should show up)
  add(enemy_table, enemy(100, 100, "exploder", 4))
  add(enemy_table, enemy(50, 50, "basic", 4))

  add(enemy_table, enemy(100, 100, "shooter", 5))
  add(enemy_table, enemy(50, 50, "exploder", 5))

  add(enemy_table, enemy(100, 100, "shooter", 6))
  add(enemy_table, enemy(50, 50, "basic", 6))

  spawn_enemies = true -- tell the game we want to spawn enemies
  wait.start_time = time() -- used for timer and spawn time to compare when to spawn
  wait.end_time = 65 -- how long the timer should run for in seconds
  wait.timer = true -- tells the game we want to wait for the timer to finish
  yield()

  kill_all_enemies()
  wait.timer = false
  spawn_enemies = false

  seraph = {}
  seraph.text = "OKAY, THAT SHOULD DO-"
  drawdialog = true
  wait.controls = true
  yield()

  seraph = {}
  seraph.text = "OKAY, THAT SHOULD DO- WAIT    WHAT'S THAT?"
  drawdialog = true
  wait.controls = true
  yield()

  wait.controls = false
  drawdialog = false

  boss1 = boss(56, 56, 128)
  drawboss = true
end

--[[
    skill-tree menu (needs to be called continuously from draw to work)
]]
function skilltree()
  in_skilltree = true
  local token_sprites = {64, 66, 68, 70, 72}
  for i=#token_sprites,0,-1 do -- reverse list and add it to token_sprites animation
    add(token_sprites, token_sprites[i])
  end

  rectfill(0, 0, 127, 127, 0)
  spr(token_sprites[flr(time()*8)%#token_sprites + 1], 20, 20, 2, 2)
  print(" - " .. player.tokens, 36, 26, 7)

  print("upgrade health ", 20, 52, 7)
  print("upgrade damage ", 20, 44, 7)
  print("upgrade speed ", 20, 36, 7)


  if skills_selected[1] then
    print("upgrade speed ", 20, 36, highlighted)
  elseif skills_selected[2] then
    print("upgrade damage ", 20, 44, highlighted)
  elseif skills_selected[3] then
    print("upgrade health ", 20, 52, highlighted)
  end
end

--[[
    draw enemy destruction animation to screen
  ]]
function step_destroy_animation(e)

  if e.destroyed_step <= e.destroy_anim_length then
    if e.destroyed_step < 5 then
      spr(e.destroy_sequence[1], e.x, e.y)
    elseif e.destroyed_step <= 10 then
      spr(e.destroy_sequence[2], e.x, e.y)
    elseif e.destroyed_step <= 15 then
      spr(e.destroy_sequence[3], e.x, e.y)
    end
  else
    del(destroyed_enemies, e)
  end

  circ(e.x+4, e.y+4, e.destroyed_step%5, 8)
  e.destroyed_step = e.destroyed_step + 1

end

--[[
    draw boss hit animation
]]
function boss_hit_animation(bul)
  local colors = {8, 9}

  if bul.current_step <= bul.max_anim_steps then
    circ(bul.x, bul.y, flr(time()*100)%4, colors[flr(time()*100)%#colors + 1])
  else
    del(boss_hit_anims, bul)
  end

  bul.current_step = bul.current_step+1
end

--[[
  draw boss destruction animation
]]
function step_boss_destroyed_animation(b)
  local s = 1 s1 = 1
  if flr(rnd(10))%2 == 0 then s = -1 end
  if flr(rnd(10))%2 == 0 then s1 = -1 end
  if b.destroyed_step <= b.destroy_anim_length then
    if b.destroyed_step < flr(b.destroy_anim_length/3) then
      spr(b.destroy_sequence[1], b.x+s*flr(rnd(8)), b.y+s1*flr(rnd(8)))
      spr(b.destroy_sequence[1], b.x+s*flr(rnd(8)), b.y+s1*flr(rnd(8)))
    elseif b.destroyed_step <= flr(b.destroy_anim_length/3)*2 then
      spr(b.destroy_sequence[2], b.x+s*flr(rnd(8)), b.y+s1*flr(rnd(8)))
      spr(b.destroy_sequence[1], b.x+s*flr(rnd(8)), b.y+s1*flr(rnd(8)))
    elseif b.destroyed_step <= b.destroy_anim_length then
      spr(b.destroy_sequence[3], b.x+s*flr(rnd(8)), b.y+s1*flr(rnd(8)))
      spr(b.destroy_sequence[3], b.x+s*flr(rnd(8)), b.y+s1*flr(rnd(8)))
    end
  else
    del(destroyed_bosses, b)
  end

  circ(b.x+4, b.y+4, b.destroyed_step%5, 8)
  b.destroyed_step = b.destroyed_step + 1

end

function step_explode_enemy(e)
  if e.destroyed_step <= e.destroy_anim_length then
    if e.destroyed_step < 5 then
      spr(e.destroy_sequence[1], e.x, e.y)
    elseif e.destroyed_step <= 10 then
      spr(e.destroy_sequence[2], e.x, e.y)
    elseif e.destroyed_step <= 15 then
      spr(e.destroy_sequence[3], e.x, e.y)
    end
  else
    del(destroyed_enemies, e)
  end

  circ(e.x+4, e.y+4, e.destroyed_step%15, 8)
  e.destroyed_step = e.destroyed_step + 1
  if e.destroyed_step == e.destroy_anim_length then
    return true
  end
  return false
end

--------------------------------------------------------------------------------
---------------------------------- constructor ---------------------------------
--------------------------------------------------------------------------------
function _init()
  poke(0x5f2d, 1)

  player.last_hit = time() - player.immune_time

  game = cocreate(gameflow)
  coresume(game)
end --end _init()


--------------------------------------------------------------------------------
---------------------------------- update --------------------------------------
--------------------------------------------------------------------------------
function _update()

  collision()
  collide_all_enemies()

  if in_skilltree then
    skills_selected[currently_selected] = false
    local diff = 0
    if btnp((c.up_arrow)) then
      diff = -1
    elseif btnp(c.down_arrow) then
      diff = 1
    end
    currently_selected = ((currently_selected+diff)%#skills_selected)
    if currently_selected == 0 then currently_selected = 3 end
    skills_selected[currently_selected] = true
  end

  if not wait.controls then
    --[[
      left arrow
    ]]
    if (btn(c.left_arrow)) then
      --dash_detect(c.left_arrow)
      --player.angle -= player.turnspeed
    end --end left button

    --[[
      right arrow
    ]]
    if (btn(c.right_arrow)) then
      --dash_detect(c.right_arrow)
      --player.angle += player.turnspeed
    end --end right button

    --[[
      up arrow
    ]]
    if (btn(c.up_arrow)) then
      if not cheats.noclip then
        if not wall_fwd then
          --dash_detect(c.up_arrow)
          player.current_speed = player.speed
        end
      else
        --dash_detect(c.up_arrow)
        player.current_speed = player.speed
      end
    end --end up button

    --[[
      down arrow
    ]]
    if (btn(c.down_arrow)) then
      if not cheats.noclip then
        if not wall_bck then
          --dash_detect(c.down_arrow)
          player.current_speed = -player.speed
        end
      else
        --dash_detect(c.down_arrow)
        player.current_speed = -player.speed
      end
    end --end down button
  end -- end wait.controls

  --[[
    z button
    -- shoot for now, this can be changed later
  ]]
  --if (btn(c.z_button)) then
  --stat(34) -> button bitmask (1=primary, 2=secondary, 4=middle)
  if (stat(34) == 1) then
    if wait.controls and not wait.dialog_finish then
      coresume(game)
    elseif not wait.controls then
      player.b_count = player.b_count + 1
      if player.b_count%player.bullet_spread == 0 then
        shoot(player.x, player.y, player.angle, 133, true)
      end
    end
  end --end z button

  --[[
    x button
  ]]
  if (btnp(c.x_button)) then
    --[[map_.sx = 0
    map_.sy = 0
    player.x = 8
    player.y = 8
    player.angle = 0]]

    coresume(game)
  end --end x button

  if not cheats.noclip then
    player.x = player.x - player.current_speed * sin(player.angle / 360)
    player.y = player.y - player.current_speed * cos(player.angle / 360)
  else
    map_.sx = map_.sx + player.current_speed * sin(player.angle / 360)
    map_.sy = map_.sy + player.current_speed * cos(player.angle / 360)
    player.x = 64
    player.y = 64
  end

  player.current_speed = 0
  if not drawdialog then player.angle = atan2(stat(32) - player.x - 3, stat(33) - player.y - 3) * -360 + 90 end
  player.angle = player.angle % 360
end --end _update()


--------------------------------------------------------------------------------
--------------------------------- draw buffer ----------------------------------
--------------------------------------------------------------------------------
function _draw()
  cls()

  map(0, 0, map_.sx, map_.sy, 128, 128)

  spr_r(player.sprite, player.x, player.y, player.angle, 2, 2)

  for e in all(enemy_spawned) do
    -- this should never happen, but just in case:
    delete_offscreen(enemy_spawned, e)

    -- check if this sprite has been shot
    for b in all(player_bullets) do
      if bullet_collision(e, b) then
        del(enemy_spawned, e)
        add(destroyed_enemies, e)
        del(player_bullets, b)
        b = nil
        e = nil
        break
      end
    end


    if e ~= nil then
      if ((time() - player.last_hit) > player.immune_time) and enemy_collision(e) then
        player.health = player.health - 1
        player.last_hit = time()
      end

      if e.exploding and flr(time()*500)%2==0 then
        pal()
        pal(2,8,0)
      end
      spr(e.sprite, e.x, e.y)
      pal()
      if e.explode_step == e.explode_wait then
        add(exploding_enemies, e)
      end
      e.move()
    end
  end

  for e in all(exploding_enemies) do
    if step_explode_enemy(e) then
      if node(e.x, e.y).distance(node(player.x, player.y)) <= 15 and ((time() - player.last_hit) > player.immune_time) then
        player.health = player.health - 1
        player.last_hit = time()
      end
      del(enemy_spawned, e)
      del(exploding_enemies, e)
    end
  end

  for d in all(destroyed_enemies) do
    step_destroy_animation(d)
  end

  for b in all(player_bullets) do
    -- first delete offscreen bullets:
    delete_offscreen(player_bullets, b)

    if bump(b.x, b.y) then
      del(player_bullets, b)
      b = nil
    end

    if b ~= nil then
      spr(b.sprite, b.x, b.y)
      b.move()
    end

    if drawboss and b~=nil then
      if boss_collision(boss1, b) then
        boss1.health -= 1
        del(player_bullets, b)
        add(boss_hit_anims, b)
        if (boss1.health <= 0) then
          drawboss = false
          add(destroyed_bosses, boss1)
          boss1 = nil
        end
        break
      end
    end
  end

  for b in all(enemy_bullets) do
    -- first delete offscreen bullets:
    delete_offscreen(enemy_bullets, b)

    if ((time() - player.last_hit) > player.immune_time) and bullet_collision(player, b) then
      player.health = player.health - 1
      player.last_hit = time()
      del(enemy_bullets, b)
      b = nil
    end

    if b~=nil and bump(b.x, b.y) then
      del(enemy_bullets, b)
      b = nil
    end

    if b ~= nil then
      spr(b.sprite, b.x, b.y)
      b.move()
    end
  end

  if drawboss then
    spr(boss1.sprite, boss1.x, boss1.y, 2, 2)
    boss1.update()
  end

  for b in all(boss_hit_anims) do
    boss_hit_animation(b)
  end
  for b in all(destroyed_bosses) do
    step_boss_destroyed_animation(b)
  end

  if player.health <= 0 then
    print("game over", 48, 60, 8)
    stop()
  end

  spr(96, stat(32) - 3, stat(33) - 3)

  if spawn_enemies then spawnenemies() end
  if detect_killed_enemies then detect_kill_enemies() end
  if wait.timer then drawcountdown() end

  if drawdialog then dialog_seraph(seraph) end

  if ((time() - player.last_hit) < player.immune_time) then
    camera(cos((time()*1000)/3), cos((time()*1000)/2))
  end
  -- skilltree()
  debug() -- always on bottom
end --end _draw()


__gfx__
000000000000000000000000555555555555555555555555533333355222222552a99a250000000000000000000000000000000000c00c000000000000000000
00000000000000000000000055555555555555555555555533777b3322aaa92252a99a256601106666011066660110666601106666c11c660000000000000000
000000000000000000000000555555555555555555555555377bbbb32aa9999252a99a2566199166661991666619916666199166661991660000000000000000
0000000000000000000000005555555555999a5999a5555537bbbbb32a99999252a99a2566199166661991666619916666199166661991660000000000000000
0000000000000000000000005555555555aaa559aaaa55553bbbbbb329999992529aa92566199166661991666619916666199166661991660000000000000000
00060000006000000000000055555555555555555555555537bbbbb32a999992529aa92500511500005115000051150000511500005115000000000000000000
000660cc066000000000000055555555559a55599a59a55533bbbb3322999922522992250001100000c11c000c011000000110c0000110000000000000000000
0006619916600000000000005555555555999a5aa55aaa555333333552222225555225550000000000c00c00c00000000000000c000000000000000000000000
000661991660000000000000bb55555b555555555555555599555559000000005555555500000000000000000000000000000000000000000000000000000000
00066199166000000000000053b555b555a5a99995559a5559955595000000005552255500000000000000000000000000000000000000000000000000000000
000005115000000000000000553b55b555aa5aaaa55aaa5555999995000000005229922500000000000000000000000000000000000000000000000000000000
000000110000000000000000553b55b555555555555555555559955500000000529aa92500000000000000000000000000000000000000000000000000000000
000000000000000000000000553b5b55555555999aa555555559995500000000529aa92500000000000000000000000000000000000000000000000000000000
00000000000000000000000053bbbb55555555aaaa555555559959950000000052a99a2500000000000000000000000000000000000000000000000000000000
0000000000000000000000003bb355b55555555555555555559555950000000052a99a2500000000000000000000000000000000000000000000000000000000
000000000000000000000000b355555b5555555555555555999555590000000052a99a2500000000000000000000000000000000000000000000000000000000
00000000000000002555552253b00b35000000005bbbbbb522222222000000000000000000000000555555555555555500000000000000000000000000000000
00000000000000002225522553b00b3507000070bb7773bb25555552000000000000000000000000555555555555555500000000000000000000000000000000
00000000000000005522225553b00b3507700770b773333b25555552000000000000000000000000555555555555555500000000000000000000000000000000
00000000000000005555255553b00b3578899887b733333b2555555200000000000000000000000055bbb35bbb35555500000000000000000000000000000000
000000000000000055552225530bb03500899800b333333b255555520000000000000000000000005533355b3333555500000000000000000000000000000000
000000000000000055222525530bb03503088030b733333b25555552000000000000000000000000555555555555555500000000000000000000000000000000
0000000000000000522555525330033500000000bb3333bb2225555200000000000000000000000055b3555bb35b355500000000000000000000000000000000
00000000000000002255555555533555000000005bbbbbb55522222200000000000000000000000055bbb3533553335500000000000000000000000000000000
00000000000000005555555555555555000000000000000000000000a55a55550000000000000000555555555555555550000005000000000000000000000000
00000000000000005555555555533555000000000000000000000000aa5aa55a000000000000000055353bbbb555b35500777600000000000000000000000000
000000000000000055555555533003350000000000000000000000005a55a5aa0000000000000000553353333553335507766660000000000000000000000000
000000000000000055555555530bb0350000000000000000000000005aa5aaa50000000000000000555555555555555507666660000000000000000000000000
000000000000000055555555530bb03500000000000000000000000055aa55550000000000000000555555bbb335555507666660000000000000000000000000
00000000000000005555555553b00b3500000000000000000000000055a5a5550000000000000000555555333355555507666660000000000000000000000000
00000000000000005555555553b00b350000000000000000000000005aa5aaaa0000000000000000555555555555555500666600000000000000000000000000
00000000000000005555555553b00b35000000000000000000000000aa55555a0000000000000000555555555555555550000005000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000aaaaaa00000000000aaaa000000000000aaa0000000000000aaaa00000000000aaaaaa00000000000000000000000000000000000000000000000000000
0000a999999a000000000a9999a00000000000a9a000000000000a9999a000000000a999999a0000000000000000000000000000000000000000000000000000
000a9979a999a0000000a9979a9a0000000000a9a00000000000a999999a0000000a99999999a000000000000000000000000000000000000000000000000000
000a979aaa99a0000000a979aa9a0000000000a9a00000000000a999999a0000000a99999999a000000000000000000000000000000000000000000000000000
000a979a9999a0000000a979a99a0000000000a9a00000000000a999999a0000000a99999999a000000000000000000000000000000000000000000000000000
000a979aaa99a0000000a979aa9a0000000000a9a00000000000a999999a0000000a99999999a000000000000000000000000000000000000000000000000000
000a99999a99a0000000a9799a9a0000000000a9a00000000000a999999a0000000a99999999a000000000000000000000000000000000000000000000000000
000a999aaa99a0000000a999aa9a0000000000a9a00000000000a999999a0000000a99999999a000000000000000000000000000000000000000000000000000
0000a999a99a000000000a999aa00000000000a9a000000000000a9999a000000000a999999a0000000000000000000000000000000000000000000000000000
00000aaaaaa00000000000aaaa000000000000aaa0000000000000aaaa00000000000aaaaaa00000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88080880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000300000a000000000000200000200000000099090990000000009090090988080880000000000c0000111000000c000700000000000000000000
00300000000030000009000000000000020202000000000009090900000990000909909008080800000000000110011111000011007670000000000000000000
0003000000030000000a00000000000002222200008880000999990000999900009aa90008888800000000000011011111000110076167000000000000000000
00025555503000000a9a9a0000000000025552000082800099aaa990099aa99009aaaa9088999880000000000001111111111100761116700000000000000000
0003885883200000000a0000000000000285820000888000098a8900099aa99009aaaa9008a9a800000000001111551515511110076167000000000000000000
033355355333300000090000000000000205020000000000090a090000999900009aa90008090800000000001001885158810010007670000000000000000000
3003333333000300000a000000000000202020200000000090909090000990000909909080808080000000001001555155510011000700000000000000000000
00303030303000300000000000000000202020200000000090909090000000009090090980808080000000001101111111110001000000000000000000000000
20303030300300000000000000000000000000000000000000000000000000000000000000000000000000000101000100010001000000000000000000000000
33030030030300200000000000000000000000000000000000000000000000000000000000000000000000001101000100010011000000000000000000000000
20003000300032000000000000000000000000000000000000000000000000000000000000000000000000001001000c00010010000000000000000000000000
00003000300020000000000000000000000000000000000000000000000000000000000000000000000000001011000000010010000000000000000000000000
00020000020002000000000000000000000000000000000000000000000000000000000000000000000000001010000000110010000000000000000000000000
0020000000200000000000000000000000000000000000000000000000000000000000000000000000000000c0110000001000c0000000000000000000000000
02000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000c0000c000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009008800900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009008800900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000998899000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000098890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000555500000000098890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005999950000000009900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00058855885000000009900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005955950000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffddddddddf55555f055555555355355350455540006ddd600444444445555555552aaa25553bbb3550000333333000000000033333300000000000000
ffff5fffdddd5dddf50005f03553553535555535045f540006ddd60046ffff6456dddd6552a9a25553b3b35500003b00b300000000003b55b300000000000000
f55fffffd66dddddf50005f0553335555353535500454000006d6000466ffff4566dddd5552a2555553b355500003b00b300000000003b55b300000000000000
ffff5fffdddd5dddf50005f03b3b3b35553b3555004f4000006d60004f6666645d66666555292555553b355500003b00b300000000003b55b300000000000000
f5f5f5ffd6d5d5ddf50005f033bbb33533bbb335004f4000006d60004f66fff45d66ddd555292555553b355500003b00b300000000003b55b300000000000000
f5f555ffd6d555ddf50005f03bbbbb353bbbbb35004f4000006560004f6ffff45d6dddd555292555553b355500003b00b3000000000000000000000000000000
ffffffffdd5dddddf50005f0533b3355533b335504fff400065d560046fffff456ddddd55299925553bbb35500003b00b3000000000000000000000000000000
ffffffffddddddddf55555f055535555555355554fffff406d555d604444444455555555299999253bbbbb350000000000000000000000000000000000000000
000033333300000000000000555555559559559500000000000000000000000000000000000000000000000000003b00b3000000000000000000000000000000
00003b55b300000000000000955955959555559500000000000000000000000000000000000000000000000000003b00b3000000000000000000000000000000
00003b55b300000000000000559995555959595500000000000000000000000000000000000000000000000000003b00b300000000003b55b300000000000000
00003b55b3000000000000009a9a9a95559a955500000000000000000000000000000000000000000000000000003b00b300000000003b55b300000000000000
00003b55b30000000000000099aaa99599aaa99500000000000000000000000000000000000000000000000000003b00b300000000003b55b300000000000000
00003b55b3000000000000009aaaaa959aaaaa9500000000000000000000000000000000000000000000000000003b00b300000000003b55b300000000000000
000b3b55b3b0000000000000599a9955599a995500000000000000000000000000000000000000000000000000003b00b300000000003b55b300000000000000
0000bbbbbb0000000000000055595555555955550000000000000000000000000000000000000000000000000000333333000000000033333300000000000000
000b3b55b3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003b55b30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003b55b30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003b55b30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003b55b30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003b55b30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003b55b30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0001000000000101000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
3c060606060606060606063c3c3c3c2500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3c03030303030303030303040503032500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3c37033703030303130303141503032505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3c031603033c0313031303030303d30615000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
253216033c3c3c32130303030303c93c05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06163216323c3232030405030303030715000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0613031303323232031415030303030705000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0622032203033203030303030303030803000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0603c303032a2b03030313030303031803000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0603ca03033a3b03032203130303030703000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0632030303030303c30316030303d30703000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3c03030303030303ca0303030303c93c03000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3c03030303030405030303030303033c03000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3c03030303031415030304050303033c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0603030303030303030314150303032500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0625252503030303030303030303030600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000253c3c3c06252506062525250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000006000190100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
04 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
