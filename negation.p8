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
destroyed_enemies = {}
destroyed_bosses = {}
boss_hit_anims = {}

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

  if type == "basic" then
    e.sprite = 132
    e.angle = 360
    e.speed = .35
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
                path = minimum_neighbor(node(e.x, e.y), node(player.x, player.y))
                e.x = path.x
                e.y = path.y
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
  b.immune_time=1
  b.last_hit=0
  b.health = 100
  b.destroyed_step = 0
  b.destroy_sequence = {135, 136, 135}
  b.destroy_anim_length = 30
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
  print("px: " .. round(player.x, 1), 0, 0, 7)
  print("py: " .. round(player.y, 1), 45, 0, 7)

  print("ag: " .. player.angle, 0, 6, 7)
  --print("mem: ".. stat(0), 45, 6, 7)
  print("health: ".. player.health, 45, 6, 7)

  print(costatus(game), 0, 12, 7)
  print("", 45, 12, 7)

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
 sx=(s%8)*8
 sy=flr(s/8)*8
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
    rectfill(0, 0, 127, 127, 0)
    print("negation", 47, 40, 12)
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
  seraph.text = "ready to get to work?"
  drawdialog = true
  wait.controls = true
  yield()

  titlescreen = true

  seraph = {}
  seraph.text = "alright, i see a door. give mea minute and i'll try and openit"
  drawdialog = true
  wait.controls = true
  yield()

  wait.controls = false
  drawdialog = false

  -- probably function to start/control enemy spawning instead of just adding them here

  add(enemy_table, enemy(100, 100, "basic", 4))
  add(enemy_table, enemy(50, 50, "basic", 4))

  add(enemy_table, enemy(100, 100, "basic", 5))
  add(enemy_table, enemy(50, 50, "basic", 5))

  add(enemy_table, enemy(100, 100, "basic", 6))
  add(enemy_table, enemy(50, 50, "basic", 6))

  spawn_enmies = true
  wait.start_time = time()
  wait.timer = true
  wait.end_time = 20
  yield()

  kill_all_enemies()
  seraph = {}
  seraph.text = "okay, that should do-"
  drawdialog = true
  wait.controls = true
  yield()

  seraph = {}
  seraph.text = "okay, that should do- wait    what's that?"
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

--------------------------------------------------------------------------------
---------------------------------- constructor ---------------------------------
--------------------------------------------------------------------------------
function _init()
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
      dash_detect(c.left_arrow)
      player.angle -= player.turnspeed
    end --end left button

    --[[
      right arrow
    ]]
    if (btn(c.right_arrow)) then
      dash_detect(c.right_arrow)
      player.angle += player.turnspeed
    end --end right button

    --[[
      up arrow
    ]]
    if (btn(c.up_arrow)) then
      if not cheats.noclip then
        if not wall_fwd then
          dash_detect(c.up_arrow)
          player.current_speed = player.speed
        end
      else
        dash_detect(c.up_arrow)
        player.current_speed = player.speed
      end
    end --end up button

    --[[
      down arrow
    ]]
    if (btn(c.down_arrow)) then
      if not cheats.noclip then
        if not wall_bck then
          dash_detect(c.down_arrow)
          player.current_speed = -player.speed
        end
      else
        dash_detect(c.down_arrow)
        player.current_speed = -player.speed
      end
    end --end down button
  end -- end wait.controls

  --[[
    z button
    -- shoot for now, this can be changed later
  ]]
  if (btn(c.z_button)) then
    if wait.controls and not wait.dialog_finish and btnp(c.z_button) then
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
  player.angle = player.angle % 360
end --end _update()


--------------------------------------------------------------------------------
--------------------------------- draw buffer ----------------------------------
--------------------------------------------------------------------------------
function _draw()
  cls()

  map(0, 0, map_.sx, map_.sy, 128, 128)

  spr_r(player.sprite, player.x, player.y, player.angle, 1, 1)

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
      elseif enemy_collision(e) then -- shake screen to show you've taken damage
        -- https://www.lexaloffle.com/bbs/?tid=2168
        camera(cos((time()*1000)/3), cos((time()*1000)/2))
      else
        -- camera()
      end
      spr(e.sprite, e.x, e.y)
      e.move()
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
  end

  for b in all(enemy_bullets) do
    -- first delete offscreen bullets:
    delete_offscreen(enemy_bullets, b)

    if ((time() - player.last_hit) > player.immune_time) and bullet_collision(player, b) then
      player.health = player.health - 1
      player.last_hit = time()
      del(enemy_bullets, b)
      b = nil
    elseif bullet_collision(player, b) then
      camera(cos((time()*1000)/3), cos((time()*1000)/2))
    else
      -- camera()
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
    for b in all(player_bullets) do
      if boss_collision(boss1,b) then
        boss1.health = boss1.health - 1
        del(player_bullets, b)
        add(boss_hit_anims, b)
        if(boss1.health<=0)then
          del(boss1)
          add(destroyed_bosses, boss1)
          drawboss=false
        end
        break
      end
    end
  end

  for b in all(boss_hit_anims) do
    boss_hit_animation(b)
  end
  for b in all(destroyed_bosses) do
    step_boss_destroyed_animation(b)
  end

  if player.health<=0 then
    print("game over", 48, 60, 8)
    stop()
  end

  if spawn_enmies then spawnenemies() end
  if detect_killed_enemies then detect_kill_enemies() end
  if wait.timer then drawcountdown() end

  if drawdialog then dialog_seraph(seraph) end

  -- skilltree()
  debug() -- always on bottom
