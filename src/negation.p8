pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
--============================================================================--
--=============================== global variables  ==========================--
--============================================================================--
-- player parameters
player = {
  x = 56,
  y = 56,
  size = 6,
  destroyed_step = 0,
  destroy_anim_length = 30,
  destroy_sequence = {135, 136, 135},
}
player_health = 15
player_max_health = player_health
player_shield = 0
player_speed = 1
player_angle = 0
player_fire_rate = .6
player_killed = 0
player_tokens = 0

-- level placement
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

-- wait controllers
wait = {
  controls = false,
  dialog_finish = false
}

-- timers
timers = {
  leveltimer = 0,
  showinv = 0,
  showinv2 = 0,
  playerlasthit = 0,
  leftclick = 0,
  middleclick = 0,
  rightclick = 0,
  firerate = 1,
  invalid = 0,
  bossstart = 0,
  spawn = 0,
  mvmt = 0
}

-- coin
coin = {
  dropped = false,
  size = 8,
  sprites = {80, 82, 84, 86, 88, 86, 84, 82}
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
  startx = 28,
  starty = 20,
  text = {         "12,12,12,12, 8, 8, 8,12,12,12, 8,12,12,12,12,12,12,12, 8, 12,12,12,12,12,12,12,12, 8, 8,12,12,12,12,12, 8, 8,12,12,12,12,12,12,12, 8,12,12,12,12,12,12,12, 8, 8,12,12,12,12, 8, 8,12,12,12,12, 8, 8, 8,12,12,12",
                   "12, 1, 1, 1,12, 8, 8,12, 1,12, 8,12, 1, 1, 1, 1, 1,12, 8, 12, 1, 1, 1, 1, 1, 1,12, 8,12, 1, 1, 1, 1, 1,12, 8,12, 1, 1, 1, 1, 1,12, 8,12, 1, 1, 1, 1, 1,12, 8,12, 1, 1, 1, 1,12, 8,12, 1, 1, 1,12, 8, 8,12, 1,12",
                   "12, 1, 1, 1, 1,12, 8,12, 1,12, 8,12, 1,12,12,12,12,12, 8, 12, 1,12,12,12,12,12,12, 8,12, 1, 1,12, 1, 1,12, 8,12,12,12, 1,12,12,12, 8,12,12,12, 1,12,12, 8, 8,12, 1,12,12, 1,12, 8,12, 1, 1, 1, 1,12, 8,12, 1,12",
                   "12, 1,12,12, 1, 1,12,12, 1,12, 8,12, 1,12, 8, 8, 8, 8, 8, 12, 1,12, 8, 8, 8, 8, 8, 8,12, 1, 1, 1, 1, 1,12, 8, 8, 8,12, 1,12, 8, 8, 8, 8, 8,12, 1,12, 8, 8, 8,12, 1,12,12, 1,12, 8,12, 1,12,12, 1, 1,12,12, 1,12",
                   "12, 1,12, 8,12, 1, 1, 1, 1,12, 8,12, 1,12,12,12, 8, 8, 8, 12, 1,12, 8,12,12,12,12, 8,12, 1, 1,12, 1, 1,12, 8, 8, 8,12, 1,12, 8, 8, 8, 8, 8,12, 1,12, 8, 8, 8,12, 1,12,12, 1,12, 8,12, 1,12, 8,12, 1, 1, 1, 1,12",
                   "12, 1,12, 8,12, 1, 1, 1, 1,12, 8,12, 1, 1, 1,12, 8, 8, 8, 12, 1,12, 8,12, 1, 1,12, 8,12, 1,12, 8,12, 1,12, 8, 8, 8,12, 1,12, 8, 8, 8, 8, 8,12, 1,12, 8, 8, 8,12, 1,12,12, 1,12, 8,12, 1,12, 8,12, 1, 1, 1, 1,12",
                   "12, 1,12, 8, 8,12, 1, 1, 1,12, 8,12, 1,12,12,12, 8, 8, 8, 12, 1,12, 8,12,12, 1,12, 8,12, 1,12, 8,12, 1,12, 8, 8, 8,12, 1,12, 8, 8, 8, 8, 8,12, 1,12, 8, 8, 8,12, 1,12,12, 1,12, 8,12, 1,12, 8, 8,12, 1, 1, 1,12",
                   "12, 1,12, 8, 8, 8,12, 1, 1,12, 8,12, 1,12, 8, 8, 8, 8, 8, 12, 1,12, 8, 8,12, 1,12, 8,12, 1,12, 8,12, 1,12, 8, 8, 8,12, 1,12, 8, 8, 8, 8, 8,12, 1,12, 8, 8, 8,12, 1,12,12, 1,12, 8,12, 1,12, 8, 8, 8,12, 1, 1,12",
                   "12, 1,12, 8, 8, 8,12, 1, 1,12, 8,12, 1,12,12,12,12,12, 8, 12, 1,12,12,12,12, 1,12, 8,12, 1,12, 8,12, 1,12, 8, 8, 8,12, 1,12, 8, 8, 8,12,12,12, 1,12,12,12, 8,12, 1,12,12, 1,12, 8,12, 1,12, 8, 8, 8,12, 1, 1,12",
                   "12, 1,12, 8, 8, 8, 8,12, 1,12, 8,12, 1, 1, 1, 1, 1,12, 8, 12, 1, 1, 1, 1, 1, 1,12, 8,12, 1,12, 8,12, 1,12, 8, 8, 8,12, 1,12, 8, 8, 8,12, 1, 1, 1, 1, 1,12, 8,12, 1, 1, 1, 1,12, 8,12, 1,12, 8, 8, 8, 8,12, 1,12",
                   "12,12,12, 8, 8, 8, 8, 8,12,12, 8,12,12,12,12,12,12,12, 8, 12,12,12,12,12,12,12,12, 8,12,12,12, 8,12,12,12, 8, 8, 8,12,12,12, 8, 8, 8,12,12,12,12,12,12,12, 8, 8,12,12,12,12, 8, 8,12,12,12, 8, 8, 8, 8, 8,12,12"}
}

-- flags
playonce = 0

--============================================================================--
--============================= helper functions =============================--
--============================================================================--
--[[
  gameflow
    coroutine to handle the flow of the game.
]]
function gameflow()
  -- showplayer = true
  -- titlescreen = true
  -- start game
  drawcontrols, wait.controls = true, true
  yield()

  drawcontrols, wait.controls = false, false

  init_tele_anim(player)
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

  init_tele_anim(boss(20, 20, 128, 1, 40))
  music(14)
  yield()

  kill_all_enemies(true)
  seraph.text = "NICE WORK. THE DOOR SHOULD BE OPENED NOW."
  yield()

  wait.controls,level_change,open_door = true,true,true
  yield()

  wait.controls = false
  yield()

  --start level 2
  wait.controls = true
  seraph.text = "WELCOME TO THE PLANET HECLAO, SUPPOSE TO BE OUR HOME AWAY   FROM HOME."
  add(boss_table, boss(100, 56, 139, 2, 35))

  yield()

  seraph.text = "UNFORTUNATELY, WE WEREN'T     ALONE."
  yield()

  seraph.text = "OH, WHO IS THIS LITTLE GUY?   SEEMS TO BE CHECKING YOU OUT."
  yield()

  fill_enemy_table(2, 60)
  wait.controls,spawn_time_start = false,60
  yield()

  kill_all_enemies(true)
  level_change = true
  yield()

  -- start level 3
  open_door = false
  seraph.text = "SO THE MAIN SOURCE OF THE     INFESTATION IS UP HERE PAST   THE DESERT."
  --music(16)
  yield()

  fill_enemy_table(3, 60)
  spawn_time_start = 60
  init_tele_anim(boss(100, 60, 160, 3, 40))
  music(16)
  yield()

  kill_all_enemies(true)
  level_change = true
  yield()

  seraph.text = "EVER SINCE THE CULT MOVED INTOTHE TEMPLE THESE CREATURES    HAVE BEEN POURING OUT OF THERE."
  --music(20)
  yield()

  seraph.text = "I'M PRETTY CERTAIN THAT THEY  ARE TRYING TO SUMMON SOME KINDOF MONSTER..."
  yield()

  -- start level 4
  fill_enemy_table(4, 90)
  spawn_time_start,detect_killed_enemies = 90, true
  yield()

  kill_all_enemies(true)
  init_tele_anim(boss(60, 60, 166, 1, 40))
  music(20)
  init_tele_anim(boss(90, 90, 38, 1.5, 10))
  init_tele_anim(boss(20, 20, 38, 1.5, 10))
  yield()

  seraph.text = "ALMOST THERE, BE CAREFUL GOINGIN THE TEMPLE. NO IDEA WHAT'S IN THERE..."
  --music(17)
  yield()

  kill_all_enemies(true)
  level_change = true
  yield()

  -- start level 5 (aoe boss)
  fill_enemy_table(3, 75)
  spawn_time_start,detect_killed_enemies = 75, true
  yield()

  init_tele_anim(boss(56, 52, 164, 4, 40))
  music(17)
  yield()

  kill_all_enemies(true)
  level_change = true
  yield()

  -- start level 6 "final" boss
  fill_enemy_table(3, 75)
  spawntime_start,detect_killed_enemies = 75, true

  yield()

  seraph.text = "THIS IS IT. MOMENT OF TRUTH.  I'M CERTAIN YOU WILL BE NO    PROBLEM FOR IT..."
  --music(19)
  yield()

  seraph.text = "IT NEEDS YOUR BLOOD SO PLEASE DO US A FAVOR AND JUST DIE!"
  yield()

  kill_all_enemies(true)
  init_tele_anim(boss(56, 56, 169, 6, 40))
  music(19)
  yield()

  level_change = true
  add(dropped, drop_obj(46, 70, 32))
  add(dropped, drop_obj(66, 70, 32))

  yield()

  --start level 7 final boss
  seraph.text = "YOU FOOL! DO YOU UNDERSTAND   HOW LONG IT TOOK US TO SUMMON THAT THING?"
  add(boss_table, boss(100, 60, 5, 10, 50))
  music(22)
  yield()

  seraph.text = "NO MATTER. WE'LL JUST USE YOURBLOOD TO SUMMON IT AGAIN!"
  yield()


  yield()

  seraph.text = "SO CLOSE... TO PERFECTION..."
  yield()

  music(3)
  win = true
  in_leaderboard = true
