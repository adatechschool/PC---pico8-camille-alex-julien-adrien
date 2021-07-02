pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- 00------
function _init()
	create_pnj()
	create_britney()
	create_notes()
	create_coeurs()
end

function _update()
	pnj_movement()
	britney_movement()
	tir_note()
	note_movement()
end

function _draw()
	cls()
	draw_map()
	draw_britney()
	draw_pnj()
	draw_note()
	draw_coeur()
end
-->8
-- 01 ------

function draw_map()
	map(0,0,0,0,128,64)
end






-->8
-- 02 ------
function create_pnj()
	pnj={
		x=9,
		y=72,
		sprite=5,
		sens=1,
		speed=1,
		flipx=true
	}
end

function draw_pnj()
	spr(pnj.sprite,pnj.x,pnj.y,1,1,pnj.flipx)
end

function pnj_movement()
	newx=pnj.x+(pnj.sens*pnj.speed)
	newy=pnj.y
	--
	testx=flr(newx/8)+1
	testy=flr(newy/8)
	--
	if not check_flag(0,testx,testy) and newx>0 and newx<120 then
			pnj.x=mid(0,newx,120)
	else
 		pnj.sens=pnj.sens*-1
 		pnj.flipx=not pnj.flipx
	end
end

-->8
-- 03 ------
function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end
-->8
-- 04--------
function create_notes()
    notes={}
end

function create_coeurs()
    coeurs={}
end

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
        add(notes, create_note(britney.x,britney.y,4,britney.sens,2,false))
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
	    	add(coeurs,create_coeur(notes[1].x,notes[1].y,10,20))
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
		x=72,
		y=72,
		sprite=17,
		sens=1,
		speed=1,
		flipx=true
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
0000000000aaaa00666666660080080000777777777fff7700000000000000000000000077aaaaa7e77e77ee0000000000000000000000000000000000000000
000000000aaaaaa066006606008008000070000777700f770000000000000000090080807550ffa77ee7ee7e0000000000000000000000000000000000000000
00700700aaaaaaaa66600066008778080070000777ffff77000000000000000000aa08007575f0aa77eee77e0000000000000000000000000000000000000000
00077000aaaaaaaa6066000600070708007000077000000700000000999888880008aa807555ffaae77e77ee0000000000000000000000000000000000000000
00077000aaaaaaaa6600660607777788777007770007000000000000888999990889800077411177ee777eee0000000000000000000000000000000000000000
00700700aaaaaaaa66600606077778807770077707070070000000000000000000909a0077444447eee7e7e70000000000000000000000000000000000000000
000000000aaaaaa0606666660080880000000000770000770000000000000000090008a077755547eeeee7770000000000000000000000000000000000000000
0000000000aaaa006666666600800800000000007707707700000000000000000000000077757577eeeeee7e0000000000000000000000000000000000000000
0000000077aaaaa70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000077a0aaa70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000076affaa70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000075788aa80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000758888770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000757668770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777888770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777878770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
