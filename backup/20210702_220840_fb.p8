pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- 00------
function _init()
	create_britney()
end

function _update()
	pnj_movement()
	pprz_movement()
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
	draw_pnj()
	draw_pprz()
	draw_note()
	draw_coeur()
end
-->8
-- 01 ------

function draw_map()
	map(0,0,0,0,128,64)
end

britney_spr=17
note_spr=4
garde_spr=5
coeur_spr=10
garde_fan_spr=11
pprz_spr=9






-->8
-- 02 ------

pnjs={}

function create_pnj(x,y,sprite,sprite_ami,sens,speed,flipx,fixe,chrono_fixe)
	pnj={
		x=x,
		y=y,
		sprite=sprite,
		sprite_ami=sprite_ami,
		sens=sens,
		speed=speed,
		flipx=flipx,
		fixe=fixe,
		chrono_fixe=chrono_fixe
	}
	return pnj
end

add(pnjs, create_pnj(7,88,garde_spr,garde_spr_ami,1,1,true,false,420))

function draw_pnj()
 if (count(pnjs) > 0) then
		spr(pnjs[1].sprite,pnjs[1].x,pnjs[1].y,1,1,pnjs[1].flipx)
	end
end

function pnj_movement()
	newx=pnjs[1].x+(pnjs[1].sens*pnjs[1].speed)
	newy=pnjs[1].y
	--
	testx=flr(newx/8)+1
	testy=flr(newy/8)
	--
	if not pnjs[1].fixe then
		if not check_flag(0,testx,testy) and newx>0 and newx<120 then
				pnjs[1].x=mid(0,newx,120)
		else
	 		pnjs[1].sens=pnjs[1].sens*-1
	 		pnjs[1].flipx=not pnjs[1].flipx
		end
	end
	
	--if pnj.fixe and pnj.chrono_fixe>0 then
	--		pnj.chrono_fixe -=1
	--else 
	--		pnj.fixe=false
 --		pnj.chrono_fixe=100
	--		pnj.sprite=5
	--end
end

-->8
-- 03 ------
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
    if (btnp(⬇️) and count(notes) == 0) then 
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

function collision_note_pnj()
	if (count(notes) > 0) then
		if flr(pnj.x/8) == flr(notes[1].x/8) and pnj.sprite==5 then
			pnj.sprite=garde_fan_spr
			pnj.fixe=true
			add(coeurs,create_coeur(notes[1].x,notes[1].y,coeur_spr,20))
			deli(notes,1)
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
	avance=((britney.sens==-1 and check_flag(0,testx-1,testy)) or (britney.sens==-1 and check_flag(0,testx+1,testy))) and newx>0 and newx<120
	--
	if not (britney.sens==-1 and check_flag(0,testx-1,testy)) and newx>0 and newx<120 then
			britney.x=mid(0,newx,120)
	else
 		britney.sens=britney.sens*-1
 		britney.flipx=not britney.flipx
	end
end

-->8
-- 02 ------

pprzs={}

function create_pprz(x,y,sprite,sprite_ami,sens,speed,flipx,fixe,chrono_fixe)
	pprz={
		x=x,
		y=y,
		sprite=sprite,
		sprite_ami=sprite_ami,
		sens=sens,
		speed=speed,
		flipx=flipx,
		fixe=fixe,
		chrono_fixe=chrono_fixe,
		--
		draw_pprz = function()
				spr(sprite,x,y,1,1,flipx)
		end,
		--
		pprz_movement = function ()
				newx=x+(sens*speed)
				newy=y
				--
				testx=flr(newx/8)+1
				testy=flr(newy/8)
				--
				if not fixe then
					if not check_flag(0,testx,testy) and newx>0 and newx<120 then
							x=mid(0,newx,120)
					else
				 		sens=sens*-1
				 		flipx=not flipx
					end
				end
--	if pnj.fixe and pnj.chrono_fixe>0 then
--			pnj.chrono_fixe -=1
--	else 
--			pnj.fixe=false
--			pnj.chrono_fixe=100
--			pnj.sprite=5
	--
--	end
		end
	}
	return pprz
end

add(pprzs, create_pprz(0,0,pprz_spr,garde_spr_ami,-1,1,true,false,420))

function draw_pprz()
	pprzs[1].draw_pprz()
end

function pprz_movement()
	pprzs[1].pprz_movement()
end

function pprz_movementx()
	newx=pprzs[1].x+(pprzs[1].sens*pprzs[1].speed)
	newy=pprzs[1].y
	--
	testx=flr(newx/8)+1
	testy=flr(newy/8)
	--
	if not pprzs[1].fixe then
		if not check_flag(0,testx,testy) and newx>0 and newx<120 then
				pprzs[1].x=mid(0,newx,120)
		else
	 		pprzs[1].sens=pprzs[1].sens*-1
	 		pprzs[1].flipx=not pprzs[1].flipx
		end
	end
	
--	if pnj.fixe and pnj.chrono_fixe>0 then
--			pnj.chrono_fixe -=1
--	else 
--			pnj.fixe=false
--			pnj.chrono_fixe=100
--			pnj.sprite=5
	--
--	end
end

__gfx__
0000000000aaaa00666666660080080000777777777fff7700000000000000000000000077aaaaa787787788777fff7700000000000000000000000000000000
000000000aaaaaa066006606008008000070000777700f770000000000000000090080807550ffa77887887877700f7700000000000000000000000000000000
00700700aaaaaaaa66600066008778080070000777ffff77000000000000000000aa08007575f0aa7788877877ffff7700000000000000000000000000000000
00077000aaaaaaaa6066000600070708007000077000000700000000999888880008aa807555ffaa877877887888888700000000000000000000000000000000
00077000aaaaaaaa6600660607777788777007770007000000000000888999990889800077411177887778888887888800000000000000000000000000000000
00700700aaaaaaaa66600606077778807770077707070070000000000000000000909a0077444447888787878787887800000000000000000000000000000000
000000000aaaaaa0606666660080880000000000770000770000000000000000090008a077755547888887777788887700000000000000000000000000000000
0000000000aaaa006666666600800800000000007707707700000000000000000000000077757577888888787787787700000000000000000000000000000000
0000000077aaaaa70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000077a0aaa70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000076affaa70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000075788aa80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000758888770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000757668770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777888770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777878770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010002040000010000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0606060606060206020606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606020606060206060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060602060606060206060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060606060206060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060606060206060602060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060606060206020202060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606020206060202060602020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060202060606060602060200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0606060606060206060606060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000080000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
