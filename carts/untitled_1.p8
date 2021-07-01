pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

chrono=0
flip=true

function init_()
end

function _update()
	if (chrono%3 == 0) then 
		flip = not flip
		print (flip)
		//print (chrono,50,50,1,1,flip,flip)
	end
end

function _draw()
	cls()
	spr(0,32,32,1,1,flip)
	chrono += 1
end

__gfx__
00000077770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000777677000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00007770667700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077700066770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777000006677000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07770000000667700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77700000000066770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77000000000006670000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
