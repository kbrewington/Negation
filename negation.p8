pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
--============================================================================--
--=============================== global variables  ==========================--
--============================================================================--
player = {
  x = 60,
  y = 60,

  size = 8,

  destroyed_step = 0,
  destroy_anim_length = 30,
  destroy_sequence = {135, 136, 135},
}
--player_sprite = 0
player_health = 10
player_max_health = 10
player_immune_time = 2
player_shield = 0
player_shield_dur = 5
player_speed = 1
player_angle = 0
player_fire_rate = .75
player_power_fire_rate = 1
player_inv_max = 4
player_killed = 20
player_tokens = 0

level_lvl = 1
level_sx = 0
level_sy = 0
level_x = 0
level_y = 0
level_transition = {
  1, 0, 0,
  2, 16, 0,
  3, 32, 0,
  4, 48, 0,
  5, 64, 0
}

wait = {
  controls = false,
  dialog_finish = false
}

timers = {
  leveltimer = 0,
  showinv = 0,
  showinv2 = 0,
  playerlasthit = 0,
  leftclick = 0,
  middleclick = 0,
  rightclick = 0,
  firerate = 0,
  invalid = 0,
  bossstart = 0,
  spawn = 0
}

coin = {
  dropped = false,
  size = 16,
  sprites = {64, 66, 68, 70, 72, 70, 68, 66}
}

-- bullets
player_bullets = {}
enemy_bullets = {}

-- enemies
boss_table = {}
enemy_table  = {}
enemy_spawned = {}

-- animations
seraph = {}
moves = {}
shield_anims = {}
tele_animation = {}
boss_hit_anims = {}
destroyed_bosses = {}
destroyed_enemies = {}
exploding_enemies = {}
water_anim_list = {}

-- inventory
dropped = {}
player_inventory = {}

-- skilltree
currently_selected = 1
selection_set = {"speed", "fire rate", "health", "quit"}
next_cost = {1, 1, 1}
skills_selected = {true, false, false, false}

title = {
  startx = 23,
  starty = 50,
  text = {   "12,12,12,12, 0, 0, 0,12,12,12, 0,12,12,12,12,12,12,12, 0, 12,12,12,12,12,12,12,12, 0, 0,12,12,12,12,12, 0, 0,12,12,12,12,12,12,12, 0,12,12,12,12,12,12,12, 0, 0,12,12,12,12, 0, 0,12,12,12,12, 0, 0, 0,12,12,12",
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
}

--============================================================================--
--============================= helper functions =============================--
--============================================================================--
function debug()
  local debug_color = 14
  local cpucolor = debug_color

  print("px: " .. player.x, 0, 0, debug_color)
  print("py: " .. player.y, 45, 0, debug_color)

  print("me: " .. round((stat(0)/1024)*100, 2) .. "%", 0, 6, debug_color)
  if stat(1) > 1 then cpucolor = 8 end --means we're not using all 30 draws (bad)
  print("cp: " ..round(stat(1)*100, 2) .. "%", 45, 6, cpucolor)

  print("m "..mget((stat(32) - 3)/8 + level_x, (stat(33) - 3)/8) + level_y, 45, 12, debug_color)
  print("", 0, 12, debug_color)

  if (spawn_time_start ~= nil) print(spawn_time_start - timers["spawn"], 0, 18, debug_color)
  print("", 45, 18, debug_color)
end

function gameflow()
  -- start game
  drawcontrols, wait.controls = true, true
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
                    255, 15*8, 14*8}
  yield()

  drawcontrols, wait.controls = false, false
  init_tele_anim(player)
  yield()

  seraph.text = "READY TO GET TO WORK?"
  yield()

  seraph.text = "I SEE A DOOR. GIVE ME A MINUTEAND I'LL GET IT OPEN."
  yield()

  fill_enemy_table(1, 65)
  spawn_time_start, timers["leveltimer"], wait.timer =  60, 60, true
  yield()

  kill_all_enemies(true)
  wait.timer = false
  seraph.text = "OKAY THAT SHOULD DO...*static*INCOM-*static* B-*static*..."
  yield()

  init_tele_anim(boss(60, 60, 128, 1, 40))
  yield()

  kill_all_enemies(true)
  seraph.text = "NICE WORK. THE DOOR SHOULD    OPEN NOW."
  yield()

  wait.controls,open_door,level_change = true,true,true
  yield()

  wait.controls = false
  yield()

  --start level 2
  wait.controls = true
  seraph.text = "WELCOME TO THE PLANET HECLAO, SUPPOSE TO BE OUR HOME AWAY   FROM HOME."
  add(boss_table, boss(100, 56, 139, 2, 35))
  yield()

  seraph.text = "UNFORTUNATELY WE WEREN'T ALONE"
  yield()

  seraph.text = "OH, WHO IS THIS LITTLE GUY?   SEEMS TO BE CHECKING YOU OUT."
  yield()

  wait.controls,spawn_time_start  = false,60
  fill_enemy_table(2, 60)
  yield()

  kill_all_enemies(true)
  level_change = true
  yield()

  -- start level 3
  fill_enemy_table(3, 90)
  spawn_time_start = 90
  init_tele_anim(boss(100, 60, 160, 3, 40))
  yield()

  level_change = true
  yield()

  -- start level 4
  fill_enemy_table(4, 90)
  spawn_time_start,detect_killed_enemies = 90, true
  yield()

  init_tele_anim(boss(60, 60, 128, 1, 40))
  init_tele_anim(boss(60, 20, 139, 2.5, 40))

  yield()
  level_change = true
end

-- http://lua-users.org/wiki/simpleround
function round(num, numdecimalplaces)
  local mult = 10^(numdecimalplaces or 0)
  return flr(num * mult + 0.5) / mult
end

--https://gist.github.com/josefnpat/bfe4aaa5bbb44f572cd0
-- function ceil(x) return -flr(-x) end

-- http://pico-8.wikia.com/wiki/centering_text
function hcenter(s) return 64-flr((s*4)/2) end

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

function distance(n, d)
  return sqrt((n.x-d.x)*(n.x-d.x)+(n.y-d.y)*(n.y-d.y))
end

function angle_btwn(tx, ty, fx, fy)
  local diffx, diffy = (tx - fx), (ty - fy)
  -- local diffy = ty - fy
  local angle = ((atan2(diffy, diffx) * 360) + 180)%360
  if (angle <= 0) angle = (angle + 360)%360
  return angle
end

--[[
  delete offscreen objects
]]
function delete_offscreen(list, obj)
  if (obj.x < 0 or obj.y < 0 or obj.x > 128 or obj.y > 128) del(list, obj)
end

function continuebuttons()
  if ((btnp(4) or btnp(5) or stat(34) == 1) and timers["firerate"] == 0) timers["firerate"] = 1; return true
  return false
end

