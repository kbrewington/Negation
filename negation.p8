pico-8 cartridge // http://www.pico-8.com
version 9
__lua__
--------------------------------------------------------------------------------
--------------------------------- global variables  ----------------------------
--------------------------------------------------------------------------------

player = {}
player_sprite = 0
player.x = 80
player.y = 8
player_speed = 1
player_angle = 0
player_turn = 0
player_fire_rate = .75
player_power_fire_rate = 1
player_health = 10
player_max_health = 10
player.size = 8
player_immune_time = 2
--player.last_hit = 0
player_b_count = 0
player_tokens = 0
player_inventory = {}
player_inv_max = 4
player_shield_dur = 5
--player.last_right = nil
--player.last_click = nil
--player.last_middle_click = nil
player_killed = 0
player_shield = 0

level = {}
-- level.border = {}
-- level.border.left = 0
-- level.border.up = 0
-- level.border.right = 120
-- level.border.down = 120
level_lvl = 1
level_sx = 0
level_sy = 0
level_x = 0
level_y = 0
level_transition = {1, 0, 0,
                    2, 16, 0,
                    3, 39, 0}

wait = {}
wait.controls = false
wait.dialog_finish = false

timers = {leveltimer = 0,
          showinv = 0,
          playerlasthit = 0,
          leftclick = 0,
          middleclick = 0,
          rightclick = 0,
          firerate = 0,
          invalid = 0,
          bossstart = 0}

-- controls
c = {}
c.left_arrow = 0
c.right_arrow = 1
c.up_arrow = 2
c.down_arrow = 3
c.z_button = 4
c.x_button = 5

title = {}
title.drawn = nil
title.init = nil
title.startx = 23
title.starty = 50
title.text = {   "12,12,12,12, 0, 0, 0,12,12,12, 0,12,12,12,12,12,12,12, 0, 12,12,12,12,12,12,12,12, 0, 0,12,12,12,12,12, 0, 0,12,12,12,12,12,12,12, 0,12,12,12,12,12,12,12, 0, 0,12,12,12,12, 0, 0,12,12,12,12, 0, 0, 0,12,12,12",
                 "12, 1, 1, 1,12, 0, 0,12, 1,12, 0,12, 1, 1, 1, 1, 1,12, 0, 12, 1, 1, 1, 1, 1, 1,12, 0,12, 1, 1, 1, 1, 1,12, 0,12, 1, 1, 1, 1, 1,12, 0,12, 1, 1, 1, 1, 1,12, 0,12, 1, 1, 1, 1,12, 0,12, 1, 1, 1,12, 0, 0,12, 1,12",
                 "12, 1, 1, 1, 1,12, 0,12, 1,12, 0,12, 1,12,12,12,12,12, 0, 12, 1,12,12,12,12,12,12, 0,12, 1, 1,12, 1, 1,12, 0,12,12,12, 1,12,12,12, 0,12,12,12, 1,12,12, 0, 0,12, 1,12,12, 1,12, 0,12, 1, 1, 1, 1,12, 0,12, 1,12",
                 "12, 1,12,12, 1, 1,12,12, 1,12, 0,12, 1,12, 0, 0, 0, 0, 0, 12, 1,12, 0, 0, 0, 0, 0, 0,12, 1, 1, 1, 1, 1,12, 0, 0, 0,12, 1,12, 0, 0, 0, 0, 0,12, 1,12, 0, 0, 0,12, 1,12,12, 1,12, 0,12, 1,12,12, 1, 1,12,12, 1,12",
                 "12, 1,12, 0,12, 1, 1, 1, 1,12, 0,12, 1,12,12,12, 0, 0, 0, 12, 1,12, 0,12,12,12,12, 0,12, 1, 1,12, 1, 1,12, 0, 0, 0,12, 1,12, 0, 0, 0, 0, 0,12, 1,12, 0, 0, 0,12, 1,12,12, 1,12, 0,12, 1,12, 0,12, 1, 1, 1, 1,12",
                 "12, 1,12, 0,12, 1, 1, 1, 1,12, 0,12, 1, 1, 1,12, 0, 0, 0, 12, 1,12, 0,12, 1, 1,12, 0,12, 1,12, 0,12, 1,12, 0, 0, 0,12, 1,12, 0, 0, 0, 0, 0,12, 1,12, 0, 0, 0,12, 1,12,12, 1,12, 0,12, 1,12, 0,12, 1, 1, 1, 1,12",
                 "12, 1,12, 0, 0,12, 1, 1, 1,12, 0,12, 1,12,12,12, 0, 0, 0, 12, 1,12, 0,12,12, 1,12, 0,12, 1,12, 0,12, 1,12, 0, 0, 0,12, 1,12, 0, 0, 0, 0, 0,12, 1,12, 0, 0, 0,12, 1,12,12, 1,12, 0,12, 1,12, 0, 0,12, 1, 1, 1,12",
                 "12, 1,12, 0, 0, 0,12, 1, 1,12, 0,12, 1,12, 0, 0, 0, 0, 0, 12, 1,12, 0, 0,12, 1,12, 0,12, 1,12, 0,12, 1,12, 0, 0, 0,12, 1,12, 0, 0, 0, 0, 0,12, 1,12, 0, 0, 0,12, 1,12,12, 1,12, 0,12, 1,12, 0, 0, 0,12, 1, 1,12",
                 "12, 1,12, 0, 0, 0,12, 1, 1,12, 0,12, 1,12,12,12,12,12, 0, 12, 1,12,12,12,12, 1,12, 0,12, 1,12, 0,12, 1,12, 0, 0, 0,12, 1,12, 0, 0, 0,12,12,12, 1,12,12,12, 0,12, 1,12,12, 1,12, 0,12, 1,12, 0, 0, 0,12, 1, 1,12",
                 "12, 1,12, 0, 0, 0, 0,12, 1,12, 0,12, 1, 1, 1, 1, 1,12, 0, 12, 1, 1, 1, 1, 1, 1,12, 0,12, 1,12, 0,12, 1,12, 0, 0, 0,12, 1,12, 0, 0, 0,12, 1, 1, 1, 1, 1,12, 0,12, 1, 1, 1, 1,12, 0,12, 1,12, 0, 0, 0, 0,12, 1,12",
                 "12,12,12, 0, 0, 0, 0, 0,12,12, 0,12,12,12,12,12,12,12, 0, 12,12,12,12,12,12,12,12, 0,12,12,12, 0,12,12,12, 0, 0, 0,12,12,12, 0, 0, 0,12,12,12,12,12,12,12, 0, 0,12,12,12,12, 0, 0,12,12,12, 0, 0, 0, 0, 0,12,12"}

_load = {}

coin = {}
coin.dropped = false
coin.size = 16
coin.x = nil
coin.y = nil
coin.sprites = {64, 66, 68, 70, 72, 70, 68, 66}

enemy_table  = {}
enemy_spawned = {}
player_bullets = {}
enemy_bullets = {}
destroyed_bosses = {}
destroyed_enemies = {}
boss_hit_anims = {}
exploding_enemies = {}
boss_table = {}
dropped = {}
shield_anims = {}
moves = {}

currently_selected = 1
selection_set = {"speed", "health", "fire rate", "quit"}
next_cost = {1, 1, 1}
skills_selected = {true, false, false, false}
--invalid = 0
titlescreen = nil

--------------------------------------------------------------------------------
------------------------ object-like structures --------------------------------
--------------------------------------------------------------------------------
--[[
  drop objects
]]
function drop_obj(sx, sy, sprite)
  local d = {}
  d.x, d.y, d.sprite, d.size, d.drop_duration = sx, sy, sprite, 8, 5
  -- d.y = sy
  -- d.sprite = sprite
  -- d.size = 8
  -- d.drop_duration = 5
  d.init_time = time()
  d.types = {[32] = "heart",
             [33] = "shotgun",
             [48] = "rockets",
             [49] = "shield"}
  d.ammos = {[33] = 10,
             [48] = 1}
  d.type = d.types[sprite]
  if (d.ammos[sprite] ~= nil) d.ammo = d.ammos[sprite]
  return d
end

