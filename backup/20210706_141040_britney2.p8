pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- free britney ------
function _init()
	create_britney()
	create_pnjs()
end
 
function _update60()
	clavier_listener()
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
	print(britney.x,10, 10, 2)
	print(britney.y,0,0,2)
	print(britney.test,20,20,2)
	update_camera()
end
-->8
-- 01 init et gestion du clavier ------

-- pour dessiner la map


-- 01 init et gestion du clavier ------
 
-- pour dessiner la map
function draw_map()
	map(0,0,0,0,128,64)
end
 
-- initialisation des constantes
britney_spr=134
britney_up= 2.3
jump_height=10
britney_speed=1
britney_life=3
britney_ko_spr=137
note_spr=130
garde_spr=131
coeur_spr=133
garde_speed=1
garde_fan_spr=135
pprz_spr=132
pprz_speed=1
pprz_fan_spr=136
gravity=1
life_x=100
life_y=5

 
-- initialisation des tableaux
pnjs={}
notes={}
coeurs={}
 
-- gestion du clavier
function clavier_listener()
	if (btnp(🅾️) and count(notes) == 0) then 
      add(notes, create_note(britney.x,britney.y,note_spr,britney.sens_x,2,false))
 end 
 --
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
 --
	if (btnp(❎) and not britney.ko) then 
		britney.jump_start=true
	end
end
 
function update_camera()
 cam=flr(britney.x/128)
	camx=cam*128
	camera(camx,0)
	life_x=cam*128+life_x
end
 
 
 
-->8
-- 02 bibliothque de fonctions ------

-- renvoie le sprite a la position x,y, 
-- si il possede le flag passe en parametre
function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end

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
				end
			end
		end
	end
end
 
-- fonction declenchee quand britney touche un pnj
function collision_britney_pnj()
	for _,pnj in pairs(pnjs) do
		if not britney.ko and flr(pnj.x/8) == flr(britney.x/8) and pnj.y == britney.y and not pnj.fan then
			britney.sens_x=britney.sens_x*-1
			britney.jump_start=true
			britney.ko=true
			britney.life-=1
		end
	end
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
		x=32,
		y=16,
		sprite=britney_spr,
		sens_x=-1,
		sens_y=1,
		running=false,
		speed=britney_speed,
		flipx=false,
		ko=false,
		life=britney_life,
		chrono_ko=0,
		life=britney_life,
		--
		jump_start=false,
		jump_up=false, -- pour declencher la phase de montee lors de saut
		jump_down=false, -- pour declencher la phase de descente lors de saut
		jump_height=jump_height, -- hauteur du saut
		x_from=0,
		y_from=0 -- pour stocker le niveau d'ou on part au moment du saut
,test
	}
end
 
function draw_britney()
	spr(britney.sprite,britney.x,britney.y,1,1,britney.flipx)
		print(rep("♥", britney.life),life_x,life_y,8)
end
 