end

--[[
  function used to center text
  sourced from: http://pico-8.wikia.com/wiki/centering_text
]]
function hcenter(s) return 64-flr((s*4)/2) end

--[[
  calculate euclidean distance between n and d
]]
function distance(n, d)
  return sqrt((n.x-d.x)*(n.x-d.x)+(n.y-d.y)*(n.y-d.y))
end

--[[
  calculate angle between two coordinates (tx,ty) and (fx,fy)
]]
function angle_btwn(tx, ty, fx, fy)
  return ((atan2((ty - fy), (tx - fx)) * 360) + 180)%360
end

--[[
  remove object 'obj' from list 'list' if it has traveled offscreen
]]
function delete_offscreen(list, obj)
  if (obj.x < 0 or obj.y < 0 or obj.x > 128 or obj.y > 128) del(list, obj)
end

--[[
  check if buttons to continue have been pressed
]]
function continuebuttons()
  --if ((stat(34) == 1 and timers["firerate"] == 0) or btnp(4) or btnp(5)) timers["firerate"] = 1; return true
  if ((btn(4) or btn(5) or stat(34) == 1) and timers["firerate"] == 0) timers["firerate"] = .5; return true
  return false
end

--[[
  check for collision between coordinates (x, y) and the flag value (defaults to 0)
]]
function bump(x, y, flag)
  return fget(mget(flr((x - level_sx + (level_x*8)) / 8), flr((y - level_sy + (level_y*8)) / 8)), (flag or 0))
end

--[[
  call bump to check every corner relative to (x, y) to check for basic wall collision
]]
function bump_all(x, y)
  return bump(x, y) or bump(x + 7, y) or bump(x, y + 7) or bump(x + 7, y + 7)
end

--[[
  check for a collision between two entities (firstent and secondent)
  'offs' is an attempt to get the player's hitbox to update with the player's rotation
]]
function ent_collide(firstent, secondent)
  offs = player_angle > 180 and 4+2*sin(player_angle/360) or 4-2*sin(player_angle/360)
  offset = (firstent == player) and offs or 0

  return (firstent.x + offset > secondent.x + level_sx + secondent.size or firstent.x + offset + firstent.size < secondent.x + level_sx
    or firstent.y + offset > secondent.y + secondent.size or firstent.y + offset + firstent.size < secondent.y) == false
end

--============================================================================--
--=========================== object-like structures =========================--
--============================================================================--
--[[
  object for power-up items that enemies drop
]]
function drop_obj(sx, sy, sprite, am)
  local d = {}
  d.x, d.y, d.sprite, d.size, d.drop_duration = sx, sy, sprite, 7, 7
  d.init_time = time()
  d.types = {[32] = "heart",
             [33] = "shotgun",
             [48] = "rockets",
             [49] = "shield"}
  d.ammos = {[33] = 10,
             [48] = 1}
  d.type = d.types[sprite]
  -- if (d.ammos[sprite] ~= nil) d.ammo = d.ammos[sprite]
  d.ammo = (am ~= nil) and am or d.ammos[sprite]
  return d
end

--[[
  enemy object, move() function updates enemy ai based on enemy type
]]
function enemy(x, y, type, time_spwn)
  local e = {}
  e.x, e.y, e.time, e.b_count,e.angle =  x, y, time_spwn, 0, 360
  e.destroy_anim_length, e.destroyed_step, e.drop_prob, e.shoot_distance = 15, 0, 20, 50
  e.destroy_sequence = {135, 136, 135}
  e.walking = {132, 134, 137}
  e.drops = {32, 32, 32, 33, 48, 49} -- sprites of drops
  e.explode_distance, e.explode_wait, e.explode_step, e.fire_rate = 15, 15, 0, 20
  e.exploding, e.dont_move, e.size, e.sprite, e.type = false, false, 7, 132, type
  e.speed = type == "exploder" and .9 or .35

  e.update_xy = function()
                  e.x = e.x - e.speed*sin(e.angle/360)
                  e.y = e.y - e.speed*cos(e.angle/360)
                end
  e.move = function()
                e.angle = angle_btwn(player.x+5, player.y+5, e.x, e.y)
                if e.type == "shooter" then
                  if distance(e, player) >= e.shoot_distance then
                    e.update_xy()
                    e.dont_move = false
                  else
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

--[[
  bullet object
  four basic types: regular bullet, _sin (more of slow and random movement),
  shotgun, and homing
]]
function bullet(startx, starty, angle, sprite, friendly, shotgun, _sin, homing)
  local b = {}
  b.x, b.y, b.angle, b.sprite, b.friendly, b.duration = startx, starty, angle, sprite, friendly, 20
  b.shotgun, b.speed, b.acceleration, b.current_step, b.max_anim_steps, b.rocket, b.size = (shotgun or false), 2, 0, 0, 5, false, 3
  if (b.sprite == 48) b.acceleration, b.max_anim_steps, b.rocket, b.size = 0.5, 15, true, 4
  if (homing) b.duration = 50

  b.move = function()
     if (b.sprite == 48 and b.friendly) b.acceleration += 0.5
     if (shotgun or homing) b.duration -= 1
     if (homing) b.speed, b.angle = .05, angle_btwn(player.x, player.y, b.x, b.y)
     if (_sin) b.speed = .5
     if (_sin and flr(rnd(2))==1) b.y -= sin(time()*5)*5*sin(b.y*.5*3.14); b.x = b.x - (b.speed+b.acceleration) * sin(b.angle / 360); return
     b.y = b.y - (b.speed+b.acceleration) * cos(b.angle / 360)
     if (_sin) b.x -= sin(time()*5)*5*sin(b.x*.5*3.14); return
     b.x = b.x - (b.speed+b.acceleration) * sin(b.angle / 360)
   end

  return b
end