--[[
  enemy object
]]
function enemy(spawn_x, spawn_y, type, time_spwn)
  local e = {}
  e.x, e.y, e.speed, e.time, e.b_count = spawn_x, spawn_y, .35, time_spwn, 0
  -- e.y = spawn_y
  -- e.speed = .35
  -- e.time = time_spwn
  -- e.b_count = 0
  e.destroy_anim_length, e.destroyed_step, e.drop_prob, e.shoot_distance = 15, 0, 100, 50
  -- e.destroyed_step = 0
  e.destroy_sequence = {135, 136, 135}
  e.drops = {32, 33, 48, 49} -- sprites of drops
  -- e.drop_prob = 100--%
  -- e.shoot_distance = 50
  e.explode_distance, e.explode_wait, e.explode_step, e.fire_rate = 15, 15, 0, 10
  -- e.explode_wait = 15
  -- e.explode_step = 0
  -- e.fire_rate = 10
  e.exploding, e.dont_move, e.size, e.sprite, e.speed, e.type = false, false, 8, 132, .35, type
  -- e.dont_move = false
  -- e.size = 8
  -- e.sprite = 132
  -- e.angle = 360
  -- e.speed = .35
  -- e.type = type

  e.update_xy = function()
                    path = minimum_neighbor(e, player)
                    e.x = e.x + ((e.x-path.x)*e.speed)*(0xffff)
                    e.y = e.y + ((e.y-path.y)*e.speed)*(0xffff)
                end
  e.move = function()
                if e.type == "shooter" then
                  if distance(e, player) >= e.shoot_distance then
                    e.update_xy()
                  else
                    e.angle = angle_btwn(player.x+5, player.y+5, e.x, e.y)
                    e.b_count += 1
                    if (e.b_count%e.fire_rate == 0) shoot(e.x, e.y, e.angle, 133, false, false)

                  end
                elseif e.type == "exploder" then
                  if distance(e, player) >= e.explode_distance and not e.dont_move then
                    e.update_xy()
                  else
                    e.dont_move = true
                    e.exploding = true
                    e.explode_step += 1
                  end
                elseif e.type == "basic" then
                  e.update_xy()
                end
           end

  return e
end


--[[
  bullet object
]]
function bullet(startx, starty, angle, sprite, friendly, shotgun)
  local b = {}
  b.x, b.y, b.angle, b.sprite, b.friendly, b.duration = startx, starty, angle, sprite, friendly, 15
  -- b.y = starty
  -- b.angle = angle
  -- b.sprite = sprite
  -- b.friendly = friendly
  -- b.duration = 15
  b.shotgun, b.speed, b.acceleration, b.current_step, b.max_anim_steps, b.rocket, b.size = (shotgun or false), 2, 0, 0, 5, false, 3
  -- b.speed = 2
  -- b.acceleration = 0
  -- b.current_step = 0
  -- b.max_anim_steps = 5
  -- b.rocket = false
  -- b.size = 3

  if (b.sprite == 48) b.acceleration, b.max_anim_steps, b.rocket = 0.5, 15, true

  b.move = function()
     if (b.sprite == 48) b.acceleration += 0.5
     if (b.shotgun) b.duration -= 1
     b.x = b.x - (b.speed+b.acceleration) * sin(b.angle / 360)
     b.y = b.y - (b.speed+b.acceleration) * cos(b.angle / 360)
   end

  return b
end