function britney_movement()
	newx=britney.x+(britney.sens_x*britney.speed)
	newy=britney.y+(britney.sens_y*britney.speed)
	--
	if britney.sens_x==-1 then
	 testx=flr(newx/8) 
	else 
		testx=flr(newx/8)+1
	end
	if not check_flag(0,testx,newy) then --and newx>0 and newx<240 then
			britney.x=mid(0,newx,512)
	end
	--
	if britney.sens_y==-1 then
	 testy=flr(newy/8) 
	else 
		testy=flr(newy/8)+1
	end
		britney.test = "testy:"..testy.."- newx:"..newx.."- newy:"..newy check_flag(7,testx,testy)
	
	if check_flag(7,newx,testy) then --and newx>0 and newx<240 then
		britney.y=mid(0,newy,128)
	end 
	
	--
	-- gestion des sauts
	if britney.jump_start and not britney.jump_up and not britney.jump_down then 
		britney.y_from=britney.y
		britney.jump_start=false
		britney.jump_up=true
		britney.jump_down=false
	end
	-- montee
	if britney.jump_up and not britney.jump_down then
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
	--add(pnjs, create_pnj(0,0,garde_spr,garde_fan_spr,-1,garde_speed,false,false,420,false))
	--add(pnjs, create_pnj(0,16,pprz_spr,pprz_fan_spr,-1,pprz_speed,false,false,420,false))
	--add(pnjs, create_pnj(50,88,pprz_spr,pprz_fan_spr,1,pprz_speed,true,false,420,false))
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
__gfx__
ccccccccccccccccccccccccffffffffeeeeeeee777777773bbb3bb39aaa9aa98ee8eee81dd1ddd13aaa3aa32aaa2aa288888888988888888444444444444448
ccccccccccccccccccccccccffffffffeeeeeeee7777777733bbbb3399aaaa9988eeee8811dddd1133aaaa3322aaaa2288888888988888884a9999a44a999a44
ccccccccccccccccccccccccffffffffeeeeeeee77777777b33b3b3ba999999ae888888ed111111da333333aa222222a8888888a9a8888884944449449444944
ccccccccccccccccccccccccffffffffeeeeeeee77777777bb33b3bbaa9a99aaee8e88eedd1d11ddaa3a33aaaa2a22aa8a9999999999999a4944449449444944
ccccccccccccccccccccccccffffffffeeeeeeee77777777bb3b33bbaa99a9aaee88e8eedd11d1ddaa33a3aaaa22a2aa86868686868686864944449449444944
ccccccccccccccccccccccccffffffffeeeeeeee77777777b3b3b33ba999999ae888888ed111111da333333aa222222a86868686868686864944449949444944
ccccccccccccccccccccccccffffffffeeeeeeee7777777733bbbb3399aaaa9988eeee8811dddd1133aaaa3322aaaa2286868786868687864944449a99444944
ccccccccccccccccccccccccffffffffeeeeeeee777777773bb3bbb39aa9aaa98eee8ee81ddd1dd13aa3aaa32aa2aaa286868686868686864944449999444944
0000000000aaaaa0cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222000000000000000088686868686868684944449449444944
000000000aa1f1a0cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222000000000000000088686868687868684944449449444944
000000000affffa0cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222000000000000000088786868686868684944449449444944
000000000aafefa0cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222000000000000000088686868686868684a9999a44a999a44
00000000f222222fcccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222000000000000000088868686868686884444444444444444
000000000a222200cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222000000000000000088868687868686884444444444444444
00000000a0800800cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222000000000000000088868686868686884488888888888844
0000000000900900cccccccc55555555aaaaaaaa222222228888888833333333cccccccc22222222000000000000000088868686868686884888888888888884
0000000077777a9999a77777eeeeea9999aeeeee88888aa99aa88888eeee33333333eeeeeeeee9a99a9eeeeebbbb9a9999a9bbbb9a99aaaaaaaa99a900000000
00000000777a96666669a777eeea96666669aeee88888a9669a88888eee3e3e33e3e3eeeeeeeea9669aeeeeebbbba966669abbbbacccccccccccccca00000000
000000007796666666666977ee966666666669ee8888aa9669aa8888ee3e3ee33ee3e3eeeeee9a9669a9eeeebbbba966669abbbb9cccccc33cccccc900000000
000000007a666666666666a7ea666666666666ae8888a966669a8888e3333333333333eeeeeea966669aeeeebbb9a966669a9bbb9ccccc33733cccc900000000
000000007966666666666697e96666666666669e8888a966669a8888e33eee3333eee33eeeeea966669aeeeebbba96666669abbbaccccc37673cccca00000000
00000000a66666666666666aa66666666666666a8888a966679a8888e3eee3e33e3eee3eeeeea966679aeeeebbba96666669abbbacccc3776633ccca00000000
00000000966666666766666996666666676666698888a966769a8888e33e3e3333e3e33eeeeea966769aeeeebbba96666679abbbaccc33765673ccca00000000
00000000966666667666666996666666766666698888a966669a8888333333e33e333333eeeea966669aeeeebbba96666769abbbacc33766567333ca00000000
00000000966666666666666996666666666666698888a966669a888833ee3ee33ee3ee33eeeea966669aeeeebbba96666669abbbacc37765566773ca00000000
00000000966666666666666996666666666666698888a966669a88883ee3eee33eee3e3eeeeea966669aeeeebbba96666669abbbac3376655566733a00000000
00000000a66666666666666aa66666666666666a8888a966669a88883333333333333333eeeea966669aeeeebbba96666669abbba33776555556677a00000000
000000007966666666666697e96666666666669e8888a966669a88883eeeeee33eeeeee3eeeea966669aeeeebbba96666669abbba77766555555667a00000000
000000007a666666666666a7ea666666666666ae8888a966669a888833e4444444444e33eeeea966669aeeeebbb9a966669a9bbb966665555555566900000000
000000007796666666666977ee966666666669ee8888aa9669aa8888eee4444444444eeeeeee9a9669a9eeeebbbba966669abbbb966665555555556900000000
00000000777a9666666a9777eee9a666666a9eee88888a9669a88888eeee44444444eeeeeeeeea9669aeeeeebbbba966669abbbba65555555555555a00000000
0000000077777a9999a77777eeeeea9999aeeeee88888aa99aa88888eeeee444444eeeeeeeeee9a99a9eeeeebbbb9a9999a9bbbb9a99aaaaaaaa99a900000000
7777777777777777884999a9999a99489a99999aa99999a9ffffffffffffffffddddda99a9addddd888888880077777777000077778888770000000000000000
777777777777777784a44444444444a4a77777ccc7777cba2222222222222222dddda966669adddd887787780070000770888807781111870000000000000000
777777777777777784499a944499a94497777cc7777ccbb9ffffffffffffffffddddaa6666aadddd878878870070000708888880811111180000000000000000
777777777777777784a9449a4a9449a4977cccc7cccbb4b92222222222222222dddaa966669aaddd887888780070000708888880811111180000000000000000
777777777777777784944449494444949cccccccccbb44b9ffffffffffffffffddda96666669addd888787887770077708888880811111180000000000000000
77777777777777778494a4494944a49497cccccccbb443b92222222222222222ddda96666669addd888878887770077708888880811111180000000000000000
444477777777777784944949494944949777ccccb44433b9ffffffffffffffffddda96666769addd888788880000000070888807781111870000000000000000
44447777777777778494a4494944a494977ccccc444333b92222222222222222ddda96667669addd887888880000000077000077778888770000000000000000
44666777777777778494444949444494a7ccccb4443333baffffffffffffffffdddaa666666aaddd770000777711117700000000000000000000000000000000
446667777777777784a9449a4a9449a49ccccbb4333333b92222222222222222ddda96666669addd700000077188881700000000000000000000000000000000
44cccccccccccccc8449a994449a99449cccbb43333333b9ffffffffffffffffddda96666669addd000000001888888100000000000000000000000000000000
447777777777777c84444444a44444449ccbb443333333b92222222222222222ddda96666669addd000000001888888100000000000000000000000000000000
444444444444444484494449494449449cbb4433333333b9ffffffffffffffffdddaa966669aaddd000000001888888100000000000000000000000000000000
444444444444444484a48888888884a49bb44333333bbbb92222222222222222ddddaa6666aadddd000000001888888100000000000000000000000000000000
44777777777777448448888888888844ab44bbbbbbbbbbbaffffffffffffffffdddda966669adddd700000077188881700000000000000000000000000000000
477777777777777484888888888888849a99999aa99999a92222222222222222ddddda9a99addddd770000777711117700000000000000000000000000000000
9a99999a99999a9999a999999a9999a9eeeea999999aeeee00000a9999a00000bbb3333443333bbb22222aa99aa22222a99999a99a99999a88889889a8898888
accccccccccccccccccccccccccccccaeeeeeea99aeeeeee0009a667667a9000bb33bb3443bb33bb2222229aa92222229cccccc99cccccc98888a99a999a8888
9cccccccccccccccccccccccccccccc9eeeeeee99eeeeeee0097766777766900bb3bbbb44bbbb3bb22222229922222229cccccc99cccccc988888889a8888888
9cccccccccccccccccccccccccccccc9eeeeeee99eeeeeee0a667777777776a0bb3333b44b3333bb22222229922222229cccccc99cccccc98888888a98888888
9cccccccccccccccccccccccccccccc9eeeeeee99eeeeeee0966677777767790bb333334433333bb22a999a99a999a229cccccc99cccccc989888889a8888898
9cccccccccccccc444ccccccccccccc9a99999aaaa99999aa67775555577776ab33bbb3443bbb33ba99767677676699a9cccccc99cccccc98a99999a999999a8
9cccccccccccc4446444444cccccccc967676767667676769775555555557779b3bbbbb44bbbbb3b97676667767676799cccccc99cccccc988888889a8888888
9cccccccccc446667766664cccccccc967676766667676769555555555555779b3bbbbb44bbbbb3b6767676776767676accc7cca9cccc7ca8888888a98888888
9cccccccc4446677777776644cccccc967676766767676769555566665555559b3333bb44b33333b67666767667676669cc7cccaaccc7cc989888889a8888898
9cccccc4446667777777776644ccccc9e67676766767676e9556664466655559b33333344333333b67676766767676769cccccc99cccccc98a99999a999999a8
9cccc44466667777777777766644ccc9e67676766767676ea56644444466555a33bbb334433bbb3326676767767666729cccccc99cccccc988888889a8888888
9cc44466677777333777777776644cc9e67676766767676e09644333334665903bbbbbb44bbbbbb327676767767676229cccccc99cccccc98888888a98888888
9cc466677777333333377777776644c9ee676766767676ee0a433333334466a03bbbbbb44bbbbbb322676667767676229cccccc99cccccc988888889a8888888
9c446777777333333333777777766449ee676766667676ee00933333333449003bba99aaaa99abb322276767766672229cccccc99cccccc9888888a99a888888
a446677773333333333337777777664aee676767667676ee0009a333333a9000bbbba999999abbbb22226767767622229cccccc99cccccc988888a9999a88888
9a99999a99999a9999a999999a9999a9eeee67676676eeee00000a9999a00000bbbbba9999abbbbb2222276766722222a99999a99a99999a8888a999999a8888
404000000000000000777777777fff777aaaaa778778778877aaaaa7777fff777aaaaa77777fff77000000000000404040400000000000000000000000000000
00000000000000000070000777700f777aff05577887887877a0aaa777700f777aff05577770ff77000000000000000000000000000000000000000000000000
40400000000000000070000777ffff77aa0f57577788877876affaa777ffff77aa0f5757767fff77000000000000404040400000000000000000000000000000
00000000000000000070000770000007aaff55578778778875788aa878888887aaff555775788888000000000000000000000000000000000000000000000000
00000000000000007770077700070000771114778877788875888877888788887711187775888877000000000000000000000000000000000000000000000000
00000000000000007770077707070070744444778887878775766877878788787888887775766877000000000000000000000000000000000000000000000000
00000000000000000000000077000077745557778888877777788877778888777888877777788877000000000000000000000000000000000000000000000000
00000000000000000000000077077077775757778888887877787877778778777787877777787877000000000000000000000000000000000000000000000000
__gff__
0000000001000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0102010201020102010201020102010201020102010201020102010201020102010201020102010201010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0112011201010112011201121812011201120101011201120112011201120112011201120112011201010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0102010201020102010201021802010201020102010201020102010201020101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404464646040404040404040404040404040404040404040404040404040404040404040404040404040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04050505050505044646460405050505030808080808080c0d08080808080803060606060606060c0d060606060606040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04050505050505044646460405050505030808080808081c1d08080808080803060606060606061c1d060606060606040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0405050505050505040446040505050503080808080808161608080808080803060606060606061616060606060606040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
040505050505050505044604050505050308080808080816160808080808080306062b2c06060616160606062b2c06040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04050505050505050504460405050505030808292a08082d2e0808292a08080306063b3c06060616160606063b3c06040101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04050505050505050504460405050505030808393a08083d3e0808393a080803060606060606061616060606060606040101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0405050505050505050446040505050503080808080808161608080808080803060e0f060606061616060606060606040101000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0405050505050505050546050505050503080808080808161608080808080846061e1f060606061616060606060606040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0403030303030303030346030303030303030303030303030303030303030303030303030303030303030346474647040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0403030303030303030346030303030303030303030303030303030303030303030303030303030303030356575657040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0403030303030303030303030303030303030303030303030303030303030303030303030303030303030346474647040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0403030303030303030303030303030303030303030303030303030303030303030303030303030303030356575657040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0403030303030303030303030303030303030303030303030303030303030303030303030303030303030346474647040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
040308393a0808083d3e080808393a08030b0b0b0b0b0b0b0b0b0b0b0b0b0b0306060606060c0d0606060656575657040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04030808080808081616080808080808030b0b0b0b0b0b0b0b0b0b0b0b0b0b0306060606061c1d0606060646474647040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04030808080808081616272808080808030b0b0b0b0b0b0b0b0b0b0b0b0b0b03060606060616160606060646475657040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04030808080808081616373808080808030b0b0b0b0b0b0b0b0b0b0b0b0b0b03060606060616160606060656575657040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04034746470303030303030303030303030b0b0b0b0b0b0b0b0b0b0b0b0b0b0306062b2c0616160606060646464646040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04035756570b0b0b0b0c0d0b0b0b0b0b030b0b0b0b0b0b0b0b0b0b0b0b0b0b0306063b3c0616160606060646464646040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04034746470b0b0b0b1c1d0b0b0b0b0b030b0b0b0b0b0b0b0b0b0b0b0b0b0b03060606060616160606060646464646040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04035756570b0b0b0b16160b0b0b0b0b030b0b0b0b0b0b0b0b0b0b0b0b0b0b03060606060616160606060646464646040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04034746470b0b0b0b44450b0b0b0b0b030b0b0b0b0b0b0b0b0b0b0b0b0b0b03060606060616160606060646464646040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0403030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0403030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04464746470b0b0b0b42430b0b0b0b0b03090909090909161609090e0f090903060606060606061616060606060606040101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04565756570b0b0b0b52530b0b0b0b0b03090909090909161609091e1f090903060606060606061616060606060606040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0403030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303040404040404040404000400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004040404000000000004040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000340503405034050350503405034050330503405036050000003805039050390503905038050350502d050290502505021050220502205022050230502305022050220502405029050290500000000000
