pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
-- init

function _init()
	menuitem(1,"colorblind mode",changepal)


	load_x,load_dx,choice,choicemade,ch_y,winner=128,128,false,false,0,"player 0"
	wintext = "congratulations "..winner

	-- _upd and _drw will be variables that store
	-- a function of current update and current
	-- draw functions
	-- to change scene, simply reassign them to
	-- different update and draws
	winpoint,_upd,_drw = 0,update_ps,draw_ps

	about_x,about_dx,player2,funcpal,part,parttimer,partrow,helpy,helpdy,frames=128,128,false,normalpal,{},0,0,97,97,0
end




function loadabout(_x)
	if player2 then
		rectfill(_x+2,33,_x+63,70,8)
		rectfill(_x+64,33,_x+123,70,3)
	else
		rectfill(_x+2,33,_x+123,70,8)
	end


	print("rules of the game",_x+25,20,8)

	print("to win, get 22-30 ★ (changes",_x+4,35,7)
	print("every game). you get ★ by",_x+4,42,7)
	print("making perfumes with ★ scents.",_x+4,49,7)

	print("each bottle needs 3 scents.",_x+5,62,7)
	print("when a perfume is made, all 3",_x+5,69,7)
	print("scents will score their 'value'.",_x+4,76,7)
	print("e.g. top[2★], middle[1★2♥],\nbottom[1★1웃]",_x+4,88,15)
	print("the reward would be 4★,2♥,1웃.",_x+3,105,15)

end



function loadscore(_x)

	print("final scoring",_x+40,3,10)
	print("➡️=go back",_x+45,12,15)

	if player2 then
		print("player 2 ★: "..star_2,35+_x,77,3)
	else
		print("★ needed to win: "..winpoint,25+_x,40,7)
	end
	print("player 1 ★: "..star,35+_x,67,8)
end


function _draw()
	funcpal()
	drawparts()
	_drw()
end


function cbpal()
	_pal={128,129,129,140,131,132,134,135,140,137,10,131,13,14,6,6}

	for i,c in pairs(_pal) do
		pal(i-1,c,1)
	end
end

function normalpal()
	for i=0,15 do
			--poke(0x5f10+i, 128+i)
		--you save 1 token by making it pal
		pal(i,128+i,1)
	end

end

function _update60()
	updateparts()
	_upd()

end


function addstock()
	for d in all(dice) do
		d.reroll=true
		add(dice2r,d)

	end

	if player2 then
		for f in all(dice_2) do
			f.reroll=true
			add(dice2r_2,f)
		end
	end

	return dice2r,dice2r_2

end



function changepal()
	if funcpal==normalpal then
		funcpal=cbpal
	else
		funcpal=normalpal
	end

end


