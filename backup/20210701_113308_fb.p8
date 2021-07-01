pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- 00------
function _init()
	create_player()
	create_pnj()
	create_note()
	--
	create_laser()
end

function _update()
	player_movement()
	pnj_movement()
	tir_note()
	note_movement()
	laser_movement()
end

function _draw()
	cls()
	draw_map()
	draw_player()
	draw_pnj()
	draw_note()
	draw_laser()
	--
	--draw_fire()
end
-->8
-- 01 ------

function draw_map()
	map(0,0,0,0,128,64)
end

function create_player()
	p={
		x=1,
		y=1,
		sprite=1,
		flipx=false
	}
end

function player_movement()
	newx=p.x
	newy=p.y

	if (btnp(⬅️)) newx-=1
	if (btnp(➡️)) newx+=1
	--if (btnp(⬆️)) newy-=1
	--if (btnp(⬇️)) newy+=1
	
	if not check_flag(0,newx,newy) then
			p.x=mid(0,newx,15)
			p.y=mid(0,newy,15)
	end
end

function draw_player()
	spr(p.sprite,p.x*8,p.y*8,1,1,p.flipx)
end





-->8
-- 02 ------
function create_pnj()
	pnj={
		x=9,
		y=28,
		sprite=5,
		sens=1,
		speed=1,
		flipx=true
	}
end

function draw_pnj()
	spr(pnj.sprite,pnj.x,pnj.y,1,1,pnj.flipx)
end

function pnj_movement()
	newx=pnj.x+(pnj.sens*pnj.speed)
	newy=pnj.y
	--
	testx=flr(newx/8)+1
	testy=flr(newy/8)
	--
	if not check_flag(0,testx,testy) and newx>0 and newx<120 then
			pnj.x=mid(0,newx,120)
	else
 		pnj.sens=pnj.sens*-1
 		pnj.flipx=not pnj.flipx
	end
end

-->8
-- 03 ------
function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end
-->8
function create_note()
	note={
		x=pnj.x,
		y=pnj.y,
		sprite=20,
		sens=pnj.sens,
		speed=3,
		flipx=false
	}
end

function draw_note()
		spr(note.sprite,note.x,note.y,1,1,note.flipx)
end

function tir_note()
	if (btnp(⬆️)) then 
		note.sprite=4
		note.x=pnj.x
		note.y=pnj.y
		note.sens=pnj.sens	
		note.flipx=pnj.flipx
		end
end

function note_movement()
	newx=note.x+(note.sens*note.speed)
	newy=note.y
	--
	testx=flr(newx/8)+1
	testy=flr(newy/8)
	--
	if not check_flag(0,testx,testy) and newx>0 and newx<120 then
			note.x=mid(0,newx,120)
	else
 		note.sens=note.sens*-1
 		note.flipx=not note.flipx
	end
end

-->8
function create_laser()
	laser={
		x=pnj.x,
		y=pnj.y,
		sprite=20,
		sens=pnj.sens,
		speed=3,
		flipx=false
	}
end

function draw_laser()
	spr(laser.sprite,laser.x,laser.y,1,1,laser.flipx)
end

function tir_laser()
	if (btnp(⬇️)) then 
		laser.sprite=7
		laser.x=pnj.x
		laser.y=pnj.y
		laser.sens=pnj.sens	
		laser.flipx=pnj.flipx
		end
end

function laser_movement()
	newx=laser.x+(laser.sens*laser.speed)
	newy=laser.y
	--
	testx=flr(newx/8)+1
	testy=flr(newy/8)
	--
	if not check_flag(0,testx,testy) and newx>0 and newx<120 then
			laser.x=mid(0,newx,120)
	else
 		laser.sens=laser.sens*-1
 		laser.flipx=not laser.flipx
	end
end

__gfx__
0000000000aaaa00666666660080080000777777777fff7700000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaaaaa066006606008008000070000777700f7700000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aaaaaaaa66600066008778080070000777ffff7700000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaaa6066000600070708007000077000000700000000999888880000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaaa6600660607777788777007770007000000000000888999990000000000000000000000000000000000000000000000000000000000000000
00700700aaaaaaaa6660060607777880777007770707007000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaaaaa06066666600808800000000007700007700000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aaaa006666666600800800000000007707707700000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0606060606060206020606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606020606060206060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060602060606060206060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060606060206060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060606060206060602060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060606060206020202060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606020206060202060602020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060202060606060602060200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060206060606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
