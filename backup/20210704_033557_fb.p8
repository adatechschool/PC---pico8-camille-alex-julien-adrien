pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- 00------
function _init()
	create_britney()
end

function _update()
	pnjs_movement()
	britney_movement()
	tir_note()
	note_movement()
	--
	collision_note_pnj()
end

function _draw()
	cls()
	draw_map()
	draw_britney()
	draw_pnjs()
	draw_note()
	draw_coeur()
end
-->8
-- 01 ------

-- pour dessiner la map
function draw_map()
	map(0,0,0,0,128,64)
end

-- initialisation des constantes
britney_spr=17
note_spr=4
garde_spr=5
coeur_spr=10
garde_fan_spr=11
pprz_spr=9
pprz_fan_spr=12






-->8
-- 02 ------

pnjs={}

function create_pnj(x,y,sprite,sprite_fan,sens,speed,flipx,fixe,chrono_fixe)
	pnj={
		x=x,
		y=y,
		sprite=sprite,
		sprite_fan=sprite_fan,
		sens=sens,
		speed=speed,
		flipx=flipx,
		fixe=fixe,
		chrono_fixe=chrono_fixe,
		fan=fan,
		--
		draw_pnj = function(self)
				spr(self.sprite,self.x,self.y,1,1,self.flipx)
		end,
		--
		pnj_movement = function (self)
				newx=self.x+(self.sens*self.speed)
				newy=self.y
				--
				testx=flr(newx/8)+1
				testy=flr(newy/8)
				--
				if not self.fixe then
					if not check_flag(0,testx,testy) and newx>0 and newx<120 then
							self.x=mid(0,newx,120)
					else
				 		self.sens=self.sens*-1
				 		self.flipx=not self.flipx
					end
				end
		end,
		--
		pnj_to_fan = function (self)
				self.sprite=sprite_fan
				self.fixe=true
				self.fan=true
		end
		-- 
--	if pnj.fixe and pnj.chrono_fixe>0 then
--			pnj.chrono_fixe -=1
--	else 
--			pnj.fixe=false
--			pnj.chrono_fixe=100
--			pnj.sprite=5
	--
--	end
	}
	return pnj
end

add(pnjs, create_pnj(0,0,garde_spr,garde_fan_spr,-1,1,false,false,420,false))
add(pnjs, create_pnj(0,16,pprz_spr,pprz_fan_spr,-1,1,false,false,420,false))
add(pnjs, create_pnj(50,88,pprz_spr,pprz_fan_spr,1,1,true,false,420,false))

function draw_pnjs()
	foreach(pnjs, function(pnj)
  pnj:draw_pnj()
	end)
end

function pnjs_movement()
	foreach(pnjs, function(pnj)
  pnj:pnj_movement()
	end)
end


-->8
-- 03 ------
-- renvoie le sprite a la position x,y, 
-- si il possede le flag passe en parametre
function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end
-->8
-- 04--------
notes={}
coeurs={}

function create_note(x,y,sprite,sens,speed,flipx)  
  note=
  {x=x,
  	y=y,
  	sprite=sprite,
  	sens=sens,
  	speed=speed,
  	flipx=flipx}
  return note
end

function create_coeur(x,y,sprite,duration)
		coeur=
  {x=x,
  	y=y,
  	sprite=sprite,
  	duration=duration}
  return coeur
end

function draw_note()
    if (count(notes) > 0) then
        spr(notes[1].sprite,notes[1].x,notes[1].y,1,1,notes[1].flipx)
    end
end

function tir_note()
    if (btnp(5) and count(notes) == 0) then 
        add(notes, create_note(britney.x,britney.y,note_spr,britney.sens,2,false))
    end
end

function note_movement()
				if notes[1] != nil then
	    newx=notes[1].x+(notes[1].sens*notes[1].speed)
	    newy=notes[1].y
	    --
	    testx=flr(newx/8)+1
	    testy=flr(newy/8)
	    --
	    if not check_flag(0,testx,testy) and newx>0 and newx<120 then
	     notes[1].x=mid(0,newx,120)
	    else
	    	deli(notes,1)
	    end
	  end