function startgame()
	winpoint= 22 + flr(rnd(8))
	round = 1
	--- c = citrus
	--- f = floral
	--- w = woody

	--- 1 = rank 1
	--- 2 = rank 2
	--- 3 = rank 3

	-- so c2 = rank 2 citrus
	-- w1 = rank 1 woody
	-- each one is a type of scent

	move_die,move_die_2,x,x_2,dice_t,dice_t2,dice_y,slotmax,dice,dice2r,inv,parfum,star,heart,hincome,men,pips,slots,pname,pname_2=false,false,0,0,180,180,140,6,{},{},{},{"","",""},0,0,0,0,0,3,"an eau fraiche","an eau fraiche"


	parfum_2,p1ready,p2ready,state1,state2,pmade,pmade_2,move_die,pos,pos_2,maxroll,maxroll_2,reroll,reroll_2,dice_2,dice2r_2,inv_2,star_2,heart_2,hincome_2,men_2,pips_2,slots_2 = {"","",""}, false,false,false,false,false,false,false,1,1,1,1,1,1,{},{},{},0,0,0,0,0,3



	-- +1 for the original roll
	-- +1 for the second roll
	-- i just added more for
	-- beta testing

	d1,d2,d3,d4 = {1,3,5,0},{1,4,5,0},{1,4,6,0},{2,2,4,6}


	cur = {
		pic=24,
		x=35,
		y=60}


	cur_2 = {
		pic=25,
		x=35,
		y=110}

	------- dice for player 1

	for i=1,3 do
		add_dice(1,0,1)
	end


	if player2 then
		for i=1,3 do
			add_dice(1,0,2)
		end
	end

	dice2r,dice2r_2 = addstock()


	_upd,_drw = update_game,draw_game


	talkt={"the bodore company is\noffering a greater supply\nof perfume oils (+dice).|but they expect a cut of\nour profits (-★) ...|should we go ahead with the\ndeal?","there's a new social media\napp called ◆chic-porium◆.|we could get a social\nmedia manager (+♥ income).|ideally using an existing\nemployee (-웃).|should we promote 웃 to a\nsocial media manager?","there have been suggestions\nfor a summer internship\nprogram.(+웃)|but it will be costly (-★)\nand the board said it could\nlower prestige(-♥).|should we start hiring\nsummer interns?","higher ups said we should\nstart 'elevating' our brand.|they want us to sell\nluxury, exclusive perfumes.|they have the resources to\nmake the change (transform\nall die into lvl 4).|but it's not going to\nbe cheap...(-dice).|should we make our perfumes\nas veblen goods?","investors are concerned\nwith our sales.|they said we should have a\nsignature 'woody' flavour \n(upgrade dice to lvl 3).|but that will take time\n(-♥) and money (-★).|should we head towards a\nrebranding?","aroma essential oils\nreached out to us for a\ncollaboration.|they want us to use their\nnew oil (rank 3) for our\nnewest perfume.|but this could hurt us\n(-♥) as we can be seen as\na 'sellout'.|should we accept their\noffer for a collaboration?","'colore' perfumes (our\ncompetitor), noticed we had\nleftover scents.|we could sell it to them.\n(score all scents in your\ninventory)|but we could lose future\nsales (-★) and our\nreputation (-♥).|should we sell our leftover\nscents?","our perfumers requested\nmore storage for scents (+1\ninventory slot).|but those don't come cheap\n(-★).|should we accept their\nrequest?","the board suggested we\nshould do a rebranding to\nincrease sales.|they thought a 'floral'\nscent was the way to go\n(transform dice to lvl 2).|but that's going to cost us\nin the short run (-★).|should we rebrand to a\nfloral flavour?","our aromachologists say\nwe have too much unused\nstorage (-1 inventory slot)|we can sell it (+★) to gain\neconomies of scale (+웃).|should we sell our storage?","we interviewed an excellent\ncandidate for a new\nperfumer (+웃).|but we recently discovered\n웃 has a criminal record\n(-♥)(-♥ income).|but 웃 is very resourceful.\n(+rank 2)(upgrade die)|should we hire the new\nperfumer?","some aromachologists made a\nbreakthrough with 'fusion' \nscents.(gain +1/-1 chips)|but it's a risky purchase\nwhich could upset investors\n(-♥).|should we buy the new\nequipment?"}

	r_event=flr(rnd(#talkt))+1

	talkqueue=split(talkt[r_event],"|")

	txtbuttx=true   nexttalk()

end



-->8
-- update



///////// player select
//////////////////////
function update_ps()
	dropparticles({7,7,15,14,9},{7,7,10,14,11},18)

	----slide the about scene
	---- even when fading out
	if about_x!=about_dx then
		about_x+=(about_dx-about_x)/5
	end

	if btnp(⬅️) then
		sfx(54)
		about_dx=0
	end

	if btnp(➡️) then
		sfx(54)
		about_dx=128
	end


	if player2 and btnp(5,1) then
		sfx(59)
		player2 = false
	end

	f+=2

	if btn(🅾️) then
		sfx(53)
		_upd,_drw=update_expo,draw_expo
	end

	for i=0,4 do
		if btnp(i,1) and not player2 then
			sfx(53)
			player2 = true
		end
	end

end


function update_expo()
	f+=2
	if btnp(❎)then
		sfx(52)
		startgame()
	end

end



function newround()
	---- we update men incomes here
	---- for rerolls
	maxroll=max(1,men+1)
	maxroll_2=max(1,men_2+1)
	---- actually update all stats here
	---- minus heart income
	heart+=hincome

	heart_2+=hincome_2

	reroll,reroll_2=maxroll,maxroll_2

	round+=1

	if #parfum<3 then
		parfum = {"","",""}
	end

	if #parfum_2<3 and player2 then
		parfum_2={"","",""}
	end

	dice2r,dice2r_2={},{}

	dice2r,dice2r_2 = addstock()

	dice_t,dice_y,dice_t2,x,x_2,pos,pos_2,choice,choicemade=180,140,180,0,0,1,1,false,false
	cur.x,cur_2.x,cur.y,cur_2.y=35,35,60,110

	move_die,move_die_2,p1ready,p2ready,state1,state2,pmade,pmade_2=false,false,false,false,false,false,false,false


end


function update_win()
	riseparticles()
	f+=2

	if btnp(❎) then
		sfx(52)
		_upd,_drw = update_ps,draw_ps
	elseif btnp(🅾️) then
	 sfx(53)
	 startgame()
	 _upd,_drw=update_game,draw_game
	end

	slidinganimation()

end




function slidinganimation()
	if load_x!=load_dx then
		load_x+=(load_dx-load_x)/5
	end

	if btnp(⬅️) then
		sfx(54)
		load_dx=0
	end

	if btnp(➡️) then
		sfx(54)
		load_dx=128
	end

end




function update_lose()
	dropparticles({1,1,14,8,5,6},{},65)


	if btnp(❎)then
		sfx(52)
		_upd,_drw = update_ps,draw_ps
	elseif btnp(🅾️) then
	 sfx(53)
	 startgame()
	 _upd,_drw=update_game,draw_game
	end

	slidinganimation()


end


function trig_endgame()

	---- subtracting negative
	---- points
	if heart<0 then
		star-=(heart/2)
	end

	if men<0 then
		star-=(men/1.5)
	end

	flr(star)


	if player2 then

		----subtracting negative
		----points for player 2
		if heart_2<0 then
			star_2-=(heart_2/3)
		end

		if men_2<0 then
			star_2-=(men_2/2)
		end


		if star > star_2 then
			winner="player 1"
		else
			winner="player 2"
		end

	else
		if star >winpoint then
			winner="player 1"
		end

	end
	wintext = "congratulations "..winner

	talkqueue=split("now the moment you've all\nbeen waiting for...|after your dedication to\nthe perfume industry...|which one of you\nwill be our featured\nparfumist of the year?|who will be rewarded\nwith their own startup\ncompany?|people of parfum, i'm\nproud to announce...|the winner (★) is...","|")
	_upd,_drw=update_talk,draw_talk

end



function update_nextstage()

	riseparticles()

	--addpart(flr(rnd(128)),flr(rnd(64)),_dx,_dy,2,120+rnd(15),_mycol,3+rnd(6))


	if btnp(❎) then

		if round > 6 then
			trig_endgame()
		else
			_upd,_drw=update_talk,draw_talk
		end

	end

end


function update_upgrade()

	if state1 and not p1ready then
		pips,hincome,slots,heart,men,dice=doupgrade(pips,hincome,slots,pos,cur,heart,men,dice,1)
	elseif not p1ready then
		pos=upgradebutt(pos,cur,heart,men,1)
	end

	if player2 and state2 and not p2ready then
		pips_2,hincome_2,slots_2,heart_2,men_2,dice_2=doupgrade(pips_2,hincome_2,slots_2,pos_2,cur_2,heart_2,men_2,dice_2,2)
	elseif player2 and not p2ready then
		pos_2=upgradebutt(pos_2,cur_2,heart_2,men_2,2)
	end

	if (p1ready) or (p1ready and p2ready and player2) then
		---- setup for the new round
		newround()
		_upd,_drw=update_nextstage,draw_nextstage
	end

end



function update_income()
	--leftov(cur)
	if #dice2r==0 then
		p1ready=true
	end

	if #dice2r_2==0 then
		p2ready=true
	end


	if not p1ready then
		heart,pips,dice2r=leftov(cur,heart,pips,dice2r,1)
	end

	if player2 and not p2ready then
		heart_2,pips_2,dice2r_2=leftov(cur_2,heart_2,pips_2,dice2r_2,2)
	end


	if (p1ready and not player2) or (p1ready and p2ready and player2) then
		--upgrade workers and buy
		-- more dice phase!!
		pos,pos_2,state1,state2,p1ready,p2ready,_upd,_drw=1,1,false,false,false,false,update_upgrade,draw_upgrade
		--state1,state2=false,false
		--p1ready,p2ready=false,false
		--_upd=update_upgrade
		--_drw=draw_upgrade
	end

end


function update_pmade()
	riseparticles()

	f+=2

	if btnp(❎) then
		_upd,_drw=update_income,draw_income
	end

end

////////making perfume
//////////////////////
function update_inv()
	--if btnp(❎) then
		--startgame()
	--end

	if p1ready and not state1 then
		pos,ivn=perfume2butt(pos,cur,inv,1)
	elseif not state1 then
		pname,pos,star,heart,men=perfumebutt(pname,star,heart,men,pos,cur,inv,1)
	end

	if player2 then
		if p2ready and not state2 then
			pos_2,inv_2=perfume2butt(pos_2,cur_2,inv_2,2)
		elseif not state2 then
			pname_2,pos_2,star_2,heart_2,men_2=perfumebutt(pname_2,star_2,heart_2,men_2,pos_2,cur_2,inv_2,2)
		end

	end

	if (state1 and not player2) or (state1 and state2 and player2) then
		p1ready,p2ready,state1,state2,pos,pos_2,cur.x,cur.y,cur_2.x,cur_2.y,_upd,_drw=false,false,false,false,1,1,20,86,90,86,update_pmade,draw_pmade
		--pos,pos_2=1,1
		--cur.x,cur.y,cur_2.x,cur_2.y=20,86,90,86
		--_upd=update_income
		--_drw=draw_income

	end
	--- do some more stuff :)

end




-----------------------------
------------------------
---------------------

///////// selecting scents
//////////////////////
function funupdate()
	local _ang=rnd()
	local _dx = sin(_ang)*(rnd(0.5))
	local _dy = cos(_ang)*(rnd(0.5))
	local _mycol={1,1,15,4,5}


	--addpart(flr(rnd(128)),_top,_dx,_dy,5,80+rnd(15),_mycol,3+rnd(6))
	addpart(flr(rnd(128)),10,_dx,_dy,5,120+rnd(15),_mycol,3+rnd(6))

	--for d in all(dice2r_2) do
		--d.num=6
	--end

	---checking if either player is done
	--if btnp(5,0) then
		--cur.y,p1ready=200,true
		--p1ready=true
		--sfx(60)
	--elseif btnp(5,1) then
		--cur_2.y,p2ready=200,true
		--p2ready=true
		--sfx(60)
	--end
	local ccount=0
	for d in all(dice2r) do
		if d.num==0 then
			ccount+=1
		end
	end

	if ccount==#dice2r then
		p1ready=true
	end

	ccount=0
	for d in all(dice2r_2) do
		if d.num==0 then
			ccount+=1
		end
	end

	if ccount==#dice2r_2 then
		p2ready=true
	end



	if #dice2r==0 or #inv==slots then
		p1ready,cur.y=true,200
		--cur.y=200
	end

	if (#dice2r_2==0 or #inv_2==slots_2) and player2 then
		p2ready,cur_2.y=true,200
		--cur_2.y=200
	end

	if (p1ready and not player2) or (player2 and p1ready and p2ready) then
		--startgame()
		state1,state2=false,false
		cur.x,cur.y,cur_2.x,cur_2.y,pos,pos_2,p1ready,p2ready,_upd,_drw=2,20,68,20,1,1,false,false,update_inv,draw_inv
		--pos,pos_2=1,1
		--p1ready,p2ready=false,false
		--_upd=update_inv
		--_drw=draw_inv
	end

		--------player 1 updates
	if not p1ready then
		pos,dice2r=scentbutt(inv,slots,pos,cur,dice2r,1)
	end

	if player2 and not p2ready then
		pos_2,dice2r_2=scentbutt(inv_2,slots_2,pos_2,cur_2,dice2r_2,2)
	end


end


--------------------
---------------------
------------------------
--------------------


///////// rolling dice screen
//////////////////////
function update_game()
	--
	addpart(flr(rnd(128)),0,0.1,rnd(0.5),0,256,{15},0)


	-------- player 1 updates
	state1,dice,pips,reroll,pos,dice2r,move_die=dobutt(state1,dice,pips,maxroll,reroll,pos,cur,dice2r,move_die,1)
	if player2 then
		state2,dice_2,pips_2,reroll_2,pos_2,dice2r_2,move_die_2=dobutt(state2,dice_2,pips_2,maxroll_2,reroll_2,pos_2,cur_2,dice2r_2,move_die_2,2)
	end
	--spawnbgparts(true,flr(rnd(200)))

end



-->8
-- draw
y,f = 0,0
local text,text2 = "press 🅾️  to start","press ⬅️  for rules"
function draw_ps()
	cls(8)
	local adv= about_x-128

	if player2 then
		rectfill(64,0,128,128,3)
		rectfill(0,17,128,27,7)
		drawparts()
		print("eau de",36+adv,20,8)
		print(" parfum",60+adv,20,3)
		print("    player 2 to\ndisconnect press ❎",25,115,1)
	else
		rectfill(0,17,128,27,7)
		drawparts()
		print("eau de parfum",36+adv,20,8)
		print("for player 2 to join\npress any: ⬅️➡️ ⬆️⬇️ 🅾️",25,115,1)
	end

	wobbletext(text,7,adv,10)

	wobbletext(text2,10,adv,22)

	loadabout(about_x)
end


function wobbletext(text,coll,adv,yplus)
	local y
	local c
	local x = 128/2 - (#text*4)/2
	for c=1,#text do
		y = cos((x+10+f)/110)*2.2 +yplus
		color(coll)
		print(sub(text,c,c),x+adv,60+y)
		x=x+4
	end

end

function expspr(a,b,x,y)
	local xp=0
	for i=a,b do
		spr(i,x+xp,y)
		xp+=10
	end

end

function draw_expo()
	cls(6)
	drawparts()
	rectfill(0,118,128,128,7)
	print("each die has 4 faces",10,8,0)
	expspr(1,4,10,17)

	spr(1,2,32)
	print("buys citrus scents",15,34)
	expspr(26,28,90,32)


	spr(2,2,44)
	print("buys floral scents",15,46)
	expspr(29,31,90,44)

	spr(3,2,56)
	print("buys woody scents",15,58)
	expspr(32,34,90,56)


	spr(4,2,68)
	print("upgrades 1 selected die *",15,70,2)

	spr(1,5,79)
	spr(77,25,79)
	print("->    this is an upgrade",15,81,2)
	print("* upgrades = buy better scents",6,89,2)

	expspr(5,8,5,102)
	print("higher lvl dice come\nwith upgraded sides",47,102)

	print("◆ press ❎ to start ◆",15,121)

end


function draw_win()
 local adv= load_x-128
 cls(15)

 if player2 then
		rectfill(65,0,128,128,10)
	end

	drawparts()

	rectfill(0+adv,35,127+adv,50,7)
	if winner=="player 2" then
		drawperfume(true,23+adv,15)
		wobbletext(wintext,3,adv,-20)
	else
		drawperfume(false,23+adv,15)
		wobbletext(wintext,8,adv,-20)
	end


	rectfill(0,0,128,20,2)
	print("🅾️=play again ❎=main menu",15+adv,3,10)
	print("⬅️=check exact scoring",17+adv,12,15)

	loadscore(load_x)
end

function draw_lose()
	local adv= load_x-128
	cls(5)
	drawparts()

	rectfill(0,65,128,75,1)
	print("you lost",50+adv,67,14)

	rectfill(0,0,128,20,2)
	print("🅾️=play again ❎=main menu",15+adv,3,10)
	print("⬅️=check exact scoring",17+adv,12,15)

	loadscore(load_x)

end


function draw_nextstage()
	cls(15)

	if not player2 then
		drawparts()
	end


	if player2 then
		rectfill(65,0,128,128,10)
		drawparts()
		rectfill(68,50,124,63,8)
		print("player 2 ★: "..star_2,67,10,3)
		print("player 2 ♥: "..heart_2,67,20,3)
		print("player 2 웃: "..men_2,67,30,3)
		print("p2 dice",70,43,0)
		local icount=0
		local xp=0
		for d in all(dice_2) do
			if icount<=3 then
				spr(d.val+d.face,72+xp,53)
				xp+=13
				icount+=1
			end
		end

		print("scent slots: "..slots_2,70,70,3)
		print("+♥"..hincome_2.." per turn",70,80,3)
		print("+1/-1 chips: "..pips_2,70,90,3)


	end


	local p1p=0
	if not player2 then
		p1p=25
	end
	rectfill(5+p1p,50,59+p1p,63,11)
	print("player 1 ★: "..star,5+p1p,10,2)
	print("player 1 ♥: "..heart,5+p1p,20,2)
	print("player 1 웃: "..men,5+p1p,30,2)
	print("p1 dice",5+p1p,43,0)
	local icount=0
	local xp=0
	for d in all(dice) do
		if icount<=3 then
			spr(d.val+d.face,10+xp+p1p,53)
			xp+=13
			icount+=1
		end
	end

	print("scent slots: "..slots,5+p1p,70,2)
	print("+♥"..hincome.." per turn",5+p1p,80,2)
	print("+1/-1 chips: "..pips,5+p1p,90,2)

	rectfill(0,111,128,128,7)
	print("end of round "..(round-1),35,113,0)
	print("press ❎ to continue",20,121,0)



end


function draw_upgrade()
	up_text={"1♥","2♥","4♥"}

	cls(2)
	rectfill(0,0,128,10,14)
	print("🅾️=select ❎=done",22,3,2)

	print("buy a new die: 4♥",5,15,15)
	print("upgrade an existing die: 2♥",5,25,15)
	print("promote 1웃: 1♥",5,35,15)

	print("⬆️",30,52-sin(time()*2),15)
	print("spend "..up_text[pos],5,60,14)
	print("⬇️",30,68+sin(time()*2),15)

	print("p1 ♥: "..heart,5,80,14)

	if player2 then
		print("⬆️",30,92-sin(time()*2),7)
		print("spend "..up_text[pos_2],5,100,10)
		print("⬇️",30,108+sin(time()*2),7)

		print("p2 ♥: "..heart_2,5,120,10)
	end



	------- upgrading the dice
	if state1 and pos==2 then
		print("pick die to upgrade",50,50,7)
		local xp=0
		for d in all(dice) do
			spr(d.val+d.face,50+xp,60)
		xp+=13
		end

		palt(12,true)
		spr(cur.pic,cur.x,cur.y+sin(time()*2))

	------- upgrading the man
	elseif	state1 and pos==1 then

		print("pick a promotion",50,50,7)
		rectfill(50,58,86,78,6)
		print("+1♥ each\nturn\n      웃",51,60,2)
		rectfill(91,58,125,78,7)
		print("+1 slot\n+3 chips\n      웃",92,60,2)

		palt(12,true)
		spr(cur.pic,cur.x,cur.y+sin(time()*2))

	end

	------- upgrading the dice player2
	if state2 and pos_2==2 and player2 then
		--- upgrading dice for player2
		print("pick die to upgrade",50,90,7)
		local xp=0
		for d in all(dice_2) do
			spr(d.val+d.face,50+xp,100)
		xp+=13
		end
		palt(12,true)
		spr(cur_2.pic,cur_2.x,cur_2.y+sin(time()*2))

	------- upgrading the man
	elseif state2 and pos_2==1 and player2 then
		print("pick a promotion",50,90,7)

		rectfill(50,98,86,118,6)
		print("+1♥ each\nturn\n      웃",51,100,2)
		rectfill(91,98,125,118,7)
		print("+1 scent\nslot\n      웃",92,100,2)

		palt(12,true)
		spr(cur_2.pic,cur_2.x,cur_2.y+sin(time()*2))

	end
	palt()


end



function draw_income()
	cls(6)

	print("player 1 ★: "..star,5,10,0)
	print("player 1 ♥: "..heart,5,20,0)
	print("player 1 웃: "..men,5,30,0)

	print("leftover dice",5,45,0)


	local icount=0
	local xp=0
	for d in all(dice2r) do
		if icount <=3 then
			spr(d.val+d.face,10+xp,55)
			xp+=13
			icount+=1
		end
	end

	palt(12,true)
	spr(38,10,65+sin(time()*2))

	rectfill(2,cur.y-9,62,cur.y-2,8)

	print("sell for +1/-1",5,78,15)
	print("sell for 1♥",5,95,15)


	if player2 then
		print("player 2 ★: "..star_2,70,10,2)
		print("player 2 ♥: "..heart_2,70,20,2)
		print("player 2 웃: "..men_2,70,30,2)
		print("leftover dice",70,45,2)

		local icount=0
		local xp=0
		for d in all(dice2r_2) do
			if icount<=3 then
				spr(d.val+d.face,75+xp,55)
				xp+=13
				icount+=1
			end
		end

		palt(12,true)
		spr(38,75,65+sin(time()*2))

		rectfill(67,cur_2.y-9,126,cur_2.y-2,3)

		print("sell for +1/-1",70,78,10)
		print("sell for 1♥",70,95,10)

	end

	rectfill(0,117,128,128,7)
	print("⬆️⬇️=move 🅾️=select ❎=done",12,120,1)

	palt()
	cursordraw()


end

function draw_pmade()
	cls(15)
	local xplus=20

	if player2 then
		rectfill(65,0,128,128,10)
		xplus=0
		if pmade_2 then
			drawparts()
			drawperfume(true,50,18)
			wobbletext("made "..pname_2,3,0,-5)
		else
			print("no perfumes were made",20,57,3)
		end
	end


	if pmade then
		if not pmade_2 then
			drawparts()
		end

		drawperfume(false,xplus,18)
		wobbletext("made "..pname,8,0,-20)

	else
		print("no perfumes were made",20,37,8)
	end

	print("press ❎ to continue",23,10,0)

end


function draw_inv()
	cls(15)

	local y=2
	local typ
	local rank

	drawperfume(false,0,0)
	rectfill(10,50,20,60,2)
	rectfill(10,74,20,84,2)
	rectfill(10,98,20,108,2)

	local icount=0
	for i in all(inv) do
		if icount <=3 then
			getpic(i,y,10)
			y+=15
			icount+=1
		end
	end

	if p1ready then
		print("❎=go back",2,120,8)
	else
		print("❎=make perfume",2,120,8)
	end



	if state1 then
		rectfill(0,33,64,42,7)

		if pmade then
			print("perfume made!",5,37,8)
		else
			print("not complete!",5,37,8)
		end
	else
		local pll=0
		for p in all(parfum) do
			if p=="" then
				pmade=false
			end
			getpic(p,12,51+pll)
			pll+=24
		end


	end



	if player2 then
		rectfill(65,0,128,128,3)
		--where green=true

		rectfill(108,50,118,60,0)
		rectfill(108,74,118,84,0)
		rectfill(108,98,118,108,0)

		y=68
		local jcount=0
		for j in all(inv_2) do
			if jcount<=3 then
				getpic(j,y,10)
				y+=15
				jcount+=1
			end
		end
		palt()
		drawperfume(true,50,0)

		if p2ready then
			print("❎=go back",67,120,10)
		else
			print("❎=make perfume",67,120,10)
		end




		if state2 then
			rectfill(66,33,128,42,7)
			if pmade_2 then
				print("perfume made!",71,37,3)
			else
				print("not complete!",71,37,3)
			end
		else
			local pll=0
			for p in all(parfum_2) do
				if p=="" then
					pmade_2=false
				end
				getpic(p,110,51+pll)
				pll+=24
		end

		end


	else
		rectfill(65,0,128,128,14)
		print("🅾️=select scent",67,120,8)

		print("put 1 scent\nin each slot.",70,4,2)
		print("if you can't,\nthe perfume\nwon't be made.",70,20,2)

		print("citrus top\nfloral middle\nwoody bottom",67,42,13)
		print("+1★",108,60,7)

		print("top=middle\nwoody bottom",67,65,13)
		print("+2★",94,78,7)
		print("+1웃",111,78,0)

		print("citrus top\nmiddle=bottom",67,85,13)
		print("+3★",111,97,7)


		print("all same type",67,104,13)
		print("+4★",94,111,7)
		print("+2♥",111,111,8)

	end




	if p1ready then
		getpic(inv[pos],cur.x+1,cur.y-12)
	end

	if p2ready and player2 then
		getpic(inv_2[pos_2],cur_2.x+1,cur_2.y-12)
	end

	palt()
	cursordraw()

end




------------------screen for
------------------buying scents
-------------------

rank_print={"★","★★","★★★\n★","★","★♥♥","★★★\n♥♥","★","★웃","★★★\n웃"}
cost_print={"1","2","2+2","3","4","4+4","5","6","6+6"}
function fundraw()
	local y =0
	cls(6)
	drawparts()
	rectfill(0,0,128,14,1)
	print("🅾️=buy a scent using\nthe numbers you have",15,2,15)
	rectfill(0,15,128,47,15)
	rectfill(0,50,128,82,13)
	rectfill(0,85,128,117,4)

	print("citrus scents (1-2)",10,18,9)
	print("floral scents (3-4)",10,53,2)
	print("woody scents (5-6)",10,88,0)


	scentspr(26,28,28,7,9)

	scentspr(29,31,63,14,2)

	scentspr(32,34,98,1,0)

	palt()

	local x=0
	print("p1: ",1,120,8)
	for a in all(dice2r) do
		print(a.num..",",16+x,120,8)
		x+=7
	end

	if player2 then
		x=0
		print("p2: ",70,120,3)
		for f in all(dice2r_2) do
			print(f.num..",",85+x,120,3)
			x+=7
		end
	end
		-------- cursors
	cursordraw()

end

function scentspr(a,b,y,c1,c2)
	local y2=10
	for i=a,b do
		spr(i,y2,y)
		print(rank_print[i-25],y2+10,y+2,c1)
		print(cost_print[i-25],y2+10,y+14,c2)
		y2+=40
	end


end


function draw_game()

	cls(11)
	map()

	drawparts()

	if player2 then
		rectfill(0,75,128,130,8)
		drawparts()
	end
	rectfill(0,0,128,20,6)
	if #dice2r_2==0 and #dice2r==0 then
		print("for any player", 35,4,2)
		print("press 🅾️ continue",28,13,2)
	else
		print("⬅️➡️=move  ❎=reroll", 28,4,2)
		print("🅾️=keep selected die",23,13,2)
	end

	move_die,dice_t=dodiceroll(x,dice2r,dice_t,move_die,1)
	if player2 then
		move_die_2,dice_t2=dodiceroll(x_2,dice2r_2,dice_t2,move_die_2,2)
		if #dice2r==0 then
			rectfill(0,65,128,73,7)
			print("player 1 ready",35,68,8)
		end
		if #dice2r_2==0 then
			rectfill(0,118,128,125,7)
			print("player 2 ready",35,120,3)
		end

		print("+1/-1 chips ⬆️⬇️",3,78,10)
		print("chips:"..pips_2,3,92,10)
		print("rolls:"..reroll_2,3,85,10)
	end



	palt(12,true)
	-------- cursors
	if not move_die then
		spr(cur.pic,cur.x,cur.y+sin(time()*2))
	end

		if reroll_2!=maxroll_2 then
			spr(cur_2.pic,cur_2.x,cur_2.y+sin(time()*2)+50)
		elseif player2 then
			spr(cur_2.pic,cur_2.x,cur_2.y+sin(time()*2))
		end

	palt()

	print("+1/-1 chips ⬆️⬇️",3,23,2)
	print("chips:"..pips,3,37,2)
	print("rolls:"..reroll,3,30,2)

	if state1 and #dice2r!=0 then
		print("select die to upgrade",20,68,0)
	end


	if state2 and #dice2r_2!=0 and player2 then
		print("select die to upgrade",20,120,7)
	end

end


-->8
-- tools

function add_dice(_typ,_face, p)
	local d={
		y=140,
		ye=35,
		typ=_typ,
		val=1,
		num=1,
		reroll=true,
		face=_face
	}
	if p==1 then
		add(dice,d)
	else
		d.ye=35+50
		add(dice_2,d)
	end

end

-- type = 1: normal dice
-- type = 2: floral/wood dice
-- type = 3: citrus/floral dice
-- type = 4: gambling dice


function ani2p(times,set)
	times=180
	if times>0 then
		times=0
	end

	for d in all(set) do
		if d.reroll then
			rolldice(d)
			d.y=140
			d.ye = 35+rnd(15)
		end
	end
	return times
end

function rollani(m,pl)
	m = true
	if pl == 2 then
		dice_t2=ani2p(dice_t2,dice_2)
	else
		dice_t=ani2p(dice_t,dice)
	end
	sfx(63)
	return m,dice_t,dice_t2
end


function toreroll(d,set)
	trr = false
	for m in all(set) do
		if m == d then
			trr = true
		end
	end
	return trr
end


function rolldice(d)
	d.val = max(1,flr(rnd(5)))
	valdice(d)
end


function valdice(d)
	if d.typ == 2 then
		d.num = d2[d.val]
	elseif d.typ ==3 then
		d.num = d3[d.val]
	elseif d.typ ==1 then
		d.num = d1[d.val]
	else
		d.num = d4[d.val]
	end
end



---------===============
----------searching for 1 die
function searchdice(dicer,num,fd)

	for d in all(dicer) do
		if d.num==num and not fd then
			fd=true
			del(dicer,d)
		end
	end

	return dicer,fd
end


---------===============
----------searching for 2 dice
function search_2(dicer,num1,num2,fd)
	local f1,f2,fd=false,false,false
	local d1,d2


	for d in all(dicer) do
		if d.num==num1 and not f1 then
			f1=true
			d1=d
		end
	end

	for f in all(dicer) do
		if f.num==num2 and (not f2) and f!=d1 then
			--sfx(57)
			f2=true
			d2=f
		end
	end

	if f1 and f2 then
		del(dicer,d1)
		del(dicer,d2)
		fd=true
	end

	return dicer,fd
end




function inv_ds(typ,rank)
	local pic=32

	if typ=="c" then
		pic=26
	elseif typ=="f" then
		pic=29
	end

	if rank=="2" then
		pic+=1
	elseif rank=="3" then
		pic+=2
	end

	return pic

end






function drawperfume(green,_x,_y)
	if green then
		_pal={128,129,130,131,132,133,134,138,139,139,138,139,140,129,131,131}

		for i=0,15 do
			pal(i,_pal[i+1],0)
		end

	end


	local y=20

	local cont=0
	local pp=34
	local pl=0

	for k=1,24 do
		pp+=1
		y+=8
		cont+=1
		spr(pp,y+_x,50+pl+_y)

		if cont%3==0 then
			y=20
			pp+=13
			pl+=8
			cont=0
		end


	end

	pal()

	funcpal()

end




function cursordraw()
	palt(12,true)
	spr(cur.pic,cur.x,cur.y+sin(time()*2))

	if player2 then
		spr(cur_2.pic,cur_2.x,cur_2.y+sin(time()*2))
	end

	palt()

end


function dodiceroll(xv,set,dt,move,pl)
	local plus=0
	if pl==2 then
		plus=50
	end
	for d in all(set) do
		if move and d.reroll then
			move,dt=movedice(d,xv,dt,move,pl)
		else
			if d.reroll and toreroll(d,set) then
				spr(d.val+d.face, 35+xv, d.y+plus)
			end
		end
		xv+=13
	end
	xv = 0
	return move,dt
end



function movedice(d,xv,dtime,move,pl)
	local plus= 0
	if pl==2 then
		plus = 50
	end
	if dtime>-100 then
		dtime-=1
		if dtime<=0 and d.y > d.ye then
			d.y+=(-24-d.y)/20
		end
		spr(d.val+d.face,35+xv,d.y+plus)
	else
		spr(d.val+d.face,35+xv,d.y+plus)
		move=false
	end
	return move,dtime
end


function getpic(str,x,y)

		if str!="" then
			ty=sub(str,1,1)
			ra=sub(str,2,2)
			undercur=inv_ds(ty,ra)
			palt(0,true)
			spr(undercur,x,y)
		end
end

function sellperfume(name,sta,hear,me,pl)
	local set={}

	if pl==1 then
		set=parfum
	else
		set=parfum_2
	end

	local tylist={}
	for p in all(set) do

		sta,hear,me=addvalue(p,sta,hear,me)
		ty=sub(p,1,1)
		add(tylist,ty)
	end

	---bonus points based
	---on types
	if tylist[1]=="c" and tylist[2]=="f" and tylist[3]=="w" then
		sta+=1
		name = "a parfum"
	elseif tylist[1]==tylist[2] and tylist[2]==tylist[3] then
		sta+=4
		hear+=2
		name = "an eau de parfum"
	elseif tylist[1]==tylist[2] and tylist[3]=="w" then
		sta+=2
		me+=1
		name = "an eau de cologne"
	elseif tylist[2]==tylist[3] and tylist[1]=="c" then
		sta+=3
		name = "an eau de toilette"
	else
		name = "an eau fraiche"
	end

	for p in all(set) do
		del(set,p)
	end

	return name,sta,hear,me

end



function addvalue(str,sta,hear,me)
	local ra,ty

	ra=sub(str,2,2)
	if ra=="3" then
		sta+=3
	else
		sta+=1
	end

	ty=sub(str,1,1)

	if ty=="c" then
		if ra!="1" then
			sta+=1
		end

	elseif ty=="f" then
		if ra!="1" then
			hear+=2
		end

	else
		if ra!="1" then
			me+=1
		end
	end



	return sta,hear,me

end


function reward(sta,hear,me,dicel,pip,inven,income,slot,pl)
	local ttp = {"c","f","w"}

	if r_event==1 then

		if #dicel<5 then
			add_dice(1,0,pl)
		end

		sta-=2
	elseif r_event==2 then
		income+=1
		me-=1
	elseif r_event==3 then
		me+=2
		sta-=1
		hear-=1
	elseif r_event==4 then

		local len=#dicel

		for d in all(dicel) do
			del(dicel,d)
		end

		for i=1,len-1 do
			add_dice(4,12,pl)
		end


	elseif r_event==5 then

		local ccount=0
		for d in all(dicel) do
			if d.typ!=3 and ccount<2then
				del(dicel,d)
				add_dice(3,8,pl)
				ccount+=1
			end
		end

		sta-=1
		hear-=2

	elseif r_event==6 then

		local typ = ttp[flr(rnd(3))+1]

		add(inven,typ..3)
		hear-=1
	elseif r_event==7 then

		for i in all(inven) do
			sta,hear,me=addvalue(i,sta,hear,me)
			del(inven,i)
		end

	elseif r_event==8 then
		slot+=1
		sta-=1
	elseif r_event==9 then

		local ccount=0
		for d in all(dicel) do
			if d.typ!=2 and ccount<2then
				del(dicel,d)
				add_dice(2,4,pl)
				ccount+=1
			end
		end

		sta-=1

	elseif r_event==10 then
		sta+=1
		me+=1
		slot-=1
	elseif r_event==11 then

		me+=1

		local typ = ttp[flr(rnd(3))+1]
		add(inven,typ..2)

		local ccount=0
		for d in all(dicel) do
			if d.typ!=4 and ccount<1then
				add_dice(d.typ+1,d.face+4,pl)
				del(dicel,d)
				ccount+=1
			end
		end

		income-=1
		hear-=1

	else
		pip+=3
		hear-=1


	end

	for f in all(dice2r) do
		del(dice2r,f)
	end

	for f in all(dice2r_2) do
		del(dice2r_2,f)
	end


	for d in all(dice) do
		d.reroll=true
		add(dice2r,d)
	end

	for d in all(dice_2) do
		d.reroll=true
		add(dice2r_2,d)
	end



	return sta,hear,me,dicel,pip,inven,income,slot
end

-->8
-- gameplay updates


-- button actions associated
function upgradebutt(poz,curs,hear,me,pl)
	butt = pl-1
	if btnp(2,butt) then
		sfx(56)
		poz=min(3,poz+1)
	elseif btnp(3,butt) then
		sfx(56)
		poz=max(poz-1,1)
	elseif btnp(4,butt) then
		if (poz==1 and hear>0 and me>0) or (poz==2 and hear>=2) or (poz==3 and hear>=4) then
			if poz!=3 then
				sfx(58)
			end
			if pl==1 then
				curs.x,curs.y=50,70
				if poz==1 then
					curs.y+=10
				end
				state1=true
			else
				curs.x,curs.y=50,110
				if poz==1 then
					curs.y+=10
				end
				state2=true
			end
		else
			sfx(59)
		end
	elseif btnp(5,butt) then
		sfx(60)
		if pl==1 then
			p1ready=true
		else
			p2ready=true
		end
	end

	return poz
end


function doupgrade(pip,income,slot,poz,curs,hear,me,dicel,pl)
	butt=pl-1

	----- upgrade the man
	if poz==1 then

		if btnp(0,butt) then
			sfx(62)
			curs.x=max(50,curs.x-50)
		elseif btnp(1,butt) then
			sfx(62)
			curs.x=min(curs.x+50,100)
		elseif btnp(4,butt) then

			if curs.x==100 then
				if slot < slotmax then
					sfx(57)
					slot+=1
					pip+=3
					hear-=1
					me-=1
				else
					sfx(59)
				end

			else
				sfx(57)
				hear-=1
				me-=1
				income+=1
			end

			if pl==1 then
				state1=false
			else
				state2=false
			end
			---upgrade the man here
			--- because a promotion
			-- was chosen
		elseif btnp(5,butt) then
			sfx(59)
			if pl==1 then
				state1=false
			else
				state2=false
			end

		end


	----- upgrade the die
	elseif poz==2 then

		if btnp(0,butt) then
			sfx(62)
			curs.x=max(50,curs.x-13)
		elseif btnp(1,butt) then
			sfx(62)
			curs.x=min(curs.x+13,50+((#dicel-1)*13))
		elseif btnp(4,butt) then
			local posi=((curs.x-50)/13)+1
			local dicechosen=dicel[posi]
			dicel,hear=upgradedie(dicechosen,dicel,hear,pl)

			if pl==1 then
				state1=false
			else
				state2=false
			end

		elseif btnp(5,butt) then
			sfx(59)
			if pl==1 then
				state1=false
			else
				state2=false
			end
		end


	----- add a new die
	else
		if #dicel>=6 then
			sfx(59)
		else
			sfx(58)
			hear-=4
			add_dice(1,0,pl)
		end
		if pl==1 then
			state1=false
		else
			state2=false
		end
	end


	return pip,income,slot,hear,me,dicel
end



function upgradedie(die,dicel,hear,pl)
	local typeup = die.typ+1
	local piclist = {0,4,8,12}

	if typeup>4 then
		sfx(59)
		return dicel,hear
	else
		sfx(57)
		del(dicel,die)
		add_dice(typeup,piclist[typeup],pl)
		hear-=2
	end

	return dicel,hear
end



function leftov(curs,hear,pip,dicer,pl)
	butt = pl-1
	if btnp(2,butt) then
		sfx(62)
		curs.y=max(curs.y-16,86)
	elseif btnp(3,butt) then
		sfx(62)
		curs.y=min(curs.y+16,102)
	elseif btnp(4,butt) then
		sfx(58)
		if curs.y==102 then
			hear+=1
		else
			pip+=1
		end
		deli(dicer,1)
	elseif btnp(5,butt) then
		sfx(60)
		if pl==1 then
			p1ready=true
		else
			p2ready=true
		end
	end
	return hear,pip,dicer
end




function perfumebutt(name,sta,hear,me,poz,curs,inven,pl)
	butt = pl-1
	if btnp(0,butt) then
		sfx(62)
		if pl==1 then
			curs.x=max(2,curs.x-15)
		else
			curs.x=max(68,curs.x-15)
		end
		poz=max(poz-1,1)

	elseif btnp(1,butt) then
		sfx(62)
		if pl==1 then
			curs.x=min(curs.x+15, 2+((#inven-1)*15) )
		else
			curs.x=min(curs.x+15, 68+((#inven-1)*15) )
		end
		poz=min(poz+1,#inven)

	elseif btnp(4,butt) and #inven!=0 then
		--move to new state
		sfx(61)
		if pl==1 then
			curs.x,curs.y,p1ready=11,63,true
		else
			curs.x,curs.y,p2ready=109,63,true
		end


	elseif btnp(5,butt) then
		--- press the ❎ button

		sfx(57)

		local set={}
		if pl==1 then
			set,state1=parfum,true
			--- we check if the perfume
			--- is ready to be sold

			--- exit from this state


		else
			set,state2=parfum_2,true
			--- we check if the perfume
			--- is ready to be sold

			--- exit from this state

		end

		local pcount=0
		for p in all(set) do
			if p!="" then
				pcount+=1
			end
		end

		if pcount==3 then

			name,sta,hear,me=sellperfume(name,sta,hear,me,pl)
			if pl==1 then
				pmade=true
			else
				pmade_2=true
			end
		end

	end

	return name,poz,sta,hear,me
end



function perfume2butt(poz,curs,inven,pl)
	butt = pl-1
	if btnp(2,butt) then
		sfx(62)
		curs.y=max(curs.y-24,63)
	elseif btnp(3,butt) then
		sfx(62)
		curs.y=min(curs.y+24,111)
	elseif btnp(5,butt) then
		sfx(59)
		if pl==1 then
			curs.x,p1ready=2,false
		else
			curs.x,p2ready=68,false
		end
		curs.y,poz=20,1
	elseif btnp(4,butt) then
		poz,inven=makeperfume(curs,inven,poz,pl)
		if pl==2 then
			p2ready,curs.x=false,68
		else
			p1ready,curs.x=false,2
		end
		curs.y,poz=20,1
	end
	return poz,inven
end


function makeperfume(curs,inven,poz,pl)
	--local
	local index=0
	if curs.y==63 then
		index=1
	elseif curs.y==111 then
		index=3
	else
		index=2
	end

	if pl==1 then
		add(parfum,inven[poz],index)
		deli(parfum,index+1)

	else
		add(parfum_2,inven[poz],index)
		deli(parfum_2,index+1)
	end

	del(inven,inven[poz])
	sfx(58)
	return poz,inven
end


function scentbutt(inven,slot,poz,curs,dicer,pl)
	butt = pl-1
	if btnp(0,butt) then
		sfx(62)
		curs.x=max(10,curs.x-40)
	elseif btnp(1,butt) then
		sfx(62)
		curs.x=min(curs.x+40,90)
	elseif btnp(2,butt) then
		sfx(62)
		curs.y,poz=max(curs.y-35,40),max(poz-1,1)
	elseif btnp(3,butt) then
		sfx(62)
		curs.y,poz=min(curs.y+35,110),min(poz+1,3)

	elseif btnp(4,butt) then

		dicer=evalscent(curs,poz,dicer,pl)

	end

	return poz,dicer
end




function evalscent(curs,poz,dicer,pl)
	local rank=0
	local num_check = 0
	local typ=""
	local founddice=false

	if poz == 1 then
		--== citrus eval
		num_check = 1
		typ="c"
	elseif poz ==2 then
		--== floral eval
		num_check = 3
		typ="f"
	else
		--== woody eval
		num_check = 5
		typ="w"
	end


	if curs.x==10 then
		/////////-----rank=1
		rank=1
		dicer,founddice=searchdice(dicer,num_check,founddice)

	elseif curs.x==50 then
		//////////-----rank=2
		rank=2
		num_check+=1
		-------searching for
		--------"advanced" die
		----- 2, 4 and 6
		dicer,founddice=searchdice(dicer,num_check,founddice)
		--num_check-=1

		--if not founddice then
			----searching for 2 1s
			----a pair to buy

	else
		/////////////-----rank=3
		--sfx(56)
		rank=3
		num_check+=1
		------- searching for 1 and 2
		----------dicer,founddice=search_2(dicer,num_check,num_check+1,founddice)
		----------if not founddice then
			----- searching for 2 and 2
		dicer,founddice=search_2(dicer,num_check,num_check,founddice)
		------------end

	end


	if founddice then
		sfx(61)

		--- actually adding items
		--- to the inventory

		if pl==1 then
			add(inv,typ..rank)
		else
			add(inv_2,typ..rank)
		end

	else
		sfx(59)
	end

	return dicer
end




function dobutt(state,dicel,pip,maxx,roll,poz,curs,dicer,move,pl)
	butt = pl-1
	if btnp(5,butt) and roll > 0 and #dicer>0 then
		roll -= 1
		poz= 1
		curs.x=35

		move,dice_t,dice_t2=rollani(move,pl)
		curs.y=dicer[1].ye +11
	elseif not move and roll<maxx then
		if btnp(0,butt) and #dicer!=0 then
			sfx(62)
			curs.x= max(curs.x-13,35)
			poz = max(1,poz-1)
			curs.y = dicer[poz].y + 11
		elseif btnp(1,butt) and #dicer!=0 then
			sfx(62)
			curs.x= min(curs.x+13,35+((#dicer-1)*13))
			poz = min(#dicer,poz+1)
			curs.y= dicer[poz].y + 11
		elseif btnp(2,butt) and #dicer!=0 and pip>0 then
			if dicer[poz].val < 3 and dicer[poz].val!=4 then
				pip-=1
				dicel[poz].num+=2
				dicel[poz].val+=1
				sfx(56)
			else
				sfx(59)
			end

		elseif btnp(3,butt) and #dicer!=0 and pip>0 then
			if dicer[poz].val > 1 and dicer[poz].val < 150 and dicer[poz].val!=4 then
				pip-=1
				dicel[poz].num-=2
				dicel[poz].val-=1
				sfx(56)

			else
				sfx(59)
			end


		elseif btnp(4,butt) then
			if #dicer==0 then
				poz,dicer=resetdie(dicer,poz,curs,pl)
			elseif dicer[poz].num == 0 then
				state=true
				poz,dicer=resetdie(dicer,poz,curs,pl)
			else
				if state and dicer[poz].num%2==1 then
					sfx(52)
					state=false
					dicer[poz].num+=1
					dicer[poz].val+=150
				else
					poz,dicer=resetdie(dicer,poz,curs,pl)
				end
			end

		end

	end

	return state,dicel,pip,roll,poz,dicer,move
end



function resetdie(dicer,poz,curs,pl)
		if (#dice2r==0 and #dice2r_2==0 and player2) or (#dicer==1 and not player2) then

			--refilling dice2r
			del(dicer,dicer[poz])
			dice2r,dice2r_2 = addstock()
			p1ready,p2ready,state1,state2,cur.x,cur.y,cur_2.x=false,false,false,false,10,38,10
			if player2 then
				cur_2.y=108
			else
				cur_2.y=170
			end

			if pl==2 then
				poz=3
			else
				poz=1
			end

			_upd,_drw=funupdate,fundraw


		elseif #dicer==0 and player2 then
			if pl==2 then
				poz=3
			else
				poz=1
			end
			sfx(59)
		elseif #dicer==1 and player2 then
			dicer[poz].reroll=false
			dicer,curs.x={},35
			if pl==2 then
				poz=3
			else
				poz=1
			end
			sfx(60)
		else
			sfx(61)
			dicer[poz].reroll=false
			curs.x=35

			del(dicer,dicer[poz])
			poz=1
			curs.y=dicer[poz].y+11
		end
		return poz,dicer
end


-->8
-- ui juice

-- add a particle
function addpart(_x,_y,_dx,_dy,_type,_maxage,_col,_s)
	local _p={}
	_p.x=_x
	_p.dx=_dx
	_p.y=_y
	_p.dy=_dy
	_p.tpe=_type
	_p.mage=_maxage
	_p.age=0
	_p.col=_col[1]
	_p.colarr=_col
	_p.s=_s
	_p.os=_s
	add(part,_p)
end




---type 0 static pixel
---type 1 moving pixel
---type 2 ball of smoke
---type 3 rotating sprite

---update funciton
function updateparts()
	local _p
	for i=#part,1,-1 do
		_p=part[i]
		_p.age+=1
		if _p.age>_p.mage then
			del(part,part[i])
		elseif _p.x <-20 or _p.x >148 then
			del(part,part[i])
		elseif _p.y <-20 or _p.y >148 then
			del(part,part[i])
		else
			--change colors
			if #_p.colarr==1 then
				_p.col = _p.colarr[1]
			else
				local _ci = (_p.age/_p.mage)
				_ci = 1+flr(_ci*#_p.colarr)
				_p.col=_p.colarr[_ci]
			end

			--- apply gravity
			if _p.tpe==1then
				_p.dy+=0.05
			end


			--appy low gravity
			if _p.tpe == 5 or _p.tpe==3 then
    if abs(_p.dy)<1 then
     _p.dy+=0.01
    end
   end


   if _p.tpe ==6 then
   	if abs(_p.dy)<1 then
   		_p.dy-=0.01
   	end
   end


   --shrink
   if _p.tpe == 2 or _p.tpe == 5 or _p.tpe==6  then
    local _ci=1-(_p.age/_p.mage)
    _p.s=_ci*_p.os
   end

			--- rotate (was not added)
			--if _p.tpe==3 then
				--_p.rottimer+=1
				--if	_p.rottimer>30 then
					--_p.rot+=1
					--if _p.rot>=4 then
						--_p.rot=0
					--end
				--end
			--end

			--- move particle
			_p.x+=_p.dx
			_p.y+=_p.dy

		end
	end
end


---draw particles
function drawparts()
	local _p
	for i=1,#part do
		--pixel particcle
		_p=part[i]
		if _p.tpe == 0 or _p.tpe == 1 then
			pset(_p.x,_p.y,_p.col)
		elseif _p.tpe ==2 or _p.tpe==5 or _p.tpe==6 then
			circfill(_p.x,_p.y,_p.s,_p.col)
		end

	end
end
-->8
--- text stuff

function draw_talk()
 cls(15)

 if player2 then
		rectfill(65,0,128,128,10)
		if choice then
			print("both players should agree\n   on the decision made",15,10,0)
		end
	end
	drawparts()
 drawprofile()

 drawtxt(helpy)

end

function dropparticles(_col1,_col2,top)
	local _ang=rnd()
	local _dx = sin(_ang)*(rnd(0.5))
	local _dy = cos(_ang)*(rnd(0.5))
	local _mycol
	if player2 then
		_mycol=_col2
	else
		_mycol=_col1
	end

	local _toprow = top
	local _btmrow= _toprow+7
	addpart(flr(rnd(128)),_toprow,_dx,_dy,5,120+rnd(15),_mycol,3+rnd(6))
	addpart(flr(rnd(128)),_btmrow,_dx,_dy,5,40+rnd(15),_mycol,3+rnd(6))



end


function riseparticles()
	local _ang=rnd()
	local _dx = sin(_ang)*(rnd(0.5))
	local _dy = cos(_ang)*(rnd(0.5))
	local _mycol
	if player2 then
		_mycol={7,7,10,14,11}
	else
		_mycol={7,7,14,6,9}
	end

	local _toprow = 127
	addpart(flr(rnd(128)),_toprow-flr(rnd(10)),_dx,_dy,6,120+rnd(15),_mycol,3+rnd(6))

end


function drawtxt(y)
 local x,w=6,116
 rectfill(5,y-1,122,y+25,8)

 rectfill(x+1,y+1,x+w-2,y+23,15)

 rectfill(x-2,y-13,x+38,y-4,15)
 print("rosalinde",x,y-10,8)

 if choice then
 	spr(48,x+3,y+3+ch_y)

 	local col1,col2

 	if ch_y>0 then
 		col1,col2=6,2
 	else
 		col1,col2=2,6
 	end

 	print("go ahead with it.",x+12,y+4,col1)
 	print("i'd rather not...",x+12,y+14,col2)
	else
		print(talktxt,x+4,y+4,8)
 	if txtbuttx then
  	rectfill(109,y+22,117,y+28,8)
  	print("❎",110,flr(y)+22.5+abs(sin(time()/2)),15)
 	end
	end


end


function dotxt()
 helpy+=(helpdy-helpy)/4
 if frames%2==0 then
	 if #talktxt!=#talktxtd then
	  talktxt=sub(talktxtd,1,#talktxt+1)
	  sfx(55)
	 end
 end
end



function update_talk()

 riseparticles()

 dotxt()
 if btnp(5) then

  if choice then
 		sfx(57)
 		choice=false
 		choicemade=true
 	end

  if #talkqueue>0 then
   nexttalk()
  elseif #talkqueue==0 and round > 6 then
  	if not player2 and star<winpoint then
  		_upd,_drw=update_lose,draw_lose
  	else
  	_upd,_drw=update_win,draw_win
  	end

  elseif #talkqueue==0 and not choicemade then
  	talktxtd="..."
  	choice=true
  else

			if ch_y==0 then
				star,heart,men,dice,pips,inv,hincome,slots=reward(star,heart,men,dice,pips,inv,hincome,slots,1)
				if player2 then
					star_2,heart_2,men_2,dice_2,pips_2,inv_2,hincome_2,slots_2=reward(star_2,heart_2,men_2,dice_2,pips_2,inv_2,hincome_2,slots_2,2)
				end
			end


			talkt[r_event]="x"

			while talkt[r_event]=="x" do
				r_event=flr(rnd(#talkt))+1
			end

			talkqueue=split(talkt[r_event],"|")
   move_die,move_die_2,x,x_2,dice_t,dice_t2=false,false,0,0,180,180
   _upd,_drw=update_game,draw_game
  end
 elseif choice then
 	if btnp(2) then
 		sfx(62)
 		ch_y=max(0,ch_y-10)
 	elseif btnp(3) then
 		sfx(62)
 		ch_y=min(ch_y+10,10)
		end

 end


end


function nexttalk()
 local t=talkqueue[1]
 talktxtd,talktxt=t,""
 del(talkqueue,t)
end





function drawprofile()


	local y=75
	local cont=0
	local pp=38
	local pl=0

	for k=1,16 do
		pp+=1
		y+=8
		cont+=1
		spr(pp,y,63+pl)

		if cont%4==0 then
			y=75
			pp+=12
			pl+=8
			cont=0
		end


	end


end
__gfx__
000000000777777007777770077777700777777009999990033333300999999009999990044444400eeeeee00eeeeee004444440088888800888888008888880
00000000777777777777277777777777777277779999999939993993999999999993999944444444e444e44ee444444e444e44448ffffff88ffffff88fff8ff8
007007007772277777727277772222777722277799933999399393939933339999333999444ee444e44e4e4ee4eeee4e44eee4448ff88ff88ff88ff88ff8f8f8
00077000772272777777277777222277722222779933939939993993993333999333339944ee4e44e444e44ee4eeee4e4eeeee448f88f8f88f88f8f88fff8ff8
00077000772722777722777777277277777277779939339939339993993993999993999944e4ee44e4ee444ee4e44e4e444e44448f8f88f88f8f88f88f88fff8
007007007772277777722777772222777772777799933999399339939933339999939999444ee444e44ee44ee4eeee4e444e44448ff88ff88ff88ff88ff88ff8
00000000777777777777777777777777777722779999999939999993999999999999339944444444e444444ee444444e4444ee448ffffff88ffffff88ffffff8
000000000777777007777770077777700777777009999990033333300999999009999990044444400eeeeee00eeeeee004444440088888800888888008888880
0888888009999990033333300ffffff00ffffff00ffffff00ffffff00ffffff0cccc8cccccccdccc097779000b777b0008fff80000d999d0003eee3000f888f0
8ffffff89999399939993993f88ffffff88ff88ff88ff88ffff88ffffff88fffccc8f8cccccdadcc97999790b7bbb7b08f888f800d9d9d9d03e3e3e30f8f8f8f
8f8888f89993939939939393f88ffffff88ff88fffffffffff8ff8ffff8ff8ffcc8fff8cccdaaadc797979797b7b7b7bf8f8f8f80d99799d03ee7ee30f88788f
8f8888f89999399939993993fffffffffffffffff88ff88ff8ff8f8ff8ff8f8fc8fffff8cdaaaaad799799797bb7bb7bf88f88f80d9d9d9d03e3e3e30f8f8f8f
8f8ff8f89933999939339993fffffffffffffffff88ff88ff8f8ff8ff8f8ff8fc8eeeee8cdbbbbbd797979797b7b7b7bf8f8f8f800d999d0003eee3000f888f0
8f8888f89993399939933993fffff88ff88ff88fffffffffff8ff8ffff8ff8ffc222e222c222b22297999799b7bbb7bb8f888f880000b000000010000000b000
8ffffff89999999939999993fffff88ff88ff88ff88ff88ffff88ffffff88fffccc2e2ccccc2b2cc097779000b777b00f8fff8f0000b70b00001c010000bb0b0
0888888009999990033333300ffffff00ffffff00ffffff00ffffff00ffffff0ccc222ccccc222cc099999000bbbbb0008888800000077000000cc000000bb00
444444444444444444444444000000ddddddddddd0000000cccc4ccc00000000000dddddd2200000000000000999999009999990044444400444444000000000
555994952227747211188481000000d777777777d0000000ccc474cc000000000dd888eeee82200000000000999aa99999aa9999444eee4444eee44400000000
444444444444444444444444000000d777777777d0000000cc47774c0000000dd88ffffd22eed2000000000099a99a999a99a9a944e444444e4444e400000000
594995552747722218488111000000d777777777d0660000c4777774000000dd88efddd8882ee8220000000099a999999a9999a944eeee444eeee4e400000000
444444444444444444444444000000d777777777dd86d000c477777400000dd88eed888dee82ee8d2000000099a999999a9999a944e444444e4444e400000000
559949552277472211884811000000d77777777778688000c22272220000dd88eed8eee8dee82ee8d220000099a99a999a99a99944e444444e44444400000000
44444444444444444444444400000088877777777688d000ccc272cc000dd8ddddd8ffffdfe882e8d8820000999aa99999aa99a944e444444e4444e400000000
5594495522744722118448110000068fff88f88868066000ccc222cc00d888deee7ddddddfee882e8d8820000999999009999990044444400444444000000000
00000000000000000000000000866ff6dfff686ff80000000000000000d88d8eddddfffd8d7ee82d88d882000444444004444440000000000000000000000000
08000000000000000000000000d8866dd8dd6d6dd6888000000000000d88d8dd8e7d7dfddddee82de88d8200444ee44444ee4444000000000000000000000000
08800000000000000000000000dd77778dd668d8dd86686800000000288d887d8edddddfe8de8828d8d8820044e44e444e44e4e4000000000000000000000000
0888000000000000000000000066777777777777777d66880000000028ed88ed8edeffd8ddd88228d2d8820044e44e444e44e4e4000000000000000000000000
0880000000000000000000000677777777777777767777760000000028eed8efddd8e8ddd8822288d288220044e44e444e44e4e4000000000000000000000000
080000000000000000000000d777777777777777d777777d0000000028ee7d88eefdddff88dee88d2282000044e44e444e44e444000000000000000000000000
000000000000000000000000d7777777777777777777777d00000000288eefddd8fffff88deed88d28820000444ee44444ee44e4000000000000000000000000
000000000000000000000000d77777777777777777777ddd00000000288eef28828888222eed882e288200000444444004444440000000000000000000000000
000000000000000000000000dddddddddddddddddddddddd000000000288eef2822222eeeed88288288200000000000007777770022222200777777002222220
000000000000000000000000dddddddddddddddddddddddd0000000000288ee2288888888d822882888200000000000077777777277777727777277727772772
000000000000000000000000d777ffd8777777778dff777d00000000000222222effddddd2288228882200000000000077722777277227727772727727727272
000000000000000000000000d777ffd8777777778dff777d00000000000000002eed888828882888822000000000000077227277272272727777277727772772
000000000000000000000000d777ffd8777777778dff777d0000000000000002228ed82288222422200000000000000077272277272722727722777727227772
000000000000000000000000d777ffd8777777778dff777d00000000000000028228e288822eee20000000000000000077722777277227727772277727722772
000000000000000000000000d777ffd8777777778dff777d00000000000000028822288222eeeee2000000000000000077777777277777727777777727777772
000000000000000000000000d777ffd8777777778dff777d000000000000000028882222eeeeeff2200000000000000007777770022222200777777002222220
000000000000000000000000d777ffd8888888888dff777d000000000000000022288822eeeffff27d0000000000000007777770022222200000000000000000
000000000000000000000000d777ffd8888888888dff777d000000000000000000222222fffffff2772200000000000077777777277777720000000000000000
000000000000000000000000d777ffd8f8f8f8f8fdff777d000000000000000000000002fffffff2277200000000000077222277272222720000000000000000
000000000000000000000000d777ffdf8f8f8f8f8dff777d000000000000000000000002ffffffff277220000000000077222277272222720000000000000000
000000000000000000000000d777ffd8f8f8f8f8fdff777d0000000000000000222222222fffffff277222000000000077277277272772720000000000000000
000000000000000000000000d777ffdffffffffffdff777d000000000000002255555552722fffff277252200000000077222277272222720000000000000000
000000000000000000000000d777ff8ffffffffff8ff777d0000000000000025555555527722222f227255200000000077777777277777720000000000000000
000000000000000000000000d777ff8ffffffffff8ff777d00000000000000555555555277777722522255500000000007777770022222200000000000000000
000000000000000000000000d777ff8ffffffffff8ff777d00000000000000555555555d7777777d555d55500000000000000000000000000000000000000000
000000000000000000000000d777ff8ffffffffff8ff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777ff8ffffffffff8ff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777ff8ffffffffff8ff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777ff8ffffffffff8ff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777ff8ffffffffff8ff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777ff8ffffffffff8ff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777ff8ffffffffff8ff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777ffffffffffffffff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777ffffffffffffffff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777ffffffffffffffff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777ffffffffffffffff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777fffffffffffff7ff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777ff7fff7fffffffff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777ffffffff7fffffff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777ff7f7fffffffffff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777f7f7f7fffff7f7ff777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d7777f7f7f7f7f7f7f7f777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d777f7f7f7f7f7f7f7f7777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d7777f7f7f7f7f7f7f7f777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d7777777777777777777777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d7777777777777777777777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d7777777777777777777777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000d7777777777777777777777d00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000d777777777777777777777d0000000002222220022222200222222000000000033333300333333003333330000000000eeeeee0
0000000000000000000000000d7777777777777777777dd0000000002777777227772772277777720000000039999993399939933999999300000000e444444e
00000000000000000000000000ddddddddddddddddddd000000000002772277227727272272222720000000039933993399393933933339300000000e44ee44e
000000000000000000000000000000000000000000000000000000002722727227772772272222720000000039339393399939933933339300000000e4ee4e4e
000000000000000000000000000000000000000000000000000000002727227227227772272772720000000039393393393399933939939300000000e4e4ee4e
000000000000000000000000000000000000000000000000000000002772277227722772272222720000000039933993399339933933339300000000e44ee44e
000000000000000000000000000000000000000000000000000000002777777227777772277777720000000039999993399999933999999300000000e444444e
0000000000000000000000000000000000000000000000000000000002222220022222200222222000000000033333300333333003333330000000000eeeeee0
0eeeeee00eeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e444e44ee444444e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e44e4e4ee4eeee4e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e444e44ee4eeee4e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e4ee444ee4e44e4e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e44ee44ee4eeee4e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e444444ee444444e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0eeeeee00eeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjvvvvvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjvvvoovvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjvvovvovvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjvovvovovjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjvovovvovjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjvvovvovvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjvvvoovvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjkkkkkkjjjjjjjppppppjjjjjjjvvvvvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjkuukkkkkjjjjjpqqpppppjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjkuukkkkkjjjjjpqqpppppjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjnnnnnnjjjjjjkkkuukkkjjjjjppppppppjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjnllnnllnjjjjjkkkuukkkjjjjjppppppppjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjnnnnnnnnjjjjjkkkkkuukjjjjjpppppqqpjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjnllnnllnjjjjjkkkkkuukjjjjjpppppqqpjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjnllnnllnjjjjjjkkkkkkjjjjjjjppppppjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjnnnnnnnnjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjnllnnllnjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjnnnnnnjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvvjjvjvjvvvjvvvjvvvjvvvjjjjjvvvjjvvjjjjjjjjjvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjvjvjvvvjvjvjvjjjvjvjjjjjjvjjvjjjjvjjjjjjvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjvjvjvjvjvvjjvvjjvvjjjjjjjvjjvvvjjjjjjjjjvvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjvjvjvjvjvjvjvjjjvjvjjjjjjvjjjjvjjvjjjjjjvjvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjjvvjvjvjvvvjvvvjvjvjjjjjvvvjvvjjjjjjjjjjvvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvvjjvjvjvvvjvvvjvvvjvvvjjjjjvvvjjvvjjjjjjjjjvvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjvjvjvvvjvjvjvjjjvjvjjjjjjvjjvjjjjvjjjjjjjjvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjvjvjvjvjvvjjvvjjvvjjjjjjjvjjvvvjjjjjjjjjjvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjvjvjvjvjvjvjvjjjvjvjjjjjjvjjjjvjjvjjjjjjjjvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjjvvjvjvjvvvjvvvjvjvjjjjjvvvjvvjjjjjjjjjjvvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvvjjvjvjvvvjvvvjvvvjvvvjjjjjvvvjjvvjjjjjjjjjvvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjvjvjvvvjvjvjvjjjvjvjjjjjjvjjvjjjjvjjjjjjjjvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjvjvjvjvjvvjjvvjjvvjjjjjjjvjjvvvjjjjjjjjjvvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjvjvjvjvjvjvjvjjjvjvjjjjjjvjjjjvjjvjjjjjjvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjjvvjvjvjvvvjvvvjvjvjjjjjvvvjvvjjjjjjjjjjvvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvvjjvjvjvvvjvvvjvvvjvvvjjjjjvvvjjvvjjjjjjjjjvvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjvjvjvvvjvjvjvjjjvjvjjjjjjvjjvjjjjvjjjjjjvjvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjvjvjvjvjvvjjvvjjvvjjjjjjjvjjvvvjjjjjjjjjvjvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjvjvjvjvjvjvjvjjjvjvjjjjjjvjjjjvjjvjjjjjjvjvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjvjvjjvvjvjvjvvvjvvvjvjvjjjjjvvvjvvjjjjjjjjjjvvvjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj

__sfx__
011a00001705017050170501705017050170501705017050177501700017150171501b1501c1501e1500000015150000001515000000000000000000000000001415000000141500675006750067500675006750
011a00001705017050170501705017050170501705017050177501700017150171501b1501c1501e150000000e150000000e15000000000000000000000000001415000000141500000000000000000000000000
011a00001b0401b0401b0401b0401b0401b0401b0401b0401b0400b7500b7500b7500b7500b7500b7500b7501a140000001a14000000000000000000000000001914000000191400b7500b7500b7500b7500b750
011a00001e1401e1401e1401e1401e1401e1401e1401e1401e14000000177501b7501e750177501b7501e7501e040000001e04003750037500375003750037501c040000001c0400000000000000000000000000
001a00000f675000051c6750a6750e675000050d675000050c675000050c675000050c6750b6050b6750b6050a6750a605096750a605096750960509675096050967509605096750960508675186750567509675
011a00001b0401b0401b0401b0401b0401b0401b0401b0401b04000000177001b7001e700177001b7001e7001c140000001c1401c7001b7501c75019750237501914000000191400000000000000000000000000
011a0000151501e100151500b7550b7550b7550b755151550b755151500b7550b7550b7550b7550b7550b7551415001755141500175501755017550175514150000001415001755037550b7550b7550175503755
011a00001a140000001a1400000000000000001a140000001a1401005010055100551005510055100551005519140000001914023750197501b7501c750191400000019140000000000023750197501b7501c750
011a00001e040000001e0400000000000000001e040000001e040000001c7501e7502075021750237501e7501c050000001c050000000000000000000001c050000001c050000001e7502075021750237501e750
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000700000c1500a15014060190602006026020300201c000230002d00039000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000017060250501900014060201601b1500e040101000f1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001964015630106300d6300a620033000332000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000160300f130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000013130181301a1401a1401a640196200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000029050290501f0501f0502e0602e0600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200001914018140125400d5500c1300b5401154013130131401f05024050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000018650124500e3400a43009420064300443002420034200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000240202b13022030241302e040330400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000250202c03021030230302d040320402800028000270002a0002e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000150501c050140501c0501f05020050161001f1000d6000b6000b6000a6000000000000000000a600096000e3001830000000000000000000000000000000000000000000000000000000000000000000
000100001065009660156001260010650186601563012640053000d64005640086300663005630046200261000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 00040203
00 01040503
00 06040708
02 06040708
