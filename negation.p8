pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
--------------------------------------------------------------------------------
--------------------------------- global variables  ----------------------------
--------------------------------------------------------------------------------

player = {}
player.sprite = 0
player.x = 80
player.y = 8
player.speed = 1
player.angle = 0
player.turn = 0
player.fire_rate = 10
player.health = 10
player.max_health = 10
player.size = 8
player.immune_time = 2
--player.last_hit = 0
player.b_count = 0
player.tokens = 0
player.inventory = {}
player.inv_max = 4
player.shield_dur = 5
--player.last_right = nil
--player.last_click = nil
--player.last_middle_click = nil
player.killed = 0
player.shield = 0

level = {}
level.border = {}
level.border.left = 0
level.border.up = 0
level.border.right = 120
level.border.down = 120
level.lvl = 1
level.sx = 0
level.sy = 0
level.x = 0
level.y = 0
level.transition = {1, 0, 0,
                    2, 16, 0,
                    3, 39, 0}

wait = {}
wait.controls = false
wait.dialog_finish = false

timers = {leveltimer = 0,
          playerlasthit = 0,
          leftclick = 0,
          middleclick = 0,
          rightclick = 0}

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
title.text = {   "14,14,14,14, 0, 0, 0,14,14,14, 0,14,14,14,14,14,14,14, 0, 14,14,14,14,14,14,14,14, 0, 0,14,14,14,14,14, 0, 0,14,14,14,14,14,14,14, 0,14,14,14,14,14,14,14, 0, 0,14,14,14,14, 0, 0,14,14,14,14, 0, 0, 0,14,14,14",
                 "14, 1, 1, 1,14, 0, 0,14, 1,14, 0,14, 1, 1, 1, 1, 1,14, 0, 14, 1, 1, 1, 1, 1, 1,14, 0,14, 1, 1, 1, 1, 1,14, 0,14, 1, 1, 1, 1, 1,14, 0,14, 1, 1, 1, 1, 1,14, 0,14, 1, 1, 1, 1,14, 0,14, 1, 1, 1,14, 0, 0,14, 1,14",
                 "14, 1, 1, 1, 1,14, 0,14, 1,14, 0,14, 1,14,14,14,14,14, 0, 14, 1,14,14,14,14,14,14, 0,14, 1, 1,14, 1, 1,14, 0,14,14,14, 1,14,14,14, 0,14,14,14, 1,14,14, 0, 0,14, 1,14,14, 1,14, 0,14, 1, 1, 1, 1,14, 0,14, 1,14",
                 "14, 1,14,14, 1, 1,14,14, 1,14, 0,14, 1,14, 0, 0, 0, 0, 0, 14, 1,14, 0, 0, 0, 0, 0, 0,14, 1, 1, 1, 1, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0, 0, 0,14, 1,14, 0, 0, 0,14, 1,14,14, 1,14, 0,14, 1,14,14, 1, 1,14,14, 1,14",
                 "14, 1,14, 0,14, 1, 1, 1, 1,14, 0,14, 1,14,14,14, 0, 0, 0, 14, 1,14, 0,14,14,14,14, 0,14, 1, 1,14, 1, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0, 0, 0,14, 1,14, 0, 0, 0,14, 1,14,14, 1,14, 0,14, 1,14, 0,14, 1, 1, 1, 1,14",
                 "14, 1,14, 0,14, 1, 1, 1, 1,14, 0,14, 1, 1, 1,14, 0, 0, 0, 14, 1,14, 0,14, 1, 1,14, 0,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0, 0, 0,14, 1,14, 0, 0, 0,14, 1,14,14, 1,14, 0,14, 1,14, 0,14, 1, 1, 1, 1,14",
                 "14, 1,14, 0, 0,14, 1, 1, 1,14, 0,14, 1,14,14,14, 0, 0, 0, 14, 1,14, 0,14,14, 1,14, 0,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0, 0, 0,14, 1,14, 0, 0, 0,14, 1,14,14, 1,14, 0,14, 1,14, 0, 0,14, 1, 1, 1,14",
                 "14, 1,14, 0, 0, 0,14, 1, 1,14, 0,14, 1,14, 0, 0, 0, 0, 0, 14, 1,14, 0, 0,14, 1,14, 0,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0, 0, 0,14, 1,14, 0, 0, 0,14, 1,14,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1, 1,14",
                 "14, 1,14, 0, 0, 0,14, 1, 1,14, 0,14, 1,14,14,14,14,14, 0, 14, 1,14,14,14,14, 1,14, 0,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0,14,14,14, 1,14,14,14, 0,14, 1,14,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1, 1,14",
                 "14, 1,14, 0, 0, 0, 0,14, 1,14, 0,14, 1, 1, 1, 1, 1,14, 0, 14, 1, 1, 1, 1, 1, 1,14, 0,14, 1,14, 0,14, 1,14, 0, 0, 0,14, 1,14, 0, 0, 0,14, 1, 1, 1, 1, 1,14, 0,14, 1, 1, 1, 1,14, 0,14, 1,14, 0, 0, 0, 0,14, 1,14",
                 "14,14,14, 0, 0, 0, 0, 0,14,14, 0,14,14,14,14,14,14,14, 0, 14,14,14,14,14,14,14,14, 0,14,14,14, 0,14,14,14, 0, 0, 0,14,14,14, 0, 0, 0,14,14,14,14,14,14,14, 0, 0,14,14,14,14, 0, 0,14,14,14, 0, 0, 0, 0, 0,14,14"}

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

currently_selected = 1
selection_set = {"speed", "health", "fire rate", "quit"}
next_cost = {1, 1, 1}
skills_selected = {true, false, false, false}
invalid = 0
titlescreen = nil

