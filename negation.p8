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
player.current_speed = 0
player.angle = 0
--player.turnspeed = 10
player.turn = 0
player.current_dash_speed = 0
--player.dash_speed = 15
--player.dash_threshold = {.05, .2}
player.bullet_spread = 5
player.health = 10
player.max_health = 10
player.immune_time = 2
player.last_hit = 0
player.b_count = 0
player.tokens = 0
player.inventory = {}
player.inv_max = 4
player.shield_dur = 5
player.shield = 0

--cheats = {}
--cheats.noclip = false
--cheats.god = false

level = {}
level.border = {}
level.border.left = 0
level.border.up = 0
level.border.right = 120
level.border.down = 120
level.sx = 0
level.sy = 0

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

coin = {}
coin.dropped = false
coin.x = nil
coin.y = nil
coin.sprites = {64, 66, 68, 70, 72}

enemy_table  = {}
enemy_spawned = {}
player_bullets = {}
enemy_bullets = {}
destroyed_bosses = {}
destroyed_enemies = {}
boss_hit_anims = {}
exploding_enemies = {}
dropped = {}

highlighted = 10
currently_selected = 1
selection_set = {"speed", "health", "damage", "quit"}
next_cost = {1, 1, 1}
skills_selected = {true, false, false, false}
invalid = 0

-- define some constants
pi = 3.14159265359
inf = 32767.99 -- max number as defined in https://neko250.github.io/pico8-api/

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
function enemy(spawn_x, spawn_y, type, time)
  local e = {}
  e.x = spawn_x
  e.y = spawn_y
  e.speed = .35
  e.time = time
  e.destroy_anim_length = 15
  e.destroyed_step = 0
  e.destroy_sequence = {135, 136, 135}
  e.drops = {32, 33, 48, 49} -- sprites of drops
  e.drop_prob = 100--%
  e.shoot_distance = 50
  e.explode_distance = 15
  e.explode_wait = 15
  e.explode_step = 0
  e.bullet_spread = 10
  e.bullet_count = 0
  e.exploding = false
  e.dont_move = false
  e.sprite = 132
  e.angle = 360
  e.speed = .35

  e.update_xy = function()
                    path = minimum_neighbor(e, player)
                    e.x = e.x + ((e.x-path.x)*e.speed)*(-1)
                    e.y = e.y + ((e.y-path.y)*e.speed)*(-1)
                end
  e.move = function()
                if type == "shooter" then
                  if distance(e, player) >= e.shoot_distance then
                    e.update_xy()
                  else
                    e.angle = angle_btwn(player.x+5, player.y+5, e.x, e.y)
                    e.bullet_count = e.bullet_count + 1
                    if e.bullet_count%e.bullet_spread == 0 then
                      add(enemy_bullets, bullet(e.x, e.y, e.angle, 133, false))
                      e.bullet_count = e.bullet_count + 1
                    end
                  end
                elseif type == "exploder" then
                  if distance(e, player) >= e.explode_distance and not e.dont_move then
                    e.update_xy()
                  else
                    e.dont_move = true
                    e.exploding = true
                    e.explode_step = e.explode_step + 1
                  end
                elseif type == "basic" then
                  e.update_xy()
                end
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
function boss(startx, starty, sprite, level)
  local b = {}
  b.x = startx
  b.y = starty
  b.speed = .01
  b.angle = 0
  b.level = (level or 1)
  b.shot_last = 0
  b.shot_ang = 0
  b.sprite = sprite
  b.bullet_speed = 2
  b.bullet_spread = 7
  b.destroyed_step = 0
  b.destroy_sequence = {135, 136, 135}
  b.destroy_anim_length = 30
  b.health = 50
  b.pattern = {90, 180, 270, 360}
  b.draw_healthbar = function()
                       --health bar
                       if b.sprite == 128 then
                         xoffset = 1
                         b.full_health = 50
                       end
                       rectfill(b.x + xoffset, b.y - 3, b.x + xoffset + 12, b.y - 3, 14)
                       rectfill(b.x + xoffset, b.y - 3, b.x + xoffset + (12 * (b.health / b.full_health)), b.y - 3, 8)
                     end
  b.update = function()
               if b.level == 1 then
                 b.angle = (b.angle+1)%360
                 for i=0,3 do
                   if b.angle%b.bullet_spread == 0 then
                     add(enemy_bullets, bullet(b.x, b.y, (b.angle + (90*i)), 130, false))
                   end
                 end

                 path = minimum_neighbor(b, player)
                 b.x = b.x + ((b.x-path.x)*b.speed)*(-1)
                 b.y = b.y + ((b.y-path.y)*b.speed)*(-1)

                 b.draw_healthbar()
               elseif b.level == 2 then
                 if ((time() - b.shot_last) < 2) and flr(time()*50)%b.bullet_spread == 0 then
                   add(enemy_bullets, bullet(b.x, b.y, (b.shot_ang), 141, false))
                 end
                 b.draw_healthbar()
               end
             end
  return b
