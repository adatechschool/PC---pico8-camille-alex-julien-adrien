pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--page 0
--var glob
function _init()
	make_grid()
	p = {}
	p.x = 2
	p.y = 2
	p.speed = 1
	p.angle = 0
	p.rotate_speed = 0.02
	cmpss = {}
	cmpss.x = 100
	cmpss.y = 20
	cmpss.r = 5
	cmpss.c1 = 6
	cmpss.c2 = 5
	cmpss.c3 = 8
	
end
function _update()
	if (btn(⬇️)) p.angle += p.rotate_speed
	if (btn(⬆️)) p.angle -= p.rotate_speed
	if (btn(➡️)) move_player(1)
	if (btn(⬅️)) move_player(-1)
end
function _draw()
	cls()
	minimap()
	draw_compass()
	draw_walls()
end


function draw_walls()
	for pix = 0, 128 do
		--ratio entre -1 et 1
		ratio = (pix-64)/64
		dirx = cos(p.angle)/2+cos(p.angle-0.25)*ratio
		diry = sin(p.angle)/2+sin(p.angle-0.25)*ratio
		mapx = flr(p.x)
		mapy = flr(p.y)
		deltadistx = sqrt(1+(diry^2/dirx^2))
		deltadisty = sqrt(1+(dirx^2/diry^2))
		if (dirx<0) then
			stepx = -1
			sidedistx = (p.x-mapx)* deltadistx
		else
		stepx = 1
		sidedistx = (mapx+1-p.x)* deltadistx
		end
		
		if (diry<0) then
			stepy = -1
			sidedisty = (p.y-mapy)* deltadisty
		else
		stepy = 1
		sidedisty = (mapy+1-p.y)* deltadisty
		end
		
		hit = 0
		while (hit ==0) do
			if (sidedistx < sidedisty) then
				sidedistx += sidedistx
				mapx = stepx
				side = 0
			else
				sidedisty += sidedisty
				mapy = stepy
				side = 1
			end
			print(mapx)
			print(mapy)
			print(#grid)
			if(grid[mapy][mapx] != 0) then //***********
				hit = 1
				end		
		end
		if (side == 0) then
			perpwalldist = (mapx-p.x+(1-stepx/2)/dirx) 
		else
			perpwalldist = (mapy-p.y+(1-stepy/2)/diry)
		end
		wallcolor = (side == 0 and 6 or 7)
		line(pix,64-32/perpwalldist,pix,64+32/perpwalldist,wallcolor)
		
		
	end
end
function draw_compass()
	circfill(cmpss.x,cmpss.y,cmpss.r +2,cmpss.c2)
	circfill(cmpss.x,cmpss.y,cmpss.r +1,cmpss.c1)
	line(cmpss.x,cmpss.y,cmpss.x+cos(p.angle)*cmpss.r,cmpss.y+sin(p.angle)*cmpss.r,cmpss.c3)
end
--creation dヌ█▥une  (la map)
function make_grid()
		grid = {}
		print(#grid)
		-- pour la largeur
		grid.wid = 0
		while (mget(grid.wid,0) != 0) do
			grid.wid += 1
		end
		
		--pour la hauteur
		grid.hei = 0
		while (mget(grid.hei,0) != 0) do
			grid.hei += 1
		end
		for y=1,grid.hei do
				grid[y] = {}
			for x=1, grid.wid do
				grid[y][x] = mget(x-1,y-1)
		end
	end	
end
-- mise en place de la mini-map
function minimap()
	for y = 1,grid.hei do
		for x = 1,grid.wid do
			if (grid[y][x] == 1) then
				pset(x-1,y-1,5)
			else
				pset(x-1,y-1,7)	
			end
		end
	end
	pset(p.x-1,p.y-1,8)
end
function move_player(nb)
	tmpx = p.x +(p.speed * cos(p.angle)) * nb
	if (grid[flr(p.y)][flr(tmpx)] == 0) then
		p.x = tmpx
		end
	tmpy = p.y +(p.speed * sin(p.angle)) * nb
	if (grid[flr(tmpy)][flr(p.x)] == 0) then
		p.y = tmpy
	end	
end


--envoyer un message れき alex soulis
















__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