--------------------------------------------------------------------------------
------------------------ object-like structures --------------------------------
--------------------------------------------------------------------------------
--[[
  drop objects
]]
function drop_obj(sx, sy, sprite)
  local d = {}
  d.x = sx
  d.y = sy
  d.sprite = sprite
  d.size = 8
  d.drop_duration = 5
  d.init_time = time()
  d.types = {[32] = "heart",
             [33] = "shotgun",
             [48] = "rockets",
             [49] = "shield"}
  d.type = d.types[sprite]
  return d
end

--[[
  enemy object
]]
function enemy(spawn_x, spawn_y, type, time_spwn)
  local e = {}
  e.x = spawn_x
  e.y = spawn_y
  e.speed = .35
  e.time = time_spwn
  e.b_count = 0
  e.destroy_anim_length = 15
  e.destroyed_step = 0
  e.destroy_sequence = {135, 136, 135}
  e.drops = {32, 33, 48, 49} -- sprites of drops
  e.drop_prob = 100--%
  e.shoot_distance = 50
  e.explode_distance = 15
  e.explode_wait = 15
  e.explode_step = 0
  e.fire_rate = 10
  e.exploding = false
  e.dont_move = false
  e.size = 8
  e.sprite = 132
  e.angle = 360
  e.speed = .35
  e.type = type

  e.update_xy = function()
                    path = minimum_neighbor(e, player)
                    e.x = e.x + ((e.x-path.x)*e.speed)*(0xFFFF)
                    e.y = e.y + ((e.y-path.y)*e.speed)*(0xFFFF)
                end
  e.move = function()
                if e.type == "shooter" then
                  if distance(e, player) >= e.shoot_distance then
                    e.update_xy()
                  else
                    e.angle = angle_btwn(player.x+5, player.y+5, e.x, e.y)
                    e.b_count = e.b_count + 1
                    if e.b_count%e.fire_rate == 0 then
                      shoot(e.x, e.y, e.angle, 133, false, false)
                    end
                  end
                elseif e.type == "exploder" then
                  if distance(e, player) >= e.explode_distance and not e.dont_move then
                    e.update_xy()
                  else
                    e.dont_move = true
                    e.exploding = true
                    e.explode_step = e.explode_step + 1
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
  b.x = startx
  b.y = starty
  b.angle = angle
  b.sprite = sprite
  b.friendly = friendly
  b.duration = 15
  b.shotgun = (shotgun or false)
  b.speed = 2
  b.acceleration = 0
  b.current_step = 0
  b.max_anim_steps = 5
  b.rocket = false
  b.size = 3

  if b.sprite == 48 then
    b.acceleration = 0.5
    b.max_anim_steps = 15
    b.rocket = true
  end

  b.move = function()
     b.x = b.x - (b.speed+b.acceleration) * sin(b.angle / 360)
     b.y = b.y - (b.speed+b.acceleration) * cos(b.angle / 360)
     if b.sprite == 48 then
        b.acceleration += 0.5
     end

     if b.shotgun then
       b.duration = b.duration - 1
     end
   end

  return b
end

--[[
  boss object
]]
function boss(startx, starty, sprite, lvl)
  local b = {}
  b.x = startx
  b.y = starty
  b.speed = .01
  b.angle = 0
  b.level = lvl or 1
  b.shot_last = nil
  b.shot_ang = 0
  b.sprite = sprite
  b.size = 16
  b.bullet_speed = 2
  b.fire_rate = 7
  b.destroyed_step = 0
  b.destroy_sequence = {135, 136, 135}
  b.destroy_anim_length = 30
  b.health = 50
  b.pattern = {90, 180, 270, 360}
  b.draw_healthbar = function()
             --health bar
             if b.sprite == 128 or 139 then
               xoffset = 1
               b.full_health = 50
             end
             rectfill(b.x + xoffset, b.y - 3, b.x + xoffset + 12, b.y - 3, 14)
             rectfill(b.x + xoffset, b.y - 3, b.x + xoffset + flr(12 * (b.health / b.full_health)), b.y - 3, 8)
           end
  b.update = function()
           if b.level == 1 then
             b.angle = (b.angle+1)%360
             for i=0,3 do
               if b.angle%b.fire_rate == 0 then
                 shoot(b.x, b.y, (b.angle + (90*i)), 130, false, true)
               end
             end

             path = minimum_neighbor(b, player)
             b.x = b.x + ((b.x-path.x)*b.speed)*(-1)
             b.y = b.y + ((b.y-path.y)*b.speed)*(-1)

             --b.draw_healthbar()
           elseif b.level == 2 then
             if b.shot_last ~= nil and ((time() - b.shot_last) < 2) and flr(time()*50)%b.fire_rate == 0 then
               local ang = angle_btwn(player.x, player.y, b.x, b.y)
               shoot(b.x, b.y, ang, 141, false, true)
               b.x = b.x - 5*sin(ang/360)
               b.y = b.y - 5*cos(ang/360)
             end
             --b.draw_healthbar()
           elseif b.level == 3 then
              local ang = (angle_btwn(60,60,b.x,b.y)+.1)%360
              b.x = b.x - 60*sin(ang/360)
              b.y = b.y - 60*cos(ang/360)
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
  print("sx: " .. level.sx, 45, 0, debug_color)

  print("me: " .. round((stat(0)/1024)*100, 2) .. "%", 0, 6, debug_color)
  local cpucolor = debug_color
  if stat(1) > 1 then cpucolor = 8 end --means we're not using all 30 draws (bad)
  print("cp: " ..round(stat(1)*100, 2) .. "%", 45, 6, cpucolor)

  print("", 45, 12, debug_color)
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
    idx = idx + 1
  end
  dset(idx, player.killed)
end