--[[
  boss object
  update() function contains all ai code for every different boss, based on b.level
]]
function boss(startx, starty, sprite, lvl, hp)
  local b = {}
  b.x, b.y, b.speed, b.angle, b.level, b.shot_last, b.shot_ang, b.sprite, b.idx, b.b_count = startx, starty, .01, 0, lvl, nil, 0, sprite, 2, 0
  b.size, b.bullet_speed, b.destroyed_step, b.destroy_anim_length, b.health, b.full_health = 16, 2, 0, 30, (hp or 50), (hp or 50)
  b.sang = 0
  b.destroy_sequence = {135, 136, 135}
  b.circs = {}
  timers["bossstart"] = (lvl == 6) and 5 or 1000
  timers["mvmt"] = 3
  rev,once = 1, false
  b.draw_healthbar = function()
             --health bar
             if (b.sprite == 128 or 139) xoffset = 1
             rectfill(b.x + xoffset, b.y - 3, b.x + xoffset + 12, b.y - 3, 14)
             rectfill(b.x + xoffset, b.y - 3, b.x + xoffset + flr(12 * (b.health / b.full_health)), b.y - 3, 8)
           end
  b.update = function()
           local p_ang = angle_btwn(player.x, player.y, b.x, b.y)
           b.b_count += 1
           if b.level == 1 then
             if (flr(timers["bossstart"])%10 == 0) rev*=0xffff; timers["bossstart"] = 100
             b.angle = (b.angle+5)%360
             for i=1,360,90 do
               if (b.b_count%5 == 0) shoot(b.x, b.y, i+(rev*b.angle)+rnd(10), 141, false, true)
             end
           elseif b.level == 1.5 then
             if (flr(timers["bossstart"])%2==0 and not once) shoot(b.x, b.y, p_ang, 142, false, true); once = true
             if (flr(timers["bossstart"])%2!=0) once = false
           elseif b.level < 3 then
             if (#enemy_spawned == 0 and #enemy_table == 0 and not wait.controls) b.level = 2.5
             if b.level==2.5 or b.shot_last ~= nil and ((time() - b.shot_last) < 2) then
               if flr(time()*50)%7 == 0 then
                 shoot(b.x, b.y, p_ang, 141, false, true)
                 b.x = b.x - 1.5*sin(p_ang/360)
                 b.y = b.y - 1.5*cos(p_ang/360)
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
              b.angle = (b.angle+7)%360
              b.x = 60
              b.y = 60
              for i=1,360,180 do
                if (b.b_count%4 == 0) shoot(b.x, b.y, i+b.angle+rnd(10), 141, false, true)
              end
              if (b.b_count%30==0) for i=0,360,180 do shoot(b.x, b.y, i+b.angle, 76, false, true, false, true) end
            end
           elseif b.level == 4 then
             if abs(time()*10)%2 == 0 then
               b.circs[#b.circs+1] = {player.x+8, player.y+8, 12}
             end
             for c in all(b.circs) do
               for i=12,c[3],0xffff do
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
             if (b.b_count%30 == 0) shoot(b.x, b.y, p_ang, 76, false, true, false, true)
             local locs = {0,100,100,0}
             if ((b.health%9)==0) b.x, b.y = 10+locs[b.idx%#locs+1], 10+locs[(b.idx-1)%#locs+1]; b.idx+=1; b.health-=1
           elseif b.level == 6 then
             b.angle = (b.angle+10)%360
             if (flr(timers["bossstart"])%1.5==0 and not once) for i=0,360,30 do shoot(b.x, b.y, i, 76, false, true) end; once=true
             for i=-30,30,30 do
               b.sang = (b.sang+1)%360
               if b.b_count%3 == 0 then
                   shoot(b.x, b.y, i+(b.angle+b.sang), 141, false, true)
               end
             end
             if (timers["bossstart"] == 0) timers["bossstart"] = 4; once = false
           elseif b.level == 10 then
             local locs = {40, 60, 80}
             if (timers["mvmt"]==0) b.y = locs[b.idx%3+1]; b.idx+=1; timers["mvmt"]=3
             if (timers["bossstart"] > 990) then
               b.angle = (b.angle+8)%180 + 180
               if (flr(timers["bossstart"])%3 == 0 and not once) for i=p_ang-60,p_ang+60, 60 do shoot(b.x, b.y, i, 48, false, true, false, false, true) end; for i=0,360,30 do shoot(b.x, b.y, i, 76, false, true) end; once = true
               if (flr(timers["bossstart"])%3!=0) once = false
               if (b.b_count%5==0) shoot(b.x, b.y, b.angle, 53, false)
             else
               b.angle = (b.angle+5)%180 + 180
               if (b.b_count%3==0) shoot(b.x, b.y, b.angle, 53, false)
               if (b.b_count%30 == 0) shoot(b.x, b.y, p_ang, 76, false, true, false, true)
               if (timers["bossstart"] < 980) timers["bossstart"] = 1000
             end
           end
           b.draw_healthbar()
          end
  return b
end
--============================================================================--
--========================== draw functions ==================================--
--============================================================================--
--[[
  function used to rotate sprite.
  this edited version is sourced from: https://www.lexaloffle.com/bbs/?pid=22757
]]
function spr_r(s,x,y,a,w,h)
 sw, sh =(w or 1)*8, (h or 1)*8
 sx, sy =(s%8)*8, flr(s/8)*4
 x0=flr(0.5*sw)
 y0=flr(0.5*sh)
 a=a/360
 sa=sin(a)
 ca=cos(a)
 clr=(s==5 or s==38) and 7 or 0
 for ix=0,sw-1 do
  for iy=0,sh-1 do
   dx=ix-x0
   dy=iy-y0
   xx=flr(dx*ca-dy*sa+x0)
   yy=flr(dx*sa+dy*ca+y0)
   if (xx>=0 and xx<sw and yy>=0 and yy<=sh) then
    if sget(sx+xx, sy+yy) == clr or sget(sx+xx, sy+yy) == 10 then
      pset(x+ix, y+iy, pget(x+ix, y+iy))
    else
      pset(x+ix,y+iy, sget(sx+xx,sy+yy))
    end
   end
  end
 end
end

--[[
  function used to draw title screen.
  reads pixel color values from the title.text gloabal variable
]]
function draw_titlescreen()
  rectfill(0, 0, 127, 127, 6)
  circfill(64, 35, 45+time()%2, 8)
  rectfill(0, 35, 128, 128, 0)
  line(0, 35, 128, 35, 12)
  for i=0,10 do
    line(14+i*10,35,-96+i*32,128,12)
    line(0, 35+(i)*10+abs(time()*20%10),128, 35+(i)*10+abs(time()*20%10),12)
  end

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

  if title.init < (flr(time()) - 1) and playonce == 0 then
    music(1)
    playonce+=1
  end
  print("left click to start", 28, 110, flr(time())%15+1)
end

--[[
  prints instructions on how to play to the screen
]]
function draw_controls()
  rectfill(10, 20, 117, 101, 8)
  rectfill(11, 21, 116, 100, 6)

  print("use the mouse to aim!", 21, 30, 8)
  print("wasd to move", 17, 42, 5)
  print("left click  to shoot", 17, 52, 5)
  print("right click to shoot", 17, 62, 5)
  print("power ups", 17, 68, 5)
  print("e to switch power ups", 17, 78, 5)
  print("q to drop power up", 17, 88, 5)
end

--[[
  draws box with seraph's dialog text to the bottom of the screen
]]
function draw_dialog()
  local bck_color = 5
  local brd_color = 0
  local fnt_color = 7
  local d = seraph.text

  if (seraph.step == nil) seraph.step = 0
  --if (seraph.step < #d) wait.dialog_finish = false
  wait.dialog_finish = (seraph.step < 30) and true or false

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
  rectfill(124, 126, 4, 126, brd_color) -- bottom
  pset(3, 125, brd_color) -- bottom left

  print("seraph", 4, 100, fnt_color)

  print(sub(d, 0, min(seraph.step, 30)), 5, 107, fnt_color)
  if (seraph.step > 30) print(sub(d, 31, min(seraph.step, 60)), 5, 113, fnt_color)
  if (seraph.step > 60) print(sub(d, 61, min(seraph.step, 90)), 5, 119, fnt_color)
  seraph.step = min(seraph.step+1, #d+30)
  --if (seraph.step == #d+30) wait.dialog_finish = false
end

--[[
  draws count down timer for first level on the screen
]]
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

--[[
  animates door opening on first level
]]
function opendoor()

  local offset = (level_lvl-1)*128

  if (doorh == nil) doorh = 1
  rectfill(124+level_sx-offset, 71+level_sy, 131+level_sx-offset, 71-doorh+level_sy, 13)
  rectfill(124+level_sx-offset, 72+level_sy, 131+level_sx-offset, 72+doorh+level_sy, 13)
  if (doorh < 13) then
    doorh += 0.5
  elseif doorh == 13 then
     coresume(game)
     doorh += 1
  end
end

--[[
  draws skilltree menu to screen, all button handling is done in skill_tree()
]]
function skilltree()
  rectfill(-50, -50, 200, 200, 0)
  print("purchase upgrades",10,10,7)
  spr(coin.sprites[flr(time()*8)%#coin.sprites + 1], 20, 20, 2, 2)
  print(" - " .. player_tokens, 36, 26, 7)

  print("UPGRADE SPEED - ".. next_cost[1] .." TOKENS ", 10, 36, 7+((skills_selected[1] and 1 or 0)*3))
  print("UPGRADE FIRE RATE - ".. next_cost[2] .." TOKENS ", 10, 44, 7+((skills_selected[2] and 1 or 0)*3))
  print("UPGRADE HEALTH - ".. next_cost[3] .." TOKENS ", 10, 52, 7+((skills_selected[3] and 1 or 0)*3))
  print("quit", 10, 68, 7+((skills_selected[4] and 1 or 0)*3))
end

--[[
  draw player's healthbar
]]
function draw_playerhp()
  --local hpcolor = 11
  local hpratio = player_health/player_max_health
  if (invtx == nil) invtx = 4
  if (invtx > 4) invtx -= 1

  if hpratio >= .5 then
    hpcolor = 11
  elseif hpratio >= .3 then
    hpcolor = (level_lvl == 3) and 10 or 9
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
    rectfill(player.x + 4, player.y + (21 - flr(7  * (player_inventory[1].ammo / player_inventory[1].ammos[player_inventory[1].sprite]))) , player.x + 11, player.y + 21, 13)
    spr(player_inventory[1].sprite, player.x + invtx, player.y + 14)
    spr(112, player.x + 4, player.y + 14)
  end
end

--[[
  this function updates all enemies that have been spawned
]]
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

--[[
  updates any item that has been dropped by an enemy
]]
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
      elseif d.type ~= "heart" and #player_inventory < 4 then
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

--[[
  updates and handles every bullet the player has fired
]]
function bullets_player()
  for b in all(player_bullets) do
    -- first delete offscreen bullets:
    delete_offscreen(player_bullets, b)

    -- if (bump_all(b.x, b.y, 4)) del(enemy_bullets, b);  b.rocket = true; add(boss_hit_anims, b); return
    if bump_all(b.x, b.y) then
      del(player_bullets, b)
      add(boss_hit_anims, b)
      if (b.rocket) rocket_kill(b)
      return
    end
    if (b.shotgun) then
      for i=0xffff,6,7 do
        pset(b.x+i*sin((90+b.angle)/360)+3, b.y+i*cos((90+b.angle)/360)+2, 10)
      end
    elseif b.rocket then
      spr_r(b.sprite, b.x, b.y, b.angle, 1, 1)
    else
      spr(b.sprite, b.x, b.y)
    end
    b.move()
    if (b.duration <= 0) del(player_bullets, b); return

    for bos in all(boss_table) do
      if ent_collide(bos, b) then
        sfx(23,1)
        bos.health -= ((b.sprite == 48) and 5 or 1)
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
          enemy_bullets={}
          if (level_lvl == 5) then coin.x, coin.y = 80, 50
          else coin.x,coin.y = bos.x,bos.y end
          if (#boss_table == 0) coresume(game)
        end
        break
      end
    end
  end
end

--[[
  updates and handles every bullet an enemy has fired
]]
function bullets_enemies()
  for b in all(enemy_bullets) do
    -- first delete offscreen bullets:
    delete_offscreen(enemy_bullets, b)

    if ent_collide(player, b) then
      if timers["playerlasthit"] == 0 then
        if player_shield <= 0 then
          add(boss_hit_anims, b)
          if (b.rocket) rocket_kill(b)
          player_hit(1)
        else
          add(shield_anims, {b.x, b.y, 10})
          player_shield = player_shield - .15
        end
      end
      del(enemy_bullets, b)
      return
    end

    if (b.duration <= 0) del(enemy_bullets, b); add(enemy_bullets, bullet(b.x, b.y, b.angle, b.sprite, false)) return
    if (b.rocket) then spr_r(b.sprite, b.x, b.y, b.angle, 1, 1) else spr(b.sprite, b.x, b.y) end
    b.move()
    -- if (bump_all(b.x, b.y, 4)) del(enemy_bullets, b); rocket_kill(b); return
    if (bump_all(b.x, b.y)) del(enemy_bullets, b); add(boss_hit_anims, b)
  end
end

--[[
  draws leaderboard to screen
]]
function show_leaderboard()
  --rectfill(0,0,128,128,0)
  if not win then
    mes = "game over";
  else
    mes = "the horde is beaten... for now!"
    rectfill(0,11,127,116,12)
    rectfill(0,13,127,114,6)
  end
  print(mes,hcenter(#mes), 55, win and 13 or 8)
  if (k<player_killed-1) k += player_killed*.01
  local t = "killed: "..flr(k)
  print(t, hcenter(#t), 63, 5)
  print("left click to start over", 15, 100, flr(time()*5)%15+1)
  if (flr(k)==player_killed-1) timers["invalid"] = 0.5; k+=1
  if (timers["invalid"] > 0) then camera(cos((time()*1000)/3), cos((time()*1000)/2))
  else camera() end
end

--============================================================================--
--======================= animation functions ================================--
--============================================================================--

--[[
  draw enemy destruction animation
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

--[[
  animate bullets hitting any object, this should really get renamed
]]
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

--[[
  steps through boss exploding animation
]]
function step_boss_destroyed_animation(b)
  if (b.destroyed_step <= b.destroy_anim_length) then
    for i=1,3 do
      spr(b.destroy_sequence[flr(b.destroyed_step/30)+1], b.x+sgn(sin(rnd(10)))*flr(rnd(8)), b.y+sgn(sin(rnd(10)))*flr(rnd(8)))
    end
  else
    if (b~= player) del(destroyed_bosses, b)
    if (b.sprite ~= 5) then
      if (#boss_table == 0) coin.dropped = true; music(3)
    end
  end

  circ(b.x+4, b.y+4, b.destroyed_step%5, 8)
  b.destroyed_step += 1


end

--[[
  initiates the teleport animation
]]
function init_tele_anim(e)
  e.anim_length,e.anim_step = 90,0
  add(tele_animation, e)
end

--[[
  steps through teleport animation
]]
function step_teleport_animation(e)
  local offset = 0xffff
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

--[[
  adds locations of water animations to a list of circles that are handled in _draw
]]
function water_anim()
  for i=0,16 do
    for j=0,16 do
      if (not fget(mget(i+level_x-(level_sx/8), j+level_y-(level_sy/8)),7) and fget(mget(i+level_x-(level_sx/8), j+level_y-(level_sy/8)),1) and rnd(10) > 9.5) add(water_anim_list, {i*8+rnd(4),j*8+rnd(4), flr(rnd(3)), 7, 25});
    end
  end
end

--============================================================================--
--================================ functions =================================--
--============================================================================--

--[[
  adds bullets to the respective table with the appropriate offset and values
]]
function shoot(x, y, a, spr, friendly, boss, shotgun, sine, homing)
  if (boss) sfx(2)
  if friendly then
    local offx, offy = (player.x + 5), (player.y + 5)
    local ang = angle_btwn((stat(32) - 3), (stat(33) - 3), offx, offy)
    offx, offy = (offx - 8*sin(ang / 360)), (offy - 8*cos(ang / 360))
    for i=(shotgun and 0xffff or 0),(shotgun and 1 or 0),1 do
      add(player_bullets, bullet(offx, offy, ang+(i*30), spr, friendly, shotgun))
    end
  elseif boss then
    add(enemy_bullets, bullet(((x + 5) - 16*sin(a / 360)), ((y + 5) - 16*cos(a / 360)), a, spr, friendly, shotgun, sine, homing))
  else
    add(enemy_bullets, bullet((x - 8*sin(a / 360)), (y - 8*cos(a / 360)), a, spr, friendly))
  end
end

--[[
  handle button presses inside skill tree, updates player attributes accordingly
]]
function skill_tree()
  skills_selected[currently_selected] = false
  local diff = 0
  if btn(2) and timers["firerate"]==0 then
    diff = 0xffff
    sfx(0)
    timers["firerate"] = .2
  elseif btn(3) and timers["firerate"]==0 then
    diff = 1
    sfx(0)
    timers["firerate"] = .2
  elseif continuebuttons() then
    if selection_set[currently_selected] == "quit" then
      in_skilltree = false
      sfx(0)
    elseif (selection_set[currently_selected] == "health" and player_tokens >= next_cost[currently_selected]) then
        player_max_health += 1
        player_health = player_max_health
        player_tokens -= next_cost[currently_selected]
        next_cost[currently_selected] += 1
        sfx(0)
    elseif (selection_set[currently_selected] == "fire rate" and player_tokens >= next_cost[currently_selected]) then
        player_fire_rate = max(.1, player_fire_rate-.1)
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

--[[
  fill enemy table with an assortment of random x,y values, enemy types, and
  spawn timing
]]
function fill_enemy_table(level, lvl_timer)
  local types = {"basic", "shooter", "exploder"}
  local baseline = 15
  for i=1,(baseline*level) do
    add(enemy_table, enemy(0, 0, types[flr(rnd(level))%#types+1], flr(rnd(lvl_timer))))
  end
end

--[[
  if the enemies from 'enemy_table' are set to spawn at the current timme,
  spawn them at least a distance of 50 pixels away from the player
]]
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

--[[
  check if all enemies have been killed, if so, step the gameflow corouting
]]
function detect_kill_enemies()
  if #enemy_spawned == 0 and #enemy_table == 0 then
    detect_killed_enemies = false
    coresume(game)
  end
end

--[[
  kill all enemies (including bosses) on screen
]]
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

--[[
  scrolls level to the left for our level transition, moves with player movement
]]
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
    if btn(1) and player.x > farx then
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

--[[
  handle a rocket explosion by adding sound effects, checking aoe, and incrementing
  the player's kill counter
]]
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

--[[
  called when an enemy is killed. this function drops an opject with probability
  e.drop_prob
]]
function drop_item(e)
  if (flr(rnd(100)) <= e.drop_prob) add(dropped, drop_obj(e.x, e.y, e.drops[flr(rnd(#e.drops)) + 1]))
end

--[[
  handle when a player gets hit by decrementing health, triggering sfx, and
  updating timers
]]
function player_hit(d)
  if timers["playerlasthit"] == 0 then
    player_health -= d
    sfx(18)
    timers["playerlasthit"] = 2
  end
end
--============================================================================--
--================================ constructor ===============================--
--============================================================================--
function _init()
  k=0
  poke(0x5f2d, 1)

  title.init = time()

  game = cocreate(gameflow)
  coresume(game)
end --end _init()

--============================================================================--
--================================ update ====================================--
--============================================================================--
--[[
  called 30 times a second, we handle most button input here (other than skilltree)
]]
function _update()

  local previousx, previousy = player.x, player.y
  move = (bump(player.x + 4, player.y + 4, 1) or bump(player.x + 11, player.y + 11, 1)) and player_speed/2 or player_speed
  if (bump(player.x + 4, player.y + 4, 2) or bump(player.x + 11, player.y + 11, 2)) player_hit(1)

  -- count down timers
  for k,t in pairs(timers) do timers[k] = max(0, timers[k] - (1/30)) end
  -- timers["playerlasthit"] = 0x.0001 --uncomment for god mode
  if (level_change)  levelchange()
  if (titlescreen == nil and continuebuttons()) titlescreen = true; return
  if (drawcontrols and continuebuttons()) music(0xffff) showcontrols = false; coresume(game); return
  if (in_leaderboard and continuebuttons()) in_leaderboard = false; run()
  if (in_skilltree) skill_tree(); return;
  if (seraph.text ~= nil and not wait.dialog_finish and continuebuttons()) seraph = {}; coresume(game); return
  if not wait.controls and seraph.text == nil then
    --========================
    --left mouse button-------
    --========================
    if stat(34) == 1 and timers["firerate"] == 0 then
      shoot(player.x, player.y, player_angle, 53, true, false)
      timers["firerate"] = player_fire_rate
      sfx(2)
    end

    --========================
    --middle mouse button-----
    --========================
    if (stat(34) == 4 or btn(5)) and timers["middleclick"] == 0 then -- cycle inventory
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

      -- controls individual power ups
      if invt.type == "shotgun" then
        shoot(player.x, player.y, player_angle, 34, true, false, true)
        sfx(20)
      elseif invt.type == "rockets" then
        shoot(player.x, player.y, player_angle, 48, true, false)
        sfx(16)
      end

      -- dec ammo if above 1, else delete
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
    --o button----------------
    --========================
    -- drops current power up
    if btnp(4) and #player_inventory > 0 then
      add(dropped, drop_obj((player.x + 5) + 12*sin(player_angle / 360), (player.y + 5) + 12*cos(player_angle / 360), player_inventory[1].sprite, player_inventory[1].ammo))
      del(player_inventory, player_inventory[1])
      timers["showinv"], timers["showinv2"] = .5, 0
    end

    --========================
    --up button---------------
    --========================
    if btn(2) then
      player.y -= move
      moving = true
      if (bump(player.x + 4, player.y + 3) or bump(player.x + 11, player.y + 3)) player.y = previousy
    end

    --========================
    --down button-------------
    --========================
    if btn(3) then
      player.y += move
      moving = true
      if (bump(player.x + 4, player.y + 12) or bump(player.x + 11, player.y + 12)) player.y = previousy
    end

    --========================
    --left button-------------
    --========================
    if btn(0) then
      player.x -= move
      moving = true
      if (bump(player.x + 3, player.y + 4) or bump(player.x + 3, player.y + 11)) player.x = previousx
    end

    --========================
    --right button------------
    --========================
    if btn(1) then
      player.x += move
      moving = true
      if (bump(player.x + 12, player.y + 4) or bump(player.x + 12, player.y + 11)) player.x = previousx
    end

    --========================================================================--
    player_angle = flr(atan2(stat(32) - (player.x + 8), stat(33) - (player.y + 8)) * -360 + 90) % 360

    -- screen border
    if (player.x < -2) player.x = -2
    if (player.y < -2) player.y = -2
    if (player.x > 107) player.x = 107
    if (player.y > 112) player.y = 112

    -- decrease shield
    if (not wait.controls or seraph.text == nil) player_shield = max(player_shield - .01,0)

    spawnenemies()
    if (detect_killed_enemies) detect_kill_enemies()

  else

    timers["playerlasthit"] = 0x.0001 --make player invulnerable so they dont get hit when they can't move
  end -- end wait.controls

end


--============================================================================--
--=============================== draw buffer ================================--
--============================================================================--
--[[
  draw all of our sprites and animations to the screen
]]
function _draw()
  cls()

  if (in_leaderboard) show_leaderboard(); return

  map(level_x, level_y, level_sx, level_sy, 128, 128)

  -- water animation
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
    music(0xffff, 300)
    sfx(9,1)
    in_leaderboard = true
  end

  if (level_lvl == 1 and #boss_table == 0) spr(139, 228+level_sx, 56, 2, 2) -- show second boss on screen
  -- draw seraph on screen before spawning him in
  if ((level_lvl == 6) and #boss_table == 0) spr_r(5, 228+level_sx, 60, angle_btwn(player.x, player.y, 228+level_sx, 60), 2, 2)--spr(5, 228+level_sx, 60, 2, 2)
  if (drawcontrols) draw_controls(); return
  if (open_door) opendoor() -- door animation
  if (player_shield > 0) circ((player.x+8), (player.y+7), ((time()*50)%2)+6, 1) -- circle around player
  if (showplayer ~= nil) draw_playerhp()
  sp = moving and 2+flr(rnd(2))*32 or 0; moving = false

  -- draw player or flash if damage
  if (showplayer ~= nil and timers["playerlasthit"] <= 0x.0001) then
    spr_r(sp, player.x, player.y, player_angle, 2, 2)
  elseif showplayer ~= nil and timers["playerlasthit"] > 0x.0001 and flr(time()*1000%2) == 0 then
    spr_r(sp, player.x, player.y, player_angle, 2, 2)
  end

  if (wait.timer) drawcountdown()

  --=======================
  --animations-------------
  --=======================
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
    if (ent_collide(player, b)) player_hit(2)
    if b.level == 10 or b.level == 1.5 then spr_r(b.sprite, b.x, b.y, angle_btwn(player.x, player.y, b.x, b.y), 2, 2)
    elseif (b.level ~= 3) then spr(b.sprite, b.x, b.y, 2, 2)
    else sspr(0, 80, 8, 8, b.x, b.y, 16, 16) end
    if (not wait.controls and seraph.text == nil) b.update()
  end

  foreach(boss_hit_anims, boss_hit_animation)

  foreach(destroyed_bosses, step_boss_destroyed_animation)

  foreach(tele_animation, step_teleport_animation)

  if (pget(stat(32), stat(33)) == 8 or pget(stat(32), stat(33)) == 2)  pal(8, 6)
  spr(114, stat(32) - 3, stat(33) - 3)
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
end

__gfx__
0000000000000000000000000000000000000000777777777777777700800000000000007666666705622222dddddddddddddd667666888876666667ffffffff
0000000000000000000000000000000000000000777777777777777700888800000000006555555105622222dddddddddddddd6b6555822265555551ffffffff
000000000000000000000000000000000000000077777777777777770088880000000000655555510562222222222222dddddd6b6555822265555551ffffffff
0000000000000000000000000000000000000000777707777770777700808800000000006552d5510562222222222222dddddd666555888865555551ffffffff
000060000006000000006000000600000000000077770777777077770000080000000000655d25510562222222222222dddddd666555888865555551ffffffff
0000660cc06600000000660cc0660000000000007077077dd77077070088880000000000056ddddd0562222222222222dddddd6b6555822266666666ff366666
00006619916600000000661991660000000000007077072dd27077070880000000000000056ddddd0562222222222222dddddd6b6555822266666666f3336666
00006619916600000000661991660000000000007077072dd27070070000000000000000056ddddd0562222222222222dddddd66d11188886666666633033666
00006619916600000000661991660000000000007007002dd20070070000000000000000656222220562222222222222dddddd66222222226666666630003666
000000511500000000000051150000000000000070070029920070070000000005555555576222220562222222222222dddddd6b222222223333333330003666
000000011000000000000001100000000000000070070029920070070000000005666666666222220562222222222222dddddd6b222222226666666630003666
00000000000000000000000cc000000000000000700000299200000700000000056dddddddd222220566666666622222dddddd66222222223333333330003666
000000000000000000000000c000000000000000777777022077777700000000056dddddddd222220655555557622222dddddd66222222226666666630003666
000000000000000000000000000000000000000077777772277777770000000005622222222222225000000065622222dddddd6b222222223333333330003666
000000000000000000000000700000000000000077777727727777770000000005622222222222220000000005622222dddddd6b222222226666666630003666
000000000000000000000007000000000000000077777277772777770000000005622222222222220000000005622222dddddd66222222226666666630003666
00000000000000000000000000000000000000007777777777777777777777777765000076666661166666677666666666666667766111157666666730003666
0ee00ee0000000000000000000000000000000000000000077777777777777777b650000677777122177777d6555555555555551600000006555555130003666
e88ee88e000000000000000000000000000000000000000077777770077777777b650000677771222217777d6555555555555551600000006555555330003666
e888888e6666666000000000000000000000000000000000777777088077777777650000677712222221777d6555555555555551600000006555555663303666
e888888e0440044000006000000600000000000000000000777777088077777777650000677122222222177d6555555555555551600000006555553330003666
0e8888e0000000440000660cc0660000000000000000000077775500005577777b650000671222222222217d6555555555555551600000006555556663303666
00e88e00000000000000661991660000000000000000000077756600006657777b650000612222222222221d6555555555555551600000006555533330003666
000ee00000000000000066199166000000000000000000007756660000666577776555551222222222222221655555555555555150000000d111166663303666
00088000990000990000661991660000000000000aa0000077566000000665777765555512222222222222216555555555555551000036667111111500003666
0006600096776669000000511500000000000000a9aa000077566000000665777b650000612222222222221d6555555555555551000036666000000000033333
0006600097666669000000011000000000000000aa9a000077566666666665777b650000671222222222217d6555555555555551000036666000000000066666
00066000966666590000000cc0000000000000000aa00000775666666666657777650000677122222222177d6555555555555551000036666000000000333333
00066000096666900000000c000000000000000000000000777566666666577777650000677712222221777d6555555555555551000036666000000000666666
00866800096665900000000000000000000000000000000077775555555577777b650000677771222217777d6555555555555551000036666000000003333333
08866880009559000000000700000000000000000000000077777777777777777b650000677777122177777d6555555555555551000036666000000006666666
0000000000099000000000007000000000000000000000007777777777777777776500007dddddd11dddddddd11111111111111d00003666d100000006666666
00aaaaaa00000000000aaaa0000000000000aaa000000000777777777777777700aaaaaa0000000000000000000000000880000000000000ffffffff44444444
0a999999a000000000a9999a000000000000a9a00000000077777777777777770a999999a000000000000000000000008228000000000000f44f444f44464444
a9979a999a0000000a9979a9a00000000000a9a0000000007777777777777777a99999999a000000000000000000000082280000000000004444446444444464
a979aaa99a0000000a979aa9a00000000000a9a0000000007777777777777777a99999999a000000000000000000000008800000000000004444444444444444
a979a9999a0000000a979a99a00000000000a9a00000000000a999999a000000a99999999a000000000000000000000000000000000000004464444444644444
a979aaa99a0000000a979aa9a00000000000a9a00000000000a999999a000000a99999999a000000000000000000000000000000000000004444464444444644
a99999a99a0000000a9799a9a00000000000a9a00000000000a999999a000000a99999999a0000000000000000000000000000000000000046444444f644f4f4
a999aaa99a0000000a999aa9a00000000000a9a00000000000a999999a000000a99999999a0000000000000000000000000000000000000044444444ffffffff
00aaaaaa00000000000aaaa0000000000000aaa000000000000aaaa00000000000aaaaaa0000000000000000dddddddddddddddd00000000ffcccccccccccccc
0a999999a000000000a9999a000000000000a9a00000000000a9999a000000000a999999a000000000000000dddddddddddddddd00000000ffccc55555555555
a9979a999a0000000a9979a9a00000000000a9a0000000000a999999a0000000a99999999a00000000000000dd9dddddddddd9dd00000000ff55556666666666
a979aaa99a0000000a979aa9a00000000000a9a0000000000a999999a0000000a99999999a00000000000000dddd99999999dddd000000005556676666666666
a979a9999a0000000a979a99a00000000000a9a0000000000a999999a0000000a99999999a00000000000000ddd9900000099ddd000000006676676666662d66
a979aaa99a0000000a979aa9a00000000000a9a0000000000a999999a0000000a99999999a00000000000000ddd9000000009ddd00000000667667666666d266
a99999a99a0000000a9799a9a00000000000a9a0000000000a999999a0000000a99999999a00000000000000ddd9000cc0009ddd00000000f676676666662d66
a999aaa99a0000000a999aa9a00000000000a9a0000000000a999999a0000000a99999999a00000000000000ddd900cccc009ddd00000000f67667666666d266
0a999a99a000000000a999aa000000000000a9a00000000000a9999a000000000a999999a000000000000000ddd900cccc009dddccccccfff676676666666666
00aaaaaa00000000000aaaa0000000000000aaa000000000000aaaa00000000000aaaaaa0000000000000000ddd9000cc0009ddd5555ccfff676676666666666
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddd9000000009ddd6665555f6676675555555555
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddd9900000099ddd666766556675555555555555
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddd4999999994ddd666766765555551111111111
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dddd44444444dddd66676676555ccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dd9dddddddddd9dd6667667ffccccccccccccccc
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dddddddddddddddd66676676ffcccccccccccccc
660000660000000000080000333333334444444433333333b44444444444444b3333333399999999444444449999999944444444444444449999999966676676
6000000600000000000800003bb3bbb344454444b3333333b44544444445444b33b3bbb394494449444f444449999999444f4444444f4444994944496667667f
000000000000000000000000b44b445b444444544b3333333b444454444444b3333b445b444444f4444444f444999999944444f4444444f9999444f455576676
000000000000000088080880444444444444444444bb3b333b444444444444b333b4444444444444444444444444949994444444444444499944444455555576
00000000000000000000000044544444445444444454b4b333bbb444445443b33b54444444f4444444f4444444f4449999f4944444f4494994f4444411555555
00000000000000000008000044444544b444b5b44444454b33b3b5bbb444bb333b44454444444f4444444f4444444f4999494f4444444f9994444f44ccccc555
600000060000000000080000454444443bbb3b3b4544b44b35333b333bbb3b333b4444444f4444449f4494944f4494499f9994999f4494999f444444cccccccc
66000066000000000000000044444444333333334444444b3333333333333333b4444444444444449999999944444444999999999999999944444444cccccccc
03000000000003000990000000000000200000020220000020000002000000009090090920000002000000000c0000111000000c011000000220000000000000
0030000000003000aa99000000000000020220202882000002022020000990000909909002022020000000000110011111000011177100002822000000000000
0003000000030000aa9900000000000002222220288200000222222000999900009aa90002222220000000000011011111000110177100002282000000000000
00025555503000000a90000000000000025555200220000002555520099aa99009aaaa9002555520000000000001111111111100011000000220000000000000
00038858832000000000000000000000028558200000000002855820099aa99009aaaa9002855820000000001111551515511110000000000000000000000000
0333553553333000000000000000000002055020000000000205502000999900009aa90002055020000000001001885158810010000000000000000000000000
30033333330003000000000000000000202002020000000020200202000990000909909020200202000000001001555155510011000000000000000000000000
00303030303000300000000000000000202002020000000000200002000000009090090920000200000000001101111111110001000000000000000000000000
20303030300300000000000000000000000000000000000000000000000000000000000000000000000000000101000100010001000000000000000000000000
33030030030300200000000000000000000000000000000000000000000000000000000000000000000000001101000100010011000000000000000000000000
20003000300032000000000000000000000000000000000000000000000000000000000000000000000000001001000c00010010000000000000000000000000
00003000300020000000000000000000000000000000000000000000000000000000000000000000000000001011000000010010000000000000000000000000
00020000020002000000000000000000000000000000000000000000000000000000000000000000000000001010000000110010000000000000000000000000
0020000000200000000000000000000000000000000000000000000000000000000000000000000000000000c0110000001000c0000000000000000000000000
02000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000c0000c000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0055550000000000aaaa000000000000000000000000000000000000000000000220000000808090908080000dd0000000000000000000000000000000000000
05dddd5000000000a88a0000000000000000a000000a000000000200002000002cc200000090999899909000d22d000000000000000000000000000000000000
58855885000000009889000000000000000040000004000000020200002020002cc200000099988988999000d22d000000000000000000000000000000000000
05d55d50000000009999000000000000000044000044000000020020020020000220000000000999990000000dd0000000000000000000000000000000000000
00555500000000000000000000000000000404000040400000002020020200000000000030089989899800300000000000000000000000000000000000000000
000dd00000000000000000000000000000a0040440400a0000002022220200000000000003080098900803000000000000000000000000000000000000000000
00055000000000000000000000000000000004444440000000002211112200000000000000300009000030000000000000000000000000000000000000000000
00055000000000000000000000000000000004444440000000202882288202000000000003000099900003000000000000000000000000000000000000000000
0000000000000000000000000000000000999884488999900d020212212020d00000000030000999990000300000000000000000000000000000000000000000
0000000000000000000000000000000000a00944449000a000002022220200000000000000009009009000000000000000000000000000000000000000000000
00000000000000000000000000000000000009944990000000020001100020000000000000088099908800000000000000000000000000000000000000000000
00000000000000000000000000000000000099099099000000200002200002000000000000300098900030000000000000000000000000000000000000000000
000000000000000000000000000000000009090000909000000d00222200d0000000000003000009000003000000000000000000000000000000000000000000
00000000000000000000000000000000009009000090090000000200002000000000000000003399933000000000000000000000000000000000000000000000
0000000000000000000000000000000000a0090000900a0000000200002000000000000000030998990300000000000000000000000000000000000000000000
0000000000000000000000000000000000000a0000a0000000000000000000000000000033300909090033300000000000000000000000000000000000000000
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
0000000000000101000001860000000000000000000000000101010100060000000000000001000001000000000000000000000000001100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000082828282820082820000000000000000828280000101010102000000000000008200000001010101000000010100000000000000010100010100000101
__map__
eaefefefefefefefefefefefefefefd8fefafacbccdcc4dbdbdbdbdbdbc3dcdcdcc1dcdcdcdce1f0f0f0f0f0f0f0f0f0f0f0f0e5f5f5f5f5f5f5f5f5f5f5f5c5dbc6f5f5f5f5f5f5f50af31d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d3b3c3b3c3b3c3b3c3b3c3b3c3b3c3b3c1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d0000000000
fecbcbcbcbcbcbcbcbcbcbcbcbfafafffefafacbccdcdcc5dbdbdbdbc3c1dcdcdcdcdcdce1f0f0f0f0f1f0f0f0f0f1f0f0f0e5f5f5f5f5f6f5f5f5f5f5f5f5c5dbc6f5f6f5f5f5f5f50af31dc0c01d1d1df3f3f3f31d1d1dc0c01d2b2c2b2c2b2c2b2c2b2c2b2c2b2c2b2c1d1d1d1d1d1d1d1d1d1d1d1d1d1d1d2b0000000000
fecbcbcbcbcbcbcbcbcbcbcbcbfafafffefafacbccdcdcc4cacacac3dcdcdcdcdcdcdcdcdce1f0f0f0f0f0f0f0f0f0f0f0f0e5f5f5f5f5f5f5f5f5f6f5f5f5c5dbc6f5f5f5f5f5f5f50af31dc00b1df3f3f3f3f3f3f3f31d0bc01d3b3c3b3c3b3c3b3c3b3c3b3c3b3c3b3c1d1d1d1d1d1d1d1d1d1d1d1d1d2b2c3b0000000000
fecbcbcbcbcbcbcbcbcbcbcbcbcbcbfffefacbcbccc1dcdcdcdcdcdcdcdcdcdcdcdcdcdcdcdce1f0f0f0f0f0f1f0f0f0f0f0e5f5f5f5f5f5f5f5f5f5f5f5f5c5dbc6f5f5f5f5f5f5f50af31d0b1df32b2c2b2c2b2c2b2cf31d0b1d2b2c2b2c2b2c2b2c2b2c2b2c2b2c2b2c1d1dc01dc01dc01d1d1d1d2b2c3b3c2b0000000000
fecbcbcbcbcbcbcbcbcbcbcbcbcbcbfffecbcbcbccdcdcdcdcdcdcdcc1dcdcdcc1dcdcdcdcdce1f0f0f1f0f0f0f0f0f0f0f0e5f5f5f6f5f5f5f5f5f5f5f5f5c5dbc6f6f5f5f5f5f51819f3f3f3f3f33b3c3b3c3b3c3b3cf3f3f3c0c03c3b3c3b3c3b3c3b3c3b3c3b3c3bc0f3f3f3f3f3f3f3f3f32b2c3b3c2b2c3b0000000000
fecbcbcbcbcbcbcbcbcbcbcbcbcbcbfffecbcbcbccdcdcc1dcdcdcdcdcdcdcdcdcdcdcdcdce1f0f0f0f0f0f0f0f07e797bf0e5f5f5f5f5f5f5f6f5f5f5f6f5c5dbc6f5f5f5f5f5d3f3c0c02b2c2b2c2b2cc0f3f3c02b2c2b2c2b2cf3f32b2c2b2c2b2c2b2c2b2c2b2cf3f3f32b2c2b2c2b2c2b2c3b3c2b2c3b3c2b0000000000
fecbcbcbcbcbcefdfdcfcbcbcbcbcbf8d7cbcbcbccdcdcdcdcdcc1dcdcdcc1dcdcdcc1dce1f0f0f0f0f0f0f0f07ef27af279794e4e4e4e4e4e4e4e4e4ed6f5c7dbdbd4f5f5f5d3f3f3c0f33b3c3b3c3b3cf30b0bf33b3c3b3c3b3cf3f33b3c3b3cc0c0c0c03b3c3b3cf3f3f33b3c3b3c3b3c3b3c2b2c3b3c2b2c3b0000000000
fecbcbcbcbcbcd5b5cfccbcbcbcbcbebeccbcbcbccdcdcdcdcdcdcdcdcdcdcdc7873737373797bf0f0f1f0f07ef27df07c7a7a7a4f4f4f4f4f4f4f4f4fe6f5f55e5f6df5f5d3f3f3f3f3f32b2c2b2c2b2cf31d1df32b2c2b2c2b2cf3f32b2c2b2cc0292ac02b2c2b2cf3f3f32b2c2b2c2b2c2b2c3b3c2b2c3b3c2b0000000000
fecbcbcbcbcbcd6b6cfccbcbcbcbcbebeccbcbcbcc7375c1dcdcdcdcc1787373d0747474747ad07979797979f27df0f0f0f0f0e5f5f5f5f5f5f5f5f5f5f5f6f56e6f7ff5f5e3f4f3f3f3f33b3c3b3c3b3cf31d1df33b3c3b3c3b3cf3f33b3c3b3cc0393ac03b3c3b3cf3f3f33b3c3b3c3b3c3b3c2b2c3b3c2b2c3b0000000000
fecbcbcbcbcbdeededdfcbcbcbcbcbebeccbcbcbcc74d0737373737373d0747477dcdcdce1f07c7a7a7a7a7d7df0f0f0f0e5f5f5f5f5f5f5f5f5f5f5f5f5f5f5c5dbc6f5f5f5e3f4f3c0f32b2c2b2c2b2cc0f3f3c02b2c2b2c2b2cf3f32b2c2b2cc0c0c0c02b2c2b2cf3f3f32b2c2b2c2b2c2b2c3b3c2b2c3b3c2b0000000000
fecbcbcbcbcbcbcbcbcbcbcbcbcbcbebeccbcbcbccdc7674747474747477dcdcdcdcdcdce1f0f0f0f0f0f0f0f0f0f0f0f0f0e5f5f5f5f5f5f5f5f5f5f5f5f5f5c5dbc6f5f5f5f5e309c8c03b3c3b3c3b3c2b2c2b2c3b3c3b3c3b3cf3f33b3c3b3c3b3c3b3c3b3c3b3cf3f3f33b3c3b3c3b3c3b3c2b2c3b3c2b2c3b0000000000
fecbcbcbcbcbcbcbcbcbcbcbcbcbcbf7e7cbcbcbccdcc1dcdcdcdcdcdcdcdcc1dcdcdce1f0f0f0f0f0f0f1f0f0f1f0f0f0e5f5f5f5f5f5f5f5f5f5f5f5f5f5f5c5dbc6f5f5f5f5f51a1bf3f3f3f3f32b2c3b3c3b3c2b2cf3f3f3c0c02c2b2c2b2c2b2c2b2c2b2c2b2c2bc0f3f3f3f3f3f3f3f3f33b3c2b2c3b3c2b0000000000
fecbcbcbcbcbcbcbcbcbcbcbcefdfdfffecbcbcbccdcdcdcdcdcdcdcc1dcdcdcdcdcc1dce1f0f0f0f0f0f0f0f0f0f0f0f0e5f5f5f5f5f6f5f5f6f5f5f5f5f5f5c5dbc6f5f5f5f5f5f50af30b0b0bf33b3c2b2c2b2c3b3cf30b0b0b3b3c3b3c3b3c3b3c3b3c3b3c3b3c3b3c0b0bc00bc00bc00b0b0b0b3b3c2b2c3b0000000000
fecbcbcbcbcbcbcbcbcbcbcbcdddfbfffefacbcbccdcdcdcc1dcdcdcdcdcdcdcdcdcdcdce1f0f0f0f0f1f0f0f0f0f0f0f0e5f5f5f5f5f5f5f5f5f5f5f5f5f5f5c5dbc6f5f5f5f5f5f50af31dc01d0bf3f33b3c3b3cf3f30b1dc01d2b2c2b2c2b2c2b2c2b2c2b2c2b2c2b2c1d1d0b1d0b1d0b1d1d1d1d0b0b3b3c2b0000000000
fecbcbcbcbcbcbcbcbcbcbcbcdfbfbfffefafacbccdcc1dcdcdcdcdcdcdcc1dcdcdcdce1f0f0f0f0f0f0f0f0f0f1f0f0e5f5f5f5f5f5f5f5f5f5f5f6f5f5f6f5c5dbc6f5f5f5f5f5f50af31dc0c01d0b0bf3f3f3f30b0b1dc0c01d3b3c3b3c3b3c3b3c3b3c3b3c3b3c3b3c1d1d1d1d1d1d1d1d1d1d1d1d1d0b0b3b0000000000
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
01040000160501620016100191001b100000000000006000190000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000070500a5500e0000e70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000030340194402b34011430223300b4301e33008430163200541011310024100b31000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000115500c550085500c0000c0000c0000e0000e0010e0010000000000000000c0000c0010c0010000000000000001300013001000000c0000c001000000e00000000000000000000000000000000000000
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
0103000028250202301a230102200c220082100720005200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d00001832020700130001a5001e320217001200017700183201b0000f0001e500203201850012700157001832020700020000a00022320157001170014000203200f5001f320195001170014700183200f500
000d020118050180501b05018050090000d0000e1001000018050180501b050180500670010500067000a10018050180501b050180501d0501f05020050210501e05000000000001d050180001b0501805018050
000d00000c0500c0500f0500c050090000d0000e100100000c0500c0500f0500c0500670010500067000a1000c0500c0500f0500c0501105013050140501505012050000000000011050000000f0500c0500c050
000d00000c3530a000000000a0000c655000000c353000000c3530000000000000000c6550000000000000000c3530000000000000000c655000000c353000000c353000000c003000000c353000000c65500000
001000000e550054000e0000e5500c5500e55013550000000c0000c55000500005000e55000500005000e5500c5500e5501555000500005000c55000000000000e5500e5010e5010000000000000000000000000
000d000012050265001a500110501100019500110500f0501205000000000001105011000000001305014050130500000000000110501100000000110500f0501205000000000001105011000000000f0500c050
000d00001e050265001a5001d05011000195001d0501b0501e05000000000001d05011000000001f050200501f05000000000001d05011000000001d0501b0501e05000000000001d05000000000001b05018050
001000000c0530000010603100530c0030c0530c0530c00303300100530c0030c0530c0530000000000100530c0030c0530c053000000c000100530c0000c0000c0030000010603100030c0030c0030c0030c003
001000000b55008000000000b550095500b5500e550030000c0000000000000000000b55008000000000b550095500b5501055000000000000000000000000000000000000000000000000000000000000000000
000f0000190001600116001110000c0000e00013000000001100011001000000000013000000000c000000001500015001150011500115001150011500100000130001300100000000000c0000c0010000000000
000f0000110000e00011000110000c0000e00011000110001500016001150011600115001160010c0010c000180001800100000000000c000000000e000000000c0000c0000c0000e0000e000110001100011605
001000000c0300c0210c0110c0010c0000c0000e0300e0210e0110000000000000000c0300c0210c0110000000000000001305013050000000c0500c0500c0000e05000000000000000000000000000000000000
0014000d0a25003250000000425000000074500b2500f450016300a10001630077500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0112000005735095450574508035090350105502545040450a05503555090550005506745045550675505735095450574508035090350105502545040450a0550355509055000550674504555067550573509515
011000000475506755067550675506755047550975509755097550975509755097550975506755067550675505755057550575504755067550675506755067550475509755097550975509755097550975509755
0110000015314113140e3140000012563165531056300000000000000000000123140d314103140000010563165630d563000000000015314113140e3140000011563185631056300000113140d3140431400000
011000000a0420a042000000a042000000000008041000000a0420a042000000a032000000000008041000000a0420a042000000a032000000000008041000000a0420a042000000a03200000000000804100000
011000000000007063055630406306563000000506305563045630706300000000000000000000000000000000000070630556304063065630000006063055630456307063000000000000000000000000000000
011000000c1530e1530b1530b1530d1530b1530b1530e1530b153000000000000000000000000000000000000c1530e1530b1530b1530d1530b1530b1530e1530b15300000000000000000000000000000000000
01100000080750a075090750a07508075080750a075090750a07508075080750a075090750a07508075080750a075090750a07508075080750a075090750a07508075080750a075090750a07508075080750a075
01100000080640a064090640a06408064080640a064090640a06408064080640a064090640a06408064080640a064090640a06408064080640a064090640a06408064080640a064090640a06408064080640a064
011000000506205562055020706205562000020506205562045620706200002000020000200002000020000205062055620550204062065620000206062055620456207062000040000400000000000000000000
011000000605306053080520805306053060520655306553085530855306552065530675306752087530875306053060530805208053060530605206553065530855308553065520655306753067520875308753
011000000115101151011510615106151061510215102151021510000100001000010000100001000010000101151011510115106151061510615102151021510215100001000000000000000000000000000000
001000000460003403044030440305403054030240302403034330343304433044330543305433024330243300000000000000000000000000000000000000000343303433044330443305433054330243302433
01100000140121a01212012140121b01214012150121b01214012150121b01214012150121b012140001a000140121a01212012140121b01214012150121b01214012150121b01214012150121b012150001b000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
01 1d181e1b
02 1a18191b
00 4e4f4d45
04 431c1f20
00 231c1f20
01 21222344
00 4c424344
00 5e424344
00 60424344
03 201f4344
01 22624344
02 21424344
01 23424344
02 24424344
03 25424344
03 26274344
03 28294544
03 2a424344
03 2b2a4344
03 2b2a2c44
03 282d4344
03 6e2f7071
03 2f313044
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