end

function xcollision_note_pnj()
	if (count(notes) > 0) then
		if flr(pnj.x/8) == flr(notes[1].x/8) and not pnj.fan then
			pnj.sprite=pnj.sprite_fan
			pnj.fixe=true
			pnj.fan=true
			add(coeurs,create_coeur(notes[1].x,notes[1].y,coeur_spr,20))
			deli(notes,1)
		end
	end
end

function collision_note_pnj()
	if (count(notes) > 0) then
		for _,note in pairs(notes) do
			for _,pnj in pairs(pnjs) do
			print ("--------")
			print ("pnj.x : "..pnj.x)
			print ("note.x : "..note.x)
			print ("flr pnj : "..flr(pnj.x/8))
			print ("flr note : "..flr(note.x/8))
				if flr(pnj.x/8) == flr(note.x/8) and pnj.y == note.y and not pnj.fan then
					pnj.sprite=pnj.sprite_fan
					pnj.fixe=true
					pnj.fan=true
					print ("dans if")
					--g=flr(pnj.xx/8)
					add(coeurs,create_coeur(note.x,note.y,coeur_spr,20))
					deli(notes,1)
				--	g=flr(pnj.xx/8) ---------
				end
			end
		end
	end
end

function draw_coeur()
    if (count(coeurs) > 0) then
        spr(coeurs[1].sprite,coeurs[1].x,coeurs[1].y)
    				coeurs[1].duration-=1
    				--
    				if (coeurs[1].duration <0) then
   						deli(coeurs,1)
   					end
    end
end

-->8
-- 05 ------
function create_britney()
	britney={
		x=90,
		y=88,
		sprite=britney_spr,
		sens=-1,
		speed=1,
		flipx=false,
		immobile=false
	}
end

function draw_britney()
	spr(britney.sprite,britney.x,britney.y,1,1,britney.flipx)
end

function britney_movement()
	newx=britney.x+(britney.sens*britney.speed)
	newy=britney.y
	--
	testx=flr(newx/8)+1
	testy=flr(newy/8)
	--
	if not check_flag(0,testx,testy) and newx>0 and newx<120 then
			britney.x=mid(0,newx,120)
	else
 		britney.sens=britney.sens*-1
 		britney.flipx=not britney.flipx
	end
end

__gfx__
0000000000aaaa00666666660080080000777777777fff7700000000000000000000000077aaaaa787787788777fff7777aaaaa7000000000000000000000000
000000000aaaaaa066006606008008000070000777700f770000000000000000090080807550ffa77887887877700f777550ffa7000000000000000000000000
00700700aaaaaaaa66600066008778080070000777ffff77000000000000000000aa08007575f0aa7788877877ffff777575f0aa000000000000000000000000
00077000aaaaaaaa6066000600070708007000077000000700000000999888880008aa807555ffaa87787788788888877555ffaa000000000000000000000000
00077000aaaaaaaa66006606077777887770077700070000000000008889999908898000774111778877788888878888778eee77000000000000000000000000
00700700aaaaaaaa66600606077778807770077707070070000000000000000000909a0077444447888787878787887877888887000000000000000000000000
000000000aaaaaa0606666660080880000000000770000770000000000000000090008a077755547888887777788887777788887000000000000000000000000
0000000000aaaa006666666600800800000000007707707700000000000000000000000077757577888888787787787777787877000000000000000000000000
0000000077aaaaa70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000077a0aaa70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000076affaa70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000075788aa80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000758888770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000757668770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777888770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777878770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010002040000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0606060606061010100606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060610100606101010060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060610101010101010060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060610100606101010060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060610101010101010060000060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060610101010101010100000060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060610101010101010100600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606061010101010101010060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060006060606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