--[[
  collision
]]
function bump(x, y, flag)
  -- local tx = flr((x - level_sx + (level_x*8)) / 8)
  -- local ty = flr((y - level_sy + (level_y*8)) / 8)
  -- local flag = (flag or 0)
  -- local map_id = mget(tx, ty)

  --return fget(map_id, flag)
  return fget(mget(flr((x - level_sx + (level_x*8)) / 8), flr((y - level_sy + (level_y*8)) / 8)), (flag or 0))
end

function bump_all(x, y)
  return bump(x, y) or bump(x + 7, y) or bump(x, y + 7) or bump(x + 7, y + 7)
end

function ent_collide(firstent, secondent)
  --secondent = secondent or player
  offset = (firstent == player) and 4 or 0
  return (firstent.x + offset > secondent.x + level_sx + secondent.size or firstent.x + offset + firstent.size < secondent.x + level_sx
    or firstent.y + offset > secondent.y + secondent.size or firstent.y + offset + firstent.size < secondent.y) == false
end


--============================================================================--
--====================== object-like structures ==============================--
--============================================================================--
function drop_obj(sx, sy, sprite)
  local d = {}
  d.x, d.y, d.sprite, d.size, d.drop_duration = sx, sy, sprite, 8, 5
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

function enemy(x, y, type, time_spwn)
  local e = {}
  e.x, e.y, e.speed, e.time, e.b_count =  x, y, .35, time_spwn, 0
  e.destroy_anim_length, e.destroyed_step, e.drop_prob, e.shoot_distance = 15, 0, 100, 50
  e.destroy_sequence = {135, 136, 135}
  e.drops = {32, 33, 48, 49} -- sprites of drops
  e.explode_distance, e.explode_wait, e.explode_step, e.fire_rate = 15, 15, 0, 20
  e.exploding, e.dont_move, e.size, e.sprite, e.speed, e.type = false, false, 8, 132, .35, type

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

function bullet(startx, starty, angle, sprite, friendly, shotgun)
  local b = {}
  b.x, b.y, b.angle, b.sprite, b.friendly, b.duration = startx, starty, angle, sprite, friendly, 15
  b.shotgun, b.speed, b.acceleration, b.current_step, b.max_anim_steps, b.rocket, b.size = (shotgun or false), 2, 0, 0, 5, false, 8

  if (b.sprite == 48) b.acceleration, b.max_anim_steps, b.rocket = 0.5, 15, true

  b.move = function()
     if (b.sprite == 48) b.acceleration += 0.5
     if (b.shotgun) b.duration -= 1
     b.x = b.x - (b.speed+b.acceleration) * sin(b.angle / 360)
     b.y = b.y - (b.speed+b.acceleration) * cos(b.angle / 360)
   end

  return b
end

function boss(startx, starty, sprite, lvl, hp)
  local b = {}
  b.x, b.y, b.speed, b.angle, b.level, b.shot_last, b.shot_ang, b.sprite = startx, starty, .01, 0, lvl, nil, 0, sprite
  b.size, b.bullet_speed, b.fire_rate, b.destroyed_step, b.destroy_anim_length, b.health, b.full_health = 16, 2, 7, 0, 30, (hp or 50), (hp or 50)
  b.destroy_sequence = {135, 136, 135}
  b.circs = {}
  timers["bossstart"] = (lvl == 6) and 12 or 1000
  b.draw_healthbar = function()
             --health bar
             if (b.sprite == 128 or 139) xoffset = 1
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
               b.x = b.x - 2*sin(p_ang/360)
               b.y = b.y - 2*cos(p_ang/360)
             end
           elseif b.level == 2.5 then
             if flr(time()*50)%b.fire_rate == 0 then
               shoot(b.x, b.y, p_ang, 141, false, true)
               b.x = b.x - 2*sin(p_ang/360)
               b.y = b.y - 2*cos(p_ang/360)
             end
           elseif b.level == 3 then
              local ang = (360/(timers["bossstart"]/50))*(10%(timers["bossstart"]/50))
              if (timers["bossstart"] <= 900) timers["bossstart"] = 1000
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
                      sfx(18)
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


--============================================================================--
--========================== draw functions ==================================--
--============================================================================--
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

function draw_titlescreen()
  rectfill(0, 0, 127, 127, 0)

  if not title.drawn then
    sfx(7)
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

  --print("press \x8e/\x97 to start", 20, 100, flr(time()*5)%15+1)
  print("PRESS left click TO START", hcenter(25), 100, flr(time())%15+1)
end

function draw_controls()
  rectfill(10, 20, 117, 101, 8)
  rectfill(11, 21, 116, 100, 6)

  print("use the mouse to aim!", 21, 30, 8)
  print("use: left click to shoot", 18, 55, 5)
  print("middle click to", 38, 65, 5)
  print("switch power ups", 38, 71, 5)
  print("right click to", 38, 81, 5)
  print("shoot power ups", 38, 87, 5)
end

