pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
--=============================== global variables  ==========================--
player = {
  x = 60,
  y = 60,

  size = 8,

  destroyed_step = 0,
  destroy_anim_length = 30,
  destroy_sequence = {135, 136, 135},
}
player_health = 10
player_max_health = 10
player_shield = 0
player_speed = 1
player_angle = 0
player_fire_rate = .1
player_killed = 0
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
  5, 75, 0,
  6, 91, 0,
  7, 107, 0
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
  text = {         "12,12,12,12, 0, 0, 0,12,12,12, 0,12,12,12,12,12,12,12, 0, 12,12,12,12,12,12,12,12, 0, 0,12,12,12,12,12, 0, 0,12,12,12,12,12,12,12, 0,12,12,12,12,12,12,12, 0, 0,12,12,12,12, 0, 0,12,12,12,12, 0, 0, 0,12,12,12",
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

--============================= helper functions =============================--
function debug()
  local debug_color = 14
  local cpucolor = debug_color

  print("px: " .. player.x, 0, 0, debug_color)
  print("py: " .. player.y, 45, 0, debug_color)

  print("me: " .. round((stat(0)/1024)*100, 2) .. "%", 0, 6, debug_color)
  if stat(1) > 1 then cpucolor = 8 end --means we're not using all 30 draws (bad)
  print("cp: " ..round(stat(1)*100, 2) .. "%", 45, 6, cpucolor)

  print(mget((player.x + 12) / 8, (player.y + 4) / 8), 45, 12, debug_color)
  print(fget(mget((player.x + 12) / 8, (player.y + 4) / 8)), 0, 12, debug_color)

  print("", 0, 18, debug_color)
  print("", 45, 18, debug_color)
end

function gameflow()
  -- start game
  drawcontrols, wait.controls = true, true
  yield()

  drawcontrols, wait.controls = false, false

  init_tele_anim(player)
  yield()

  seraph.text = "i see a door. give me a minuteand i'll get it open."
  yield()

  fill_enemy_table(1, 65)
  spawn_time_start, timers["leveltimer"], wait.timer =  60, 60, true
  yield()

  kill_all_enemies(true)
  wait.timer = false
  seraph.text = "okay that should do...*static*incom-*static* b-*static*..."
  yield()

  init_tele_anim(boss(60, 60, 128, 1, 40))
  --music(3)
  yield()

  kill_all_enemies(true)
  seraph.text = "nice work. the door should be opened now."
  yield()

  wait.controls,level_change,open_door = true,true,true
  yield()

  wait.controls = false
  yield()

  --start level 2
  wait.controls = true
  seraph.text = "welcome to the planet heclao, suppose to be our home away   from home."
  add(boss_table, boss(100, 56, 139, 2, 35))
  --music(5)
  yield()

  seraph.text = "unfortunately we weren't alone"
  yield()

  seraph.text = "oh, who is this little guy?   seems to be checking you out."
  yield()

  fill_enemy_table(2, 60)
  wait.controls,spawn_time_start = false,60
  yield()

  kill_all_enemies(true)
  level_change = true
  yield()

  -- start level 3
  open_door = false
  seraph.text = "so the main source of the     infestation is up here past   the desert."
  yield()

  fill_enemy_table(3, 90)
  spawn_time_start = 90
  init_tele_anim(boss(100, 60, 160, 3, 40))
  yield()

  kill_all_enemies(true)
  level_change = true
  yield()

  seraph.text = "ever since the cult moved intothe temple these creatures    have been pouring out of there."
  yield()

  seraph.text = "i'm pretty certain that they  are trying to summon some kindof monster."
  yield()

  -- start level 4
  fill_enemy_table(4, 90)
  spawn_time_start,detect_killed_enemies = 90, true
  -- music(7)
  yield()

  kill_all_enemies(true)
  init_tele_anim(boss(60, 60, 128, 1, 40))
  init_tele_anim(boss(60, 20, 139, 2.5, 40))
  yield()

  seraph.text = "almost there, be careful goingin the temple. no idea what's in there."
  yield()

  kill_all_enemies(true)
  level_change = true
  yield()

  -- start level 5 (aoe boss)
  fill_enemy_table(3, 75)
  spawn_time_start,detect_killed_enemies = 75, true
  --music(9)
  yield()

  init_tele_anim(boss(56, 52, 164, 4, 40))
  yield()

  kill_all_enemies(true)
  level_change = true
  yield()

  -- start level 6 "final" boss
  fill_enemy_table(3, 75)
  spawntime_start,detect_killed_enemies = 75, true
  yield()

  seraph.text = "this is it. moment of truth.  i'm certain you will be no    problem for it."
  yield()

  kill_all_enemies(true)
  init_tele_anim(boss(50, 50, 169, 6, 50))
  yield()

  level_change = true
  yield()

  --start level 7 final boss
  seraph.text = "you fool! do you understand   how long it took us to summon that thing?"
  yield()

  seraph.text = "no matter. we'll just use yourbody to summon it again."
  yield()

  seraph.text = "to be continued..."
  yield()

  player_health = 0

  -- boss(50, 100, 5, 10, 50)
end

-- http://lua-users.org/wiki/simpleround
function round(num, numdecimalplaces)
  local mult = 10^(numdecimalplaces or 0)
  return flr(num * mult + 0.5) / mult
end
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
        if 0 < nx and nx < map.x and 0 < ny and ny < map.y and not bump_all(nx, ny) and not bump(nx, ny, 2) then
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
  return ((atan2((ty - fy), (tx - fx)) * 360) + 180)%360
end

function delete_offscreen(list, obj)
  if (obj.x < 0 or obj.y < 0 or obj.x > 128 or obj.y > 128) del(list, obj)
end

function continuebuttons()
  if ((btnp(4) or btnp(5) or stat(34) == 1) and timers["firerate"] == 0) timers["firerate"] = 1; return true
  return false
end

function bump(x, y, flag)
  return fget(mget(flr((x - level_sx + (level_x*8)) / 8), flr((y - level_sy + (level_y*8)) / 8)), (flag or 0))
end

function bump_all(x, y)
  return bump(x, y) or bump(x + 7, y) or bump(x, y + 7) or bump(x + 7, y + 7)
end

function ent_collide(firstent, secondent)
  offset = (firstent == player) and 4 or 0
  return (firstent.x + offset > secondent.x + level_sx + secondent.size or firstent.x + offset + firstent.size < secondent.x + level_sx
    or firstent.y + offset > secondent.y + secondent.size or firstent.y + offset + firstent.size < secondent.y) == false
end


--====================== object-like structures ==============================--
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
  e.x, e.y, e.time, e.b_count =  x, y, time_spwn, 0
  e.destroy_anim_length, e.destroyed_step, e.drop_prob, e.shoot_distance = 15, 0, 15, 50
  e.destroy_sequence = {135, 136, 135}
  e.walking = {132, 134, 137}
  e.drops = {32, 33, 48, 49} -- sprites of drops
  e.explode_distance, e.explode_wait, e.explode_step, e.fire_rate = 15, 15, 0, 20
  e.exploding, e.dont_move, e.size, e.sprite, e.type = false, false, 8, 132, type
  e.speed = type == "exploder" and .9 or .35

  e.update_xy = function()
                    path = minimum_neighbor(e, player)
                    e.x = e.x + ((e.x-path.x)*e.speed)*(0xffff)
                    e.y = e.y + ((e.y-path.y)*e.speed)*(0xffff)
                end
  e.move = function()
                if e.type == "shooter" then
                  if distance(e, player) >= e.shoot_distance then
                    e.update_xy()
                    e.dont_move = false
                  else
                    e.angle = angle_btwn(player.x+5, player.y+5, e.x, e.y)
                    e.b_count += 1; e.dont_move = true
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

function bullet(startx, starty, angle, sprite, friendly, shotgun, sine)
  local b = {}
  b.x, b.y, b.angle, b.sprite, b.friendly, b.duration = startx, starty, angle, sprite, friendly, 15
  b.shotgun, b.speed, b.acceleration, b.current_step, b.max_anim_steps, b.rocket, b.size = (shotgun or false), 2, 0, 0, 5, false, 8

  if (b.sprite == 48) b.acceleration, b.max_anim_steps, b.rocket = 0.5, 15, true

  b.move = function()
     if (b.sprite == 48) b.acceleration += 0.5
     if (b.shotgun) b.duration -= 1
     if (sine) b.speed = .5
     b.y = b.y - (b.speed+b.acceleration) * cos(b.angle / 360)
     if (sine) b.x -= sin(time()*5)*5*sin(b.x*.5*3.14); return
     b.x = b.x - (b.speed+b.acceleration) * sin(b.angle / 360)
   end

  return b
end

function boss(startx, starty, sprite, lvl, hp)
  local b = {}
  b.x, b.y, b.speed, b.angle, b.level, b.shot_last, b.shot_ang, b.sprite, b.idx, b.b_count = startx, starty, .01, 0, lvl, nil, 0, sprite, 2, 0
  b.size, b.bullet_speed, b.fire_rate, b.destroyed_step, b.destroy_anim_length, b.health, b.full_health = 16, 2, 7, 0, 30, (hp or 50), (hp or 50)
  b.destroy_sequence = {135, 136, 135}
  b.circs = {}
  timers["bossstart"] = (lvl == 6) and 12 or 1000
  rev = 1
  b.draw_healthbar = function()
             --health bar
             if (b.sprite == 128 or 139) xoffset = 1
             rectfill(b.x + xoffset, b.y - 3, b.x + xoffset + 12, b.y - 3, 14)
             rectfill(b.x + xoffset, b.y - 3, b.x + xoffset + flr(12 * (b.health / b.full_health)), b.y - 3, 8)
           end
  b.update = function()
           local p_ang = angle_btwn(player.x, player.y, b.x, b.y)
           if b.level == 1 then
             if (flr(timers["bossstart"])%10 == 0) rev*=-1; timers["bossstart"] = 100
             b.angle = (b.angle+1)%360
             for i=1,360,90 do
               if (b.angle%b.fire_rate == 0) shoot(b.x, b.y, i+(rev*b.angle), 141, false, true)
             end
           elseif b.level < 3 then
             if (#enemy_spawned == 0 and #enemy_table == 0 and not wait.controls) b.level = 2.5
             if b.level==2.5 or b.shot_last ~= nil and ((time() - b.shot_last) < 2) then
               if flr(time()*50)%b.fire_rate == 0 then
                 shoot(b.x, b.y, p_ang, 141, false, true)
                 b.x = b.x - 2*sin(p_ang/360)
                 b.y = b.y - 2*cos(p_ang/360)
               end
             end
           elseif b.level == 3 then
             if #enemy_spawned > 0 or #enemy_table > 0 then
              local ang = (360/(timers["bossstart"]/50))*(10%(timers["bossstart"]/50))
              if (timers["bossstart"] <= 900) timers["bossstart"] = 1000
              b.x = 60 - 55*cos(ang)
              b.y = 60 - 55*sin(ang)
              line((b.x-8*sin(p_ang/360)+8),(b.y-8*cos(p_ang/360)+8),((b.x+8)-(30*sin(p_ang/360))),((b.y+8)-(30*cos(p_ang/360))),10)
              if (distance(player, b) <= 30+8) shoot(b.x, b.y, p_ang, 141, false, true)
            else
              b.angle = (b.angle+6)%360
              b.fire_rate = 5
              b.b_count += 1
              b.x = 60
              b.y = 60
              for i=1,360,180 do
                if (b.b_count%b.fire_rate == 0) shoot(b.x, b.y, i+b.angle+(time()*2), 141, false, true)
              end
              if (b.b_count%(b.fire_rate+15)==0) for i=0,360,180 do shoot(b.x, b.y, i, 76, false, true, false, true) end
            end
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
                      player_hit(1)
                   end
                   del(b.circs, c)
                 end
               end
             end
             local locs = {0,100,100,0}
             if (timers["bossstart"]%20 == 0) b.x, b.y = 10+locs[b.idx%#locs+1], 10+locs[(b.idx-1)%#locs+1]; b.idx+=1; timers["bossstart"]=100
           elseif b.level == 6 then
             b.x = b.x + .01*((b.x > 8 and b.x < 112) and sin(p_ang/360) or 0)
             b.y = b.y + .01*((b.y > 8 and b.y < 112) and cos(p_ang/360) or 0)
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
           elseif b.level == 10 then
             b.x = player.x+50*sin(p_ang/360)
             b.y = player.y+50*cos(p_ang/360)
             if (timers["firerate"] > 0 and flr(time()*50)%b.fire_rate == 0) shoot(b.x, b.y, p_ang, 34, false, true)
           end
           b.draw_healthbar()
          end
  return b
end


--========================== draw functions ==================================--
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
 clr=(s==5) and 7 or 0
 for ix=0,sw-1 do
  for iy=0,sh-1 do
   dx=ix-x0
   dy=iy-y0
   xx=flr(dx*ca-dy*sa+x0)
   yy=flr(dx*sa+dy*ca+y0)
   if (xx>=0 and xx<sw and yy>=0 and yy<=sh) then
    if sget(sx+xx, sy+yy) == clr then
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
  print("press left click to start", hcenter(25), 100, flr(time())%15+1)
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
  if (seraph.step < #d) wait.dialog_finish = false

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
  rectfill(124+level_sx-((level_lvl-1)*128), 71+level_sy, 131+level_sx-((level_lvl-1)*128), 71-doorh+level_sy, 13)
  rectfill(124+level_sx-((level_lvl-1)*128), 72+level_sy, 131+level_sx-((level_lvl-1)*128), 72+doorh+level_sy, 13)
  if (doorh < 13) then
    doorh += 0.5
  elseif doorh == 13 then
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
          player_hit(1)
        else
          player_shield -= .15
        end
      end

      if e.type == "shooter" then
        pal(2,1,0)
        pal(5,13,0)
      elseif e.type == "exploder" and not e.exploding then
        pal(8,10,0)
        pal(2,8,0)
        pal(5,9,0)
      end

      if e.exploding and flr(time()*500)%2==0 then
        pal()
        pal(2,8,0)
      end
      if (not e.dont_move) then spr(e.walking[flr(time()*5)%#e.walking+1], e.x, e.y) else spr(e.sprite, e.x, e.y) end
      pal()

      if (e.explode_step == e.explode_wait) add(destroyed_enemies, e); del(enemy_spawned, e)

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
        player_shield = 5 --player_shield_dur
        sfx(6)
        del(dropped, d)
      elseif d.type ~= "heart" and #player_inventory < 4 --[[player_inv_max]] then
        add(player_inventory, d)
        if (#player_inventory < 4) timers["showinv"] = .5
        sfx(19)
        del(dropped, d)
      end
    end

    if (d.type == "shotgun" and (pget(d.x+2, d.y+4) == 4 or pget(d.x+3, d.y+4) == 4)) pal(4,0,0)
    if (d.type == "shield" and (pget(d.x+4,d.y+7) == 9 or pget(d.x, d.y) == 9)) pal(9,12,0)

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

    if bump_all(b.x, b.y) then
      del(player_bullets, b)
      add(boss_hit_anims, b)
      if (b.rocket) rocket_kill(b)
      return
    end

    spr_r(b.sprite, b.x, b.y, b.angle, 1, 1)
    b.move()
    if (b.duration <= 0) del(player_bullets, b); return

    for bos in all(boss_table) do
      if ent_collide(bos, b) then
        sfx(23,1)
        bos.health -= ((b.sprite == 48) and 3 or 1)
        bos.shot_last = time()
        bos.shot_ang = angle_btwn(player.x+5, player.y+5, bos.x, bos.y)
        del(player_bullets, b)
        add(boss_hit_anims, b)
        if (b.rocket) rocket_kill(b)
        if bos.health <= 0 then
          sfx(22,1)
          add(destroyed_bosses, bos)
          player_killed += 1
          del(boss_table, bos)
          if (level_lvl == 5) then coin.x, coin.y = 50, 100
          else coin.x,coin.y = bos.x,bos.y end
          if (#boss_table == 0) coresume(game)
        end
        break
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
          player_hit(1)
        else
          add(shield_anims, {b.x, b.y, 10})
          player_shield = player_shield - .15
        end
      end
      del(enemy_bullets, b)
      return
    end

    spr(b.sprite, b.x, b.y)
    b.move()
    if (bump(b.x, b.y)) del(enemy_bullets, b); add(boss_hit_anims, b)
  end
end

function show_leaderboard()
  rectfill(0,0,128,128,0)
  print("you died",hcenter(8), 55, 8)
  --k = min(player_killed, k+0.5)
  if (k<player_killed-1) k += 0.5
  local t = "killed: "..flr(k)
  print(t, hcenter(#t), 63, 5)
  print("press \x8e/\x97 to start over", 20, 100, flr(time()*5)%15+1)
  if (flr(k)==player_killed-1) timers["invalid"] = 0.5; k+=1
  if (timers["invalid"] > 0) camera(cos((time()*1000)/3), cos((time()*1000)/2))
end

--======================= animation functions ================================--
--[[
    draw enemy destruction animation to screen
  ]]
function step_destroy_animation(e)
  if e.destroyed_step <= e.destroy_anim_length then
    spr(e.destroy_sequence[flr(e.destroyed_step/15)+1], e.x, e.y)
    if e.type == "exploder" then
      circ(e.x+4, e.y+4, e.destroyed_step%15, 8)
      if e.destroyed_step >= e.destroy_anim_length then
        del(destroyed_enemies, e)
        del(enemy_spawned, e)
        if distance(e, player) <= 15 and timers["playerlasthit"] == 0 then
          if player_shield <= 0 then
            player_hit(1)
          else
            player_shield -= .15
          end
        end
      end
    end
  else
    drop_item(e)
    del(destroyed_enemies, e)
  end
  circ(e.x+4, e.y+4, e.destroyed_step%5, 8)
  e.destroyed_step += 1
end

function boss_hit_animation(bul)
  local colors = {8, 9}

  if bul.current_step <= bul.max_anim_steps then
    local c = colors[flr(time()*100)%(#colors) + 1]
    local r = sgn(sin(rnd(10)))
    -- if (rnd(1) > .5) r = 0xffff
    if (not bul.rocket) then
      circ(bul.x, bul.y, flr(time()*100)%4, c)
    else
      for i=1,3 do
        circfill((r*rnd(bul.max_anim_steps/2))+bul.x, r*rnd(bul.max_anim_steps/2)+bul.y, rnd(4), c)
        circfill((r*rnd(bul.max_anim_steps))+bul.x, r*rnd(bul.max_anim_steps)+bul.y, .1, c)
      end
      circ(bul.x, bul.y, bul.current_step, c)
    end
  else
    del(boss_hit_anims, bul)
  end

  bul.current_step += 1
end

function step_boss_destroyed_animation(b)
  if (b.destroyed_step <= b.destroy_anim_length) then
    for i=1,3 do
      spr(b.destroy_sequence[flr(b.destroyed_step/30)+1], b.x+sgn(sin(rnd(10)))*flr(rnd(8)), b.y+sgn(sin(rnd(10)))*flr(rnd(8)))
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
      if (not fget(mget(i+level_x-(level_sx/8), j+level_y-(level_sy/8)),7) and fget(mget(i+level_x-(level_sx/8), j+level_y-(level_sy/8)),1) and rnd(10) > 9.5) add(water_anim_list, {i*8+rnd(4),j*8+rnd(4), flr(rnd(3)), 7, 25});
    end
  end
end


--================================ functions =================================--
function shoot(x, y, a, spr, friendly, boss, shotgun, sine)
  if (boss) sfx(2)
  if friendly then
    local offx, offy = (player.x + 5), (player.y + 5)
    local ang = angle_btwn((stat(32) - 3), (stat(33) - 3), offx, offy)
    offx, offy = (offx - 8*sin(ang / 360)), (offy - 8*cos(ang / 360))
    for i=(shotgun and 0xffff or 0),(shotgun and 1 or 0),1 do
      add(player_bullets, bullet(offx, offy, ang+(i*30), spr, friendly, shotgun))
    end
  elseif boss then
    -- if (spr == 2) for i=0xffff,1,2 do add(enemy_bullets, bullet((x-sin(a/360)),(y-cos(a/360)),a,spr,friendly)) end; return
    add(enemy_bullets, bullet(((x + 5) - 16*sin(a / 360)), ((y + 5) - 16*cos(a / 360)), a, spr, friendly, shotgun, sine))
  else
    add(enemy_bullets, bullet((x - 8*sin(a / 360)), (y - 8*cos(a / 360)), a, spr, friendly))
  end
end

function skill_tree()
  skills_selected[currently_selected] = false
  local diff = 0
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
        player_max_health += 1
        player_health += 1
        player_tokens -= next_cost[currently_selected]
        next_cost[currently_selected] += 1
        sfx(0)
    elseif (selection_set[currently_selected] == "fire rate" and player_tokens >= next_cost[currently_selected]) then
        player_fire_rate = max(.1, player_fire_rate-.15)
        player_tokens -= next_cost[currently_selected]
        next_cost[currently_selected] += 1
        sfx(0)
    elseif (selection_set[currently_selected] == "speed" and player_tokens >= next_cost[currently_selected]) then
        player_speed += .2
        player_tokens -= next_cost[currently_selected]
        next_cost[currently_selected] += 1
        sfx(0)
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

function fill_enemy_table(level, lvl_timer)
  local types = {"basic", "shooter", "exploder"}
  local baseline = 20
  for i=1,(baseline*level) do
    add(enemy_table, enemy(flr(rnd(120)), flr(rnd(120)), types[flr(rnd(level))%#types+1], flr(rnd(lvl_timer))))
  end
end

function spawnenemies()
  if (#enemy_table == 0) timers["spawn"] = 0; return
  if (timers["spawn"] == 0) timers["spawn"] = spawn_time_start
  for enemy in all(enemy_table) do
    if spawn_time_start - timers["spawn"] >= enemy.time then
      repeat
        enemy.x,enemy.y = flr(rnd(120)), flr(rnd(120))
      until (distance(player, enemy) > 50 and not bump_all(enemy.x, enemy.y) and not bump(enemy.x, enemy.y, 2) and not bump(enemy.x, enemy.y, 2))

      add(enemy_spawned, enemy)
      del(enemy_table, enemy)
    end
  end
end

function detect_kill_enemies()
  if #enemy_spawned == 0 and #enemy_table == 0 then
    detect_killed_enemies = false
    coresume(game)
  end
end

function kill_all_enemies(no_drop_items)
  for e in all(enemy_spawned) do
    if (no_drop_items) e.drop_prob = 0
    del(enemy_spawned, e)
    add(destroyed_enemies, e)
  end

  for b in all(boss_table) do
    del(boss_table, b)
    add(destroyed_bosses, b)
    if (level_lvl == 5) then coin.x, coin.y = 100, 50
    else coin.x,coin.y = b.x,b.y end
    b = nil
  end

  enemy_table = {}
end

function levelchange()
  local farx = 100
  local previoussx = level_sx

  level_i = 3*level_lvl+1
  if (level_transition[level_i] == level_lvl+1 and (level_transition[level_i+1] - 12) * 8 < abs(level_sx - level_x * 8)) move_map = true

  --todo add map centering on player in the beginning
  -- if (bump(player.x + 3, player.y + 4) or bump(player.x + 3, player.y + 11)) player.x = previousx
  -- if (bump(player.x + 12, player.y + 4) or bump(player.x + 12, player.y + 11)) player.x = previousx
  if not move_map then
    if btn(0) and abs(level_sx - level_x * 8) > level_x*8 and player.x < farx then
      level_sx += move
      if player.x < farx then player.x = farx end
      if (bump(player.x + 3, player.y + 4, 3) or bump(player.x + 3, player.y + 11, 3)) level_sx = (previoussx%8)-2
      if (bump(player.x + 3, player.y + 4) or bump(player.x + 3, player.y + 11)) level_sx = previoussx
    end
    if btn(1) --[[and level_sx - ((level_lvl-1) * 128) <= (level_transition[level_i+1])*8]]  and player.x > farx then
      level_sx -= move
      if player.x > farx then player.x = farx end

      if (bump(player.x + 12, player.y + 4) or bump(player.x + 12, player.y + 11)) level_sx = previoussx
    end
  end

  if move_map ~= nil and move_map then
    wait.controls = true

    if level_transition[level_i+1]*8 > abs(level_sx - level_x * 8) then
      level_sx = flr(level_sx) - 1
      player.x -= 1

    --[[elseif check we go down then]]

    else
      dropped = {}
      level_sprites = {}
      --open_door = false
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

-- function collide_all_enemies()
--   local e = enemy_spawned[1]
--   for o in all(enemy_spawned) do
--     if (o~=e and ent_collide(e, o)) fix_enemy(o, e)
--   end
-- end

-- function fix_enemy(o, e)
--   local function fix_coord(o,e,c)
--     if (o[c] - e[c]) < 0 then
--       o[c] = o[c] - 8
--     elseif (o[c] - e[c]) > 0 then
--       o[c] = o[c] + 8
--     elseif (o[c] == e[c]) then
--       o[c] = o[c] + 8
--     end
--   end
--   fix_coord(o,e,'x')
--   fix_coord(o,e,'y')
-- end

function player_hit(d)
  player_health -= d
  sfx(18)
  timers["playerlasthit"] = 2
end
---------------------------------- constructor ---------------------------------
function _init()
  k=0
  poke(0x5f2d, 1)

  title.init = time()

  game = cocreate(gameflow)
  coresume(game)
end --end _init()


--================================ update ====================================--
function _update()
  --timers["playerlasthit"] = 1 --uncomment for god mode
  -- collide_all_enemies()

  local previousx, previousy = player.x, player.y
  move = (bump(player.x + 4, player.y + 4, 1) or bump(player.x + 11, player.y + 11, 1)) and player_speed/2 or player_speed
  if ((bump(player.x + 4, player.y + 4, 2) or bump(player.x + 11, player.y + 11, 2)) and timers["playerlasthit"] == 0) player_hit(1)

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
      timers["rightclick"] = 1 -- player_power_fire_rate

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
        timers["showinv2"] = 1.2 --player_power_fire_rate + 0.2
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
      if (bump(player.x + 3, player.y + 4, 3) or bump(player.x + 3, player.y + 11, 3)) player.x -= previousx%8
    end

    --========================
    --right button------------
    --========================
    if btn(1) then
      player.x += move
      add(moves, {player.x, player.y})
      if (bump(player.x + 12, player.y + 4) or bump(player.x + 12, player.y + 11)) player.x = previousx
      if (bump(player.x + 12, player.y + 4, 3) or bump(player.x + 12, player.y + 11, 3)) player.x += min(move, previousx%8-2)
    end

    --========================================================================--
    player_angle = flr(atan2(stat(32) - (player.x + 8), stat(33) - (player.y + 8)) * -360 + 90) % 360

    if (player.x < -2) player.x = -2
    if (player.y < -2) player.y = -2
    if (player.x > 107) player.x = 107
    if (player.y > 112) player.y = 112

    if (not wait.controls or seraph.text == nil) player_shield = max(player_shield - .01,0)

    spawnenemies()
    if (detect_killed_enemies) detect_kill_enemies()

  else

    timers["playerlasthit"] = 0x.0001 --make player invulnerable so they dont get hit when they can't move
  end -- end wait.controls

  --========================
  --x button----------------
  --========================
  -- if btnp(5) and not level_change then
  --   for t in all(tele_animation) do
  --     t.anim_step = t.anim_length
  --   end
  --   --seraph = {}
  --   wait.dialog_finish = false
  --   if (seraph.text == nil) kill_all_enemies(true)
  --   coresume(game)
  -- elseif level_change then
  --   kill_all_enemies(true)
  -- end
end


--------------------------------------------------------------------------------
--------------------------------- draw buffer ----------------------------------
--------------------------------------------------------------------------------
function _draw()
  cls()

  if (in_leaderboard) show_leaderboard(); return

  map(level_x, level_y, level_sx, level_sy, 128, 128)
  if (rnd(10) > 9.5 and not level_change) water_anim()
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
  end

  if (level_lvl == 1 and #boss_table == 0) spr(139, 228+level_sx, 56, 2, 2)
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
    if (timers["playerlasthit"] == 0 and ent_collide(player, b)) player_hit(2) --player_health -= 2; sfx(18); timers["playerlasthit"] = 2 -- player_immune_time
    if (b.level ~= 3 and b.level ~= 10) then spr(b.sprite, b.x, b.y, 2, 2)
    elseif b.level == 10 then spr_r(b.sprite, b.x, b.y, angle_btwn(player.x, player.y, b.x, b.y), 2, 2)
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
     end
  end

  if (seraph.text ~= nil) draw_dialog()

  if (timers["playerlasthit"] > 1.5) or (timers["invalid"] > 0) then
    camera(cos((time()*1000)/3), cos((time()*1000)/2))
  else
    camera()
  end

  if (in_skilltree) skilltree()

  --debug() -- always on bottom
end

__gfx__
0000000000000000000000000000000000000000777777777777777700000000000000007666666705622222dddddddddddddd667666888876666667ffffffff
0000000000000000000000000000000000000000777777777777777700000000000000006555555105622222dddddddddddddd6b6555822265555551ffffffff
000000000000000000000000000000000000000077777777777777770000000000000000655555510562222222222222dddddd6b6555822265555551ffffffff
0000000000000000000000000000000000000000777707777770777700000000000000006552d5510562222222222222dddddd666555888865555551ffffffff
000060000006000000000000000000000000000077770777777077770000000000000000655d25510562222222222222dddddd666555888865555551ffffffff
0000660cc06600000000000000000000000000007077077dd77077070000000000000000056ddddd0562222222222222dddddd6b6555822266666666ff366666
00006619916600000000000000000000000000007077072dd27077070000000000000000056ddddd0562222222222222dddddd6b6555822266666666f3336666
00006619916600000000000000000000000000007077072dd27070070000000000000000056ddddd0562222222222222dddddd66d11188886666666633033666
00006619916600000000000000000000000000007007002dd20070070000000000000000656222220562222222222222dddddd66222222226666666630003666
000000511500000000000000000000000000000070070029920070070000000005555555576222220562222222222222dddddd6b222222223333333330003666
000000011000000000000000000000000000000070070029920070070000000005666666666222220562222222222222dddddd6b222222226666666630003666
000000000000000000000000000000000000000070000029920000070000000005622222222222220562222222222222dddddd66222222223333333330003666
000000000000000000000000000000000000000077777702207777770000000005622222222222220562222222222222dddddd66222222226666666630003666
000000000000000000000000000000000000000077777772277777770000000005622222222222220566666666622222dddddd6b222222223333333330003666
000000000000000000000000000000000000000077777727727777770000000005622222222222220655555557622222dddddd6b222222226666666630003666
000000000000000000000000000000000000000077777277772777770000000005622222222222225000000065622222dddddd66222222226666666630003666
00000000000000000000000000000000000000007777777777777777000000007765000076666661166666677666666666666667766111157666666730003666
0ee00ee0000000000000000000000000000000000000000000000000000000007b650000677777122177777d6555555555555551600000006555555130003666
e88ee88e000000000000000000000000000000000000000000000000000000007b650000677771222217777d6555555555555551600000006555555330003666
e888888e666666600a0000a0000000000000000000000000000000000000000077650000677712222221777d6555555555555551600000006555555663303666
e888888e044004400a0000a0000000000000000000000000000000000000000077650000677122222222177d6555555555555551600000006555553330003666
0e8888e0000000440000000000000000000000000000000000000000000000007b650000671222222222217d6555555555555551600000006555556663303666
00e88e00000000000000000000000000000000000000000000000000000000007b650000612222222222221d6555555555555551600000006555533330003666
000ee00000000000000000000000000000000000000000000000000000000000776555551222222222222221655555555555555150000000d111166663303666
00088000990000990000000000000000000000000000000000000000000000007765555512222222222222216555555555555551000036667111111500003666
00066000967766690000000000000000000000000000000000000000000000007b650000612222222222221d6555555555555551000036666000000000033333
00066000976666690000000000000000000000000000000000000000000000007b650000671222222222217d6555555555555551000036666000000000066666
000660009666665900000000000000000000000000000000000000000000000077650000677122222222177d6555555555555551000036666000000000333333
000660000966669000000000000000000000000000000000000000000000000077650000677712222221777d6555555555555551000036666000000000666666
00866800096665900000000000000000000000000000000000000000000000007b650000677771222217777d6555555555555551000036666000000003333333
08866880009559000000000000000000000000000000000000000000000000007b650000677777122177777d6555555555555551000036666000000006666666
0000000000099000000000000000000000000000000000000000000000000000776500007dddddd11dddddddd11111111111111d00003666d100000006666666
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088880000000000ffffffff44444444
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000822228000000000f44f444f44464444
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000082288228000000004444446444444464
00000aaaaaa00000000000aaaa000000000000aaa0000000000000aaaa00000000000aaaaaa00000000000000000000082822828000000004444444444444444
0000a999999a000000000a9999a00000000000a9a000000000000a9999a000000000a999999a0000000000000000000082822828000000004464444444644444
000a9979a999a0000000a9979a9a0000000000a9a00000000000a999999a0000000a99999999a000000000000000000082288228000000004444464444444644
000a979aaa99a0000000a979aa9a0000000000a9a00000000000a999999a0000000a99999999a0000000000000000000082222800000000046444444f644f4f4
000a979a9999a0000000a979a99a0000000000a9a00000000000a999999a0000000a99999999a0000000000000000000008888000000000044444444ffffffff
000a979aaa99a0000000a979aa9a0000000000a9a00000000000a999999a0000000a99999999a00000000000000000000000000000000000ffcccccccccccccc
000a99999a99a0000000a9799a9a0000000000a9a00000000000a999999a0000000a99999999a00000000000000000000000000000000000ffccc55555555555
000a999aaa99a0000000a999aa9a0000000000a9a00000000000a999999a0000000a99999999a00000000000000000000000000000000000ff55556666666666
0000a999a99a000000000a999aa00000000000a9a000000000000a9999a000000000a999999a0000000000000000000000000000000000005556676666666666
00000aaaaaa00000000000aaaa000000000000aaa0000000000000aaaa00000000000aaaaaa00000000000000000000000000000000000006676676666662d66
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000667667666666d266
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f676676666662d66
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f67667666666d266
00080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccccfff676676666666666
000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005555ccfff676676666666666
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006665555f6676675555555555
88080880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666766556675555555555555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000666766765555551111111111
0008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066676676555ccccccccccccc
000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006667667ffccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000066676676ffcccccccccccccc
66000066000000000000000033333333444444443333333344444444444444443333333399999999444444449999999944444444444444449999999966676676
60000006000000000000000034434443444544444333333344454444444544443343444394494449444f444449999999444f4444444f4444994944496667667f
000000000000000000000000444444544444445444333333344444544444445333344454444444f4444444f444999999944444f4444444f9999444f455576676
00000000000000000000000044444444444444444444343334444444444444433344444444444444444444444444949994444444444444499944444455555576
00000000000000000000000044544444445444444454443333543444445443433454444444f4444444f4444444f4449999f4944444f4494994f4444411555555
00000000000000000000000044444544444445444444454333434544444445333444454444444f4444444f4444444f4999494f4444444f9994444f44ccccc555
6000000600000000000000004544444435443434454434433533343335443433354444444f4444449f4494944f4494499f9994999f4494999f444444cccccccc
660000660000000000000000444444443333333344444444333333333333333344444444444444449999999944444444999999999999999944444444cccccccc
0300000000000300000a000000000000200000020000000020000002000000009090090920000002000000000c0000111000000c000700000000000000000000
00300000000030000009000000000000020220200000000002022020000990000909909002022020000000000110011111000011007670000002200000000000
0003000000030000000a00000000000002222220008880000222222000999900009aa90002222220000000000011011111000110076167000026620000000000
00025555503000000a9a9a0000000000025555200082800002555520099aa99009aaaa9002555520000000000001111111111100761116700026620000000000
0003885883200000000a000000000000028558200088800002855820099aa99009aaaa9002855820000000001111551515511110076167000002200000000000
0333553553333000000900000000000002055020000000000205502000999900009aa90002055020000000001001885158810010007670000000000000000000
3003333333000300000a000000000000202002020000000020200202000990000909909020200202000000001001555155510011000700000000000000000000
00303030303000300000000000000000202002020000000000200002000000009090090920000200000000001101111111110001000000000000000000000000
20303030300300000000000000000000000000000000000000000000000000000000000000000000000000000101000100010001000000000000000000000000
33030030030300200000000000000000000000000000000000000000000000000000000000000000000000001101000100010011000000000000000000000000
20003000300032000000000000000000000000000000000000000000000000000000000000000000000000001001000c00010010000000000000000000000000
00003000300020000000000000000000000000000000000000000000000000000000000000000000000000001011000000010010000000000000000000000000
00020000020002000000000000000000000000000000000000000000000000000000000000000000000000001010000000110010000000000000000000000000
0020000000200000000000000000000000000000000000000000000000000000000000000000000000000000c0110000001000c0000000000000000000000000
02000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000c0000c000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00555500000000009000000900000000000000000000000000000000000000000000000000808000008080000000000000000000777777777777777700000000
05dddd500000000090088009000000000000a000000a000000000200002000000000000000d0ddd8ddd0d0000002220000000000777777777777777700000000
58855885000000009008800900000000000040000004000000020200002020000000000000ddd88d88ddd000002ddd2000000000777777777777777700000000
05d55d5000000000099889900000000000004400004400000002002002002000c000000000000ddddd00000002dd2dd200000000777707777770777700000000
0055550000000000009889000000000000040400004040000000202002020000cccccccc6000dd8d8dd00060002d2d2000000000777707777770777700000000
000dd00000000000009889000000000000a0040440400a0000002022220200000000000c060800d8d008060002dd2dd2000000000777077dd770777000000000
0005500000000000000990000000000000000444444000000000221111220000000000000060000d00006000002ddd20000000000777072dd270777000000000
000550000000000000099000000000000000044444400000002028822882020000000000060000ddd000060000022200000000000777072dd270770000000000
0000000000000000000000000000000000999884488999900d020212212020d00000000060000ddddd00006000000000000000000077002dd200770000000000
0000000000000000000000000000000000a00944449000a00000202222020000000000000000d00d00d000000000000000000000007700299200770000000000
000000000000000000000000000000000000099449900000000200011000200000000000000800ddd00800000000000000000000007700299200770000000000
000000000000000000000000000000000000990990990000002000022000020000000000006000d8d00060000000000000000000000000299200000000000000
000000000000000000000000000000000009090000909000000d00222200d000000000000600000d000006000000000000000000777777022077777700000000
000000000000000000000000000000000090090000900900000002000020000000000000000060ddd06000000000000000000000777777722777777700000000
0000000000000000000000000000000000a0090000900a0000000200002000000000000000060dd8dd0600000000000000000000777777277277777700000000
0000000000000000000000000000000000000a0000a0000000000000000000000000000066600d0d0d0066600000000000000000777772777727777700000000
766666673333333366666666cccccccfffccccccffcccccccccccccffccccccc76666667ccccccffcccccccc55555555633333339ddddddd5555555995555555
655555513333333366666666cccccccfffccccccffccccccccccccff6ccccccc65555551ccccccffcccccccc55555555633333339ddddddd5555559dd9555555
655555513333333366666666cccccccfffccccccffccccccccccccfffccccccc65555551cccccccfcccccccc55555555633333339ddddddd555559dddd955555
6552d5513333b33366666666ccccccf6f6ccccccf6fcccccccccccfffccccccc6552d551ccccccc6cccccccc55555555633333339ddddddd55559dddddd95555
655d255133b3b3b366666666ccccccffffccccccfffcccccccccccff6fcccccc655d2551cccccccfcccccccc55555555633333339ddddddd5559dddddddd9555
655555513333333366666666cccccc6ff6fcccccffccccccccccccfffffcccccddddddddccccccffcccccccc55555555633333339ddddddd559dddddddddd955
655555513333333366666666ccff6fffffffffcc6fccccccccccccfff6ffccffddddddddcffcccffff6ccccc55555555633333339ddddddd59dddddddddddd95
d111111d3333333366666666fffffff336ff6ffffffcccccccccccff3fffff6fddddddddff6ffff3f6fff6ff55555555633333339ddddddd9dddddddddddddd9
44444444ffffffffffffffffffff6665ffffffffffffffffffffffff6655667700000000000056b7d666666dcccccccc33333333dddddddd9dddddddddddddd9
44454444ffffffffffffffffff656555ccffffffffffffff4ff4ffffb6566775000000000000567b66555567cccccccc33333333dddddddd59dddddddddddd95
44444454ffffffff6666666665656555cccfffffffffcccc4fffffffb6667755000000000000566665566557cccccccc33333333dddddddd559dddddddddd955
44444444655555516666666665656555ccccfffffffccccc444ff4ff6667755500000000000055556566d657cccccccc33333333dddddddd5559dddddddd9555
44544444655555516666666665656555ccccccfffffccccc4464ffff667755555555000000000000656d6657cccccccc33333333dddddddd55559dddddd95555
44444544655555516666666665656555ccccccffffcccccc4444ffffb6755555666500000000000065566557cccccccc33333333dddddddd555559dddd955555
45444444655555516666666665656555ccccccffffcccccc4644ffffb6755555b76500000000000066555567cccccccc33333333dddddddd5555559dd9555555
44444444d111111d6666666665656555ccccccffffcccccc44444fff667755557b65000000000000d777777dcccccccc33333333dddddddd5555555995555555
3393399333333339666666666565666576666665999999ff4444ffff667755557b650000fffff650000000009ddd888888885555dddddddd7777777700000000
3339333333339999666666666565655565555555999999ff44644fffb6755555b7650000fffff650000000009ddd822222285555dddddddd7bb77bb700000000
333939393393339966666666656565556555555599999fff44444fffb675555566650000fffff650000000009ddd822222285555dddddddd6666666600000000
3399333333333339666666666565655565555555999999ff444444ff6677555555550000fffff650000000009ddd888888885555dddddddd5555555500000000
33399393333399996666666665656555655555559999999f44644fff6667755500000000fffff650000055559ddd888888885555dddddddd0000000055555555
3399333333333399666666666565000000000000999999ff4444ffffb666775500000000fffff650000056669ddd822222285555dddddddd0000000066666666
33933393333393395555555565000000000000009999ffff46ffff4fb656677500000000fffff6500000567b9ddd822222285555dddddddd000000007bb77bb7
3339393933333999000000000000000000000000999999ffffffffff6655667700000000fffff650000056b79ddd888888885555999999990000000077777777
9999999999999999444444447666666776666665ffffffffffffffff9ddd776677665566dddddd6644444445ddddddddddddddd9999999990000567777650000
9999999999999999944944446555555165555555ffffffffffffffff59ddd76b5776656bdddddd6b44fff445d4444444ddddddd9dddddddd000056b77b650000
9999999999999999444444946555555165555555ffffffffffffffff559dd76b5577666bdddddd6b4f4f4f45d44fff44ddddddd9dddddddd000056b77b650000
999999999999a999449444446555555165555555ffffffffffffdfff5559776655577666dddddd664ff4ff45d4f4f4f4ddddddd9dddddddd0000567777650000
9999999999a9a9a9444449446555555165555555ffffffffffdfdfdf5557766655597766dddddd664f4f4f45d4ff4ff4ddddddd9dddddddd0000567777650000
9999999999999999494444446555555100000000ffffffffffffffff5577666b559dd76bdddddd6b44fff445d4f4f4f4ddddddd9dddddddd000056b77b650000
9999999999999999444449446555555100006555ffffffffffffffff5776656b59ddd76bdddddd6b44444445d44fff44ddddddd9dddddddd000056b77b650000
999999999999999944444444d111111d00656555ffffffffffffffff776655669ddd77669999996655555555d4444444ddddddd9dddddddd0000567777650000

__gff__
0000000000000101000001860000000000000000000000000101010100060000000000000001000001000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000082828282820082820000000000000000828280000101010102000000000000008200000001010101000000010100000000000000010100010100000101
__map__
eaefefefefefefefefefefefefefefd8fefafacbccc5dbdbdbdbdbdbdbdbdbc3dcc1dcdcdcdce1f0f0f0f0f0f0f0f0f0f0f0f0e5f5f5f5f5f5f5f5f5f5f5f5c5dbc6f5f5f5f5f5f5f50af31d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d3b3c3b3c3b3c3b3c3b3c3b3c3b3c3b3c1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d0000000000
fecbcbcbcbcbcbcbcbcbcbcbcbfafafffefafacbccc5dbdbdbdbdbdbdbdbc6dcdcdcdcdce1f0f0f0f0f1f0f0f0f0f1f0f0f0e5f5f5f5f5f6f5f5f5f5f5f5f5c5dbc6f5f6f5f5f5f5f50af31dc0c01d1d1df3f3f3f31d1d1dc0c01d2b2c2b2c2b2c2b2c2b2c2b2c2b2c2b2c1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d2b0000000000
fecbcbcbcbcbcbcbcbcbcbcbcbfafafffefafacbccc4dbdbdbdbdbdbdbdbc3dcdcdcdcdcdce1f0f0f0f0f0f0f0f0f0f0f0f0e5f5f5f5f5f5f5f5f5f6f5f5f5c5dbc6f5f5f5f5f5f5f50af31dc00b1df3f3f3f3f3f3f3f31d0bc01d3b3c3bdadada3b3c3b3c3b3c3b3c3b3c1d1d1d1d1d1d1d1d1d1d1d1d1d2b2c3b0000000000
fecbcbcbcefdfdcfcbcbcbcbcbcbcbfffefacbcbccdcc5dbdbdbdbdbdbc3c1dcdcdcdcdcdcdce1f0f0f0f0f0f1f0f0f0f0f0e5f5f5f5f5f5f5f5f5f5f5f5f5c5dbc6f5f5f5f5f5f5f50af31d0b1df32b2c2b2c2b2c2b2cf31d0b1d2b2c2bda2b2c2b2c2b2c2b2c2b2c2b2c1d1dc01dc01dc01d1d1d1d2b2c3b3c2b0000000000
fecbcbcbcdfbfbfccbcbcbcbcbcbcbfffecbcbcbccdcc4cacacacacac3dcdcdcc1dcdcdcdcdce1f0f0f1f0f0f0f0f0f0f0f0e5f5f5f6f5f5f5f5f5f5f5f5f5c5dbc6f6f5f5f5f5f51819f3f3f3f3f33b3c3b3c3b3c3b3cf3f3f3c0c03c3bda3b3c3b3c3b3c3b3c3b3c3bc0f3f3f3f3f3f3f3f3f32b2c3b3c2b2c3b0000000000
fecbcbcbdeddfbfccbcbcbcbcbcbcbfffecbcbcbccdcdcc1dcdcdcdcdcdcdcdcdcdcdcdcdce1f0f0f0f0f0f0f0f07e797bf0e5f5f5f5f5f5f5f6f5f5f5f6f5c5dbc6f5f5f5f5f5d3f3c0c02b2c2b2c2b2cc0f3f3c02b2c2b2c2b2cf3f32b2c2b2cc0c0c0c02b2c2b2cf3f3f32b2c2b2c2b2c2b2c3b3c2b2c3b3c2b0000000000
fecbcbcbcbcdfbfccbcbcbcbcbcbcbf8d7cbcbcbccdcdcdcdcdcc1dcdcdcc1dcdcdcc1dce1f0f0f0f0f0f0f0f07ef27af279794e4e4e4e4e4e4e4e4e4ed6f5c7dbdbd4f5f5f5d3f3f3c0f33b3c3b3c3b3cf30b0bf33b3c3b3c3b3cf3f33b3c3b3cc0292ac03b3c3b3cf3f3f33b3c3b3c3b3c3b3c2b2c3b3c2b2c3b0000000000
fecbcbcbcbdeeddfcbcbcbcbcbcbcbebeccbcbcbccdcdcdcdcdcdcdcdcdcdcdc7873737379797bf0f0f1f0f07ef27df07c7a7a7a4f4f4f4f4f4f4f4f4fe6f5f55e5f6df5f5d3f3f3f3f3f32b2c2b2c2b2cf31d1df32b2c2b2c2b2cf3f32b2c2b2cc0393ac02b2c2b2cf3f3f32b2c2b2c2b2c2b2c3b3c2b2c3b3c2b0000000000
fecbcbcbcbcbcbcbcbcbcbcbcbcbcbebeccbcbcb737375c1dcdcdcdcc1787373d07474747a7ad07979797979f27df0f0f0f0f0e5f5f5f5f5f5f5f5f5f5f5f6f56e6f7ff5f5e3f4f3f3f3f33b3c3b3c3b3cf31d1df33b3c3b3c3b3cf3f33b3c3b3cc0c0c0c03b3c3b3cf3f3f33b3c3b3c3b3c3b3c2b2c3b3c2b2c3b0000000000
fecbcbcefdfdfdcfcbcbcbcbcbcbcbebeccbcbcb7474d0737373737373d0747477dcdcdce1f07c7a7a7a7a7d7df0f0f0f0e5f5f5f5f5f5f5f5f5f5f5f5f5f5f5c5dbc6f5f5f5e3f4f3c0f32b2c2b2c2b2cc0f3f3c02b2c2b2c2b2cf3f32b2c2b2c2b2c2b2c2b2cda2cf3f3f32b2c2b2c2b2c2b2c3b3c2b2c3b3c2b0000000000
fecbcbcdddddddfccbcbcbcbcbcbcbebeccbcbcbccdc7674747474747477dcdcdcdcdcdce1f0f0f0f0f0f0f0f0f0f0f0f0f0e5f5f5f5f5f5f5f5f5f5f5f5f5f5c5dbc6f5f5f5f5e309c8c03b3c3b3c3b3c2b2c2b2c3b3c3b3c3b3cf3f33b3c3b3c3b3c3b3c3b3cda3cf3f3f33b3c3b3c3b3c3b3c2b2c3b3c2b2c3b0000000000
fecbcbcdfbddfbfccbcbcefdfdcfcbf7e7cbcbcbccdcc1dcdcdcdcdcdcdcdcc1dcdcdce1f0f0f0f0f0f0f1f0f0f1f0f0f0e5f5f5f5f5f5f5f5f5f5f5f5f5f5f5c5dbc6f5f5f5f5f51a1bf3f3f3f3f32b2c3b3c3b3c2b2cf3f3f3c0c02c2b2c2b2c2b2c2b2cdadada2c2bc0f3f3f3f3f3f3f3f3f33b3c2b2c3b3c2b0000000000
fecbcbcdfbfbddfccbcbcdfbfbfccbfffecbcbcbccdcdcdcdcdcdcdcc1dcdcdcdcdcc1dce1f0f0f0f0f0f0f0f0f0f0f0f0e5f5f5f5f5f6f5f5f6f5f5f5f5f5f5c5dbc6f5f5f5f5f5f50af30b0b0bf33b3c2b2c2b2c3b3cf30b0b0b3b3c3b3c3b3c3b3c3b3c3b3c3b3c3b3c0b0bc00bc00bc00b0b0b0b3b3c2b2c3b0000000000
fecbcbdeedededdfcbcbdeededdfcbfffefacbcbccdcdcdcc1dcdcdcdcdcdcdcdcdcdcdce1f0f0f0f0f1f0f0f0f0f0f0f0e5f5f5f5f5f5f5f5f5f5f5f5f5f5f5c5dbc6f5f5f5f5f5f50af31dc01d0bf3f33b3c3b3cf3f30b1dc01d2b2c2b2c2b2c2b2c2b2c2b2c2b2c2b2c1d1d0b1d0b1d0b1d1d1d1d0b0b3b3c2b0000000000
fecbcbcbcbcbcbcbcbcbcbcbcbcbcbfffefafacbccdcc1dcdcdcdcdcdcdcc1dcdcdcdce1f0f0f0f0f0f0f0f0f0f1f0f0e5f5f5f5f5f5f5f5f5f5f5f6f5f5f6f5c5dbc6f5f5f5f5f5f50af31dc0c01d0b0bf3f3f3f30b0b1dc0c01d3b3c3b3c3b3c3b3c3b3c3b3c3b3c3b3c1d1d1d1d1d1d1d1d1d1d1d1d1d0b0b3b0000000000
d9eeeeeeeeeeeeeeeeeeeeeeeeeeeee8fefafafaccdcdcdcdcdcdcdcc1dcdcdcdcdcdce1f0f0f0f0f0f0f1f0f0f0f0f0f0e5f5f5f5f5f5f6f5f5f5f5f5f5f5f5c5dbc6f5f5f5f5f5f50ae41d0b0b1d1d1d0b0b0b0b1d1d1d0b0b1d2b2c2b2c2b2c2b2c2b2c2b2c2b2c2b2c1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d0b0000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005c5c5c5c5c5c5c5c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005c5c5c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000004a4b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000005a5b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000005b5b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000005b5b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000005b5b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000005b5b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000005b5b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000005c5c5c5c5c5c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00040000160501620016100191001b100000000000006000190000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000070500a5500e0000e70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000030340194402b34011430223300b4301e33008430163200541011310024100b31000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001c100151000f1000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000b0000080000d0000f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000162300b43012220064200d210054100b6000b6001420000000000000000000000000000000000000000000000000000000000c2000220000000000000000000000000000000000000000000000000000
000a00000e35010350143500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500001b060232601606027260100602b2600c0602f2600705033250382501b0501f2501705025250100502c2500c050352503a2500b340103301432018310213001f3001d3001b30019300173000000000000
001000001335013350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000d0500d0500d0500d0500d0500d0500c0500c0500c0500c0500c0500c0500c05007050070500705007050070500704007040070300702007010070100701007010010000400003000030000300003000
000a000013040140501805014000190001e0002400020500016000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000e05050080500b5500e55005110071103870006050080500c5500e5500615008150104001f000104001d300104001f000104001f000104001f000104001f000104001f000104001f000104001f00010400
001000200375004750087500875008750087500875008750097500e7500b7500b7500b7500c7500e7500e7500e7500e7500e750107501775012750127501275012750117501b7501e7500f7500e7500000000000
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
0003000028250202301a230102200c220082100720005200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d00001832020700130001a5001e320217001200017700183201b0000f0001e500203201850012700157001832020700020000a00022320157001170014000203200f5001f320195001170014700183200f500
000d020118050180501b05018050090000d0000e1001000018050180501b050180500670010500067000a10018050180501b050180501d0501f05020050210501e05000000000001d050180001b0501805018050
000d00000c0500c0500f0500c050090000d0000e100100000c0500c0500f0500c0500670010500067000a1000c0500c0500f0500c0501105013050140501505012050000000000011050000000f0500c0500c050
000d00000c3530a000000000a0000c655000000c353000000c3530000000000000000c6550000000000000000c3530000000000000000c655000000c353000000c353000000c003000000c353000000c65500000
001000040675005450057500625001400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001d550265501a550215501355019550095500f550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000815720035400a740075400a740055400a740065400000000000000000c70000000000003e5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000a017400733013700084000a330063200800004400033300775008100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000906050080500000000000010500505000000030500c0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000040235000000023500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000414150081500e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001400060545006450000000445007450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0014000d0a25003250000000425000000074500b2500f450016300a10001630077500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
01 121a0304
02 1a18191b
02 4e0f4d45
01 1b5c4344
02 1b1c4344
03 0b424344
03 0c424344
03 1e424344
00 60424344
03 201f4344
01 22624344
02 21424344
01 23424344
02 24424344
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