end
--------------------------------------------------------------------------------
-------------------------------- helper functions ------------------------------
--------------------------------------------------------------------------------
function debug()
  local debug_color = 7
  print("px: " .. player.x, 0, 0, debug_color)
  print("sx: " .. level.sx, 45, 0, debug_color)

  print("", 0, 6, debug_color)
  print("mem: ".. stat(0), 45, 6, debug_color)

  print(#player.inventory, 45, 12, debug_color)
  -- stat(33) = y stat(32) = x
  -- print(costatus(game), 0, 12, debug_color)
end

function bump(x, y)
  local tx = flr((x - level.sx) / 8)
  local ty = flr((y - level.sy) / 8)
  local map_id = mget(tx, ty)

  return fget(map_id, 0)
end

function bump_all(x, y)
  return bump(x, y) or bump(x + 7, y) or bump(x, y + 7) or bump(x + 7, y + 7)
end

function collision()
  --local fwd_tempx = player.x - player.speed * sin(player.angle / 360)
  --local fwd_tempy = player.y - player.speed * cos(player.angle / 360)
  --local up_tempx = player.x + 5
  --local up_tempy = player.y + 4

  --local bck_tempx = player.x + player.speed * sin(player.angle / 360)
  --local bck_tempy = player.y + player.speed * cos(player.angle / 360)

  --[[pset(player.x + 3, player.y + 3, clr) --topleft
  pset(player.x + 12, player.y + 3, clr) --topright
  pset(player.x + 3, player.y + 12, clr) --bottomleft
  pset(player.x + 12, player.y + 12, clr) --bottomright]]

  --[[topleft, topright, bottomleft, bottomright = {}, {}, {}, {}
  topleft.x, topleft.y = player.x + 3, player.y + 3
  topright.x, topright.y = player.x + 12, player.y + 3
  bottomleft.x, bottomleft.y = player.x + 3, player.y + 12
  bottomright.x, bottomright.y = player.x + 12, player.y + 12

  local test = bump_all(topleft.x + 1, topleft.y + 1)
  wall_up, wall_lft, wall_rgt, wall_dwn = test, test, test, test]]

  --[[wall_up =  bump(topleft.x, topleft.y) or bump(topright.x, topright.y)
  wall_lft = bump(topleft.x, topleft.y) or bump(bottomleft.x, bottomleft.y)
  wall_rgt = bump(topright.x, topright.y) or bump(bottomright.x, bottomright.y)
  wall_dwn = bump(bottomleft.x, bottomleft.y) or bump(bottomright.x, bottomright.y)]]

  wall_up = bump(player.x + 4, player.y + 3) or bump(player.x + 11, player.y + 3) --done
  wall_lft = bump(player.x + 3, player.y + 4) or bump(player.x + 3, player.y + 11) --done
  wall_rgt = bump(player.x + 12, player.y + 4) or bump(player.x + 12, player.y + 11)
  wall_dwn = bump(player.x + 4, player.y + 12) or bump(player.x + 11, player.y + 12) --done
end

function enemy_collision(e, p)
  local other = (p or player)
  return (e.x > other.x+8 or e.x+8 < other.x or e.y > other.y+8 or e.y+8<other.y) == false
end

function bullet_collision(sp, b)
  if sp == player then
    return (b.x > sp.x+4+5 or b.x+4 < sp.x+5 or b.y > sp.y+4+5 or b.y+4<sp.y+5) == false
  end
  return (b.x > sp.x+4 or b.x+4 < sp.x or b.y > sp.y+4 or b.y+4<sp.y) == false
end

function boss_collision(sp, b)
  if b == player then
    return (b.x > sp.x+16 or b.x+8 < sp.x or b.y > sp.y+16 or b.y+8 < sp.y)==false
  end
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
  local minimum_dist = inf
  local min_node = start
    for i=-1,1 do
      for j=-1,1 do
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
function shoot(x, y, a, spr, friendly)
  if friendly then
    local offx = player.x + 5
    local offy = player.y + 5
    local ang = angle_btwn((stat(32) - 3), (stat(33) - 3), offx, offy)
    offx = offx - 8*sin(ang / 360)
    offy = offy - 8*cos(ang / 360)
    add(player_bullets, bullet(offx, offy, ang, spr, friendly))
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

  if drawboss then
    drawboss = false
    add(destroyed_bosses, boss1)
    boss1 = nil
  end
end

function screentransaction()
  player.last_hit = time() - 0.5 --make player invulnerable so they dont get hit during transition
  local map_right = level.border.right + level.sx - 120
  local map_left = level.border.left + level.sx

  --when to transistion
  --===========================================================
  if level.sx < -78 and level.sy == 0 then move_map = true end
  --===========================================================

  if level.sx - (player.x - 50) < level.sx then
    wait.controls = true
    level.sx -= 1
    player.x -= 1

  --follow player if not all the way left, not all the way right, and player.x == 50
  elseif map_right > 0 and (player.x > 50 or map_left < 0) and not move_map then
    --level.sx = level.sx + player.current_speed * sin((player.angle - player.turn) / 360)
    wait.controls = false
    player.x = 50
    if btn(c.left_arrow) and not wall_lft then level.sx += player.speed end
    if btn(c.right_arrow) and not wall_rgt then level.sx -= player.speed end
  end

  --if hit transistion trigger from above, move the map to center on new level
  if move_map then
    if map_right > 0 then
      level.sx = flr(level.sx) --reset so map lines up nicely
      player.x -= 1 --move player sprite back along with
      level.sx -= 1 --moving map
      wait.controls = true --pause player controls
    else
      move_map = nil
      wait.controls = false --resume player controls
      screen_transaction = false --stop doing this functions checks
      level.sx = 120 - level.border.right --make the new map bounds the new level
      level.border.left += 128
    end
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

function draw_hud()
  local bck_color = 1
  local brd_color = 10
  local fnt_color = 6
  local topx = 1
  local topy = 112
  local btmx = 126
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
  shield.tx = healthbar.tx+12
  shield.ty = healthbar.ty+6
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
    -- rectfill(healthbar.tx, healthbar.ty, healthbar.fx, healthbar.by, 6)
    rectfill(healthbar.tx, healthbar.ty, healthbar.bx, healthbar.by, healthbar.color)
  elseif player.health > 1 then
    -- rectfill(healthbar.tx, healthbar.ty, healthbar.fx, healthbar.by, 6)
    rectfill(healthbar.tx, healthbar.ty, healthbar.bx, healthbar.by, healthbar.color)
  end

  print("inv",healthbar.tx+55, healthbar.ty+6, fnt_color)
  local invx = healthbar.tx+67
  local invy = healthbar.ty+5
  for sp in all(player.inventory) do
    spr(sp, invx, invy)
    invx = invx + 9
  end
  print("shield", healthbar.tx-12, healthbar.ty+6, fnt_color)
  if player.shield > 0 then rectfill(shield.tx, shield.ty, shield.bx, shield.by, shield.color) end
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
  seraph.text = "ready to get to work?"
  drawdialog = true -- show seraph's dialog
  wait.controls = true -- stop player controls
  yield()

  titlescreen = true -- stop showing titlescreen

  seraph = {} -- reset seraph table to defaults
  seraph.text = "alright, i see a door. give mea minute and i'll try and openit."
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

  boss1 = boss(56, 56, 128, 2)
  drawboss = true
  yield()

  kill_all_enemies()
  level.border.right = 248
  screen_transaction = true
end

--[[
    skill-tree menu (needs to be called continuously from draw to work)
]]
function skilltree()
  local token_sprites = {64, 66, 68, 70, 72}
  for i=#token_sprites,0,-1 do -- reverse list and add it to token_sprites animation
    add(token_sprites, token_sprites[i])
  end

  rectfill(0, 0, 127, 127, 0)
  spr(token_sprites[flr(time()*8)%#token_sprites + 1], 20, 20, 2, 2)
  print(" - " .. player.tokens, 36, 26, 7)

  print("upgrade health - ".. player.tokens .." tokens ", 20, 52, 7)
  print("upgrade damage - ".. player.tokens .." tokens ", 20, 44, 7)
  print("upgrade speed - ".. player.tokens .." tokens ", 20, 36, 7)
  print("quit", 20, 68, 7)


  if skills_selected[1] then
    print("upgrade speed - ".. player.tokens .." tokens ", 20, 36, highlighted)
  elseif skills_selected[2] then
    print("upgrade damage - ".. player.tokens .." tokens ", 20, 44, highlighted)
  elseif skills_selected[3] then
    print("upgrade health - ".. player.tokens .." tokens ", 20, 52, highlighted)
  elseif skills_selected[4] then
    print("quit", 20, 68, highlighted)
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
    drop_item(e)
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
    coin.dropped = true
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
    drop_item(e)
    del(destroyed_enemies, e)
  end

  circ(e.x+4, e.y+4, e.destroyed_step%15, 8)
  e.destroyed_step = e.destroyed_step + 1
  if e.destroyed_step == e.destroy_anim_length then
    return true
  end
  return false
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
      sfx(4, 1, 0)
    elseif btnp(c.down_arrow) then
      diff = 1
      sfx(4, 1, 0)
    elseif btnp(c.x_button) then
      if selection_set[currently_selected] == "quit" then
        in_skilltree = false
        sfx(2, 1, 0)
      elseif selection_set[currently_selected] == "health" and player.tokens >= next_cost[currently_selected] then
        player.max_health = player.max_health + 1
        next_cost[currently_selected] = next_cost[currently_selected] + 1
        player.tokens = player.tokens - 1
        sfx(2, 1, 0)
      elseif selection_set[currently_selected] == "damage" and player.tokens >= next_cost[currently_selected] then
        --TODO==> implement this
        next_cost[currently_selected] = next_cost[currently_selected] + 1
        player.tokens = player.tokens - 1
        sfx(2, 1, 0)
      elseif selection_set[currently_selected] == "speed" and player.tokens >= next_cost[currently_selected] then
        player.speed = player.speed + .5
        next_cost[currently_selected] = next_cost[currently_selected] + 1
        player.tokens = player.tokens - 1
        sfx(2, 1, 0)
      else
        invalid = time()
        sfx(3, 1, 0)
      end
    end
    currently_selected = ((currently_selected+diff)%#skills_selected)
    if currently_selected == 0 then currently_selected = 4 end
    skills_selected[currently_selected] = true
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
  end -- end wait.controls

  --[[
    z button
    -- shoot for now, this can be changed later
  ]]
  --if (btn(c.z_button)) then
  --stat(34) -> button bitmask (1=primary, 2=secondary, 4=middle)
  if (stat(34) == 1) then
    if wait.controls and not wait.dialog_finish and time() - (lastclick or time() - 2) > 1 then
      coresume(game)
      lastclick = time()
    elseif not wait.controls then
      player.b_count = player.b_count + 1
      if player.b_count%player.bullet_spread == 0 then
        shoot(player.x, player.y, player.angle, 2, true)
      end
    end
  end --end z button

  -- middle button
  if (stat(34) == 4) and time() - (lastclick or time() - 2) > 0.5 then
    coresume(game)
    lastclick = time()
  end

  --[[
    x button
  ]]
  if (btnp(c.x_button)) then
    coresume(game)
  end --end x button

  --player.x = player.x - player.current_speed * sin((player.angle - player.turn) / 360)
  --player.y = player.y - player.current_speed * cos((player.angle - player.turn) / 360)

  if screen_transaction then screentransaction() end

  player.current_speed = 0
  player.turn = 0
  if player.x < -4 then player.x = -4 end
  if player.y < -4 then player.y = -4 end
  if player.x > 116 then player.x = 116 end
  if player.y > 116 then player.y = 116 end

  if player.shield > 0 and not wait.controls then
    player.shield = player.shield - .01
  elseif player.shield < 0 then
    player.shield = 0
  end
end --end _update()

--------------------------------------------------------------------------------
--------------------------------- draw buffer ----------------------------------
--------------------------------------------------------------------------------
function _draw()
  cls()
  map(0, 0, level.sx, level.sy, 128, 128)

  spr_r(player.sprite, player.x, player.y, player.angle, 2, 2)

  if player.shield > 0 then -- draw shield.
    circ((player.x+8), (player.y+7), ((time()*50)%2)+6, 12)
  end

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
      if ((time() - player.last_hit) > player.immune_time) and enemy_collision(e) and player.shield == 0 then
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
      if distance(e, player) <= 15 and ((time() - player.last_hit) > player.immune_time) and player.shield == 0 then
        player.health = player.health - 1
        player.last_hit = time()
      end
      del(enemy_spawned, e)
      del(exploding_enemies, e)
    end
  end

  -- for d in all(destroyed_enemies) do
  --   step_destroy_animation(d)
  -- end
  loop_func(destroyed_enemies, step_destroy_animation)

  for d in all(dropped) do

    if enemy_collision(d) then
      if d.type == "heart" and player.health < player.max_health then
        player.health = player.health+1
        del(dropped, d)
      elseif d.type == "shield" then
        player.shield = player.shield_dur
        del(dropped, d)
      elseif d.type ~= "heart" and #player.inventory < player.inv_max then
        add(player.inventory, d.sprite)
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
      b = nil
    end

    if b ~= nil then
      spr_r(b.sprite, b.x, b.y, b.angle, 1, 1)
      b.move()
    end

    if drawboss and b~=nil then
      if boss_collision(boss1, b) then
        boss1.health -= 1
        boss1.shot_last = time()
        boss1.shot_ang = angle_btwn(player.x+5, player.y+5, boss1.x, boss1.y)
        del(player_bullets, b)
        add(boss_hit_anims, b)
        if (boss1.health <= 0) then
          drawboss = false
          add(destroyed_bosses, boss1)
          coin.x = boss1.x
          coin.y = boss1.y
          boss1 = nil
          coresume(game)
        end
        break
      end
    end
  end

  for b in all(enemy_bullets) do
    -- first delete offscreen bullets:
    delete_offscreen(enemy_bullets, b)

    if ((time() - player.last_hit) > player.immune_time) and bullet_collision(player, b) then
      if player.shield == 0 then
        player.health = player.health - 1
        player.last_hit = time()
      else
        local colors = {8, 9}
        circ(b.x+8, b.y+8, flr(time()*100)%4, colors[flr(time()*100)%#colors + 1])
      end
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

  -- for b in all(boss_hit_anims) do
  --   boss_hit_animation(b)
  -- end
  loop_func(boss_hit_anims, boss_hit_animation)
  -- for b in all(destroyed_bosses) do
  --   step_boss_destroyed_animation(b)
  -- end
  loop_func(destroyed_bosses, step_boss_destroyed_animation)

  if player.health <= 0 then
    print("game over", 48, 60, 8)
    stop()
  end

  spr(96, stat(32) - 3, stat(33) - 3)

  draw_hud()
  if spawn_enemies then spawnenemies() end
  if detect_killed_enemies then detect_kill_enemies() end
  if wait.timer then drawcountdown() end
  if coin.dropped then
     spr(coin.sprites[flr(time()*8)%#coin.sprites + 1], coin.x, coin.y, 2, 2)
     if boss_collision(coin, player) then
       player.tokens = player.tokens + 1
       coin.dropped = false
       in_skilltree = true
     end
  end

  if drawdialog then dialog_seraph(seraph) end

  if (abs(time() - player.last_hit) < 0.5) or (abs(time() - invalid) < 0.5) then
    camera(cos((time()*1000)/3), cos((time()*1000)/2))
  else
    camera()
  end

  if in_skilltree then
    skilltree()
  end

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
00088000999009990000000055555555000000000000000000000000a55a55550000000000000000555555555555555550000005000000000000000000000000
00066000967766690000000055533555000000000000000000000000aa5aa55a000000000000000055353bbbb555b35500777600000000000000000000000000
000660009766666900000000533003350000000000000000000000005a55a5aa0000000000000000553353333553335507766660000000000000000000000000
000660009666665900000000530bb0350000000000000000000000005aa5aaa50000000000000000555555555555555507666660000000000000000000000000
000660000966669000000000530bb03500000000000000000000000055aa55550000000000000000555555bbb335555507666660000000000000000000000000
00866800096665900000000053b00b3500000000000000000000000055a5a5550000000000000000555555333355555507666660000000000000000000000000
08866880009559000000000053b00b350000000000000000000000005aa5aaaa0000000000000000555555555555555500666600000000000000000000000000
00000000000990000000000053b00b35000000000000000000000000aa55555a0000000000000000555555555555555550000005000000000000000000000000
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
3c03160303030313031303030303d30615000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2503160303030303130303030303c93c05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0616031603030303030405030303030715000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0613031303030303031415030303030705000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0603030303030303030303030303030803000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0603c303032a2b03030313030303031803000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0603ca03033a3b03030303130303030703000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0603030303030303c30316030303d30703000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0010000024050180001d0001c0001c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001c0500f0501a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001c0501c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
07 41020304
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