function draw_dialog()
  local bck_color = seraph.bck_color or 5
  local brd_color = seraph.brd_color or 0
  local fnt_color = seraph.fnt_color or 7
  local d = seraph.text

  if (seraph.step == nil) seraph.step = 0
  if (seraph.step < #d) wait.dialog_finish = true

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

  print(sub(d, 0, min(seraph.step, 30)), 5, 107, fnt_color)
  if (seraph.step > 30) print(sub(d, 31, min(seraph.step, 60)), 5, 113, fnt_color)
  if (seraph.step > 60) print(sub(d, 61, min(seraph.step, 90)), 5, 119, fnt_color)
  seraph.step = min(seraph.step+1, #d+30)
  if (seraph.step == #d+30) wait.dialog_finish = false
end

function drawcountdown()
  --local x, y, clr = 57, 15, 12
  local countdown = timers["leveltimer"]
  local hours = flr(countdown/3600);
  local mins = flr(countdown/60 - (hours * 60));
  local secs = -flr(-(countdown - hours * 3600 - mins * 60));
  if (secs == 60) mins += 1; secs = 0
  if (secs < 10) secs = "0" .. secs

  print(mins .. ":" .. secs, 57, 15, 12)

  if (countdown == 0) wait.timer = false; coresume(game)
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

function skilltree()
  rectfill(-50, -50, 200, 200, 0)
  spr(coin.sprites[flr(time()*8)%#coin.sprites + 1], 20, 20, 2, 2)
  print(" - " .. player_tokens, 36, 26, 7)

  print("upgrade speed - ".. next_cost[1] .." tokens ", 10, 36, 7+((skills_selected[1] and 1 or 0)*3))
  print("upgrade fire rate - ".. next_cost[2] .." tokens ", 10, 44, 7+((skills_selected[2] and 1 or 0)*3))
  print("upgrade health - ".. next_cost[3] .." tokens ", 10, 52, 7+((skills_selected[3] and 1 or 0)*3))
  print("quit", 10, 68, 7+((skills_selected[4] and 1 or 0)*3))
end

function draw_playerhp()
  --local hpcolor = 11
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

  rectfill(player.x + 3, player.y + 1, player.x + 12, player.y + 1, 6)
  rectfill(player.x + 3, player.y + 1, player.x + 3 + (9 * hpratio), player.y + 1, hpcolor)
  if (player_shield > 0) rectfill(player.x + 3, player.y + 1, player.x + 4 + (8 * (player_shield / 4.8)), player.y + 1, 12)

  if timers["showinv"] > 0 then
    if (#player_inventory > 0) spr(player_inventory[1].sprite, player.x + invtx, player.y + 14)
    if (#player_inventory > 1) spr(player_inventory[2].sprite, player.x + invtx + 9, player.y + 14)
    if (#player_inventory > 2) spr(player_inventory[#player_inventory].sprite, player.x + invtx - 9, player.y + 14)
    spr(112, player.x + 4, player.y + 14)
  end
  if timers["showinv2"] > 0 and #player_inventory > 0 then
    local ammoratio = player_inventory[1].ammo / player_inventory[1].ammos[player_inventory[1].sprite]
    rectfill(player.x + 4, player.y + (21 - flr(7  * ammoratio)) , player.x + 11, player.y + 21, 13)
    spr(player_inventory[1].sprite, player.x + invtx, player.y + 14)
  end
end

function enem_spawned()
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
      if timers["playerlasthit"] == 0 and ent_collide(player, e) then
        if player_shield <= 0 then
          player_health -= 1
          sfx(18)
          --player.last_hit = time()
          timers["playerlasthit"] = player_immune_time
        else
          player_shield -= .15
        end
      end

      if e.exploding and flr(time()*500)%2==0 then
        pal()
        pal(2,8,0)
      end

      if e.type == "shooter" then
        pal(2,1,0)
        pal(5,13,0)
      elseif e.type == "exploder" then
        pal(8,10,0)
        pal(2,8,0)
        pal(5,9,0)
      end
      spr(e.sprite, e.x, e.y)
      pal()

      if (e.explode_step == e.explode_wait) add(exploding_enemies, e)

      e.move()
    end
  end
end

function item_drops()
  for d in all(dropped) do
    if ent_collide(player, d) then
      if d.type == "heart" and player_health < player_max_health then
        player_health = min(player_max_health, player_health+3)
        sfx(17)
        del(dropped, d)
      elseif d.type == "shield" then
        player_shield = player_shield_dur
        sfx(6)
        del(dropped, d)
      elseif d.type ~= "heart" and #player_inventory < player_inv_max then
        add(player_inventory, d)
        if (#player_inventory < 4) timers["showinv"] = .5
        sfx(19)
        del(dropped, d)
      end
    end

    if (d.type == "shotgun" and (pget(d.x+2, d.y+4) == 4) or pget(d.x+3, d.y+4) == 4) pal(4,0,0)
    if (d.type == "shield" and (pget(d.x+4,d.y+7) == 9) or pget(d.x, d.y) == 9) pal(9,12,0)

    if abs(time() - d.init_time) <= d.drop_duration then
      if abs(time() - d.init_time) <= 2*(d.drop_duration/3) then
        spr(d.sprite, d.x+level_sx, d.y+level_sy)
      elseif flr(time()*1000)%2==0 then
        spr(d.sprite, d.x+level_sx, d.y+level_sy)
      end
    else
      del(dropped, d)
    end
  end
  pal()
end

function bullets_player()
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
          if bos.health <= 0 then
            sfx(5,1)
            add(destroyed_bosses, bos)
            player_killed += 1
            del(boss_table, bos)
            coin.x,coin.y = bos.x,bos.y
            --bos = nil
            if (#boss_table == 0) coresume(game)
          end
          break
        end
      end
    end
  end
end

function bullets_enemies()
  for b in all(enemy_bullets) do
    -- first delete offscreen bullets:
    delete_offscreen(enemy_bullets, b)

    if ent_collide(player, b) then
      if timers["playerlasthit"] == 0 then
        if player_shield <= 0 then
          player_health -= 1
          add(boss_hit_anims, b)
          sfx(18)
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
end

-- function show_leaderboard()
--   rectfill(0,0,128,128,0)
--   print("you died",20, 20, 8)
--   if sort then
--     if (timers["countup"] == 0) then
--        timers["countup"] = .1
--        if(k<player_killed) k+=1
--        if(k==player_killed) sort=false; timers["countup"] = .5
--     end
--     print("killed: "..k, 30, 50, 8)
--   else
--     print("killed: "..player_killed, 30, 50, 8)
--     if (timers["countup"] ~= 0) camera(cos((time()*1000)/3), cos((time()*1000)/2))
--   end
--   in_leaderboard = true
--   print("press \x8e/\x97 to start", 20, 100, flr(time()*5)%15+1)
-- end

function show_leaderboard()
  rectfill(0,0,128,128,0)
  print("you died",hcenter(8), 55, 8)
  --k = min(player_killed, k+0.5)
  if (k<player_killed-1) k += 0.5
  local t = "KILLED: "..flr(k)
  print(t, hcenter(#t), 63, 5)
  print("PRESS \x8e/\x97 TO START OVER", 20, 100, flr(time()*5)%15+1)
  if (flr(k)==player_killed-1) timers["invalid"] = 0.5; k+=1
  if (timers["invalid"] > 0) camera(cos((time()*1000)/3), cos((time()*1000)/2))
end

--============================================================================--
--======================= animation functions ================================--
--============================================================================--
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
  if (b.destroyed_step <= b.destroy_anim_length) then
    for i=1,3 do
      spr(b.destroy_sequence[flr(b.destroyed_step/30)+1], b.x+s*flr(rnd(8)), b.y+s1*flr(rnd(8)))
    end
  else
    if (b~= player) del(destroyed_bosses, b)
    if (#boss_table == 0) coin.dropped = true
  end

  circ(b.x+4, b.y+4, b.destroyed_step%5, 8)
  b.destroyed_step += 1

end

function init_tele_anim(e)
  e.anim_length,e.anim_step = 90,0
  add(tele_animation, e)
end

function step_teleport_animation(e)
  local offset = -1
  if (e == player) offset = 4
  if e.anim_step < e.anim_length then
    if (e == player) wait.controls = true
    if (e.anim_step == 15) sfx(21)

    if e.anim_step >= e.anim_length - 15 then
      circfill(e.x +offset + (e.size/2), e.y + offset + (e.size/2), e.anim_step%18, 12)
      circ(e.x+offset + (e.size/2), e.y+offset + (e.size/2), e.anim_step%18*2, 12)
      timers["invalid"] = 0.1
      showplayer=true
    end

    if rnd(30) < e.anim_step-15 then
      circ(e.x - 5 + rnd(10 + e.size), e.y - 5 + rnd(10 + e.size), rnd(3), 12)
    end

    e.anim_step += 1

  else
    del(tele_animation, e)
    if (e == player) showplayer, wait.controls = true, false; coresume(game)
    if (e ~= player) add(boss_table, e)
  end
end

function move_anim(l)
  local col = {8,9,10}
  for i=1,5 do
    pset(rnd(5)+(l[1]+8)+6*sin(player_angle / 360), rnd(5)+(l[2]+8)+6*cos(player_angle / 360), col[i%#col + 1])
  end
end

function water_anim()
  for i=0,16 do
    for j=0,16 do
      if (fget(mget(i+level_x-(level_sx/8), j+level_y-(level_sy/8)),1) and fget(mget(i-1+level_x-(level_sx/8), j-1+level_y-(level_sy/8)),1) and rnd(10) > 9.5) add(water_anim_list, {i*8+rnd(4),j*8+rnd(4), flr(rnd(3)), 7, 25});
    end
  end
end


--============================================================================--
--================================ functions =================================--
--============================================================================--
--[[
  shoot: create bullet objects and add them to the 'bullets' table
]]
function shoot(x, y, a, spr, friendly, boss, shotgun)
  if (boss) sfx(2)
  if friendly then
    local offx, offy = (player.x + 5), (player.y + 5)
    local ang = angle_btwn((stat(32) - 3), (stat(33) - 3), offx, offy)
    local range = shotgun and 1 or 0
    local start = shotgun and 0xffff or 0
    offx, offy = (offx - 8*sin(ang / 360)), (offy - 8*cos(ang / 360))
    for i=start,range,1 do
      add(player_bullets, bullet(offx, offy, ang+(i*30), spr, friendly, shotgun))
    end
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

function skill_tree()
  skills_selected[currently_selected] = false
  local diff = 0
  local function update_selec()
          if selection_set[currently_selected] == "health" then
            player_max_health += 1
            player_health += 1
          elseif selection_set[currently_selected] == "fire rate" then
            player_fire_rate = max(.1, player_fire_rate-.15)
          elseif selection_set[currently_selected] == "speed" then
            player_speed += .2
          end
          player_tokens -= next_cost[currently_selected]
          next_cost[currently_selected] += 1
          -- sfx(1)
        end
  if btnp(2) then
    diff = 0xffff
    sfx(0)
  elseif btnp(3) then
    diff = 1
    sfx(0)
  elseif btnp(5) then
    if selection_set[currently_selected] == "quit" then
      in_skilltree = false
      sfx(0)
    elseif (selection_set[currently_selected] == "health" and player_tokens >= next_cost[currently_selected]) then
      update_selec()
    elseif (selection_set[currently_selected] == "fire rate" and player_tokens >= next_cost[currently_selected]) then
      update_selec()
    elseif (selection_set[currently_selected] == "speed" and player_tokens >= next_cost[currently_selected]) then
      update_selec()
    else
      timers["invalid"] = 0.5
      sfx(3)
    end
  end
  currently_selected = ((currently_selected+diff)%#skills_selected)
  if (currently_selected == 0) currently_selected = 4
  skills_selected[currently_selected] = true
  if player_tokens == 0 then
    for i=1,10 do
      flip()
    end
    in_skilltree = false
  end
  return
end

function enem_exploder()
  for e in all(exploding_enemies) do
    if step_destroy_animation(e) then
      if distance(e, player) <= 15 and timers["playerlasthit"] == 0 then
        if player_shield <= 0 then
          player_health -= 1
          sfx(18)
          timers["playerlasthit"] = player_immune_time
        else
          player_shield -= .15
        end
      end
    end
  end
end

function fill_enemy_table(level, lvl_timer)
  local types = {"shooter", "basic", "exploder"}
  local baseline = 20
  for i=1,(baseline*level) do
    add(enemy_table, enemy(flr(rnd(120)), flr(rnd(120)), types[flr(rnd(#types))+1], flr(rnd(lvl_timer))))
  end
end

function spawnenemies()
  if (#enemy_table == 0) timers["spawn"] = 0; return
  if (timers["spawn"] == 0) timers["spawn"] = spawn_time_start
  local types = {"basic", "shooter", "exploder"} --1, 2, 3
  for enemy in all(enemy_table) do
    if spawn_time_start - timers["spawn"] >= enemy.time then
      repeat
        enemy.x,enemy.y = flr(rnd(120)), flr(rnd(120))
      until (distance(player, enemy) > 50 and not bump_all(enemy.x, enemy.y))

      if (level_lvl == 1) enemy.type = types[1]
      if level_lvl == 2 then
        enemy.type = "basic"
        if (rnd(99) < 20) enemy.type = "shooter"
      end
      if level_lvl == 3 then
        if enemy.type == "exploder" then
          if (rnd(99) < 80) enemy.type = types[1+rnd(1)]
        end
      end

      add(enemy_spawned, enemy)
      del(enemy_table, enemy)
    end
  end

  -- if #enemy_table == 0 then
  --   spawn_enemies = false
  --   --if (not wait.timer) detect_killed_enemies = true
  -- end
end

function detect_kill_enemies()
  if #enemy_spawned == 0 and #enemy_table == 0 then
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

  level_i = 3*level_lvl+1
  if (level_transition[level_i] == level_lvl+1 and (level_transition[level_i+1] - 12) * 8 < abs(level_sx - ((level_lvl-1) * 128))) move_map = true

  --todo add map centering on player in the beginning

  if not move_map then
    if btn(0) and abs(level_sx - ((level_lvl-1) * 128)) > level_x*8 and player.x < farx then
      level_sx += player_speed
      if player.x < farx then player.x = farx end
    end
    if btn(1) --[[and level_sx - ((level_lvl-1) * 128) <= (level_transition[level_i+1])*8]]  and player.x > farx then
      level_sx -= player_speed
      if player.x > farx then player.x = farx end
    end
  end

  if move_map ~= nil and move_map then
    wait.controls = true

    if level_transition[level_i+1]*8 > abs(level_sx - ((level_lvl-1) * 128)) then
      level_sx = flr(level_sx) - 1
      player.x -= 1

    --[[elseif check we go down then]]

    else
      dropped = {}
      level_sprites = {}
      open_door = false
      level_sx, level_sy, level_x, level_y = 0, 0, level_transition[level_i+1], level_transition[level_i+2]
      wait.controls, move_map, level_change, coin.dropped = false, false, false, false
      level_lvl += 1
      coresume(game)
    end
  end
end

function rocket_kill(rocket)
  sfx(22)
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

function drop_item(e)
  if (flr(rnd(100)) <= e.drop_prob) add(dropped, drop_obj(e.x, e.y, e.drops[flr(rnd(#e.drops)) + 1]))
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

function save_data()
  local save = {player.x, player.y, level_sx, level_sy, level_lvl, player_tokens} -- missing: player_inventory, and current skill values/costs
  for i=0,(#save-1) do
    dset(i, save[i+1])
  end
end

function load_data()
  _load = {}
  for i=0,53 do
    _load[#_load+1] = dget(i)
  end
end


--------------------------------------------------------------------------------
---------------------------------- constructor ---------------------------------
--------------------------------------------------------------------------------
function _init()
  -- for i=53,63 do
  --   dset(i, 0)
  -- end
  k=0
  poke(0x5f2d, 1)

  title.init = time()

  game = cocreate(gameflow)
  coresume(game)
end --end _init()


--============================================================================--
--================================ update ====================================--
--============================================================================--
function _update()
  --timers["playerlasthit"] = 1 --uncomment for god mode
  collide_all_enemies()

  local previousx, previousy = player.x, player.y
  local move = (bump(player.x + 4, player.y + 4, 1) or bump(player.x + 11, player.y + 11, 1)) and player_speed/2 or player_speed

  -- count down timers
  for k,t in pairs(timers) do timers[k] = max(0, timers[k] - (1/30)) end

  if (level_change)  levelchange()

  if (titlescreen == nil and continuebuttons()) titlescreen = true; return

  if (drawcontrols and continuebuttons()) showcontrols = false coresume(game); return

  if (in_leaderboard and continuebuttons()) in_leaderboard = false; sort = true; run()

  if (in_skilltree) skill_tree(); return;

  if (seraph.text ~= nil and not wait.dialog_finish and continuebuttons()) seraph = {}; coresume(game); return

  if not wait.controls and seraph.text == nil then
    --========================
    --left mouse button-------
    --========================
    if stat(34) == 1 and timers["firerate"] == 0 then
        shoot(player.x, player.y, player_angle, 34, true, false)
        timers["firerate"] = player_fire_rate
        sfx(2)
    end

    --========================
    --middle mouse button-----
    --========================
    if stat(34) == 4 and timers["middleclick"] == 0 then -- cycle inventory
      local temp = 0
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

        timers["middleclick"] = .25
        if (#player_inventory == 2) invtx = 7
        if (#player_inventory > 2) invtx = 13
      end
      timers["showinv"], timers["showinv2"] = .5, 0
    end

    --========================
    --right mouse button------
    --========================
    if (stat(34) == 2) and #player_inventory > 0 and timers["rightclick"] == 0 then
      local invt = player_inventory[1]
      timers["rightclick"] = player_power_fire_rate

      if invt.type == "shotgun" then
        shoot(player.x, player.y, player_angle, 34, true, false, true)
        sfx(20)
      elseif invt.type == "rockets" then
        shoot(player.x, player.y, player_angle, 48, true, false)
        sfx(16)
      end

      if invt.ammo == 1 then
        if (invt.type ~= "rockets") sfx(3)
        del(player_inventory, player_inventory[1])
        timers["rightclick"], timers["showinv"], timers["showinv2"] = 1, .5, 0
      else
        invt.ammo -= 1
        timers["showinv2"] = player_power_fire_rate + 0.2
      end
    end

    --========================
    --up button---------------
    --========================
    if btn(2) then
      player.y -= move
      add(moves, {player.x, player.y})
      if (bump(player.x + 4, player.y + 3) or bump(player.x + 11, player.y + 3)) player.y = previousy
    end

    --========================
    --down button-------------
    --========================
    if btn(3) then
      player.y += move
      add(moves, {player.x, player.y})
      if (bump(player.x + 4, player.y + 12) or bump(player.x + 11, player.y + 12)) player.y = previousy
    end

    --========================
    --left button-------------
    --========================
    if btn(0) then
      player.x -= move
      add(moves, {player.x, player.y})
      if (bump(player.x + 3, player.y + 4) or bump(player.x + 3, player.y + 11)) player.x = previousx
    end

    --========================
    --right button------------
    --========================
    if btn(1) then
      player.x += move
      add(moves, {player.x, player.y})
      if (bump(player.x + 12, player.y + 4) or bump(player.x + 12, player.y + 11)) player.x = previousx
    end

    --========================================================================--
    player_angle = flr(atan2(stat(32) - (player.x + 8), stat(33) - (player.y + 8)) * -360 + 90) % 360

    if (player.x < 0) player.x = 0
    if (player.y < 0) player.y = 0
    if (player.x > 112) player.x = 112
    if (player.y > 112) player.y = 112

    if (not wait.controls or seraph.text == nil) player_shield = max(player_shield - .01,0)

    --if (btn(c.left_arrow, 1)) level_sx += 1
    --if (btn(c.right_arrow, 1)) level_sx -= 1

    enem_exploder()
    spawnenemies()
    if (detect_killed_enemies) detect_kill_enemies()

  else

    timers["playerlasthit"] = 0x.0001 --make player invulnerable so they dont get hit when they can't move
  end -- end wait.controls

  --========================
  --x button----------------
  --========================
  if btnp(5) and not level_change then
    for t in all(tele_animation) do
      t.anim_step = t.anim_length
    end
    --seraph = {}
    wait.dialog_finish = false
    if (seraph.text == nil) kill_all_enemies(true)
    coresume(game)
  elseif level_change then
    kill_all_enemies(true)
  end
end


--------------------------------------------------------------------------------
--------------------------------- draw buffer ----------------------------------
--------------------------------------------------------------------------------
function _draw()
  cls()

  if (in_leaderboard) show_leaderboard(); return

  map(level_x, level_y, level_sx, level_sy, 128, 128)

  if (rnd(10) > 9.5) water_anim()
    for i in all(water_anim_list) do
    circ(i[1], i[2], i[3], i[4])
    i[5] -= 1; if (rnd(5) > 4.5) i[3] = (i[3]+1)%4
    if (i[5] == 0) del(water_anim_list, i)
  end

  if (titlescreen == nil) draw_titlescreen(); return

  if player_health <= 0 then
    sfx(22)
    if (player.destroyed_step < player.destroy_anim_length) step_boss_destroyed_animation(player); return
    sfx(9,1)
    in_leaderboard = true
    --sort = true
    -- run()
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

  if (level_lvl == 1 and #boss_table == 0) spr(139, 228+level_sx, 56, 2, 2)
  --if (level_lvl == 2 and #boss_table == 0) spr(139, 100, 56, 2, 2)

  if (drawcontrols) draw_controls(); return

  if (open_door) opendoor()

  if (player_shield > 0) circ((player.x+8), (player.y+7), ((time()*50)%2)+6, 1)

  if (showplayer ~= nil) draw_playerhp()
  if (showplayer ~= nil and timers["playerlasthit"] <= 0x.0001) then
    spr_r(0, player.x, player.y, player_angle, 2, 2)
  elseif showplayer ~= nil and timers["playerlasthit"] > 0x.0001 and flr(time()*1000%2) == 0 then
    spr_r(0, player.x, player.y, player_angle, 2, 2)
  end

  if (wait.timer) drawcountdown()

  --=======================
  --animations-------------
  --=======================
  foreach(moves, move_anim)
  moves = {}
  foreach(destroyed_enemies, step_destroy_animation)

  enem_spawned()
  item_drops()
  bullets_player()
  bullets_enemies()

  for s in all(shield_anims) do
    local colors = {12, 13, 1}
    s[3] = s[3]-1
    circ(s[1]+8, s[2]+8, flr(time()*100)%4, colors[flr(time()*100)%#colors + 1])
    if (s[3] == 0) del(shield_anims, s)
  end

  for b in all(boss_table) do
    if (timers["playerlasthit"] == 0 and ent_collide(player, b)) player_health -= 2; sfx(18); timers["playerlasthit"] = player_immune_time
    if (b.level ~= 3) then spr(b.sprite, b.x, b.y, 2, 2)
    else sspr(0, 80, 8, 8, b.x, b.y, 16, 16) end
    b.update()
  end

  foreach(boss_hit_anims, boss_hit_animation)

  foreach(destroyed_bosses, step_boss_destroyed_animation)

  foreach(tele_animation, step_teleport_animation)

  if (pget(stat(32), stat(33)) == 8 or pget(stat(32), stat(33)) == 2)  pal(8, 6)
  spr(96, stat(32) - 3, stat(33) - 3)
  pal()


  if coin.dropped then
     spr(coin.sprites[flr(time()*8)%#coin.sprites + 1], coin.x+level_sx, coin.y+level_sy, 2, 2)
     if ent_collide(player, coin) then
       sfx(17,1)
       player_tokens += 1
       coin.dropped,direction,in_skilltree = false, nil, true
       -- direction = nil
       -- in_skilltree = true
     end
  end

  if (seraph.text ~= nil) draw_dialog()

  if (timers["playerlasthit"] > player_immune_time - 0.5) or (timers["invalid"] > 0) then
    camera(cos((time()*1000)/3), cos((time()*1000)/2))
  else
    camera()
  end

  if (in_skilltree) skilltree()

  debug() -- always on bottom
end

__gfx__
000000000000000000000000555555555555555555555555533333355222222552a99a2500000000000000000000000000000000000000000000000000000000
00000000000000000000000055555555555555555555555533777b3322aaa92252a99a2500000000000000000000000000000000000000000000000000000000
000000000000000000000000555555555555555555555555377bbbb32aa9999252a99a2500000000000000000000000000000000000000000000000000000000
0000000000000000000000005555555555999a5999a5555537bbbbb32a99999252a99a2500000000000000000000000000000000000000000000000000000000
0000600000060000000000005555555555aaa559aaaa55553bbbbbb329999992529aa92500000000000000000000000000000000000000000000000000000000
0000660cc06600000000000055555555555555555555555537bbbbb32a999992529aa92500000000000000000000000000000000000000000000000000000000
00006619916600000000000055555555559a55599a59a55533bbbb33229999225229922500000000000000000000000000000000000000000000000000000000
0000661991660000000000005555555555999a5aa55aaa5553333335522222255552255500000000000000000000000000000000000000000000000000000000
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
00300000000030000009000000000000020202000000000009090900000990000909909008080800000000000110011111000011007670000002200000000000
0003000000030000000a00000000000002222200008880000999990000999900009aa90008888800000000000011011111000110076167000026620000000000
00025555503000000a9a9a0000000000025552000082800099aaa990099aa99009aaaa9088999880000000000001111111111100761116700026620000000000
0003885883200000000a0000000000000285820000888000098a8900099aa99009aaaa9008a9a800000000001111551515511110076167000002200000000000
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
00555500000000009000000900000000000000000000000000000000000000000000000000808000008080000000000000000000777777777777777700000000
05dddd50000000009008800900000000000080000008000000000200002000000000000000505558555050000002220000000000777777777777777700000000
5885588500000000900880090000000000005000000500000002020000202000000000000055588588555000002ddd2000000000777777777777777700000000
05d55d5000000000099889900000000000005500005500000002002002002000c0000000000005555500000002dd2dd200000000777707777770777700000000
0055550000000000009889000000000000050500005050000000202002020000cccccccc2000558585500020002d2d2000000000777707777770777700000000
000dd000000000000098890000000000008005055050080000002022220200000000000c020800585008020002dd2dd2000000000777077dd770777000000000
0005500000000000000990000000000000000555555000000000221111220000000000000020000500002000002ddd20000000000777072dd270777000000000
000550000000000000099000000000000000054444500000002028822882020000000000020000555000020000022200000000000777072dd270770000000000
0000000000000000000000000000000000555884488555500d020212212020d000000000200005555500002000000000000000000077002dd200770000000000
00000000000000000000000000000000008005444450008000002022220200000000000000005005005000000000000000000000007700299200770000000000
00000000000000000000000000000000000005544550000000020001100020000000000000080055500800000000000000000000007700299200770000000000
00000000000000000000000000000000000055055055000000200002200002000000000000200058500020000000000000000000000000299200000000000000
000000000000000000000000000000000005050000505000000d00222200d0000000000002000005000002000000000000000000777777022077777700000000
00000000000000000000000000000000005005000050050000000200002000000000000000002055502000000000000000000000777777722777777700000000
00000000000000000000000000000000008005000050080000000200002000000000000000020558550200000000000000000000777777277277777700000000
00000000000000000000000000000000000008000080000000000000000000000000000022200505050022200000000000000000777772777727777700000000
666555663333333300000000cccccccfffccccccffcccccccccccccffccccccc55555555ccccccffcccccccc55676665633333339ddddddd5555555995555555
677555773333333300000000cccccccfffccccccffccccccccccccff6ccccccc55555555ccccccffcccccccc55567765633333339ddddddd5555559dd9555555
675555553333333300000000cccccccfffccccccffccccccccccccfffccccccc53333355cccccccfcccccccc56766755633333339ddddddd555559dddd955555
675555553333b33300000000ccccccf6f6ccccccf6fcccccccccccfffccccccc53bbb355ccccccc6cccccccc57655556633333339ddddddd55559dddddd95555
5555555533b3b3b300000000ccccccffffccccccfffcccccccccccff6fcccccc53333355cccccccfcccccccc56556676633333339ddddddd5559dddddddd9555
675555763333333300000000cccccc6ff6fcccccffccccccccccccfffffccccc55355555ccccccffcccccccc55566676633333339ddddddd559dddddddddd955
555557763333333300000000ccff6fffffffffcc6fccccccccccccfff6ffccff55b55555cffcccffff6ccccc66666677633333339ddddddd59dddddddddddd95
555556663333333300000000fffffff336ff6ffffffcccccccccccff3fffff6f55555555ff6ffff3f6fff6ff77777777633333339ddddddd9dddddddddddddd9
444444449999999999999a9900000000cccccccc000000000000000000000000000000000000000055555535cccccccc33333333dddddddd9dddddddddddddd9
44544444999999999999a9a900000000cccccccc0000000000000000000000000000000000000000555555b5cccccccc33333333dddddddd59dddddddddddd95
4444445499999999999a999a00000000cccccccc000000000000000000000000000000000000000055bbbbb5cccccccc33333333dddddddd559dddddddddd955
44444444999a999999a999a900000000cccccccc000000000000000000000000000000000000000055b333b5cccccccc33333333dddddddd5559dddddddd9555
44544444aaa9a9aaaa99999a00000000cccccccc000000000000000000000000000000000000000055bbbbb5cccccccc33333333dddddddd55559dddddd95555
4444454499999a999999999900000000cccccccc000000000000000000000000000000000000000055555555cccccccc33333333dddddddd555559dddd955555
45444444999999999999999900000000cccccccc000000000000000000000000000000000000000055555555cccccccc33333333dddddddd5555559dd9555555
44444444999999999999999900000000cccccccc000000000000000000000000000000000000000055555555cccccccc33333333dddddddd5555555995555555
3393399333339333999999993335553355555553f9fff9ff00000000000000000000000055b5555500000000555555bb55555555dddddddd555555556bb66bb6
3339333339999393999999993bb555bb53b5555bff9fffff0000000000000000000000005535555500000000555555b655555555dddddddd5555555566666666
3339393933393393999999993b5555553b555555fffffff90000000000000000000000005333335500000000555555b655555555dddddddd5555555555555555
3399333339339993999999993b5555553b55b355f9ff9fff00000000000000000000000053bbb35500000000555555bb55555555dddddddd5555555555555555
3339939339399393aa99999a5555555555553b55ffffff9f0000000000000000000000005333335500000000555555bb55555555dddddddd5555555555555555
339933333939939999a999a93b5555b353355555ff9fffff0000000000000000000000005555555500000000555555b655555555dddddddd5555555555555555
3393339333399393999a9a9955555bb35b3b5555f9fff9ff0000000000000000000000005555555500000000555555b6bbbbbbbbdddddddd6666666655555555
33393939393999939999a9995555533353355555fff9ffff0000000000000000000000005555555500000000555555bbb66bb66b999999996bb66bb655555555
9999999999999999444444445555555656555555ffffffffffffffff00000000000000005655555544444445ddddddddddddddd9999999996655555555555566
9999999999999999944944445675555756555555ffffffffffffffff00000000000000005666665544fff445d4444444ddddddd9ddddddddb65555555555556b
9999999999999999444444946755555556666666ffffffffffffffff0000000000000000567776554f4f4f45d44fff44ddddddd9ddddddddb65555555555556b
999999999999a999449444446755765556777776ffffffffffffdfff0000000000000000566666554ff4ff45d4f4f4f4ddddddd9dddddddd6655555555555566
9999999999a9a9a9444449445555675556666666ffffffffffdfdfdf0000000000000000555555554f4f4f45d4ff4ff4ddddddd9dddddddd6655555555555566
9999999999999999494444445665555555555556ffffffffffffffff00000000000000005555555544fff445d4f4f4f4ddddddd9ddddddddb65555555555556b
9999999999999999444449445767555555555556ffffffffffffffff00000000000000005555555544444445d44fff44ddddddd9ddddddddb65555555555556b
9999999999999999444444445665555555555556ffffffffffffffff00000000000000005555555555555555d4444444ddddddd9dddddddd6655555555555566

__gff__
0001000000000101000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000002020202020002020000000000000202000200000000000002000000000000020000000000000000000000000000000000000000000000010100000000
__map__
feefefefefefefefefefefefefefeffffefafa03ccc5dbdbdbd4dbdbdbd4dbc3dcc1dcdce0e0e1f0f0f0f0f0f0f0f0f0f0e5f0e5f5f5f5f5f5f5f5f5f5f5f5f503e403d2d2d2d2d2000000000000000000000303f4f3f4f3f9f90303f403030303f400fc03d2d2d2030303e4ebd2d20303f30300000000000000000000000000
fe0303030303030303030303030303fffefafa03ccc5dbd4dbdbd4dbd4dbc6dcdcdcdce0e1f0f0f0f0f1f0f0f0f0f1f0f0f0f5f5e5f5f5f6f5f5f5f5f5f5f5f5dac80303c8d2d2d20000000000000000000003f9c0c0f3f403c003030303030303f300d503030303030303e3e9d2d203cbf40300000000000000000000000000
fe0303030303030303030303030303fffefafa03ccc4dbdbdbdbdbd4d4dbc3dcdcdce0dce0e1f0f0f0f0f0f0f0f0f0f0f0e5f0f5f5f5f5f5f5f5f5f6f5f5f5f50303e9e403d2d2d200000000000000000000c003030303f303030303030303f303c000dd03ced7f8e3e9f40303030303c0f40300000000000000000000000000
fe030303cefdfdcf03030303030303fffefa0303ccdcc5d4dbd4dbdbdbc3c1dcdcdce0e1dcdcf0f0f0f0f0f0f1f0f0f0f0f0f5f5f5f5f5f5f5f5f5f5f5f5f5f5e3e303e303c803d20000000000000000000003030303030303030303030303f9f3f400ddddddf8f8e4c8f3cbc003030303030300000000000000000000000000
fe030303cdfbfbfc03030303030303fffe030303ccdcc4cacacacacac3dcdcdcc1dcdce0dce0e1f0f0f1f0f0f0f0f0f0f0f0e5f5f5f6f5f5f5f5f5f5f5f5f5f5d2d2d2e90303e4e303030303030303f4f3f9030303030303030303f3f40303030303030303030303e3e403f903e4030303030300000000000000000000000000
fe030303deddfbfc03030303030303fffe030303ccdcdcc1dcdcdcdcdcdcdcdcdcdcdcdce0e1f0f0f0f0f0f0f0f0f2f2f2f0f5f5f5f5f5f5f5f6f5f5f5f6f5f5d2d2d2e3e3e3e9e4030303030303030303030303f403030303f303030303030303030303030303030303030303e3030303030300000000000000000000000000
fe03030303cdfbfc03030303030303fffe030303ccdcdcdcdcdcc1dcdcdcc1dcdcdcc1e0e1f0f0f0f0f0f0f0f0f2f2f2f2f2f2d0d0f5f5f5f5f5f5f5f5f5f5f5d2d2d2d2d2d2e3e303030303030303f4f3f9f303f303030303f40303030303c00303030303030303030303030303030303030300000000000000000000000000
fe03030303deeddf03030303030303ce03030303ccdcdcdcdcdcdcdcdcdcdcdcdcd0d0d0f2d0d0f0f0f1f0f0d0f2f2f0f0f2d0d0f2d0d0f5f5f5f5f6f5f5f5f5d2d2d2d2d2d2e4e30303030303030300000003f3c00303c003f303f3f403030303c000f60303030303030303030303f9f3030300000000000000000000000000
fe0303030303030303030303030303cd03030303d0d0d0c1dcdcdcdcc1d0d0d0f2d0f2d0d0f2d0d0d0f2d0d0f2d0f0f0f0f0f0e5d0f2d0f2d0d0f5f5f5f5f6f5d2d2d2d2d2d2c8030300005b5b000000000003c0f30303030303030303030303030300f60303030303030303030303fbfbfb0300000000000000000000000000
fe0303030303030303030303030303cd03030303d0d0d0d0d0d0dcd0d0d0d0d0d0dce0e1e1f0d0f2f2d0f2d0f0f0f0f0f0e5f5f5f5f5f5d0d0d0d0f5f5f5f5f5c8e303e4e3e303e30000005b5b00000000000303f30303030303030303030303030300f6030303d20303030303e4030303cb0300000000000000000000000000
fe0303030303030303030303030303de03030303ccdcd0d0d0d0d0d0d0dcdcdcdcdcdce0e0f0f0f0f0f0f0f0f0f0f0f0f0f0e5f5f5f5f5f5f5d0d0d0d0d0f5f503030303030303030000005b5b00000000000303030303030303f3f90303030303c000f6030303d2d203030303c8030303f30300000000000000000000000000
fe0303030303030303030303030303fffe030303ccdcc1dcdcdcdcdcdcdcdcc1dcdce0e1f0f0e1f0f0f0f1f0f0f1f0f0f0e5f0f5f5f5f5f5f5f5d0d0d0d0d0d00303da03030303030300005b5b00000000000303030303030303f4c0cb03030303c000f603d2d2d2d2d20303e4e40303f4c00300000000000000000000000000
fe0303030303030303030303cefdfdfdfe030303ccdcdcdcdcdcdcdcc1dcdcdcdcdcc1e0e1f0f0f0f0f0f0f0f0f0f0f0f0f0f5f5f5f5f6f5f5f6f5f5f5d0d0d0e3e403030303d2030300005b5b0000000000030303030303030303030303030303f300cd03d2d2d2d2d20303e9da0303f9030300000000000000000000000000
fe0303030303030303030303cdfbfbddfefa0303ccdcdcdcc1dcdcdcdcdcdcdcdcdce0dce1f0f0f0f0f1f0f0f0f0f0f0f0e5f5e5f5f5f5f5f5f5f5f5f5f5f5f5030303d2d2d2d20300000000000000000000cbf4c0f3f303030303030303030303c000cd03d203d2d20303030303030303030300000000000000000000000000
fe0303030303030303030303deedededfefafa03ccdcc1dcdcdcdcdcdcdcc1dcdcdce0e1f0f0e1f0f0f0f0f0f0f1f0f0f0f0e5f5f5f5f5f5f5f5f5f6f5f5f5f5030303000000000000000000000000000000c0cbc0cbf3030303f30303030303f3c000cd03d203d2d20303030303030303030300000000000000000000000000
feeecefdfdcfeeeeeeeeeeeeeeeeeefffefafafaccdcdcdcdcdcdcdcc1dcdcdcdce0e0e1f0e1f0f0f0f0f1f0f0f0f0f0f0e5f5e5f5f5f5f6f5f5f5f5f5f5f5f500000000000000000000000000000000000003030303cbf3f40303f4f303f3cb0303e1cdd2d2d2d2d2e4cbf3f3f3f9e4f4030300000000000000000000000000
0000000000e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8e8d2d2d2d2d2d203030303e403d2d2d2d2d2000000000000000000000000000000005c5c5c5c5c5c5c5c000000000000000000000000000000000000e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000
0000000000d50303f7f8f8f8f8f703f6f8d503030303d8d2d2d203030303e303dac80303c8d2d2d200000000000000000000000000000000000000005c5c5c00000000000000000000000000000000000000e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000
0000000000d5030303f7f7f7f70303f6f6f503030303d8d2d2d2e9e303c803c80303e9e403d2d2d2000000000000000000000000000000000000000000000000000000000000000000000000000000000000e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1e1000000000000000000000000000000000000000000000000000000000000
0000000000d503030303030303030303f6f503030303d803e90303c803e9e3e3e3e303e303c803d200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d503030303030303030303f6f503030303d6030303c8da03d2d2d2d2d2d2e90303e4e303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d5e5e50303030303030303030303030303f6e3e403e403e3d2d2d2d2d2d2e3e3e3e9e403000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00e8e8e8e8f6f8d50303030303030303030303030303f6e9e3c803e3e3d2d2d2d2d2d2d2d2d2e3e303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0003030303030303030303030303f6d5030303030303f60303dac803d2e3e9d2d2d2d2d2d2d2e4e303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0003030303030303030303030303f6d5030303030303f6030303e903d2e303d2d2d2d2d2d2d2c8030300005b5b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030303030303f6030303030303030303030303f6d9e6e4e4e3c803c8030303c8e303e4e3e303e30000005b5b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030303030303f6f80303030303030303030303f6e10303030303030303030303030303030303030000005b5b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030303030303f6f7f7f7f70303030303030303f600030303d203e3e40303030303da03030303030300005b5b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d9d9d9d9030303030303030303030303030303f60003d2d2d2030303e9c8e3e3e403030303d2030300005b5b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000030303030303030303030303030303f60000d2d2d2d203e3e4e903030303d2d2d2d20300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000e5e5e5e5e5e5d50303030303030303f60000000000d20303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000e1e1e1e1e1e1e5e5e5e5e5e5e5e5e5e500000000005c5c5c5c5c5c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00040000160501620016100191001b100000000000006000190000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000070500a5500e0000e70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000030340194402b34011430223300b4301e33008430163200541011310024100b31000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001c150151500f1000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000b0000080500d0500f0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000162300b43012220064200d210054100b6000b6001420000000000000000000000000000000000000000000000000000000000c2000220000000000000000000000000000000000000000000000000000
000a00000e35010350143500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500001b060232601606027260100602b2600c0602f2600705033250382501b0501f2501705025250100502c2500c050352503a2500b340103301432018310213001f3001d3001b30019300173000000000000
001000001335013350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000d0500d0500d0500d0500d0500d0500c0500c0500c0500c0500c0500c0500c05007050070500705007050070500704007040070300702007010070100701007010010000400003000030000300003000
000a000013040140501805014000190001e0002400020500016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000705050080500b5500e55005110071103870006050080500c5500e5500615008150104001f000104001d300104001f000104001f000104001f000104001f000104001f000104001f000104001f00010400
001000200375004750087500875008750087500875008750097500b7500b7500b7500b7500c7500e7500e7500e7500e7500e7501075012750127501275012750127501175011750107500f7500e7500000000000
0010000e096501b650036001b50009600000000a6501a6501860000000000000c6000b600000000000000000000000000000000000000000000000000003f7000000000000000000000000000000000000000000
0010000b073000255005350053100a3500a3100735007310103501031013300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100013047500675006750067500675004750097500975009750097500975009750097500675006750067500575005750057500a7500a7500a7500a750097500975008750057500675006750057500575004750
000900000362004620046200462003630036200160001600016000160001600016000160001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500001c05021050260502c0503105031000280002d000280002a0002c0002e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200002d65026650206501c64017640116400b620356201a620156200d620136202b6002a600216001f6000c600096000860000000000000000000000000000000000000000000000000000000000000000000
00040000062100a210132501a250052100b210162501c250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0003000019650176400f6400c63009620036100361003610036100361000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000900002f0502b150242501c1402f0202c110232101c1202f0302c130212501c1502f0502c150202301b1202e0202c110202201b1202f0502d00000000000002265022630216301f6201a610166101361010610
000600000d65013650186501b6500231012650166501f650256502265030650033101b650166401463013630126300f6300d6200b6200a6100961008610076100661000000000000000000000000000000000000
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
02 0e0f4d45
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