function save_data()
  local save = {player.x, player.y, level.sx, level.sy, level.lvl, player.tokens} -- missing: player.inventory, and current skill values/costs
  for i=0,(#save-1) do
    dset(i, save[i+1])
  end
  -- dset(#save, -5) -- save inventory items
  -- for i=(#save+1),(#player.inventory) do
  --   dset(i, player.inventory[i+1])
  -- end
end

function load_data()
  local idx = 0
  _load = {}
  while dget(idx) ~= -1 do
    _load[#_load+1] = dget(idx)
    idx = idx + 1
  end
end

function show_leaderboard()
  rectfill(0,0,128,128,0)
  print("Killed: "..player.killed,20,20,5)
  for i=1,90 do
    flip()
  end
end

function bump(x, y)
  local tx = flr((x - level.sx + (level.x*8)) / 8)
  local ty = flr((y - level.sy + (level.y*8)) / 8)
  local map_id = mget(tx, ty)

  return fget(map_id, 0)
end

function bump_all(x, y)
  return bump(x, y) or bump(x + 7, y) or bump(x, y + 7) or bump(x + 7, y + 7)
end

function collision()
  wall_up = bump(player.x + 4, player.y + 3) or bump(player.x + 11, player.y + 3) --done
  wall_lft = bump(player.x + 3, player.y + 4) or bump(player.x + 3, player.y + 11) --done
  wall_rgt = bump(player.x + 12, player.y + 4) or bump(player.x + 12, player.y + 11)
  wall_dwn = bump(player.x + 4, player.y + 12) or bump(player.x + 11, player.y + 12) --done
end

function ent_collide(firstent, secondent)
  secondent = secondent or player
  if firstent == player then offset = 4 else offset = 0 end
  return (firstent.x + offset > secondent.x + level.sx + secondent.size or firstent.x + offset + player.size < secondent.x + level.sx
    or firstent.y + offset > secondent.y + secondent.size or firstent.y + offset + firstent.size < secondent.y) == false
end

function collide_all_enemies()
  local e = enemy_spawned[1]
  for o in all(enemy_spawned) do
    if o~=e and ent_collide(e, o) then
      fix_enemy(o, e)
    end
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
  map.x = 128
  map.y = 120
  local minimum_dist = 8000
  local min_node = start
    for i=0xFFFF,1 do
      for j=0xFFFF,1 do
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
  local diffx = tx - fx
  local diffy = ty - fy
  local angle = ((atan2(diffy, diffx) * 360) + 180)%360
  if angle <= 0 then
    angle = (angle + 360)%360
  end
  return angle
end

--[[
  shoot: create bullet objects and add them to the 'bullets' table
]]
function shoot(x, y, a, spr, friendly, boss, shotgun)
  if friendly then
    local offx = player.x + 5
    local offy = player.y + 5
    local ang = angle_btwn((stat(32) - 3), (stat(33) - 3), offx, offy)
    if a != player.angle then
      ang += a
    end
    offx = offx - 8*sin(ang / 360)
    offy = offy - 8*cos(ang / 360)
    add(player_bullets, bullet(offx, offy, ang, spr, friendly, shotgun))
  elseif boss then
    local offx = x + 5
    local offy = y + 5
    offx = offx - 16*sin(a / 360)
    offy = offy - 16*cos(a / 360)
    add(enemy_bullets, bullet(offx, offy, a, spr, friendly))
  else
    local offx = x - 8*sin(a / 360)
    local offy = y - 8*cos(a / 360)
    add(enemy_bullets, bullet(offx, offy, a, spr, friendly))
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
    if not wait.timer then detect_killed_enemies = true end
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
    if no_drop_items then e.drop_prob = 0 end
    del(enemy_spawned, e)
    add(destroyed_enemies, e)
  end

  for b in all(boss_table) do
    del(boss_table, b)
    add(destroyed_bosses, b)
    coin.x = b.x - level.sx
    coin.y = b.y - level.sy
    b = nil
  end
end

function levelchange()
  local farx = 100
  --local farleft

  level.i = 3*level.lvl+1
  if level.transition[level.i] == level.lvl+1
  and (level.transition[level.i+1] - 12) * 8 < abs(level.sx - ((level.lvl-1) * 128))
  --[[and transition[level.i+2] == flr(level.sy)]] then
    move_map = true
  end

  --TODO add map centering on player in the beginning

  if not move_map then
    if btn(c.left_arrow) and not wall_lft and abs(level.sx - ((level.lvl-1) * 128)) > level.x*8 and player.x < farx then
      level.sx += player.speed
      if player.x < farx then player.x = farx end
    end
    if btn(c.right_arrow) and not wall_rgt --[[and level.sx - ((level.lvl-1) * 128) <= (level.transition[level.i+1])*8]]  and player.x > farx then
      level.sx -= player.speed
      if player.x > farx then player.x = farx end
    end
  end

  if move_map ~= nil and move_map then
    wait.controls = true

    if level.transition[level.i+1]*8 > abs(level.sx - ((level.lvl-1) * 128)) then
      level.sx = flr(level.sx) - 1
      player.x -= 1

    --[[elseif check we go down then]]

    else
      dropped = {}
      level_sprites = {}
      open_door = false
      level.sx = 0
      level.sy = 0
      level.x = level.transition[level.i+1]
      level.y = level.transition[level.i+2]

      wait.controls = false
      move_map = false
      level_change = false
      level.lvl += 1
      coin.dropped = false
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
  if secs < 10 then secs = "0" .. secs end

  print(mins .. ":" .. secs, x, y, clr)

  if countdown == 0 then
    wait.timer = false
    coresume(game)
  end
end

function opendoor()
  if doorh == nil then doorh = 1 end
  rectfill(126+level.sx, 63+level.sy, 127+level.sx, 63-doorh+level.sy, 13)
  rectfill(126+level.sx, 64+level.sy, 127+level.sx, 64+doorh+level.sy, 13)
  if doorh < 20 then doorh += 0.5
  elseif doorh == 20 then
     coresume(game)
     doorh += 1
  end
end

function draw_hud()
  local bck_color = 1
  local brd_color = 10
  local fnt_color = 6
  local topx = 1
  local topy = 112
  local btmx = 70--126
  local btmy = 126
  local healthbar = {}
  healthbar.tx = topx + 15
  healthbar.ty = topy + 3
  healthbar.bx = healthbar.tx + (player.health * 5)
  healthbar.fx = healthbar.tx + (player.max_health * 5)
  healthbar.by = healthbar.ty + 4
  if player.health >= 5 then
    healthbar.color = 11
  elseif player.health >= 3 then
    healthbar.color = 9
  else
    healthbar.color = 8
  end

  local shield = {}
  shield.tx = healthbar.tx
  shield.ty = healthbar.ty
  shield.bx = shield.tx + (player.shield * 5)
  shield.by = shield.ty + 4
  shield.color = 12

  --main
  rectfill(topx, topy, btmx, btmy, bck_color)
  --brd
  rectfill(topx-1, topy+1, topx-1, btmy-1, brd_color)
  rectfill(btmx+1, topy+1, btmx+1, btmy-1, brd_color)
  rectfill(topx+1, topy-1, btmx-1, topy-1, brd_color)
  rectfill(topx+1, btmy+1, btmx-1, btmy+1, brd_color)
  pset(topx, topy, brd_color)
  pset(btmx, btmy, brd_color)
  pset(topx, btmy, brd_color)
  pset(btmx, topy, brd_color)

  print("sys",healthbar.tx-12, healthbar.ty, fnt_color)
  rectfill(healthbar.tx, healthbar.ty, healthbar.fx, healthbar.by, 6)
  if player.health <= 1 and flr(time()*10000)%2==0 then
    rectfill(healthbar.tx, healthbar.ty, healthbar.bx, healthbar.by, healthbar.color)
  elseif player.health > 1 then
    rectfill(healthbar.tx, healthbar.ty, healthbar.bx, healthbar.by, healthbar.color)
  end

  print("inv",healthbar.tx-12--[[+55]], healthbar.ty+6, fnt_color)
  local invx = healthbar.tx--+67
  local invy = healthbar.ty+5
  for sp in all(player.inventory) do
    spr(sp, invx, invy)
    invx = invx + 9
  end
  -- print("shield", healthbar.tx-12, healthbar.ty+6, fnt_color)
  if player.shield > 0 then rectfill(shield.tx, shield.ty, shield.bx, shield.by, shield.color) end
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
        if title.drawn[i][j] ~= 0 then
          pset(j+title.startx, i+title.starty, (title.drawn[i][j]+(flr(time()*(i*5))%15)))
        end
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
  seraph = {}

  seraph.brd_color = 12
  seraph.text = "READY TO GET TO WORK?"
  music(11,1)
  drawdialog = true -- show seraph's dialog
  wait.controls = true -- stop player controls

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
  yield()

  titlescreen = true -- stop showing titlescreen

  seraph = {} -- reset seraph table to defaults
  seraph.text = "ALRIGHT, I SEE A DOOR. GIVE MEA MINUTE AND I'LL TRY AND OPENIT."
  drawdialog = true -- show seraph's dialog
  wait.controls = true -- stop player controls
  yield()

  wait.controls = false  -- resume player controls
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
  seraph.text = "OKAY, THAT SHOULD DO- WAIT    WHAT'S THAT?"
  drawdialog = true
  wait.controls = true
  yield()

  wait.controls = false
  drawdialog = false

  add(boss_table, boss(56, 56, 128, 3))
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
  print(" - " .. player.tokens, 36, 26, 7)

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
  e.destroyed_step = e.destroyed_step + 1

  if e.type == "exploder" then
    circ(e.x+4, e.y+4, e.destroyed_step%15, 8)
    e.destroyed_step = e.destroyed_step + 1
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
    if rnd(1) > .5 then r = 0xFFFF end
    if not bul.rocket then
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

  bul.current_step = bul.current_step+1
end

--[[
  draw boss destruction animation
]]
function step_boss_destroyed_animation(b)
  local s = 1 s1 = 1
  if flr(rnd(10))%2 == 0 then s = 0xFFFF end
  if flr(rnd(10))%2 == 0 then s1 = 0xFFFF end
  if b.destroyed_step <= b.destroy_anim_length then
    spr(b.destroy_sequence[flr(b.destroyed_step/30)+1], b.x+s*flr(rnd(8)), b.y+s1*flr(rnd(8)))
    spr(b.destroy_sequence[flr(b.destroyed_step/30)+1], b.x+s*flr(rnd(8)), b.y+s1*flr(rnd(8)))
  else
    del(destroyed_bosses, b)
    coin.dropped = true
  end

  circ(b.x+4, b.y+4, b.destroyed_step%5, 8)
  b.destroyed_step = b.destroyed_step + 1

end

function drop_item(e)
  if flr(rnd(100)) <= e.drop_prob then
    local d  = drop_obj(e.x, e.y, e.drops[flr(rnd(#e.drops)) + 1])
    add(dropped, d)
  end
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

function inc(var)
  return var + 1
end

function rocket_kill(rocket)
  for enemy in all(enemy_spawned) do
    if distance(enemy, rocket) <= rocket.max_anim_steps then
      player.killed = inc(player.killed)
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
  local hpratio = player.health/player.max_health
  if invtx == nil then invtx = 4 end
  if invtx > 4 then invtx -= 1 end

  if hpratio >= .5 then
    hpcolor = 11
  elseif hpratio >= .3 then
    hpcolor = 9
  elseif player.health == 1 and flr(time()*10000)%2==0 then
    hpcolor = 6
  else
    hpcolor = 8
  end

  rectfill(player.x + 3, player.y + 1, player.x + 12, player.y + 1, 6) --background
  rectfill(player.x + 3, player.y + 1, player.x + 3 + (9 * hpratio), player.y + 1, hpcolor) --hp bar
  if player.shield > 0 then rectfill(player.x + 3, player.y + 1, player.x + 4 + (8 * (player.shield / 4.8)), player.y + 1, 12)--[[shield]] end

  --if not time_diff(player.last_middle_click, .5) --[[or not time_diff(player.last_right, .5)]] then
  if timers["middleclick"] > 0 then
    if #player.inventory > 0 then
      spr(player.inventory[1], player.x + invtx, player.y + 14)
    end
    if #player.inventory > 1 then
      spr(player.inventory[2], player.x + invtx + 9, player.y + 14)
    end
    if #player.inventory > 2 then
      spr(player.inventory[#player.inventory], player.x + invtx - 9, player.y + 14)
    end
    spr(112, player.x + 4, player.y + 14)
  end
end


--------------------------------------------------------------------------------
---------------------------------- constructor ---------------------------------
--------------------------------------------------------------------------------
function _init()
  init_mem()
  poke(0x5f2d, 1)

  --player.last_hit = time() - player.immune_time
  title.init = time()

  game = cocreate(gameflow)
  coresume(game)
end --end _init()


--------------------------------------------------------------------------------
---------------------------------- update --------------------------------------
--------------------------------------------------------------------------------
function _update()
  --player.last_hit = abs(time() - 0.5) --uncomment for god mode
  collision()
  collide_all_enemies()

  for k,t in pairs(timers) do
    timers[k] = max(0, timers[k] - (1/30))
  end

  if not titlescreen then
    if btnp(c.x_button) or btnp(c.z_button) then
      titlescreen = true
    end
    return
  end

  if in_skilltree then
    skills_selected[currently_selected] = false
    local diff = 0
    local function update_selec()
            if selection_set[currently_selected] == "health" then
              player.max_health = inc(player.max_health)
              player.health += 1
            elseif selection_set[currently_selected] == "fire rate" then

            elseif selection_set[currently_selected] == "speed" then
              player.speed += .2
            end
            next_cost[currently_selected] = next_cost[currently_selected] + 1
            player.tokens = player.tokens - 1
            sfx(2, 1, 0)
          end
    if btnp((c.up_arrow)) then
      diff = 0xFFFF
      sfx(4, 1, 0)
    elseif btnp(c.down_arrow) then
      diff = 1
      sfx(4, 1, 0)
    elseif btnp(c.x_button) then
      if selection_set[currently_selected] == "quit" then
        in_skilltree = false
        sfx(2, 1, 0)
      elseif selection_set[currently_selected] == "health" and player.tokens >= next_cost[currently_selected] then
        update_selec()
      elseif selection_set[currently_selected] == "fire rate" and player.tokens >= next_cost[currently_selected] then
        update_selec()
      elseif selection_set[currently_selected] == "speed" and player.tokens >= next_cost[currently_selected] then
        update_selec()
      else
        invalid = time()
        sfx(3, 1, 0)
      end
    end
    currently_selected = ((currently_selected+diff)%#skills_selected)
    if currently_selected == 0 then currently_selected = 4 end
    skills_selected[currently_selected] = true
    if player.tokens == 0 then
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
      if not wall_up then
        --dash_detect(c.up_arrow)
        --player.current_speed = player.speed
        player.y -= player.speed
      end
    end --end up button

    --[[
      down arrow
    ]]
    if (btn(c.down_arrow)) then
      if not wall_dwn then
        --dash_detect(c.down_arrow)
        --player.current_speed = -player.speed
        player.y += player.speed
      end
    end --end down button

    --[[
      left arrow
    ]]
    if (btn(c.left_arrow)) then
      if not wall_lft then
        --dash_detect(c.left_arrow)
        --player.angle -= player.turnspeed
        --player.turn = 85
        --player.current_speed = player.speed
        player.x -= player.speed
      end
    end --end left button

    --[[
      right arrow
    ]]
    if (btn(c.right_arrow)) then
      if not wall_rgt then
        --dash_detect(c.right_arrow)
        --player.angle += player.turnspeed
        --player.turn = -85
        --player.current_speed = player.speed
        player.x += player.speed
      end
    end --end right button

    player.angle = flr(atan2(stat(32) - (player.x + 8), stat(33) - (player.y + 8)) * -360 + 90) % 360
  else
    -- player.last_hit = time() - player.immune_time --make player invulnerable so they dont get hit when they can't move
<<<<<<< HEAD
    timers["playerlasthit"] = 0.1 --make player invulnerable so they dont get hit when they can't move
=======
    timers["playerlasthit"] = 0x.0001 --make player invulnerable so they dont get hit when they can't move
>>>>>>> KBedit
  end -- end wait.controls

  --[[
    z button
    -- shoot for now, this can be changed later
  ]]
  -- if (btn(c.z_button)) then
  --stat(34) -> button bitmask (1=primary, 2=secondary, 4=middle)
  if (stat(34) == 1) then
    --if drawdialog and not wait.dialog_finish and time_diff(player.last_click, 1)then
    if drawdialog and not wait.dialog_finish and timers["leftclick"] == 0 then
      --player.last_click = time()
      timers["leftclick"] = 1
      coresume(game)

    elseif not drawdialog and not wait.controls then
      player.b_count = inc(player.b_count)
      --if time_diff(player.last_click, .25) or player.b_count%player.fire_rate == 0 then
      if timers["leftclick"] == 0 or player.b_count%player.fire_rate == 0 then
        --player.last_click = time()
        timers["leftclick"] = .25
        shoot(player.x, player.y, player.angle, 34, true, false)
        sfx(1,1)
      end
    end
  end --end z button

  -- right mouse button
  if (stat(34) == 2) then
    save_data()
    load_data()
    --if player.inventory[1] == 48 and time_diff(player.last_right, .25) then
    if player.inventory[1] == 48 and timers["rightclick"] == 0 then
      shoot(player.x,player.y, 0, 48, true, false)
      del(player.inventory, player.inventory[1])
      sfx(10,1)
      --player.last_right = time()
      --player.last_middle_click = time() --so when the inventory switches after firing, it shows inventory
      timers["rightclick"] = .25
      timers["middleclick"] = .25
    end
    --if player.inventory[1] == 33 or time_diff(player.last_right, .25) then
    if player.inventory[1] == 33 or timers["rightclick"] == 0 then
      player.b_count = inc(player.b_count)
      --if player.b_count%player.fire_rate == 0 and time_diff(player.last_click, .25) then
      if player.b_count%player.fire_rate == 0 and timers["leftclick"] == 0 then
        shoot(player.x, player.y, player.angle, 34, true, false, true)
        shoot(player.x, player.y, 30, 34, true, false, true)
        shoot(player.x, player.y, -30, 34, true, false, true)
        sfx(1,1)
      end
      --player.last_right = time()
      timers["rightclick"] = .25
    end
  end

  -- middle mouse button
  if (stat(34) == 4) then -- cycle inventory
    local temp = 0
    --if #player.inventory > 1 and time_diff(player.last_middle_click, .15) then
    if #player.inventory > 1 and timers["middleclick"] == 0 then
      for i=1,#player.inventory do
        if i == 1 then
          temp = player.inventory[i]
        elseif i == #player.inventory then
          player.inventory[i] = temp
          break
        end
        player.inventory[i] = player.inventory[i+1]
      end
      if #player.inventory == 2 then invtx = 7
      else invtx = 13 --[[inventory animation]] end
    end
    --player.last_middle_click = time()
    timers["middleclick"] = .25
  end

  --[[
    x button
  ]]
  if (btnp(c.x_button)) and not level_change then
    coresume(game)
  end --end x button

  --player.x = player.x - player.current_speed * sin((player.angle - player.turn) / 360)
  --player.y = player.y - player.current_speed * cos((player.angle - player.turn) / 360)

  if level_change then levelchange() end

  --player.current_speed = 0
  --player.turn = 0
  if player.x < -4 then player.x = -4 end
  if player.y < -4 then player.y = -4 end
  if player.x > 116 then player.x = 116 end
  if player.y > 116 then player.y = 116 end

  if player.shield > 0 and not wait.controls then
    player.shield = player.shield - .01
  elseif player.shield < 0 then
    player.shield = 0
  end

  if btn(c.left_arrow, 1) then level.sx += 1 end
  if btn(c.right_arrow, 1) then level.sx -= 1 end
end --end _update()

--------------------------------------------------------------------------------
--------------------------------- draw buffer ----------------------------------
--------------------------------------------------------------------------------
function _draw()
  cls()
  map(level.x, level.y, level.sx, level.sy, 128, 128)

  if not titlescreen then
    draw_titlescreen()
    return
  end


  if level_sprites ~= nil then
    palt(5, true)
    for i = 1, #level_sprites, 3 do
      local x = level_sprites[i+1] + level.sx
      local y = level_sprites[i+2] + level.sy
      --spr_r(level_sprites[i], level_sprites[i+1] + level.sx, level_sprites[i+2] + level.sy, level_sprites[i+3], 1, 1)
      spr(level_sprites[i], x, y)
      --if x < 128 then del(level_sprites, ) end TODO make this delete offscreen sprites
    end
  end
  palt()

  if open_door then opendoor() end

  spr_r(player.sprite, player.x, player.y, player.angle, 2, 2)

  if player.shield > 0 then -- draw shield.
    circ((player.x+8), (player.y+7), ((time()*50)%2)+6, 12)
  end

  for e in all(enemy_spawned) do
    -- this should never happen, but just in case:
    delete_offscreen(enemy_spawned, e)

    -- check if this sprite has been shot
    for b in all(player_bullets) do
      if ent_collide(e, b) then
        player.killed = inc(player.killed)
        del(enemy_spawned, e)
        sfx(5,1)
        add(destroyed_enemies, e)
        del(player_bullets, b)
        add(boss_hit_anims, b)
        if b.rocket then
          rocket_kill(b)
        end
        b = nil
        e = nil
        break
      end
    end


    if e ~= nil then
      -- if time_diff(player.last_hit, player.immune_time) and ent_collide(e) then
      if timers["playerlasthit"] == 0 and ent_collide(e) then
        if player.shield <= 0 then
          player.health = player.health - 1
          sfx(2,2)
          --player.last_hit = time()
          timers["playerlasthit"] = player.immune_time
        else
          player.shield = player.shield - .15
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

      if e.explode_step == e.explode_wait then
        add(exploding_enemies, e)
      end
      e.move()
    end
  end

  for e in all(exploding_enemies) do
    if step_destroy_animation(e) then
      -- if distance(e, player) <= 15 and time_diff(player.last_hit, player.immune_time) then
      if distance(e, player) <= 15 and timers["playerlasthit"] == 0 then
        if player.shield <= 0 then
          player.health = player.health - 1
          sfx(2,2)
          -- player.last_hit = time()
          timers["playerlasthit"] = player.immune_time
        else
          player.shield = player.shield - .15
        end
      end
    end
  end

  loop_func(destroyed_enemies, step_destroy_animation)

  for d in all(dropped) do

    if ent_collide(d) then
      if d.type == "heart" and player.health < player.max_health then
        player.health = min(player.max_health, player.health+3)
        sfx(7,1)
        del(dropped, d)
      elseif d.type == "shield" then
        player.shield = player.shield_dur
        sfx(7,1)
        del(dropped, d)
      elseif d.type ~= "heart" and #player.inventory < player.inv_max then
        add(player.inventory, d.sprite)
        sfx(7,1)
        del(dropped, d)
      end
    end

    local live = abs(time() - d.init_time) <= d.drop_duration
    if live then
      if live and abs(time() - d.init_time) <= 2*(d.drop_duration/3) then
        spr(d.sprite, d.x, d.y)
      elseif live and flr(time()*1000)%2==0 then
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
      if b.rocket then
        rocket_kill(b)
      end
      b = nil
    end

    if b ~= nil then
      spr_r(b.sprite, b.x, b.y, b.angle, 1, 1)
      b.move()
      if b.duration <= 0 then
        del(player_bullets, b)
        b = nil
      end
    end

    if b~=nil then
      for bos in all(boss_table) do
        if ent_collide(bos, b) then
          sfx(6,1)
          if b.sprite == 48 then
            bos.health -= 3
          else
            bos.health -= 1
          end
          bos.shot_last = time()
          bos.shot_ang = angle_btwn(player.x+5, player.y+5, bos.x, bos.y)
          del(player_bullets, b)
          add(boss_hit_anims, b)
          if b.rocket then
            rocket_kill(b)
          end
          if (bos.health <= 0) then
            sfx(5,1)
            add(destroyed_bosses, bos)
            player.killed = player.killed+1
            del(boss_table, bos)
            coin.x = bos.x - level.sx
            coin.y = bos.y - level.sy
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

    -- if time_diff(player.last_hit, player.immune_time) and ent_collide(player, b) then
    if ent_collide(player, b) then
      if timers["playerlasthit"] == 0 then
        if player.shield <= 0 then
          player.health = player.health - 1
          sfx(2,2)
          -- player.last_hit = time()
          timers["playerlasthit"] = player.immune_time
        else
          add(shield_anims, {b.x, b.y, 10})
          player.shield = player.shield - .15
        end
      end
      del(enemy_bullets, b)
      b = nil
    end

    if b~=nil then
      spr(b.sprite, b.x, b.y)
      b.move()
      if bump(b.x, b.y) then
        del(enemy_bullets, b)
        b = nil
      end
    end
  end

  for s in all(shield_anims) do
    local colors = {12, 13, 1}
    s[3] = s[3]-1
    circ(s[1]+8, s[2]+8, flr(time()*100)%4, colors[flr(time()*100)%#colors + 1])
    if s[3] == 0 then
      del(shield_anims, s)
    end
  end

  for b in all(boss_table) do
    -- if time_diff(player.last_hit, player.immune_time) and ent_collide(player, b) then
    if timers["playerlasthit"] == 0 and ent_collide(player, b) then
      player.health = player.health - 2
      --player.last_hit = time()
      timers["playerlasthit"] = player.immune_time
    end
    spr(b.sprite, b.x, b.y, 2, 2)
    b.update()
  end

  loop_func(boss_hit_anims, boss_hit_animation)

  loop_func(destroyed_bosses, step_boss_destroyed_animation)

  if player.health <= 0 then
    sfx(9,1)
    show_leaderboard()
    run()
  end

  draw_playerhp()

  if pget(stat(32), stat(33)) == 8 or pget(stat(32), stat(33)) == 2 then pal(8, 6) end
  spr(96, stat(32) - 3, stat(33) - 3)
  pal()

  --draw_hud()
  if spawn_enemies then spawnenemies() end
  if detect_killed_enemies then detect_kill_enemies() end
  if wait.timer then drawcountdown() end
  if coin.dropped then
     spr(coin.sprites[flr(time()*8)%#coin.sprites + 1], coin.x+level.sx, coin.y+level.sy, 2, 2)
     if ent_collide(player, coin) then
       player.tokens = player.tokens + 1
       coin.dropped = false
       direction = nil
       in_skilltree = true
     end
  end

  if drawdialog then dialog_seraph(seraph) end

  -- if (abs(time() - player.last_hit) < 0.5) or (abs(time() - invalid) < 0.5) then
  if (timers["playerlasthit"] > player.immune_time - 0.5) then
    camera(cos((time()*1000)/3), cos((time()*1000)/2))
  else
    camera()
  end

  if in_skilltree then skilltree() end
  if in_leaderboard then draw_leaderboard() end

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
e888888e0440044000000000530bb03500899800b333333b255555520000000000000000000000005533355b3333555500000000000000000000000000000000
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
00000000000000008855555555555555355355350455540006ddd600555555550000000052aaa25553bbb35533333300333333009ddddddd5555555995555555
0000000000000000285555553553553535555535045f540006ddd600555555550000000052a9a25553b3b3553b00b3003b55b3009ddddddd5555559dd9555555
000000000000000028555555553335555353535500454000006d60005555555500000000552a2555553b35553b00b3003b55b3009ddddddd555559dddd955555
0000000000000000885555553b3b3b35553b3555004f4000006d6000555555550000000055292555553b35553b00b3003b55b3009ddddddd55559dddddd95555
00000000000000008855555533bbb33533bbb335004f4000006d6000555555550000000055292555553b35553b00b3003b55b3009ddddddd5559dddddddd9555
0000000000000000285555553bbbbb353bbbbb35004f400000656000555555550000000055292555553b35553b00b300000000009ddddddd559dddddddddd955
000000000000000028555555533b3355533b335504fff400065d560055555555000000005299925553bbb3553b00b300000000009ddddddd59dddddddddddd95
00000000000000008855555555535555555355554fffff406d555d605555555500000000299999253bbbbb3500000000000000009ddddddd9dddddddddddddd9
03333330000000000000000055555555955955958888888255555552255555555555558882288228000000003b00b30000000000dddddddd9dddddddddddddd9
03b55b30000000000000000095595595955555958888888255555528825555555555558288888888000000003b00b30000000000dddddddd59dddddddddddd95
03b55b30000000000000000055999555595959558888888255555288882555555555558255555555000000003b00b3003b55b300dddddddd559dddddddddd955
03b55b3000000000000000009a9a9a95559a95558888888255552888888255555555558855555555000000003b00b3003b55b300dddddddd5559dddddddd9555
03b55b30000000000000000099aaa99599aaa9958888888255528888888825555555558855555555000000003b00b3003b55b300dddddddd55559dddddd95555
03b55b3000000000000000009aaaaa959aaaaa958888888255288888888882555555558255555555000000003b00b3003b55b300dddddddd555559dddd955555
b3b55b3b0000000000000000599a9955599a99558888888252888888888888255555558255555555000000003b00b3003b55b300dddddddd5555559dd9555555
0bbbbbb0000000000000000055595555555955558888888228888888888888825555558855555555000000003333330033333300dddddddd5555555995555555
b3b55b3b00000000000000000000000000000000222222222888888888888882555555550000000000000000555555bb55555555dddddddd555555556bb66bb6
03b55b3000000000000000000000000000000000888888885288888888888825555555550000000000000000555555b655555555dddddddd5555555566666666
03b55b3000000000000000000000000000000000888888885528888888888255555555550000000000000000555555b655555555dddddddd5555555555555555
03b55b3000000000000000000000000000000000888888885552888888882555555555550000000000000000555555bb55555555dddddddd5555555555555555
03b55b3000000000000000000000000000000000888888885555288888825555555555550000000000000000555555bb55555555dddddddd5555555555555555
03b55b3000000000000000000000000000000000888888885555528888255555555555550000000000000000555555b655555555dddddddd5555555555555555
03b55b3000000000000000000000000000000000888888885555552882555555888888880000000000000000555555b6bbbbbbbbdddddddd6666666655555555
0333333000000000000000000000000000000000888888885555555225555555822882280000000000000000555555bbb66bb66b999999996bb66bb655555555
0000000000000000000000000000000000000000888888822888888800000000000000000000000000000000ddddddddddddddd9999999996655555555555566
0000000000000000000000000000000000000000888888822888888800000000000000000000000000000000d4444444ddddddd9ddddddddb65555555555556b
0000000000000000000000000000000000000000888888822888888800000000000000000000000000000000d44fff44ddddddd9ddddddddb65555555555556b
0000000000000000000000000000000000000000888888822888888800000000000000000000000000000000d4f4f4f4ddddddd9dddddddd6655555555555566
0000000000000000000000000000000000000000888888822888888800000000000000000000000000000000d4ff4ff4ddddddd9dddddddd6655555555555566
0000000000000000000000000000000000000000888888822888888800000000000000000000000000000000d4f4f4f4ddddddd9ddddddddb65555555555556b
0000000000000000000000000000000000000000888888822888888800000000000000000000000000000000d44fff44ddddddd9ddddddddb65555555555556b
0000000000000000000000000000000000000000888888822888888800000000000000000000000000000000d4444444ddddddd9dddddddd6655555555555566

__gff__
0001000000000101000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000
__map__
feefefefefefefefefefefefefefefff3c060606060606060606063c3c3c3c250000000000e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fe0303030303030303030303030303ff3c0303030303030303030304050303250000000000d5c7c7e6d7d6d7d6f5c7d6d7d5c7c7c7c7d800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fe0303030303030303030303030303ff3c3703370303c70313030314150303250500000000d5c7c7c7e6e7e6e7c7c7e6d5f5c7c7c7c7d800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fe030303cefdfdcf03030303030303ff3c0316c7c73cc713031303030303d3061500000000d5c7c7c7c7c7c7c7c7c7c7f6f5c7c7c7c7d800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fec70303cdfbfbfc03030303030303ff25c716c73c3c3cc7130303030303c93c0500000000d5c7c7c7c7c7c7c7c7c7c7e6e7c7c7c7c7d800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fe030303deddfbfc03030303030303ce0316c716c73cc7c703040503030303071500000000d5c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7d800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fe03030303cdfbfc03030303030303cd03130313c7c7c7c7031415030303030705e8e8e8e8e6d7c7c7c7c7c7c7c7d6d7c7c7c7c7c7c7d800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fe03030303deeddf03030303030303cd03c703c70303c703030303030303030803c7c7c7c7c7e6d7c7c7c7c7c7c7f6d5c7c7c7c7c7c7d800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fe0303030303030303030303030303cd0303c303032a2b03030313030303031803c7c7c7c7c7c7d5c7c7c7c7c7c7f6d5c7c7c7c7c7c7d800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fe0303030303030303030303030303cd0303ca03033a3b0303c703130303030703c7c7c7c7c7c7c7c7c7c7c7c7c7e6e7c7c7e8e8e8e8d800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fe0303030303030303030303030303de03c7030303030303c30316030303d30703c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c2c7c7c7d900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fe0303030303030303030303030303ff3c03030303030303ca0303030303c93c03d9d9d9d9c2c7c7c7c7c7d6d7c7c7c7c7d6c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fe0303030303030303030303cefdfdfd3c03030303030405030303030303033c0300000000c2c7c7c7c7c7f6d5c7c7c7c7e6c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fe0303030303030303030303cdfbfbdd3c03030303031415030304050303033c0000000000c2c7c7c7c7c7e6e7c7c7c7c7c7c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fe0303030303030303030303deededed060303030303030303031415030303250000000000c2c7c7c7c7c7e8e8e8e8e8e8e8c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
feeecefdfdcfeeeeeeeeeeeeeeeeeeff062525250303030303030303030303060000000000c2c7c7c7c7c7c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000253c3c3c0625250606252525000000000000e8e8e8e8e8e8c2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
001000001152001500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000024050180001d0001c0001c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001c0500f0501a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000140501c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000260005600096400f60009600096000960009600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001853000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001e0501d05022350350002b000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001335013350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000d0500d0500d0500d0500d0500d0500c0500c0500c0500c0500c0500c0500c05007050070500705007050070500704007040070300702007010070100701007010010000400003000030000300003000
000a000013040140501805014000190001e0002400020500016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001704002550070401304003530000000c010105200753001550105400d7400255010030130200f5500c7500475002750055500b5500a7500e7501452006550150200e040145300a530000000000000000
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
07 41424344
00 41434344
04 41424445
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