end --end _draw()


__gfx__
000000005bbbbbb555555555555555555555555555555555533333355222222552a99a2500000000000000000000000000000000000000000000000000000000
07000070bb7773bb5555555555555555555555555555555533777b3322aaa92252a99a2500000000000000000000000000000000000000000000000000000000
07700770b773333b55555555555555555555555555555555377bbbb32aa9999252a99a2500000000000000000000000000000000000000000000000000000000
78899887b733333b555555555555555555999a5999a5555537bbbbb32a99999252a99a2500000000000000000000000000000000000000000000000000000000
00899800b333333b555555555555555555aaa559aaaa55553bbbbbb329999992529aa92500000000000000000000000000000000000000000000000000000000
03088030b733333b5555555555555555555555555555555537bbbbb32a999992529aa92500000000000000000000000000000000000000000000000000000000
00000000bb3333bb5555555555555555559a55599a59a55533bbbb33229999225229922500000000000000000000000000000000000000000000000000000000
000000005bbbbbb5555555555555555555999a5aa55aaa5553333335522222255552255500000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555555555555555555566666666000000005555555500000000000000000000000000000000000000000000000000000000
5555555555555555555555555555555555a5a99995559a5566666666000000005552255500000000000000000000000000000000000000000000000000000000
5555555555555555555555555555555555aa5aaaa55aaa5566666666000000005229922500000000000000000000000000000000000000000000000000000000
55bbb35bbb355555555555555555555555555555555555556666666600000000529aa92500000000000000000000000000000000000000000000000000000000
5533355b333355555555555555555555555555999aa555556666666600000000529aa92500000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555555555aaaa555555666666660000000052a99a2500000000000000000000000000000000000000000000000000000000
55b3555bb35b355555555555555555555555555555555555666666660000000052a99a2500000000000000000000000000000000000000000000000000000000
55bbb3533553335555555555555555555555555555555555666666660000000052a99a2500000000000000000000000000000000000000000000000000000000
55555555555555555555555553b00b35000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55353bbbb555b3555555555553b00b35000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55335333355333555555555553b00b35000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555555555555553b00b35000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555555bbb335555555555555530bb035000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555555333355555555555555530bb035000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555555555555553300335000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555555555555555533555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005555555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005555555555533555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005555555553300335000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000055555555530bb035000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000055555555530bb035000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005555555553b00b35000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005555555553b00b35000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000005555555553b00b35000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0300000000000300000a000000000000200000200000000099090990000000009090090988080880000000000000000000000000000000000000000000000000
00300000000030000009000000000000020202000000000009090900000990000909909008080800000000000000000000000000000000000000000000000000
0003000000030000000a00000000000002222200008880000999990000999900009aa90008888800000000000000000000000000000000000000000000000000
00025555503000000a9a9a0000000000025552000082800099aaa990099aa99009aaaa9088999880000000000000000000000000000000000000000000000000
0003885883200000000a0000000000000285820000888000098a8900099aa99009aaaa9008a9a800000000000000000000000000000000000000000000000000
033355355333300000090000000000000205020000000000090a090000999900009aa90008090800000000000000000000000000000000000000000000000000
3003333333000300000a000000000000202020200000000090909090000990000909909080808080000000000000000000000000000000000000000000000000
00303030303000300000000000000000202020200000000090909090000000009090090980808080000000000000000000000000000000000000000000000000
20303030300300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33030030030300200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
20003000300032000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003000300020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000020002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00200000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0001000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0106060601010101010606060101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0110110203020203101103040502030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0120211213121303202103141502030105000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102030203060303030303020202d30615000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0111131206060603030303020203c90605000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0621030203060303030405030310110715000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0612131213030303031415030320210705000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0602020203030303030303030303030803000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0612c30213030310110203030302021813000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0603ca0302030220210203030202030703000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
061302c312131213c31213011212d30713000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010302ca02030203ca1301010102c90603000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0113121011130405020312011011130113000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103022021031415121011032021030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0613120203131203022021020312130100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0601010101030201010106060101010600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000006060606000006060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00 41424344