--[[
  boss object
]]
function boss(startx, starty, sprite, lvl)
  local b = {}
  b.x, b.y, b.speed, b.angle, b.level, b.shot_last, b.shot_ang, b.sprite = startx, starty, .01, 0, (lvl or 1), nil, 0, sprite
  -- b.y = starty
  -- b.speed = .01
  -- b.angle = 0
  -- b.level = lvl or 1
  -- b.shot_last = nil
  -- b.shot_ang = 0
  -- b.sprite = sprite
  b.size, b.bullet_speed, b.fire_rate, b.destroyed_step, b.destroy_anim_length, b.health = 16, 2, 7, 0, 30, 50
  -- b.bullet_speed = 2
  -- b.fire_rate = 7
  -- b.destroyed_step = 0
  b.destroy_sequence = {135, 136, 135}
  -- b.destroy_anim_length = 30
  -- b.health = 50
  b.circs = {}
  timers["bossstart"] = 12
  b.draw_healthbar = function()
             --health bar
             if (b.sprite == 128 or 139) xoffset = 1; b.full_health = 50
             rectfill(b.x + xoffset, b.y - 3, b.x + xoffset + 12, b.y - 3, 14)
             rectfill(b.x + xoffset, b.y - 3, b.x + xoffset + flr(12 * (b.health / b.full_health)), b.y - 3, 8)
           end
  b.update = function()
           local p_ang = angle_btwn(player.x, player.y, b.x, b.y)
           if b.level == 1 then
             b.angle = (b.angle+1)%360
             for i=0,3 do
               if (b.angle%b.fire_rate == 0) shoot(b.x, b.y, (b.angle + (90*i)), 130, false, true)
             end

             path = minimum_neighbor(b, player)
             b.x = b.x + ((b.x-path.x)*b.speed)*(-1)
             b.y = b.y + ((b.y-path.y)*b.speed)*(-1)

           elseif b.level == 2 then
             if b.shot_last ~= nil and ((time() - b.shot_last) < 2) and flr(time()*50)%b.fire_rate == 0 then
               shoot(b.x, b.y, p_ang, 141, false, true)
               b.x = b.x - 5*sin(p_ang/360)
               b.y = b.y - 5*cos(p_ang/360)
             end
             --b.draw_healthbar()
           elseif b.level == 3 then
              local ang = (360/(abs(time())/2))*(10%(abs(time())/2))
              b.x = 60 - 55*cos(ang)
              b.y = 60 - 55*sin(ang)
              line((b.x-8*sin(p_ang/360)+8),(b.y-8*cos(p_ang/360)+8),((b.x+8)-(30*sin(p_ang/360))),((b.y+8)-(30*cos(p_ang/360))),10)
              if (distance(player, b) <= 30+8) shoot(b.x, b.y, p_ang, 141, false, true)
           elseif b.level == 4 then
             if abs(time()*10)%2 == 0 then
               b.circs[#b.circs+1] = {player.x+8, player.y+8, 12}
             end
             for c in all(b.circs) do
               for i=12,c[3],-1 do
                 circ(c[1], c[2], i, 8)
               end
               if abs(time()*1000000)%2 == 0 then
                 c[3] -= 1
                 if c[3] <= 0 then
                   circfill(c[1], c[2], 12, 9)
                   if distance(player, {["x"]=c[1],["y"]=c[2]}) <= 15 then
                      player_health -= 1
                      sfx(2,2)
                      timers["playerlasthit"] = player_immune_time
                   end
                   del(b.circs, c)
                 end
               end
             end
           elseif b.level == 6 then
             b.x = b.x + .1*((b.x > 8 and b.x < 112) and sin(p_ang/360) or 0)
             b.y = b.y + .1*((b.y > 8 and b.y < 112) and cos(p_ang/360) or 0)
             b.angle = (b.angle+1)%360
             b.fire_rate = 4
             for i=1,360,60 do
               if b.angle%b.fire_rate == 0 then
                 if (timers["bossstart"] < 6 and timers["bossstart"] > 5) break
                 if timers["bossstart"] <= 12 then
                   if (timers["bossstart"] > 6) shoot(b.x, b.y, i+(b.angle), 141, false, true)
                   shoot(b.x, b.y, i-(b.angle), 141, false, true)
                 end
               end
             end
             if (timers["bossstart"] == 0) timers["bossstart"] = 13
             if (b.health/50) == 33/50 then
               b.health -= 1
               for i=1,3 do
                 add(boss_table, boss(b.x+rnd(10), b.y+rnd(10), b.sprite, 6))
               end
             end
           end
           b.draw_healthbar()
          end
  return b
end
--------------------------------------------------------------------------------
-------------------------------- helper functions ------------------------------
--------------------------------------------------------------------------------
function debug()
  local debug_color = 14

  print("px: " .. player.x, 0, 0, debug_color)
  print("sx: " .. level_sx, 45, 0, debug_color)

  print("me: " .. round((stat(0)/1024)*100, 2) .. "%", 0, 6, debug_color)
  local cpucolor = debug_color
  if stat(1) > 1 then cpucolor = 8 end --means we're not using all 30 draws (bad)
  print("cp: " ..round(stat(1)*100, 2) .. "%", 45, 6, cpucolor)

  if #player_inventory > 0 then print(player_inventory[1].ammo, 45, 12, debug_color) end
  print(timers["playerlasthit"], 0, 12, debug_color)

  print(timers["rightclick"], 0, 18, debug_color)
  print("", 45, 18, debug_color)
end

function init_mem()
  for i=0,53 do -- 53 - 63 = leaderboard data
    dset(i, -1)
  end
end

function save_leaderboard()
  local idx = 53
  while dget(idx) ~= 0 do
    idx += 1
  end
  dset(idx, player_killed)
end

function save_data()
  local save = {player.x, player.y, level_sx, level_sy, level_lvl, player_tokens} -- missing: player_inventory, and current skill values/costs
  for i=0,(#save-1) do
    dset(i, save[i+1])
  end
  -- dset(#save, -5) -- save inventory items
  -- for i=(#save+1),(#player_inventory) do
  --   dset(i, player_inventory[i+1])
  -- end
end

function load_data()
  local idx = 0
  _load = {}
  while dget(idx) ~= -1 do
    _load[#_load+1] = dget(idx)
    idx += 1
  end
end

function show_leaderboard()
  rectfill(0,0,128,128,0)
  print("killed: "..player_killed,20,20,5)
  for i=1,90 do
    flip()
  end
end

function bump(x, y)
  local tx = flr((x - level_sx + (level_x*8)) / 8)
  local ty = flr((y - level_sy + (level_y*8)) / 8)
  local map_id = mget(tx, ty)

  return fget(map_id, 0)
end

function bump_all(x, y)
  return bump(x, y) or bump(x + 7, y) or bump(x, y + 7) or bump(x + 7, y + 7)
end

function ent_collide(firstent, secondent)
  secondent = secondent or player
  offset = (firstent == player) and 4 or 0
  return (firstent.x + offset > secondent.x + level_sx + secondent.size or firstent.x + offset + player.size < secondent.x + level_sx
    or firstent.y + offset > secondent.y + secondent.size or firstent.y + offset + firstent.size < secondent.y) == false
end

function collide_all_enemies()
  local e = enemy_spawned[1]
  for o in all(enemy_spawned) do
    if (o~=e and ent_collide(e, o)) fix_enemy(o, e)
  end
end

function fix_enemy(o, e)
  local function fix_coord(o,e,c)
    if (o[c] - e[c]) < 0 then
      o[c] = o[c] - 8
    elseif (o[c] - e[c]) > 0 then
      o[c] = o[c] + 8
    elseif (o[c] == e[c]) then
      o[c] = o[c] + 8
    end
  end
  fix_coord(o,e,'x')
  fix_coord(o,e,'y')
end

-- http://lua-users.org/wiki/simpleround
function round(num, numdecimalplaces)
  local mult = 10^(numdecimalplaces or 0)
  return flr(num * mult + 0.5) / mult
end
function ceil(x) return -flr(-x) end

-- https://www.lexaloffle.com/bbs/?pid=22757
function spr_r(s,x,y,a,w,h)
 sw=(w or 1)*8
 sh=(h or 1)*8
 sx=(s%8)*8
 sy=flr(s/8)*4
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
    if sget(sx+xx, sy+yy) == 0 then
      pset(x+ix, y+iy, pget(x+ix, y+iy))
    else
      pset(x+ix,y+iy, sget(sx+xx,sy+yy))
    end
   end
  end
 end
end

function minimum_neighbor(start, goal)
  local map = {}
  map.x, map.y = 128, 120
  -- map.y = 120
  local minimum_dist, min_node = 8000, start
  -- local min_node = start
    for i=0xffff,1 do
      for j=0xffff,1 do
        local nx = start.x+(i*enemy().speed)
        local ny = start.y+(j*enemy().speed)
        if 0 < nx and nx < map.x and 0 < ny and ny < map.y and not bump_all(nx, ny) then
          local current = enemy(nx, ny)
          local cur_distance = distance(current, goal)
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
  get angle between two objects
  args:
    coordinates to object: tx, ty
    coordinates from object: fx, fy
]]
function angle_btwn(tx, ty, fx, fy)
  local diffx, diffy = (tx - fx), (ty - fy)
  -- local diffy = ty - fy
  local angle = ((atan2(diffy, diffx) * 360) + 180)%360
  if (angle <= 0) angle = (angle + 360)%360
  return angle
end

--[[
  shoot: create bullet objects and add them to the 'bullets' table
]]
function shoot(x, y, a, spr, friendly, boss, shotgun)
  if (spr~=48) then
    sfx(2)
  else
    sfx(16)
  end
  if friendly then
    local offx, offy = (player.x + 5), (player.y + 5)
    local ang = angle_btwn((stat(32) - 3), (stat(33) - 3), offx, offy)
    if (a != player_angle) ang += a
    offx, offy = (offx - 8*sin(ang / 360)), (offy - 8*cos(ang / 360))
    -- offy = offy - 8*cos(ang / 360)
    add(player_bullets, bullet(offx, offy, ang, spr, friendly, shotgun))
  elseif boss then
    local offx, offy = (x + 5), (y + 5)
    -- local offy = y + 5
    offx, offy = (offx - 16*sin(a / 360)), (offy - 16*cos(a / 360))
    -- offy = offy - 16*cos(a / 360)
    add(enemy_bullets, bullet(offx, offy, a, spr, friendly, shotgun))
  else
    local offx, offy = (x - 8*sin(a / 360)), (y - 8*cos(a / 360))
    -- local offy = y - 8*cos(a / 360)
    add(enemy_bullets, bullet(offx, offy, a, spr, friendly))
  end
end

--[[
  delete offscreen objects
]]
function delete_offscreen(list, obj)
  if (obj.x < 0 or obj.y < 0 or obj.x > 128 or obj.y > 128) del(list, obj)
end

function spawnenemies()
  for enemy in all(enemy_table) do
    if enemy.x == nil then
      -- if not within player.x 20?
      -- if not bump
      -- while loop?
    end
    if enemy.y == nil then

    end
    if time() - wait.start_time >= enemy.time then
      add(enemy_spawned, enemy)
      del(enemy_table, enemy)
    end
  end

  if #enemy_table == 0 then
    spawn_enemies = false
    if (not wait.timer) detect_killed_enemies = true
  end
end

function detect_kill_enemies()
  if #enemy_spawned == 0 then
    detect_killed_enemies = false
    coresume(game)
  end
end

function kill_all_enemies(no_drop_items)
  enemy_table = {}

  for e in all(enemy_spawned) do
    if (no_drop_items) e.drop_prob = 0
    del(enemy_spawned, e)
    add(destroyed_enemies, e)
  end

  for b in all(boss_table) do
    del(boss_table, b)
    add(destroyed_bosses, b)
    coin.x = b.x - level_sx
    coin.y = b.y - level_sy
    b = nil
  end
end

function levelchange()
  local farx = 100
  --local farleft

  level.i = 3*level_lvl+1
  if (level_transition[level.i] == level_lvl+1 and (level_transition[level.i+1] - 12) * 8 < abs(level_sx - ((level_lvl-1) * 128))) move_map = true
  -- [[and transition[level.i+2] == flr(level_sy)]] then
    -- move_map = true
  -- end

  --todo add map centering on player in the beginning

  if not move_map then
    if btn(c.left_arrow) and abs(level_sx - ((level_lvl-1) * 128)) > level_x*8 and player.x < farx then
      level_sx += player_speed
      if player.x < farx then player.x = farx end
    end
    if btn(c.right_arrow) --[[and level_sx - ((level_lvl-1) * 128) <= (level_transition[level.i+1])*8]]  and player.x > farx then
      level_sx -= player_speed
      if player.x > farx then player.x = farx end
    end
  end

  if move_map ~= nil and move_map then
    wait.controls = true

    if level_transition[level.i+1]*8 > abs(level_sx - ((level_lvl-1) * 128)) then
      level_sx = flr(level_sx) - 1
      player.x -= 1

    --[[elseif check we go down then]]

    else
      dropped = {}
      level_sprites = {}
      open_door = false
      level_sx, level_sy, level_x, level_y = 0, 0, (level_transition[level.i+1]), (level_transition[level.i+2])
      -- level_sy = 0
      -- level_x = level_transition[level.i+1]
      -- level_y = level_transition[level.i+2]

      wait.controls, move_map, level_change, coin.dropped = false, false, false, false
      -- move_map = false
      -- level_change = false
      level_lvl += 1
      -- coin.dropped = false
      coresume(game)
    end
  end
end

function drawcountdown()
  local x, y, clr = 57, 15, 12
  --local countdown = flr((wait.start_time + wait.end_time) - time())
  local countdown = timers["leveltimer"]
  local hours = flr(countdown/3600);
  local mins = flr(countdown/60 - (hours * 60));
  local secs = ceil(countdown - hours * 3600 - mins * 60);
  if secs == 60 then
    mins += 1
    secs = 0
  end
  if (secs < 10) secs = "0" .. secs

  print(mins .. ":" .. secs, x, y, clr)

  if countdown == 0 then
    wait.timer = false
    coresume(game)
  end
end

function opendoor()
  if (doorh == nil) doorh = 1
  rectfill(126+level_sx, 63+level_sy, 127+level_sx, 63-doorh+level_sy, 13)
  rectfill(126+level_sx, 64+level_sy, 127+level_sx, 64+doorh+level_sy, 13)
  if (doorh < 20) then
    doorh += 0.5
  elseif doorh == 20 then
     coresume(game)
     doorh += 1
  end
end

function draw_titlescreen()
  rectfill(0, 0, 127, 127, 0)

  if not title.drawn then
    title.drawn = {}
    for i=1, #title.text do
      title.drawn[i] = {}
    end
    for i=1, #title.text do
      while #title.text[i] > 0 do
       local d = sub(title.text[i], 1, 1)
       title.text[i] = sub(title.text[i], 2)
       if d ~= "," and d ~= " " then
         local b = sub(title.text[i], 1, 1)
         title.text[i] = sub(title.text[i], 2)
         if b ~= "," and b ~= " " then
           add(title.drawn[i], (d..b)+0)
         else
           add(title.drawn[i], d+0)
         end
       end

      end
    end
  end

  for i=1,#title.drawn do
    for j=1,#title.drawn[i] do
      if title.init > (flr(time()) - 1) then
        if (title.drawn[i][j] ~= 0) pset(j+title.startx, i+title.starty, (title.drawn[i][j]+(flr(time()*(i*5))%15)))
      else
        pset(j+title.startx, i+title.starty, (title.drawn[i][j]))
      end
    end
  end

  print("press \x8e/\x97 to start", 20, 100, flr(time()*5)%15+1)

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


function fill_enemy_table(level, lvl_timer)
  local types = {"shooter", "basic", "exploder"}
  local baseline = 20
  for i=1,(baseline*level) do
    add(enemy_table, enemy(flr(rnd(128)), flr(rnd(128)), types[flr(rnd(#types))+1], flr(rnd(lvl_timer))))
  end
end

function gameflow()
  -- start game
  -- music(11,1)
  seraph = {}
  seraph.brd_color = 12
  seraph.text = "READY TO GET TO WORK?"
  drawdialog = true -- show seraph's dialog
  --wait.controls = true -- stop player controls

  level_sprites = { 239, 0, 0,
                    239, 15*8, 0,
                    238, 0*8, 15*8,
                    238, 15*8, 15*8,

                    235, 15*8, 5*8,
                    235, 15*8, 6*8,
                    235, 15*8, 7*8,
                    235, 15*8, 8*8,
                    235, 15*8, 9*8,
                    235, 15*8, 10*8,

                    255, 15*8, 12*8,
                    255, 15*8, 13*8,
                    255, 15*8, 14*8

                    --251, 50, 26

                  }
  timers["leftclick"] = 1
  yield()

  titlescreen = true -- stop showing titlescreen

  seraph = {} -- reset seraph table to defaults
  seraph.text = "ALRIGHT, I SEE A DOOR. GIVE MEA MINUTE AND I'LL TRY AND OPENIT."
  drawdialog = true -- show seraph's dialog
  --wait.controls = true -- stop player controls
  yield()

  --wait.controls = false  -- resume player controls
  drawdialog = false -- stop showing seraph's dialog

  fill_enemy_table(1, 65)
  spawn_enemies = true -- tell the game we want to spawn enemies
  wait.start_time = time() -- used for timer and spawn time to compare when to spawn
  timers["leveltimer"] = 65
  wait.timer = true -- tells the game we want to wait for the timer to finish
  yield()

  kill_all_enemies(true)
  wait.timer = false
  spawn_enemies = false

  seraph = {}
  seraph.text = "okay, that should do-"
  drawdialog = true
  --wait.controls = true
  yield()

  --wait.controls = false
  drawdialog = false

  add(boss_table, boss(60, 60, 128, 1))
  yield()

  kill_all_enemies()

  wait.controls = true
  open_door = true
  level_change = true
  yield()

  --level.border.right = 248
  wait.controls = false
  yield()

  fill_enemy_table(2, 60)
  wait.start_time = time()
  --wait.timer = true
  spawn_enemies = true
  add(boss_table, boss(56, 56, 139, 2))
  yield()

  kill_all_enemies(true)
  --level.border.right = 432
  level_change = true
end

--[[
    skill-tree menu (needs to be called continuously from draw to work)
]]
function skilltree()

  rectfill(-50, -50, 200, 200, 0)
  spr(coin.sprites[flr(time()*8)%#coin.sprites + 1], 20, 20, 2, 2)
  print(" - " .. player_tokens, 36, 26, 7)

  print("upgrade speed - ".. next_cost[1] .." tokens ", 10, 36, 7+((skills_selected[1] and 1 or 0)*3))
  print("upgrade fire rate - ".. next_cost[2] .." tokens ", 10, 44, 7+((skills_selected[2] and 1 or 0)*3))
  print("upgrade health - ".. next_cost[3] .." tokens ", 10, 52, 7+((skills_selected[3] and 1 or 0)*3))
  print("quit", 10, 68, 7+((skills_selected[4] and 1 or 0)*3))

end

--[[
    draw enemy destruction animation to screen
  ]]
function step_destroy_animation(e)

  if e.destroyed_step <= e.destroy_anim_length then
    spr(e.destroy_sequence[flr(e.destroyed_step/15)+1], e.x, e.y)
  else
    drop_item(e)
    del(destroyed_enemies, e)
  end

  circ(e.x+4, e.y+4, e.destroyed_step%5, 8)
  e.destroyed_step += 1

  if e.type == "exploder" then
    circ(e.x+4, e.y+4, e.destroyed_step%15, 8)
    e.destroyed_step += 1
    if e.destroyed_step >= e.destroy_anim_length then
      del(destroyed_enemies, e)
      del(exploding_enemies, e)
      del(enemy_spawned, e)
      return true
    end
    return false
  end
end

--[[
    draw boss hit animation
]]
function boss_hit_animation(bul)
  local colors = {8, 9}

  if bul.current_step <= bul.max_anim_steps then
    local c = colors[flr(time()*100)%(#colors) + 1]
    local s = flr(time()*100)%4
    local r = 1
    if (rnd(1) > .5) r = 0xffff
    if (not bul.rocket) then
      circ(bul.x, bul.y, s, c)
    else
      for i=1,3 do
        circfill((r*rnd(bul.max_anim_steps/2))+bul.x, (r*rnd(bul.max_anim_steps/2))+bul.y, rnd(4), c)
        circfill((r*rnd(bul.max_anim_steps))+bul.x, (r*rnd(bul.max_anim_steps))+bul.y, .1, c)
      end
      circ(bul.x, bul.y, bul.current_step, c)
    end
  else
    del(boss_hit_anims, bul)
  end

  bul.current_step += 1
end

--[[
  draw boss destruction animation
]]
function step_boss_destroyed_animation(b)
  local s = 1 s1 = 1
  if (flr(rnd(10))%2 == 0) s = 0xffff
  if (flr(rnd(10))%2 == 0) s1 = 0xffff
  if b.destroyed_step <= b.destroy_anim_length then
    spr(b.destroy_sequence[flr(b.destroyed_step/30)+1], b.x+s*flr(rnd(8)), b.y+s1*flr(rnd(8)))
    spr(b.destroy_sequence[flr(b.destroyed_step/30)+1], b.x+s*flr(rnd(8)), b.y+s1*flr(rnd(8)))
  else
    del(destroyed_bosses, b)
    coin.dropped = true
  end

  circ(b.x+4, b.y+4, b.destroyed_step%5, 8)
  b.destroyed_step += 1

end

function drop_item(e)
  if (flr(rnd(100)) <= e.drop_prob) add(dropped, drop_obj(e.x, e.y, e.drops[flr(rnd(#e.drops)) + 1]))
end

function distance(n, d)
  return sqrt((n.x-d.x)*(n.x-d.x)+(n.y-d.y)*(n.y-d.y))
end

function loop_func(table, func)
  for e in all(table) do
    func(e)
  end
end

function time_diff(time_var, thresh)
  return ((time() - (time_var or (time()-2))) > thresh)
end

function move_anim(l)
  local col = {8,9,10}
  for i=1,5 do
    pset(rnd(5)+(l[1]+8)+6*sin(player_angle / 360), rnd(5)+(l[2]+8)+6*cos(player_angle / 360), col[i%#col + 1])
  end
end

function rocket_kill(rocket)
  for enemy in all(enemy_spawned) do
    if distance(enemy, rocket) <= rocket.max_anim_steps then
      player_killed += 1
      del(enemy_spawned, enemy)
      sfx(5,1)
      add(destroyed_enemies, enemy)
      del(player_bullets, rocket)
      add(boss_hit_anims, rocket)
    end
  end
end

function draw_playerhp()
  local hpcolor = 11
  local hpratio = player_health/player_max_health
  if (invtx == nil) invtx = 4
  if (invtx > 4) invtx -= 1

  if hpratio >= .5 then
    hpcolor = 11
  elseif hpratio >= .3 then
    hpcolor = 9
  elseif player_health == 1 and flr(time()*10000)%2==0 then
    hpcolor = 6
  else
    hpcolor = 8
  end

  rectfill(player.x + 3, player.y + 1, player.x + 12, player.y + 1, 6) --background
  rectfill(player.x + 3, player.y + 1, player.x + 3 + (9 * hpratio), player.y + 1, hpcolor) --hp bar
  if (player_shield > 0) rectfill(player.x + 3, player.y + 1, player.x + 4 + (8 * (player_shield / 4.8)), player.y + 1, 12)

  --if not time_diff(player.last_middle_click, .5) --[[or not time_diff(player.last_right, .5)]] then
  if timers["showinv"] > 0 then
    if (#player_inventory > 0) spr(player_inventory[1].sprite, player.x + invtx, player.y + 14)
    if (#player_inventory > 1) spr(player_inventory[2].sprite, player.x + invtx + 9, player.y + 14)
    if (#player_inventory > 2) spr(player_inventory[#player_inventory].sprite, player.x + invtx - 9, player.y + 14)
    spr(112, player.x + 4, player.y + 14)
  end
end


--------------------------------------------------------------------------------
---------------------------------- constructor ---------------------------------
--------------------------------------------------------------------------------
function _init()
  init_mem()
  poke(0x5f2d, 1)

  title.init = time()

  game = cocreate(gameflow)
  coresume(game)
end --end _init()


--------------------------------------------------------------------------------
---------------------------------- update --------------------------------------
--------------------------------------------------------------------------------
function _update()
  --player.last_hit = abs(time() - 0.5) --uncomment for god mode
  --collision()
  collide_all_enemies()

  local previousx, previousy = player.x, player.y
  -- local previousy = player.y

  for k,t in pairs(timers) do
    timers[k] = max(0, timers[k] - (1/30))
  end

  if not titlescreen then
    if (btnp(c.x_button) or btnp(c.z_button)) titlescreen = true; --music(0)
    return
  end

  if in_skilltree then
    skills_selected[currently_selected] = false
    local diff = 0
    local function update_selec()
            if selection_set[currently_selected] == "health" then
              player_max_health += 1
              player_health += 1
            elseif selection_set[currently_selected] == "fire rate" then

            elseif selection_set[currently_selected] == "speed" then
              player_speed += .2
            end
            next_cost[currently_selected] = next_cost[currently_selected] + 1
            player_tokens -= 1
            sfx(2, 1, 0)
          end
    if btnp((c.up_arrow)) then
      diff = 0xffff
      sfx(4, 1, 0)
    elseif btnp(c.down_arrow) then
      diff = 1
      sfx(4, 1, 0)
    elseif btnp(c.x_button) then
      if selection_set[currently_selected] == "quit" then
        in_skilltree = false
        sfx(1, 1, 0)
      elseif (selection_set[currently_selected] == "health" and player_tokens >= next_cost[currently_selected]) then
        update_selec()
      elseif (selection_set[currently_selected] == "fire rate" and player_tokens >= next_cost[currently_selected]) then
        update_selec()
      elseif (selection_set[currently_selected] == "speed" and player_tokens >= next_cost[currently_selected]) then
        update_selec()
      else
        --invalid = time()
        timers["invalid"] = 0.5
        sfx(2, 1, 0)
      end
    end
    currently_selected = ((currently_selected+diff)%#skills_selected)
    if (currently_selected == 0) currently_selected = 4
    skills_selected[currently_selected] = true
    if player_tokens == 0 then
      for i=1,5 do
        flip()
      end
      in_skilltree = false
    end
    return
  end

  if not wait.controls then
    --[[
      up arrow
    ]]
    if (btn(c.up_arrow)) then
      player.y -= player_speed
      add(moves, {player.x, player.y})
      if (bump(player.x + 4, player.y + 3) or bump(player.x + 11, player.y + 3)) player.y = previousy
    end --end up button

    --[[
      down arrow
    ]]
    if (btn(c.down_arrow)) then
      player.y += player_speed
      add(moves, {player.x, player.y})
      if (bump(player.x + 4, player.y + 12) or bump(player.x + 11, player.y + 12)) player.y = previousy
    end --end down button

    --[[
      left arrow
    ]]
    if (btn(c.left_arrow)) then
      player.x -= player_speed
      add(moves, {player.x, player.y})
      if (bump(player.x + 3, player.y + 4) or bump(player.x + 3, player.y + 11)) player.x = previousx
    end --end left button

    --[[
      right arrow
    ]]
    if (btn(c.right_arrow)) then
      player.x += player_speed
      add(moves, {player.x, player.y})
      if (bump(player.x + 12, player.y + 4) or bump(player.x + 12, player.y + 11)) player.x = previousx
    end --end right button

    -- middle mouse button
    if (stat(34) == 4) then -- cycle inventory
      local temp = 0
      --if #player_inventory > 1 and time_diff(player.last_middle_click, .15) then
      if timers["middleclick"] == 0 then
        if #player_inventory > 1 then
          for i=1,#player_inventory do
            if i == 1 then
              temp = player_inventory[i]
            elseif i == #player_inventory then
              player_inventory[i] = temp
              break
            end
            player_inventory[i] = player_inventory[i+1]
          end
        end

        timers["middleclick"] = .25
        timers["showinv"] = .5
        if (#player_inventory == 2) invtx = 7
        if (#player_inventory > 2) invtx = 13
      end
      --player.last_middle_click = time()
    end

    --right mouse button
    if (stat(34) == 2) and #player_inventory > 0 and timers["rightclick"] == 0 then
      timers["rightclick"] = player_power_fire_rate

      if player_inventory[1].type == "shotgun" then
        for i=-1,1 do
          shoot(player.x, player.y, i*30, 34, true, false, true)
        end
        --timers["rightclick"] = .1 --allows for custom firespeed
        --sfx(1,1)

      elseif player_inventory[1].type == "rockets" then
        shoot(player.x, player.y, 0, 48, true, false)
        --sfx(10,1)
      end

      if player_inventory[1].ammo == 1 then
        if (player_inventory[1].type ~= "rockets") sfx(3)
        del(player_inventory, player_inventory[1])
        timers["showinv"] = .5
        timers["rightclick"] = 1
      else player_inventory[1].ammo -= 1 end
    end

    player_angle = flr(atan2(stat(32) - (player.x + 8), stat(33) - (player.y + 8)) * -360 + 90) % 360
  else
    -- player.last_hit = time() - player_immune_time --make player invulnerable so they dont get hit when they can't move
    timers["playerlasthit"] = 0x.0001 --make player invulnerable so they dont get hit when they can't move
  end -- end wait.controls

  --[[
    z button
    -- shoot for now, this can be changed later
  ]]
  -- if (btn(c.z_button)) then
  --stat(34) -> button bitmask (1=primary, 2=secondary, 4=middle)
  -- if (stat(34) == 1) then
  --   --if drawdialog and not wait.dialog_finish and time_diff(player.last_click, 1)then
  --   if drawdialog and not wait.dialog_finish and timers["leftclick"] == 0 then
  --     --player.last_click = time()
  --     timers["leftclick"] = 1
  --     coresume(game)
  --
  --   elseif not drawdialog and not wait.controls then
  --     player_b_count = inc(player_b_count)
  --     --if time_diff(player.last_click, .25) or player_b_count%player_fire_rate == 0 then
  --     if timers["leftclick"] == 0 or player_b_count%player_fire_rate == 0 then
  --       --player.last_click = time()
  --       timers["leftclick"] = .25
  --       shoot(player.x, player.y, player_angle, 34, true, false)
  --       sfx(1,1)
  --     end
  --   end
  -- end --end z button
  if (stat(34) == 1) then
    if drawdialog and not wait.dialog_finish and timers["leftclick"] == 0 then
      coresume(game)
      timers["leftclick"] = 1

    elseif not wait.controls and timers["firerate"] == 0 then
      shoot(player.x, player.y, player_angle, 34, true, false)
      --sfx(1,1)
      timers["firerate"] = player_fire_rate
    end
  end

  -- right mouse button
  -- if (stat(34) == 2) and #player_inventory > 0 then
  --   save_data()
  --   load_data()
  --   --if player_inventory[1] == 48 and time_diff(player.last_right, .25) then
  --   if player_inventory[1].sprite == 48 and timers["rightclick"] == 0 then
  --     shoot(player.x,player.y, 0, 48, true, false)
  --     sfx(10,1)
  --     if player_inventory[1].ammo == 1 then
  --       del(player_inventory, player_inventory[1])
  --     else
  --       player_inventory[1].ammo -= 1
  --     end
  --     --player.last_right = time()
  --     --player.last_middle_click = time() --so when the inventory switches after firing, it shows inventory
  --     timers["rightclick"] = .25
  --     timers["middleclick"] = .25
  --   end
  --   --if player_inventory[1] == 33 or time_diff(player.last_right, .25) then
  --   if player_inventory[1].sprite == 33 and timers["rightclick"] == 0 then
  --     player_b_count = inc(player_b_count)
  --     --if player_b_count%player_fire_rate == 0 and time_diff(player.last_click, .25) then
  --     if --[[player_b_count%player_fire_rate == 0 and]] timers["leftclick"] == 0 then
  --       shoot(player.x, player.y, player_angle, 34, true, false, true)
  --       shoot(player.x, player.y, 30, 34, true, false, true)
  --       shoot(player.x, player.y, -30, 34, true, false, true)
  --       sfx(1,1)
  --     end
  --
  --     if player_inventory[1].ammo == 1 then
  --       del(player_inventory, player_inventory[1])
  --     else
  --       player_inventory[1].ammo -= 1
  --     end
  --     --player.last_right = time()
  --     timers["rightclick"] = 1
  --   end
  -- end

  --[[
    x button
  ]]
  if (btnp(c.x_button)) and not level_change then
    coresume(game)
  end --end x button

  --player.x = player.x - player.current_speed * sin((player_angle - player_turn) / 360)
  --player.y = player.y - player.current_speed * cos((player_angle - player_turn) / 360)

  if (level_change)  levelchange()

  --player.current_speed = 0
  --player_turn = 0
  if (player.x < 0) player.x = 0
  if (player.y < 0) player.y = 0
  if (player.x > 112) player.x = 112
  if (player.y > 112) player.y = 112

  if player_shield > 0 and not wait.controls then
    player_shield = player_shield - .01
  elseif player_shield < 0 then
    player_shield = 0
  end

  if (btn(c.left_arrow, 1)) level_sx += 1
  if (btn(c.right_arrow, 1)) level_sx -= 1
end --end _update()

--------------------------------------------------------------------------------
--------------------------------- draw buffer ----------------------------------
--------------------------------------------------------------------------------
function _draw()
  cls()
  map(level_x, level_y, level_sx, level_sy, 128, 128)

  if not titlescreen then
    draw_titlescreen()
    return
  end


  if level_sprites ~= nil then
    palt(5, true)
    for i = 1, #level_sprites, 3 do
      local x = level_sprites[i+1] + level_sx
      local y = level_sprites[i+2] + level_sy
      --spr_r(level_sprites[i], level_sprites[i+1] + level_sx, level_sprites[i+2] + level_sy, level_sprites[i+3], 1, 1)
      spr(level_sprites[i], x, y)
      --if x < 128 then del(level_sprites, ) end todo make this delete offscreen sprites
    end
  end
  palt()

  if (open_door) opendoor()

  spr_r(player_sprite, player.x, player.y, player_angle, 2, 2)
  loop_func(moves, move_anim)
  moves = {}

  if (player_shield > 0) circ((player.x+8), (player.y+7), ((time()*50)%2)+6, 12)

  for e in all(enemy_spawned) do
    -- this should never happen, but just in case:
    delete_offscreen(enemy_spawned, e)

    -- check if this sprite has been shot
    for b in all(player_bullets) do
      if ent_collide(e, b) then
        player_killed += 1
        del(enemy_spawned, e)
        sfx(5,1)
        add(destroyed_enemies, e)
        del(player_bullets, b)
        add(boss_hit_anims, b)
        if (b.rocket) rocket_kill(b)
        b = nil
        e = nil
        break
      end
    end


    if e ~= nil then
      -- if time_diff(player.last_hit, player_immune_time) and ent_collide(e) then
      if timers["playerlasthit"] == 0 and ent_collide(e) then
        if player_shield <= 0 then
          player_health -= 1
          sfx(2,2)
          --player.last_hit = time()
          timers["playerlasthit"] = player_immune_time
        else
          player_shield = player_shield - .15
        end
      end

      if e.exploding and flr(time()*500)%2==0 then
        pal()
        pal(2,8,0)
      end

      if e.type == "shooter" then
        pal(2,9,0)
        pal(5,10,0)
      elseif e.type == "exploder" then
        pal(8,10,0)
        pal(2,8,0)
        pal(5,9,0)
      else
        pal()
      end
      spr(e.sprite, e.x, e.y)
      pal()

      if (e.explode_step == e.explode_wait) add(exploding_enemies, e)

      e.move()
    end
  end

  for e in all(exploding_enemies) do
    if step_destroy_animation(e) then
      -- if distance(e, player) <= 15 and time_diff(player.last_hit, player_immune_time) then
      if distance(e, player) <= 15 and timers["playerlasthit"] == 0 then
        if player_shield <= 0 then
          player_health -= 1
          sfx(2,2)
          -- player.last_hit = time()
          timers["playerlasthit"] = player_immune_time
        else
          player_shield = player_shield - .15
        end
      end
    end
  end

  loop_func(destroyed_enemies, step_destroy_animation)

  for d in all(dropped) do
    if ent_collide(d) then
      if d.type == "heart" and player_health < player_max_health then
        player_health = min(player_max_health, player_health+3)
        sfx(7,1)
        del(dropped, d)
      elseif d.type == "shield" then
        player_shield = player_shield_dur
        sfx(4,1)
        del(dropped, d)
      elseif d.type ~= "heart" and #player_inventory < player_inv_max then
        add(player_inventory, d)
        sfx(6,1)
        del(dropped, d)
      end
    end

    if abs(time() - d.init_time) <= d.drop_duration then
      if abs(time() - d.init_time) <= 2*(d.drop_duration/3) then
        spr(d.sprite, d.x, d.y)
      elseif flr(time()*1000)%2==0 then
        spr(d.sprite, d.x, d.y)
      end
    else
      del(dropped, d)
    end
  end

  for b in all(player_bullets) do
    -- first delete offscreen bullets:
    delete_offscreen(player_bullets, b)

    if bump(b.x, b.y) then
      del(player_bullets, b)
      add(boss_hit_anims, b)
      if (b.rocket) rocket_kill(b)
      b = nil
    end

    if b ~= nil then
      spr_r(b.sprite, b.x, b.y, b.angle, 1, 1)
      b.move()
      if (b.duration <= 0) del(player_bullets, b); b = nil

    end

    if b~=nil then
      for bos in all(boss_table) do
        if ent_collide(bos, b) then
          sfx(4,1)
          bos.health -= ((b.sprite == 48) and 3 or 1)
          bos.shot_last = time()
          bos.shot_ang = angle_btwn(player.x+5, player.y+5, bos.x, bos.y)
          del(player_bullets, b)
          add(boss_hit_anims, b)
          if (b.rocket) rocket_kill(b)
          if (bos.health <= 0) then
            sfx(5,1)
            add(destroyed_bosses, bos)
            player_killed = player_killed+1
            del(boss_table, bos)
            coin.x = bos.x - level_sx
            coin.y = bos.y - level_sy
            bos = nil
            coresume(game)
          end
          break
        end
      end
    end
  end

  for b in all(enemy_bullets) do
    -- first delete offscreen bullets:
    delete_offscreen(enemy_bullets, b)

    -- if time_diff(player.last_hit, player_immune_time) and ent_collide(player, b) then
    if ent_collide(player, b) then
      if timers["playerlasthit"] == 0 then
        if player_shield <= 0 then
          player_health -= 1
          sfx(2,2)
          -- player.last_hit = time()
          timers["playerlasthit"] = player_immune_time
        else
          add(shield_anims, {b.x, b.y, 10})
          player_shield = player_shield - .15
        end
      end
      del(enemy_bullets, b)
      b = nil
    end

    if b~=nil then
      spr(b.sprite, b.x, b.y)
      b.move()
      if (bump(b.x, b.y)) del(enemy_bullets, b); b = nil
    end
  end

  for s in all(shield_anims) do
    local colors = {12, 13, 1}
    s[3] = s[3]-1
    circ(s[1]+8, s[2]+8, flr(time()*100)%4, colors[flr(time()*100)%#colors + 1])
    if (s[3] == 0) del(shield_anims, s)
  end

  for b in all(boss_table) do
    -- if time_diff(player.last_hit, player_immune_time) and ent_collide(player, b) then
    if (timers["playerlasthit"] == 0 and ent_collide(player, b)) player_health -= 2; timers["playerlasthit"] = player_immune_time
    spr(b.sprite, b.x, b.y, 2, 2)
    b.update()
  end

  loop_func(boss_hit_anims, boss_hit_animation)

  loop_func(destroyed_bosses, step_boss_destroyed_animation)

  if player_health <= 0 then
    sfx(9,1)
    show_leaderboard()
    run()
  end

  draw_playerhp()

  if (pget(stat(32), stat(33)) == 8 or pget(stat(32), stat(33)) == 2)  pal(8, 6)
  spr(96, stat(32) - 3, stat(33) - 3)
  pal()

  --draw_hud()
  if (spawn_enemies) spawnenemies()
  if (detect_killed_enemies) detect_kill_enemies()
  if (wait.timer) drawcountdown()
  if coin.dropped then
     spr(coin.sprites[flr(time()*8)%#coin.sprites + 1], coin.x+level_sx, coin.y+level_sy, 2, 2)
     if ent_collide(player, coin) then
       player_tokens += 1
       coin.dropped = false
       direction = nil
       in_skilltree = true
     end
  end

  if (drawdialog) dialog_seraph(seraph)

  -- if (abs(time() - player.last_hit) < 0.5) or (abs(time() - invalid) < 0.5) then
  if (timers["playerlasthit"] > player_immune_time - 0.5) or (timers["invalid"] > 0) then
    camera(cos((time()*1000)/3), cos((time()*1000)/2))
  else
    camera()
  end

  if (in_skilltree) skilltree()
  if (in_leaderboard) draw_leaderboard()

  debug() -- always on bottom
end --end _draw()


__gfx__
000000000000000000000000555555555555555555555555533333355222222552a99a250000000000000000000000000000000000c00c000000000000000000
00000000000000000000000055555555555555555555555533777b3322aaa92252a99a256601106666011066660110666601106666c11c660000000000000000
000000000000000000000000555555555555555555555555377bbbb32aa9999252a99a2566199166661991666619916666199166661991660000000000000000
0000000000000000000000005555555555999a5999a5555537bbbbb32a99999252a99a2566199166661991666619916666199166661991660000000000000000
0000600000060000000000005555555555aaa559aaaa55553bbbbbb329999992529aa92566199166661991666619916666199166661991660000000000000000
0000660cc06600000000000055555555555555555555555537bbbbb32a999992529aa92500511500005115000051150000511500005115000000000000000000
00006619916600000000000055555555559a55599a59a55533bbbb3322999922522992250001100000c11c000c011000000110c0000110000000000000000000
0000661991660000000000005555555555999a5aa55aaa555333333552222225555225550000000000c00c00c00000000000000c000000000000000000000000
000066199166000000000000bb55555b555555555555555599555559000000005555555500000000000000000000000000000000000000000000000000000000
00000051150000000000000053b555b555a5a99995559a5559955595000000005552255500000000000000000000000000000000000000000000000000000000
000000011000000000000000553b55b555aa5aaaa55aaa5555999995000000005229922500000000000000000000000000000000000000000000000000000000
000000000000000000000000553b55b555555555555555555559955500000000529aa92500000000000000000000000000000000000000000000000000000000
000000000000000000000000553b5b55555555999aa555555559995500000000529aa92500000000000000000000000000000000000000000000000000000000
00000000000000000000000053bbbb55555555aaaa555555559959950000000052a99a2500000000000000000000000000000000000000000000000000000000
0000000000000000000000003bb355b55555555555555555559555950000000052a99a2500000000000000000000000000000000000000000000000000000000
000000000000000000000000b355555b5555555555555555999555590000000052a99a2500000000000000000000000000000000000000000000000000000000
00000000000000000000000053b00b35000000005bbbbbb522222222000000000000000000000000555555555555555500000000000000000000000000000000
0ee00ee0000000000000000053b00b3507000070bb7773bb25555552000000000000000000000000555555555555555500000000000000000000000000000000
e88ee88e000000000000000053b00b3507700770b773333b25555552000000000000000000000000555555555555555500000000000000000000000000000000
e888888e666666600a0000a053b00b3578899887b733333b2555555200000000000000000000000055bbb35bbb35555500000000000000000000000000000000
e888888e044004400a0000a0530bb03500899800b333333b255555520000000000000000000000005533355b3333555500000000000000000000000000000000
0e8888e00000004400000000530bb03503088030b733333b25555552000000000000000000000000555555555555555500000000000000000000000000000000
00e88e0000000000000000005330033500000000bb3333bb2225555200000000000000000000000055b3555bb35b355500000000000000000000000000000000
000ee000000000000000000055533555000000005bbbbbb55522222200000000000000000000000055bbb3533553335500000000000000000000000000000000
00088000990000990000000055555555771111770000000000000000a55a55550000000000000000555555555555555550000005000000000000000000000000
00066000967766690003000055533555711111170000000000000000aa5aa55a000000000000000055353bbbb555b35500777600000000000000000000000000
0006600097666669003b3000533003351111111100000000000000005a55a5aa0000000000000000553353333553335507766660000000000000000000000000
000660009666665903b30000530bb0351111111100000000000000005aa5aaa50000000000000000555555555555555507666660000000000000000000000000
000660000966669003b30000530bb03511111111000000000000000055aa55550000000000000000555555bbb335555507666660000000000000000000000000
0086680009666590003b300053b00b3571111117000000000000000055a5a5550000000000000000555555333355555507666660000000000000000000000000
08866880009559000003000053b00b357711117700000000000000005aa5aaaa0000000000000000555555555555555500666600000000000000000000000000
00000000000990000000000053b00b35aaaaaaaa0000000000000000aa55555a0000000000000000555555555555555550000005000000000000000000000000
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
66000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00555500000000009000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05999950000000009008800900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
58855885000000009008800900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05955950000000000998899000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00555500000000000098890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099000000000000098890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055000000000000009900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055000000000000009900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66655566000000008800000055555555355355350455540006ddd600555555555555555552aaa25553bbb35555676665000000009ddddddd5555555995555555
6775557700000000280000003553553535555535045f540006ddd600555555555555555552a9a25553b3b35555567765000000009ddddddd5555559dd9555555
675555550000000028000000553335555353535500454000006d60005555555553333355552a2555553b355556766755000000009ddddddd555559dddd955555
6755555500000000880000003b3b3b35553b3555004f4000006d60005555555553bbb35555292555553b355557655556000000009ddddddd55559dddddd95555
55555555000000008800000033bbb33533bbb335004f4000006d6000555555555333335555292555553b355556556676000000009ddddddd5559dddddddd9555
6755557600000000280000003bbbbb353bbbbb35004f400000656000555555555535555555292555553b355555566676000000009ddddddd559dddddddddd955
555557760000000028000000533b3355533b335504fff400065d56005555555555b555555299925553bbb35566666677000000009ddddddd59dddddddddddd95
55555666000000008800000055535555555355554fffff406d555d605555555555555555299999253bbbbb3577777777000000009ddddddd9dddddddddddddd9
033333309999999999999a9955555555955955958888888255555552255555555555558882288228555555353b00b30000000000dddddddd9dddddddddddddd9
03b55b30999999999999a9a995595595955555958888888255555528825555555555558288888888555555b53b00b30000000000dddddddd59dddddddddddd95
03b55b3099999999999a999a5599955559595955888888825555528888255555555555820000000055bbbbb53b00b3003b55b300dddddddd559dddddddddd955
03b55b30999a999999a999a99a9a9a95559a9555888888825555288888825555555555880000000055b333b53b00b3003b55b300dddddddd5559dddddddd9555
03b55b30aaa9a9aaaa99999a99aaa99599aaa995888888825552888888882555555555880000000055bbbbb53b00b3003b55b300dddddddd55559dddddd95555
03b55b3099999a99999999999aaaaa959aaaaa958888888255288888888882555555558200000000555555553b00b3003b55b300dddddddd555559dddd955555
b3b55b3b9999999999999999599a9955599a99558888888252888888888888255555558200000000555555553b00b3003b55b300dddddddd5555559dd9555555
0bbbbbb0999999999999999955595555555955558888888228888888888888825555558800000000555555553333330033333300dddddddd5555555995555555
b3b55b3b000000009999999933355533555555532222222228888888888888820000000055b5555582288228555555bb55555555dddddddd555555556bb66bb6
03b55b3000000000999999993bb555bb53b5555b888888885288888888888825000000005535555588888888555555b655555555dddddddd5555555566666666
03b55b3000000000999999993b5555553b555555888888885528888888888255000000005333335588000000555555b655555555dddddddd5555555555555555
03b55b3000000000999999993b5555553b55b3558888888855528888888825550000000053bbb35528000000555555bb55555555dddddddd5555555555555555
03b55b3000000000aa99999a5555555555553b55888888885555288888825555000000005333335528000000555555bb55555555dddddddd5555555555555555
03b55b300000000099a999a93b5555b353355555888888885555528888255555000000005555555588000000555555b655555555dddddddd5555555555555555
03b55b3000000000999a9a9955555bb35b3b5555888888885555552882555555888888885555555588000000555555b6bbbbbbbbdddddddd6666666655555555
03333330000000009999a9995555533353355555888888885555555225555555822882285555555528000000555555bbb66bb66b999999996bb66bb655555555
0000000000000000000000005555555656555555888888822888888888888888888888885655555500000000ddddddddddddddd9999999996655555555555566
0000000000000000000000005675555756555555888888822888888888888888888888885666665500000000d4444444ddddddd9ddddddddb65555555555556b
0000000000000000000000006755555556666666888888822888888888888888888888885677765500000000d44fff44ddddddd9ddddddddb65555555555556b
0000000000000000000000006755765556777776888888822888888888888888888888885666665500000000d4f4f4f4ddddddd9dddddddd6655555555555566
0000000000000000000000005555675556666666888888822888888888888888888888885555555500000000d4ff4ff4ddddddd9dddddddd6655555555555566
0000000000000000000000005665555555555556888888822888888888888888888888885555555500000000d4f4f4f4ddddddd9ddddddddb65555555555556b
0000000000000000000000005767555555555556888888822888888888888888888888885555555500000000d44fff44ddddddd9ddddddddb65555555555556b
0000000000000000000000005665555555555556888888822888888822222222888888885555555500000000d4444444ddddddd9dddddddd6655555555555566

__gff__
0001000000000101000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000202000000000000000000000000000000020000000000000000000000000000000000000000000000000100000000
__map__
feefefefefefefefefefefefefefefff3c060606060606060606063c3c3c3c250000000000e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8d2d2d2d2d2d2c7c7c7c7e4c7d2d2d2d2d200000000000000000000c7c7f4f3f4f3f9f9c7c7f4c7c7c7c7f400fc03d2d2d203c7c7e4ebd2d2c703f3c700000000000000000000000000
fe0303030303030303030303030303ff3c0303030303030303030304050303250000000000d5c7c7f7f8f8f8f8f7c7f6f8d5c7c7c7c7d8d2d2d2c7c7c7c7e3c7dac8c7c7c8d2d2d200000000000000000000c7f9c0c0f3f4c7c00303030303c7c7f300d503c7c7c7c7c7c7e3e9d2d2c7cbf4c700000000000000000000000000
fe0303030303030303030303030303ff3c3703370303c70313030314150303250500000000d5c7c7c7f7f7f7f7c7c7f6f6f5c7c7c7c7d8d2d2d2e9e3c7c8c7c8c7c7e9e4c7d2d2d200000000000000000000c0c7c7c7c7f3c7030303c7c7c7f3c7c000ddc7ced7f8e3e9f40303c7c7c7c0f4c700000000000000000000000000
fe030303cefdfdcf03030303030303ff3c0316c7c73cc713031303030303d3061500000000d5c7c7c7c7c7c7c7c7c7c7f6f5c7c7c7c7d8c7e9c7c7c8c7e9e3e3e3e3c7e3c7c8c7d200000000000000000000c7c7c7c7c703030303030303c7f9f3f400ddddddf8f8e4c8f3cbc0c7c7030303c700000000000000000000000000
fec70303cdfbfbfc03030303030303ff25c716c73c3c3cc7130303030303c93c0500000000d5c7c7c7c7c7c7c7c7c7c7f6f5c7c7c7c7d6c7c7c7c8dac7d2d2d2d2d2d2e9c7c7e4e3c7c7c7c7c7c7c7f4f3f9c7c7c7c7c7c7c7c7c7f3f4c7c7c7c7c7030303030303e3e403f903e403030303c700000000000000000000000000
fe030303deddfbfc03030303030303ce0316c716c73cc7c703040503030303071500000000d5e5e5c7c7c7c7c7c7c7c7c7c7c7c7c7c7f6e3e4c7e4c7e3d2d2d2d2d2d2e3e3e3e9e4c7c7c7c7c7c7c7c7c7c7c7c7f4c7c7c7c7f3c7c7c7c7c7c7c7c70303030303030303030303e303030303c700000000000000000000000000
fe03030303cdfbfc03030303030303cd03130313c7c7c7c7031415030303030705e8e8e8e8f6f8d5c7c7c7c7c7c7c7c7c7c7c7c7c7c7f6e9e3c8c7e3e3d2d2d2d2d2d2d2d2d2e3e3c7c7c7c7c7c7c7f4f3f9f3c7f3c7c7c7c7f4c7c7c7c7c7c0c7c703030303030303030303030303030303c700000000000000000000000000
fe03030303deeddf03030303030303cd03c703c70303c703030303030303030803c7c7c7c7c7c7c7c7c7c7c7c7c7f6d5c7c7c7c7c7c7f6c7c7dac8c7d2e3e9d2d2d2d2d2d2d2e4e3c7c7c7c7c7c7c7000000c7f3c0c7c7c0c7f3c7f3f4c7c7c7c7c000f6c7c7c7c7c7c7c7c7c7c7c7f9f303c700000000000000000000000000
fe0303030303030303030303030303cd0303c303032a2b03030313030303031803c7c7c7c7c7c7c7c7c7c7c7c7c7f6d5c7c7c7c7c7c7f6c7c7c7e9c7d2e3c7d2d2d2d2d2d2d2c8c7c100005b5b0000000000c7c0f3c7c7c7c7c7c7c7c7c7c7c7c7c700f6c7c7c7c7c7c7c7c7c7c7c7fbfbfbc700000000000000000000000000
fe0303030303030303030303030303cd0303ca03033a3b0303c703130303030703c7c7c7c7c7c7f6c7c7c7c7c7c7c7c7c7c7c7c7f6d9e6e4e4e3c8c7c8c7c7c7c8e3c7e4e3e3c7e30000005b5b0000000000c7c7f3c7c7c7c7c7c7c7c7c7c7c7c7c700f6c7c7c7d2c7c7c7c7c7e4c7c7c7cbc700000000000000000000000000
fe0303030303030303030303030303de03c7030303030303c30316030303d30703c7c7c7c7c7c7f6f8c7c7c7c7c7c7c7c7c7c7c7f6e1c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c70000005b5b0000000000c7c7c7c7c7c7c7c7f3f9c7c7c7c7c7c000f6c7c7c7d2d2c7c7c7c7c8c7c7c7f3c700000000000000000000000000
fe0303030303030303030303030303ff3c03030303030303ca0303030303c93c03c7c7c7c7c7c7f6f7f7f7f7c7c7c7c7c7c7c7c7f600c7c7c7d2c7e3e4c7c7c7c7c7dac7c7c7c7c7c100005b5b0000000000c7c7c7c7c7c7c7c7f4c0cbc7c7c7c7c000f6c7d2d2d2d2d2c7c7e4e4c7c7f4c0c700000000000000000000000000
fe0303030303030303030303cefdfdfd3c03030303030405030303030303033c03d9d9d9d9c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7f600c7d2d2d2c7c7c7e9c8e3e3e4c7c7c7c7d2c1c100005b5b0000000000c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7f300cdc7d2d2d2d2d2c7c7e9dac7c7f9c7c700000000000000000000000000
fe0303030303030303030303cdfbfbdd3c03030303031415030304050303033c0000000000c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7f60000d2d2d2d2c7e3e4e9c7c7c7c7d2d2d2d2c100000000000000000000cbf4c0f3f3c7c7c7c7c7c7c7c7c7c7c000cdc7d2c7d2d2c7c7c7c7c7c7c7c7c7c700000000000000000000000000
fe0303030303030303030303deededed060303030303030303031415030303250000000000e5e5e5e5e5e5d5c7c7c7c7c7c7c7c7f60000000000d2c7c7c7c7c7c7c7c7000000000000000000000000000000c0cbc0cbf3c7c7c7f3c7c7c7c7c7f3c000cdc7d2c7d2d2c7c7c7c7c7c7c7c7c7c700000000000000000000000000
feeecefdfdcfeeeeeeeeeeeeeeeeeeff062525250303030303030303030303060000000000e1e1e1e1e1e1e5e5e5e5e5e5e5e5e5e50000005c5c5c5c5c5c5c5c000000000000000000000000000000000000c7c7c7c7cbf3f4c7c7f4f3c7f3cbc7c7e1cdd2d2d2d2d2e4cbf3f3f3f9e4f4c7c700000000000000000000000000
00000000000000000000000000000000000000253c3c3c0625250606252525000000000000e1e1e1e1e1e1e1e1e1e1e1e1000000000000005c5c5c5c5c5c5c5c000000000000000000000000000000000000e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000e10000e1e1e1e1e100e1e100000000000000000000005c5c5c00000000000000000000000000000000000000e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000e100000000e1e1e1e10000000000000000000000000000000000000000000000000000000000000000000000e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000e10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
000100000d1501215016150191501b150000000000006000190000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000070500a5500e0000e70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000263006010061101b3001b4001b5001b6001b700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001c150151500f1000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000080500d0500f0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000c6500e65011650136200e620096100b6100b6001420000000000000000000000000000000000000000000000000000000000c2000220000000000000000000000000000000000000000000000000000
001000000e35010350143500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000055500a550105701971009100171002310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001335013350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000d0500d0500d0500d0500d0500d0500c0500c0500c0500c0500c0500c0500c05007050070500705007050070500704007040070300702007010070100701007010010000400003000030000300003000
000a000013040140501805014000190001e0002400020500016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000705050080500b5500e55005110071103870006050080500c5500e5500615008150104001f000104001d300104001f000104001f000104001f000104001f000104001f000104001f000104001f00010400
001000200375004750087500875008750087500875008750097500b7500b7500b7500b7500c7500e7500e7500e7500e7500e7501075012750127501275012750127501175011750107500f7500e7500000000000
0010000e096501b650036001b50009600000000a6501a6501860000000000000c6000b600000000000000000000000000000000000000000000000000003f7000000000000000000000000000000000000000000
0010000b073000255005350053100a3500a3100735007310103501031013300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100013047500675006750067500675004750097500975009750097500975009750097500675006750067500575005750057500a7500a7500a7500a750097500975008750057500675006750057500575004750
001000000362004620046200462003630036200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
01 0e0f4344
00 0e0f4344
02 0e0f0d45
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
00 4b4e4544
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
