pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- free britney ------
function _init()
	create_britney()
	create_pnjs()
end

function _update()
	clavier_listener()
	--
	pnjs_movement()
	britney_movement()
	notes_movement()
end

function _draw()
	cls()
	draw_map()
	draw_britney()
	draw_pnjs()
	draw_notes()
	draw_coeurs()
end
-->8
-- 01 init et gestion du clavier ------

-- pour dessiner la map
function draw_map()
	map(0,0,0,0,128,64)
end

-- initialisation des constantes
britney_spr=17
britney_up=2.5
note_spr=4
garde_spr=5
coeur_spr=10
garde_fan_spr=11
pprz_spr=9
pprz_fan_spr=12
gravity=1

-- initialisation des tableaux
pnjs={}
notes={}
coeurs={}

-- gestion du clavier
function clavier_listener()
	if (btnp(❎) and count(notes) == 0) then 
      add(notes, create_note(britney.x,britney.y,note_spr,britney.sens,2,false))
 end 
 --
 if (btnp(➡️)) then 
 	britney.sens=1
 	britney.flipx=true
 end
 --
 if (btnp(⬅️)) then 
 	britney.sens=-1 
		britney.flipx=false
 end
 --
	if (btnp(🅾️)) then 
		britney.jump_start=true
	end
end





-->8
-- 02 bibliothque de fonctions ------

-- renvoie le sprite a la position x,y, 
-- si il possede le flag passe en parametre
function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end

-- fonction declenchee quand une note touche un pnj
function collision_note_pnj()
	if (count(notes) > 0) then
		for _,note in pairs(notes) do
			for _,pnj in pairs(pnjs) do
				if flr(pnj.x/8) == flr(note.x/8) and pnj.y == note.y and not pnj.fan then
					pnj.fixe=true
					pnj.fan=true
					pnj.sprite=pnj.sprite_fan
					-- on dessine le coeur et on "supprime" la note
					add(coeurs,create_coeur(note.x,note.y,coeur_spr,20))
					deli(notes,1)
				end
			end
		end
	end
end
-->8
-- 03 britney ------

function create_britney()
	britney={
		x=90,
		y=88,
		sprite=britney_spr,
		sens=-1,
		speed=1,
		flipx=false,
		immobile=false,
		jump_start=false,
		jump_up=false, -- pour declencher la phase de montee lors de saut
		jump_down=false, -- pour declencher la phase de descente lors de saut
		jump_height=18, -- hauteur du saut
		y_from=0 -- pour stocker le niveau d'ou on part au moment du saut
	}
end

function draw_britney()
	spr(britney.sprite,britney.x,britney.y,1,1,britney.flipx)
end

function britney_movement()
	newx=britney.x+(britney.sens*britney.speed)
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
	--
	-- gestion des sauts
	if britney.jump_start and not(britney.jump_up or britney.jump_down) then 
		britney.y_from=britney.y
		britney.jump_start=false
		britney.jump_up=true
		britney.jump_down=false
	end
	-- montee
	if britney.jump_up and 1 <0 and not britney.jump_down then
		if britney.y-britney.y_from<britney.jump_height then
			britney.y+=gravity
		else 
			britney.y=britney.y_from+britney.jump_height
			britney.jump_up=false
			britney.jump_down=true
		end
	end
	-- descente
	if britney.jump_down and not britney.jump_up then
		if britney.y>britney.y_from then
			britney.y-=gravity
			print(hrfh)
		else 
			britney.y=britney.y_from
			britney.jump_down=false
	 end
	end
end

-->8
-- 04 pnj -----
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
				-- si le pnj n'est pas deja arrete et rencontre
				-- un obstacle, il se retourne
				if not self.fixe then
					if not check_flag(0,testx,testy) and newx>0 and newx<120 then
							self.x=mid(0,newx,120)
					else
				 		self.sens=self.sens*-1
				 		self.flipx=not self.flipx
					end
				end
				--
				-- si le pnj est arrete, on decrement un compteur
				-- et on le fait repartir quand le chrono est epuise
				if self.fixe and self.chrono_fixe>0 then
					self.chrono_fixe -=1
				else 
						self.fixe=false
						self.chrono_fixe=100
						self.sprite=sprite
						self.fan=false
				end
		end,
		-- transforme le pnj en fan
		pnj_to_fan = function (self)
				self.sprite=sprite_fan
				self.fixe=true
				self.fan=true	
		end
	}
	return pnj
end

function create_pnjs()
	add(pnjs, create_pnj(0,0,garde_spr,garde_fan_spr,-1,1,false,false,420,false))
	add(pnjs, create_pnj(0,16,pprz_spr,pprz_fan_spr,-1,1,false,false,420,false))
	add(pnjs, create_pnj(50,88,pprz_spr,pprz_fan_spr,1,1.2,true,false,420,false))
end

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
-- 05 tir (note et coeur) --------

function create_note(x,y,sprite,sens,speed,flipx)  
  note=
  {x=x,
  	y=y,
  	sprite=sprite,
  	sens=sens,
  	speed=speed,
  	flipx=flipx,
  	---------
  	draw_note = function(self)
    spr(self.sprite,self.x,self.y,1,1,self.flipx)
   end,
   --
   note_movement = function(self)
	    newx=self.x+self.sens*self.speed
	    newy=self.y
	    --
	    testx=flr(newx/8)+1
	    testy=flr(newy/8)
	    --
	    if not check_flag(0,testx,testy) and newx>0 and newx<120 then
	     self.x=mid(0,newx,120)
	    else
	    	deli(notes,1)
	    end
	    --
	    collision_note_pnj()  
	  end
  	}
  return note
end


function create_coeur(x,y,sprite,duration)
		coeur=
  {x=x,
  	y=y,
  	sprite=sprite,
  	duration=duration,
  	-- fonction pour afficher le coeur
  	-- avec un compteur qu'on decremente pour effacer le coeur 
  	-- au bou d'un ceratin temps
  	draw_coeur = function(self)
    spr(self.sprite,self.x,self.y)
    --
    self.duration-=1
    if (self.duration <0) then
   			deli(coeurs,1)
   	end
   end
 	}
 	--
  return coeur
end

------------

function draw_notes()
	foreach(notes, function(note)
  note:draw_note()
	end)
end

function notes_movement()
	foreach(notes, function(note)
  note:note_movement()
	end)
end

function draw_coeurs()
	foreach(coeurs, function(coeur)
  coeur:draw_coeur()
	end)
end

function xnotes_movement()
    --
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
	    --
	    collision_note_pnj()  
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
0000000077aaaaa7777fff7700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000077a0aaa77770ff7700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000076affaa7777fff7700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000075788aa87778888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000758888777888887700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000757668777776687700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777888777778887700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777878777778787700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010002040000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0606060606061010100602060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060610100606101002060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060610101010101010060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060610100602101010060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060602020202101010060000060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060610101010101010100000060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606020610101010101002100600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0602021010101010101002060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060006060602060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
