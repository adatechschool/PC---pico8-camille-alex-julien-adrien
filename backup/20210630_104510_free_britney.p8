pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function create_britney()
	p={x=6,y=4,sprite=1,h=8,w=8}
end

function britney_movement()
	newx=p.x
	newy=p.y
	speed=1
	if(btnp(➡️)) newx+=speed
	if(btnp(⬅️)) newx-=speed
	if(btnp(⬆️)) newy-=speed
	if(btnp(⬇️)) newy+=speed
	
	if (newx>127-p.w) then	
		p.x=127-p.w
	elseif (newx<0) then
		p.x=0
	else
		p.x=newx 
	end	
	
	--print(check_flag(0,newx,newy))
	if (not check_flag(0,newx,newy)) then
		if (newy>127-p.h) then
			p.y=127-p.h
		elseif (newy<0) then
			p.y=0
		--else
		--	p.y=p.y
		else 
			p.y=newy
		end
 end
	--print("test")
	
end

function draw_britney()
	spr(p.sprite,p.x,p.y)
end

-->8
function draw_map()
	map(0,0,0,0,128,128)
end


--controle si un sprite porte un flag donne
function check_flag(flag,x,y)
 local sprite=mget(x,y)
 return fget(sprite,flag)
end
-->8
function _init()
	create_britney()
	--print("init")
end

function _update()
	britney_movement()
end

function _draw()
	cls()
	draw_map()
	draw_britney()
end
__gfx__
0000000000aaaa006666666666600666666600060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000af1f1a06666666666600666600606660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000aafffa06666666666600666006600060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000aafefa06666666666600666660006660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007600022e22e226666666666600666606666060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000eeee006666666666600666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000e00e006666666666600666660660060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000e00e006666666666600666606666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0202020402020202020204020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020402020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020402020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040402040404040202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202040202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202040202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202040404020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
