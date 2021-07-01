pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function create_britney()
	p={x=6,y=4,sprite=1,h=8,w=8}
end

function britney_movement()
	newx=p.x
	newy=p.y
	if(btnp(➡️)) newx+=8
	if(btnp(⬅️)) newx-=8
	if(btnp(⬆️)) newy-=8
	if(btnp(⬇️)) newy+=8
	
	print("test",0,0,7)
	
	if (newx>127-16) then	
		p.x=127
	elseif (newx<0) then
		p.x=0
	else
		p.x=newx 
	end	
	
	if (newy>127-8) then
		p.y=127
	elseif (newy<0) then
		p.y=0
	else
		p.y=newy
	end
end

function draw_britney()
	spr(p.sprite,p.x,p.y)
end

-->8
function draw_map()
	--map(0,0,0,0,128,128)
end


--controle si un sprite porte un flag donne
function check_flag(flag,x,y)
 local sprite=mget(x,y)
 return fget(sprite,flag)
end
-->8
function _init()
	create_britney()
	--draw_map()
end

function _update()
	britney_movement()
end

function _draw()
	cls()
	draw_britney()
end
__gfx__
0000000000aaaa006666666666600666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000af1f1a06666666666600666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000aafffa06666666666600666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000aafefa06666666666600666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007600022e22e226666666666600666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000eeee006666666666600666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000e00e006666666666600666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000e00e006666666666600666666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020203020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020203020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020203020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020203020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020203020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
