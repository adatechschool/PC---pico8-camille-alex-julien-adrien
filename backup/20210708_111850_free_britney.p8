pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- free britney ------
function _init()
  palt(0, false)
	create_britney()
	create_pnjs()
	music(0)
	game_status="start"
end
 
function _update60()
	clavier_listener()
	pnjs_movement()
	britney_movement()
	notes_movement()
end
 
function _draw()
	cls()	
	if game_status=="start"
	then draw_acceuil()		
	else
		if game_status=="victoire"
		then draw_victoire()
	else
			if game_status=="defaite"
			then draw_defaite()
	else 
			 draw_acceuil()	
			 draw_map()
			draw_britney()
			draw_pnjs()
			draw_notes()
			draw_coeurs()
			update_camera()
			end
		end
	end
end
-->8
-- 01 init et gestion du clavier ------
function draw_map()
	map(0,0,0,0,128,64)
end

-- initialisation des constantes
--game_status="start"
--
britney_spr=128
britney_up= 2.3
jump_height=10
britney_speed=1
britney_life=3
britney_ko_spr=129
--
note_spr=135
coeur_spr=134
--
garde_spr=130
garde_speed=1
garde_fan_spr=131
--
pprz_spr=132
pprz_speed=1
pprz_fan_spr=133
--
gravity=1
--
life_x=100
life_y=5
--
flag_mur=0
flag_escalier=7
flag_sortie=6

trace=""
 
-- initialisation des tableaux
pnjs={}
notes={}
coeurs={}
 
-- gestion du clavier
function clavier_listener()
			-- tir des notes
			if (btnp(🅾️) and count(notes) == 0) then 
		      add(notes, create_note(britney.x,britney.y,note_spr,britney.sens_x,2,false))
		 end 
		 -- deplacement
		 if (btn(➡️) and not britney.ko) then 
		 	britney.sens_x=1
		 	britney.sens_y=0
		 	britney.flipx=true
		 	britney.run=true
		 	britney.running=true
		 	britney.speed=britney_speed
		 end
		 --
		 if (btn(⬅️) and not britney.ko) then 
		 	britney.sens_x=-1 
		 	britney.sens_y=0
				britney.flipx=false
				britney.running=true
				britney.speed=britney_speed
		 end
		  --
		 if (btn(⬇️) and not britney.ko) then 
		 	britney.sens_x=0
		 	britney.sens_y=1 
				britney.running=true
				britney.speed=britney_speed
		 end
		 --
		   --
		 if (btn(⬆️) and not britney.ko) then 
		 	britney.sens_x=0
		 	britney.sens_y=-1 
				britney.running=true
				britney.speed=britney_speed
		 end
		 --
		 -- saut + lancement du jeu
			if game_status=="on" 
						and btnp(❎) 
			 		and not britney.ko
			then 
				britney.jump_start=true
			else 
				game_status="on"
			end
end
 

 
 
 
-->8
-- 02 bibliothque de fonctions ------

function update_camera()
 camx=flr(britney.x/128)
	camx=camx*128
	--
	camy=flr(britney.y/128)
	camy=camy*128
	--
	camera(camx,camy)
end



-- renvoie le sprite a la position x,y, 
-- si il possede le flag passe en parametre
function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end

-- renvoie le flag du sprite present aux coordonnees x,y 
function get_flag(x,y)
	local sprite=mget(x,y)
	return fget(sprite)
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
					--
					sfx(0)
				end
			end
		end
	end
end
 
-- fonction declenchee quand britney touche un pnj
function collision_britney_pnj()
	for _,pnj in pairs(pnjs) do
		if not britney.ko 
		   and flr(pnj.x/8) == flr(britney.x/8) 
		   and pnj.y == britney.y 
		   and not pnj.fan 
		then	britney.sens_x=britney.sens_x*-1
							-- quand elle est touchee, britney fait un bond en arrire
							britney.jump_start=true
							britney.ko=true
							britney.life-=1
		end
	end
	-- compteur pour le retour de ko
	if britney.ko then
		if britney.chrono_ko>0 then
			britney.chrono_ko -=1
			britney.sprite=britney_ko_spr
		else 
			britney.ko=false
			britney.chrono_ko=100
			britney.sprite=britney_spr
		end
	end
