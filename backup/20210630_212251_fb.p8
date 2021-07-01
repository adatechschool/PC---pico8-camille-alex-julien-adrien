pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function _init()
	create_player()
	create_pnj()
end

function _update()
	player_movement()
	pnj_movement()
end

function _draw()
	cls()
	draw_map()
	draw_player()
	draw_pnj()
end
-->8
function draw_map()
	map(0,0,0,0,128,64)
end

function create_player()
	p={
		x=6,
		y=6,
		sprite=1
	}
end

function player_movement()
	newx=p.x
	newy=p.y

	if (btnp(⬅️)) newx-=1
	if (btnp(➡️)) newx+=1
	if (btnp(⬆️)) newy-=1
	if (btnp(⬇️)) newy+=1
	
	if not check_flag(0,newx,newy) then
			p.x=mid(0,newx,15)
			p.y=mid(0,newy,15)
	end
end

function draw_player()
	spr(p.sprite,p.x*8,p.y*8)
end





-->8
function create_pnj()
	pnj={
		x=9,
		y=8,
		sprite=3,
		sens=-1,
		speed=1
	}
end

function draw_pnj()
	spr(pnj.sprite,pnj.x,pnj.y)
end

function pnj_movement()
	newx=pnj.x+(pnj.sens*pnj.speed)
	newy=pnj.y
	--
	testx=8*(-2+flr(newx/8))
	testy=8*(-2+flr(newy/8))
	--
	if not check_flag(0,testx,testy) and newx>0 and newx<120 then
			pnj.x=mid(0,newx,120)
	else
 		pnj.sens=pnj.sens*-1
	end
end

-->8
function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end
__gfx__
0000000000aaaa006666666600800800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaaaaa06600660600800800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aaaaaaaa6660006600877808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaaa6066000600070708000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaaa6600660607777788000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aaaaaaaa6660060607777880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaaaaa06066666600808800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aaaa006666666600800800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000002020000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000002000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000002000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000020000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020000000200000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000200020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000202000002020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000002000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
