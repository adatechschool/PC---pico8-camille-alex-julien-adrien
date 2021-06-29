--variables globales
btn_speed=1
spr_width=7
spr_height=7


function _init()
	x=60
	y=30
end

function _update()
	if(btn(➡️)) x+=1
	if(btn(⬅️)) x-=1
	if(btn(⬆️)) y-=1
	if(btn(⬇️)) y+=1
	
	if(x>127-spr_width) then
		x=127-spr_width
	end
	if(x<0) then
		x=0
	end
	if(y>127-spr_height) then
		y=127-spr_height
	end
	if(y<0) then
		y=0
	end
end

function _draw()
 cls()
	map(0,0,0,0)
	spr(1,x,y)

end