end

--
function rep(char, multiplier)    
		local out = ""
  for i=1, multiplier do
   	 out = out..char    end
return out
end

-->8
-- 03 britney ------
 
function create_britney()
	britney={
		x=10,
		y=72,
		sprite=britney_spr,
		sens_x=0,
		sens_y=0,
		running=false,
		speed=britney_speed,
		flipx=true,
		ko=false,
		life=britney_life,
		chrono_ko=0,
		--
		jump_start=false,
		jump_up=false, -- pour declencher la phase de montee lors de saut
		jump_down=false, -- pour declencher la phase de descente lors de saut
		jump_height=jump_height, -- hauteur du saut
		x_from=0,
		y_from=0, -- pour stocker le niveau d'ou on part au moment du saut
		cam_x=0,
		cam_y=0
	}
end
 
function draw_britney()
 camx=flr(britney.x/128)*128
	spr(britney.sprite,britney.x,britney.y,1,1,britney.flipx)
	life_x=camx+100
	print(rep("♥", britney.life),life_x,life_y,8)
end
 
function britney_movement()
	newx=britney.x+(britney.sens_x*britney.speed)
	newy=britney.y+(britney.sens_y*britney.speed)
	-----------------------------
	-- calcul du sprite suivant pour l'axe x
	if britney.sens_x !=1 then
	 testx=flr(newx/8)
	else 
		if newx%8==0 then
			testx=flr(newx/8)
		else
			testx=flr(newx/8)+1
		end
	end
	-- calcul du sprite suivant pour l'axe y
	if britney.sens_y != 1 then
	 testy=flr(newy/8) 
	else 
		if newy%8==0 then
			testy=flr(newy/8)
		else
			testy=flr(newy/8)+1
		end
	end
	-----------------------
	-- controle des flags pour l'axe x
	if not check_flag(flag_mur,testx,testy)
					and (check_flag(flag_mur,testx,testy+1)
										or check_flag(flag_escalier,testx,testy+1))
	then	britney.x=mid(0,newx,512)
	end
	-------------------------
	-- controle des flags pour l'axe y
 if (check_flag(flag_escalier,testx,testy)
 				or (check_flag(flag_escalier,testx,testy+1) 
 							and not check_flag(flag_mur,testx,testy))
 		 	and (newx%8==0 
 							or check_flag(flag_escalier,testx+1,testy)))
 then	britney.y=mid(0,newy,512)
	end
	-------------------
	-- gestion des sauts
	if britney.jump_start 
	   and not britney.jump_up 
	   and not britney.jump_down 
	then 
		britney.y_from=britney.y
		britney.jump_start=false
		britney.jump_up=true
		britney.jump_down=false
	end
	-- montee
	if britney.jump_up 
				and not britney.jump_down 
	then
		britney.speed=1.2
		if britney.y_from-britney.y<britney.jump_height then
			britney.y-=gravity
		else 
			britney.y=britney.y_from-britney.jump_height
			britney.jump_up=false
			britney.jump_down=true
		end
	end
	-- descente
	if britney.jump_down and not britney.jump_up then
		britney.speed=1.2
		if britney.y<britney.y_from then
			britney.y+=gravity
		else 
			britney.y=britney.y_from
			britney.jump_down=false
			britney.speed=1
	 end
	end
	britney.speed=0
	
	-- condition de victoire
	-- controle des flags pour l'axe x
 if check_flag(flag_sortie,testx,testy)
	then	
	 	game_status="victoire"
	 	britney.sprite=11
	end
	--
	if britney.life ==0 then
		game_status="defaite"
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
				testx=flr(newx/8)
				testy=flr(newy/8)
				-- si le pnj n'est pas deja arrete et rencontre
				-- un obstacle, il se retourne
				if not self.fixe then
					if not check_flag(flag_mur,testx,testy) and newx>0 and newx<120 then
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
				----
				collision_britney_pnj()
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
 pnjs={}
 ----	
	local positions_libres={}
	--
	for x=0,15 do
		for y=0,15 do
				if not fget(mget(x, y),0) 
							and fget(mget(x, y+1),0)
						 and not fget(mget(x, y),flag_escalier)
			 then
				 add(positions_libres,{posx=x*8,posy=y*8})
				--add(positions_pnj, create_pnj(x*8,y*8,garde_spr,garde_fan_spr,-1,garde_speed,false,false,420,false))
				end
		end	
	end 
	
	while #pnjs < 2 and #positions_libres>0 do
			rnd_position=flr(rnd(#positions_libres))
			x_pnj=positions_libres[rnd_position].posx
			y_pnj=positions_libres[rnd_position].posy
			add(pnjs, create_pnj(x_pnj,y_pnj,garde_spr,garde_fan_spr,-1,garde_speed,false,false,420,false))
			deli(pnjs,rnd_position)
	end
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
	    if not check_flag(flag_mur,testx,testy) 
	       and newx>0 
	       and newx<camx+128 
	    then
	     self.x=mid(0,newx,camx+128)
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
-->8
--06 ok 
function draw_acceuil()
 map(0,32,0,0,128,64)
	--
	print ("a vous de jouer",20,30,1)
	print ("❎ pour sauter",20,40,1)
	print ("🅾️ pour chanter",20,50,1)
	print ("⬅️⬆️➡️⬇️ pour se deplacer",20,60,1)
end

function draw_victoire()
 map(0,49,0,0,128,64)
	--
	print ("baby one more time?",20,30,139)
 game_status="victoire"
end

function draw_defaite()
 map(0,48,0,0,128,64)
	--
	print ("oups, game over!",20,30,131)
 game_status="defaite"
end

__gfx__
ccccccccccccccccccccccccffffffffeeeeeeee777777773bbb3bb39aaa9aa98ee8eee81dd1ddd13aaa3aa32aaa2aa288888888988888888444444444444448
ccccccccccccccccccccccccffffffffeeeeeeee7777777733bbbb3399aaaa9988eeee8811dddd1133aaaa3322aaaa2288888888988888884a9999a44a999a44
ccccccccccccccccccccccccffffffffeeeeeeee77777777b33b3b3ba999999ae888888ed111111da333333aa222222a8888888a9a8888884944449449444944
ccccccccccccccccccccccccffffffffeeeeeeee77777777bb33b3bbaa9a99aaee8e88eedd1d11ddaa3a33aaaa2a22aa8a9999999999999a4944449449444944
ccccccccccccccccccccccccffffffffeeeeeeee77777777bb3b33bbaa99a9aaee88e8eedd11d1ddaa33a3aaaa22a2aa86868686868686864944449449444944
ccccccccccccccccccccccccffffffffeeeeeeee77777777b3b3b33ba999999ae888888ed111111da333333aa222222a86868686868686864944449949444944
ccccccccccccccccccccccccffffffffeeeeeeee7777777733bbbb3399aaaa9988eeee8811dddd1133aaaa3322aaaa2286868786868687864944449a99444944
ccccccccccccccccccccccccffffffffeeeeeeee777777773bb3bbb39aa9aaa98eee8ee81ddd1dd13aa3aaa32aa2aaa286868686868686864944449999444944
0000000000aaaaa0cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222ffffffffeeeeeeee88686868686868684944449449444944
000000000aa1f1a0cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222ffffffffeeeeeeee88686868687868684944449449444944
000000000affffa0cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222ffffffffeeeeeeee88786868686868684944449449444944
000000000aafefa0cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222ffffffffeeeeeeee88686868686868684a9999a44a999a44
00000000f222222fcccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222ffffffffeeeeeeee88868686868686884444444444444444
000000000a222200cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222ffffffffeeeeeeee88868687868686884444444444444444
00000000a0800800cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222ffffffffeeeeeeee88868686868686884488888888888844
0000000000900900cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222ffffffffeeeeeeee88868686868686884888888888888884
0000000077777a9999a77777eeeeea9999aeeeeeaaaaaaa99aaaaaaaeeee33333333eeeeeeeee9a99a9eeeeebbbb9a9999a9bbbb9a99aaaaaaaa99a944444444
00000000777a96666669a777eeea96666669aeeeaaaaaa9669aaaaaaeee3e3e33e3e3eeeeeeeea9669aeeeeebbbba966669abbbbacccccccccccccca44444444
000000007796666666666977ee966666666669eeaaaaaa9669aaaaaaee3e3ee33ee3e3eeeeee9a9669a9eeeebbbba966669abbbb9cccccc33cccccc944444444
000000007a666666666666a7ea666666666666aeaaaaa966669aaaaae3333333333333eeeeeea966669aeeeebbb9a966669a9bbb9ccccc33733cccc944444444
000000007966666666666697e96666666666669eaaaaa966669aaaaae33eee3333eee33eeeeea966669aeeeebbba96666669abbbaccccc37673cccca44444444
00000000a66666666666666aa66666666666666aaaaaa966679aaaaae3eee3e33e3eee3eeeeea966679aeeeebbba96666669abbbacccc3776633ccca44444444
0000000096666666676666699666666667666669aaaaa966769aaaaae33e3e3333e3e33eeeeea966769aeeeebbba96666679abbbaccc33765673ccca44444444
0000000096666666766666699666666676666669aaaaa966669aaaaa333333e33e333333eeeea966669aeeeebbba96666769abbbacc33766567333ca44444444
0000000096666666666666699666666666666669aaaaa966669aaaaa33ee3ee33ee3ee33eeeea966669aeeeebbba96666669abbbacc37765566773ca00000000
0000000096666666666666699666666666666669aaaaa966669aaaaa3ee3eee33eee3e3eeeeea966669aeeeebbba96666669abbbac3376655566733a00000000
00000000a66666666666666aa66666666666666aaaaaa966669aaaaa3333333333333333eeeea966669aeeeebbba96666669abbba33776555556677a00000000
000000007966666666666697e96666666666669eaaaaa966669aaaaa3eeeeee33eeeeee3eeeea966669aeeeebbba96666669abbba77766555555667a00000000
000000007a666666666666a7ea666666666666aeaaaaa966669aaaaa33e4444444444e33eeeea966669aeeeebbb9a966669a9bbb966665555555566900000000
000000007796666666666977ee966666666669eeaaaaaa9669aaaaaaeee4444444444eeeeeee9a9669a9eeeebbbba966669abbbb966665555555556900000000
00000000777a9666666a9777eee9a666666a9eeeaaaaaa9669aaaaaaeeee44444444eeeeeeeeea9669aeeeeebbbba966669abbbba65555555555555a00000000
0000000077777a9999a77777eeeeea9999aeeeeeaaaaaaa99aaaaaaaeeeee444444eeeeeeeeee9a99a9eeeeebbbb9a9999a9bbbb9a99aaaaaaaa99a900000000
eeeeeeeeeeeeeeeeee4999a9999a994e9a99999aa99999a9ffffffffffffffffddddda99a9addddd777777770077777777000077778888770000000000000000
eeeeeeeeeeeeeeeee4a44444444444a4a77777ccc7777cba2222222222222222dddda966669adddd777777770070000770888807781111870000000000000000
eeeeeeeeeeeeeeeee4499a944499a94497777cc7777ccbb9ffffffffffffffffddddaa6666aadddd777777770070000708888880811111180000000000000000
eeeeeeeeeeeeeeeee4a9449a4a9449a4977cccc7cccbb4b92222222222222222dddaa966669aaddd777777770070000708888880811111180000000000000000
eeeeeeeeeeeeeeeee4944449494444949cccccccccbb44b9ffffffffffffffffddda96666669addd777777777770077708888880811111180000000000000000
eeeeeeeeeeeeeeeee494a4494944a49497cccccccbb443b92222222222222222ddda96666669addd777777777770077708888880811111180000000000000000
4444eeeeeeeeeeeee4944949494944949777ccccb44433b9ffffffffffffffffddda96666769addd777777770000000070888807781111870000000000000000
4444eeeeeeeeeeeee494a4494944a494977ccccc444333b92222222222222222ddda96667669addd777777770000000077000077778888770000000000000000
44666eeeeeeeeeeee494444949444494a7ccccb4443333baffffffffffffffffdddaa666666aaddd77000077771111777777a7aaaa7a7777ffffafaa00000000
44666eeeeeeeeeeee4a9449a4a9449a49ccccbb4333333b92222222222222222ddda96666669addd70000007718888177777aa7aa7aa7777ffffaafa00000000
44cccccccccccccce449a994449a99449cccbb43333333b9ffffffffffffffffddda96666669addd00000000188888817777a7aaaa7a7777ffffafaa00000000
447777777777777ce4444444a44444449ccbb443333333b92222222222222222ddda96666669addd00000000188888817777aa7aa7aa7777ffffaafa00000000
4444444444444444e4494449494449449cbb4433333333b9ffffffffffffffffdddaa966669aaddd00000000188888817777a7aaaa7a7777ffffafaa00000000
4444444444444444e4a4eeeeeeeee4a49bb44333333bbbb92222222222222222ddddaa6666aadddd00000000188888817777aa7aa7aa7777ffffaafa00000000
44eeeeeeeeeeee44e44eeeeeeeeeee44ab44bbbbbbbbbbbaffffffffffffffffdddda966669adddd70000007718888177777a7aaaa7a7777ffffafaa00000000
4eeeeeeeeeeeeee4e4eeeeeeeeeeeee49a99999aa99999a92222222222222222ddddda9a99addddd77000077771111777777aa7aa7aa7777ffffaafa00000000
9a99999a99999a9999a999999a9999a9eeeea999999aeeeeeeeeea9999aeeeeebbb3333443333bbbeeeeeaa99aaeeeeea99999a99a99999aeeee9ee9aee9eeee
accccccccccccccccccccccccccccccaeeeeeea99aeeeeeeeee9a667667a9eeebb33bb3443bb33bbeeeeee9aa9eeeeee9cccccc99cccccc9eeeea99a999aeeee
9cccccccccccccccccccccccccccccc9eeeeeee99eeeeeeeee977667777669eebb3bbbb44bbbb3bbeeeeeee99eeeeeee9cccccc99cccccc9eeeeeee9aeeeeeee
9cccccccccccccccccccccccccccccc9eeeeeee99eeeeeeeea667777777776aebb3333b44b3333bbeeeeeee99eeeeeee9cccccc99cccccc9eeeeeeea9eeeeeee
9cccccccccccccccccccccccccccccc9eeeeeee99eeeeeeee96667777776779ebb333334433333bbeea999a99a999aee9cccccc99cccccc9e9eeeee9aeeeee9e
9cccccccccccccc444ccccccccccccc9a99999aaaa99999aa67775555577776ab33bbb3443bbb33ba99767677676699a9cccccc99cccccc9ea99999a999999ae
9cccccccccccc4446444444cccccccc967676767667676769775555555557779b3bbbbb44bbbbb3b97676667767676799cccccc99cccccc9eeeeeee9aeeeeeee
9cccccccccc446667766664cccccccc967676766667676769555555555555779b3bbbbb44bbbbb3b6767676776767676accc7cca9cccc7caeeeeeeea9eeeeeee
9cccccccc4446677777776644cccccc967676766767676769555566665555559b3333bb44b33333b67666767667676669cc7cccaaccc7cc9e9eeeee9aeeeee9e
9cccccc4446667777777776644ccccc9e67676766767676e9556664466655559b33333344333333b67676766767676769cccccc99cccccc9ea99999a999999ae
9cccc44466667777777777766644ccc9e67676766767676ea56644444466555a33bbb334433bbb33e66767677676667e9cccccc99cccccc9eeeeeee9aeeeeeee
9cc44466677777333777777776644cc9e67676766767676ee96443333346659e3bbbbbb44bbbbbb3e7676767767676ee9cccccc99cccccc9eeeeeeea9eeeeeee
9cc466677777333333377777776644c9ee676766767676eeea433333334466ae3bbbbbb44bbbbbb3ee676667767676ee9cccccc99cccccc9eeeeeee9aeeeeeee
9c446777777333333333777777766449ee676766667676eeee933333333449ee3bba99aaaa99abb3eee7676776667eee9cccccc99cccccc9eeeeeea99aeeeeee
a446677773333333333337777777664aee676767667676eeeee9a333333a9eeebbbba999999abbbbeeee67677676eeee9cccccc99cccccc9eeeeea9999aeeeee
9a99999a99999a9999a999999a9999a9eeee67676676eeeeeeeeea9999aeeeeebbbbba9999abbbbbeeeee767667eeeeea99999a99a99999aeeeea999999aeeee
77aaaaa7777fff77777fff77777fff777aaaaa777aaaaa7787787788007777770001010001010000000101010100000000010100010100000001010101000000
77a0aaa77770ff7777700f7777700f777aff05577aff055778878878007000070000000000000000000000000000000000000000000000000000000000000000
76affaa7777fff7777ffff7777ffff77aa0f5757aa0f575777888778007000070000000000000000000000000000000000000000000000000000000000000000
75788aa8777888887000000778888887aaff5557aaff555787787788007000070000000000000000000000000000000000000000000000000000000000000000
75888877788888770007000088878888771114777711187788777888777007770000000000000000000000000000000000000000000000000000000000000000
75766877777668770707007087878878744444777888887788878787777007770000000000000000000000000000000000000000000000000000000000000000
77788877777888777700007777888877745557777888877788888777000000000000000000000000000000000000000000000000000000000000000000000000
77787877777878777707707777877877775757777787877788888878000000000000000000000000000000000000000000000000000000000000000000000000
a99999a9a9a9999a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94444449494444490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94444449494444490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94444449494444490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94444449494444490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a449a44a4a4a944a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
944a44494944a4490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
944a4449a944a4490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
944a4449aa44a4490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
944a44494944a4490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a4a9444a4a449a4a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94444449494444490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94444449494444490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94444449494444490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
94444449494444490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a99999a9a9a9999a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60606060606060606060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000101000000000000000000000001000000000000002000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000080800000000000000000000000000000808000000000010101000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000040400000000000000000000000000000404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0102010201020102010201020102010201020102010201020102010201020102010201020102010201010101010102010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0112010101010101010101010101010101010101011201120112011201120112011201120112011201010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102010101010101010101010101010101010102010201020102010201020101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040404040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04080808080864650808080803060606030808080808080c0d08080808080803060606060606060c0d060606060606040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04080808080874750808080803060606030808080808081c1d08080808080803060606060606061c1d060606060606040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0408082d2e080808232408080306060603080808080808161608080808080803060606060606061616060606060606040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0408083d3e0808083334080803066c6d030808080808081616080808080808030606060606060616160606060606060401014e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04404108080808080808080803067c7d030808292a086061626308292a08080306062b2c0606062d2e0606062b2c060401014e4e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04505108080808080808080803060606030808393a087071727308393a08080306063b3c0606063d3e0606063b3c060401014e4e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04030303030303034647030303060606030808080808081616080808080808030606060606060616160606060606060401014e4e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
040306060606065c56575d0606060606030808080808081616080808080808030606060606060616160606060606060401014e4e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
040306060606065c57575d0606686906060808080808080e0f08082728080806060668690606060e0f060606060606040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04030606060606065757060606787906060808080808081e1f08083738080806060678790606061e1f06060606060604010100000000000000000000000000001b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03030303030303030303030303030303030303030303030303030303030303030303030303030303030303035e464604010100000000000000000000000000001b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303031a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a0303030303030303030303035e4646040101000000000000000000000000001b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303031a1a1a1a1a1a1a031a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a03030303030303030303035e4646040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030a0a0a0a0a0a0a64650a0a0a0a0a0a030b0b0b0b0b0b6a6b0b0b0b0b0b0b0306060606066a6b06060606065e4646040101000000000000000000000000001b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030a0a0a0a0a0a0a74750a0a0a0a0a0a030b0b0b0b0b0b7a7b0b0b6c6d0b0b0306060606067a7b06060606065e46460401010000000000000000000000001b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030a0a0a0a0a0a0a04040a0a0a0a0a0a030b0b0b0b0b0b04040b0b7c7d0b0b030606060606040406060606065e464604010100000000000000000000001b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030a0a0a0a0a0a0a04040a0a0a0a0a0a030b0b0b0b0b0b04040b0b0b0b0b0b03062b2c0606666706062b2c065e464604010100000000000000000000001b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030a0a0a0a0a0a0a04040a0a0a0a0a0a030b0b0b0b0b0b040403030303030303063b3c0606767706063b3c065e4646040101000000000000000000001b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030a0a0a25260a0a04040a0a25260a0a030b0b0b0b0b0b04040b0b0b0b0b0b030606060606040406060606065e4646040101000000000000000000001b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030a0a0a35360a0a04040a0a35360a0a030b0b0b0b0b0b66670b0b0b0b0b0b0306060606061b1b06060606065e46460401010000000000000000001b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030a0a0a0a0a0a0a04040a0a0a0a0a0a030b0b25260b0b76770b0b25260b0b0306060606061b1b06060606061a464604010100000000000000001b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030a0a0a0a0a0a606162630a0a0a0a0a1a0b0b35360b0b04040b0b35360b0b1a030303575703030303030303034646040101000000000000001b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030a0a0a0a0a0a707172730a0a0a0a0a030b0b0b0b0b0b04040b0b0b0b0b0b030606065757060606060606065e5757040101000000000000001b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
030a0a0a0a0a0a0a04040a0a0a0a0a0a030b0b0b0b0b0b04040b0b0b0b0b0b03060606575706066c6d0606065e575704010100001b001b001b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
90910a0a6e6f0a0a42430a0a0a0a0a0a0b0b0b0b0b0b0b42430b0b0b0b0b0b0b066869575706067c7d0606065e575704010100001b1b1b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a0a10a0a7e7f0a0a52530a0a0a0a0a0a0b0b0b0b0b0b0b52530b0b0b0b0b0b0b0678795757060606060606060657570418181b001b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030418021b1b1b1b1b1b1b1b1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
101000000000000000001000000000000000000000000000000000000000001b000000000000001b0000000000001b1b1b1b1b1b0000001b1b1b1b1b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000340503405034050350503405034050330503405036050000003805039050390503905038050350502d050290502505021050220502205022050230502305022050220502405029050290500000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00240000180241d024160241d02418024180241d0141d000180241d024160241d0241802416024180261d024180241d024160241d0241802416024180241d014180241d024160241d02418024160242402629014
002400000c1220e1220e1222600022000200001e000187330c1220e1220e122110000b0000800007000187000c1220e1220e1221d000280003100000000187330c1220e1220e1222600022000200001873318700
00240000181121a1121a112260032200020000306001b000181121a1121a1120000000000000003060000000181121a1121a112260032200020000306411b000181121a1121a112260032200020000306001b000
002400000000000000000000c00000000000000c0000c0000c6000c6000c0000c00024600000000c0000c0000000000000000000c00000000000000c0000c0000000000000000000c00000000000000c0000c000
002400000c1001d100161001d114181140c6130c6002d6000c1001d1001a5001d1141d1160c6000c600000000c1001d100161001d114181140c61300000000000c1001d1001a5001d11418114186131a4001a400
002400000c1220e1220e1222600022000200001e000187330c1220e1220e122110000b0000800007000187330c1220e1220e1221d000280003100000000187330c1220e1220e122000003c000370003600018733
00240000181121a1121a112260032200020000306111b000181121a1121a1120000000000000003061100000181121a1121a1120000000000000003061100000181121a1121a1120000000000000003061100000
002400000000000000000000c05300000000000c0530c0530c6000c6000c0000c00024614000000c0530c0530000000000000000c05300000000000c0530c0530000000000000000c00000000000000c0530c053
012400000000000000000000c05300000000000c0530c0530c6000c6000c0000c00024614000000c0530c0530000000000000000c05300000000000c0530c0530000000000000000c00000000000000c0530c053
012400000c1001d100161001d114181140c6130c6002d6000c1001d1001a5001d1141d1160c6000c600000000c1001d100161001d114181140c61300000000000c1001d1001a5001d11418114186131a4001a400
112400000c1220e1220e1222600022000200001e000187330c1220e1220e122110000b0000800007000187330c1220e1220e1221d000280003100000000187330c1220e1220e122000003c000370003600018733
01240000181121a1121a112260032200020000306111b000181121a1121a1120000000000000003061100000181121a1121a1120000000000000003061100000181121a1121a1120000000000000003061100000
__music__
01 11121310
00 08090a0b
02 0c0d0e0f

