pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--init
player = {
	x = 60,
	y = 60,
	vx = 0,
	vy = 0,
	speed = 0.3,
	friction = 0.8,
	gravity = 0, life = 5
}

cam = { x = 0, y = 0, deep = 0 }
agmentationvalue = 0
particles = {}

anchor = {x=0, y=0}
explode = false
lock = false
left,right,up,down,btno,btnx = 0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

function _init()
	firstgenerationmap()
end

-->8
--update

function _update60()
	if (player.life <= 0) then
		return
	end
	if btn(left) then
		player.vx -= player.speed
	end
	if btn(right) then
		player.vx += player.speed
	end
	if btn(up) then
		player.vy -= player.speed
	end
	if btn(down) then
		player.vy += player.speed
	end
	player.vx *= player.friction
	player.vy *= player.friction
	if ( 4 <= player.x+player.vx and player.x+player.vx <=116) then
		player.x += player.vx
	end
	player.y += player.vy

	--anchors
	--for all(anchors) do
	anchor.x, anchor.y = player.x, player.y + 14
	destroy_x1 = (anchor.x) \ 8
	--destroy_y1 = (anchor.y \ 8)+((cam.deep\64))
	destroy_y1 = (anchor.y \8)
	destroy_x2 = (anchor.x + 8) \ 8
	targetblock1 = mget(destroy_x1, destroy_y1)
	targetblock2 = mget(destroy_x2, destroy_y1)
	if targetblock1 == 10 or targetblock2 == 10 then
		explode = true
		
	end
	mset(destroy_x1, destroy_y1, 0)
	mset(destroy_x2, destroy_y1, 0)

	--camera
	if(rnd({0,1})==0) cam.x *= -0.8
	if(rnd({0,1})==0) cam.y *= -0.8
	if abs(cam.x)<1 or abs(cam.y)<1 then
		cam.x = 0
		cam.y = 0
	end

	--particles
	for i in all(particles) do
		i.delay -= 1
		if i.delay == 0 then
			sfx(rnd({0,1}))
		elseif i.delay < 0 then
			i.r -= 1
			i.frame += 1
			if i.r <= 0 then
				del(particles, i)
			end
		end
	end
	if explode or btnp(btnx) then
		explode = false
		screenshake(3)
		for i=0, 4 do
			spread = 10
			add(particles, {
				x = anchor.x + random(-spread, spread), 
				y = anchor.y + random(-spread, spread),
				delay = random(0, 5),
				r = random(10, 20),
				frame = 0,
				anim = {black, white, white, yellow, orange, red, light_gray, 
				light_gray, dark_gray, dark_gray, dark_gray, dark_gray, dark_gray, 
				dark_gray, dark_gray, dark_gray},
			})
		end
		player.life -=1
	end
	
	--if (btn(btno)) then
	--	cam.deep += 1 --(((cam.deep+0.11)*10)\1)/10 --+(time()/3000)
	--	lock = false
	--end
	--if (cam.deep%8)==0 and cam.deep!=0 and not lock then
	--	lock = true
	--	setnew(cam.deep\8)
	--end
	--0.5 is speed of cube par frame of desnade
	--cam.deep += 0.1+(time()/300)
	--Dessante speed
	descnetespeed = 1+(time()/30)
	cam.deep += descnetespeed 
	agmentationvalue += descnetespeed -- SI VOUS COMPRENEZ PAS CE CODE C4EST NORMAL

	if agmentationvalue >= 8 then
		setnew(cam.deep\8)
		agmentationvalue -= 8
	end
end

function screenshake(i)
	cam.x = rnd({-i,i})
	cam.y = rnd({-i,i})
end

function random(a, b)
	return flr(rnd(b-a+1)) + a
end

-->8
--draw 

function _draw()
	cls(blue)
	--map(0,cam.deep, 0,(((cam.deep%1)*8)*-1),16,17)
	map(0,0,0,(cam.deep\1)%8*-1,16,16)

	--player 
	for i=0, player.y\8 do
		spr(35, player.x, player.y - i*8 - 8)
	end
	spr(36, player.x-4, player.y, 2, 2)
	spr(33, player.x, player.y - 8)

	--particles
	for i in all(particles) do
		if i.delay < 0 then
			circfill(i.x, i.y, i.r, i.anim[i.frame])
		end
	end

	--camera
	camera(cam.x, cam.y)
	
	--camera(cam.x, cam.y)
	--mset(rnd(16), cam.deep + 16, 1)
	--
	--for i=0,16 do
	--	if rnd(20)\1==1 then
	--		mset(i,cam.deep,1)
	--	end
	--end
	
	--debufg var
	--print(cam.deep%8*-1 ,3,108)
	print("vITTESSE: "..((descnetespeed*100)\1/10).."KM/H",3,108, white)
	print("vIE: " .. player.life, 3, 114, white)
	print("pRONFONDEUR :"..(cam.deep\1).."M", 3, 120, white)
	print(player.x+player.vx, 5,5,black)
end

--[[
function no_update()
	if (btn(down)) then
		cam.deep += 1 --(((cam.deep+0.11)*10)\1)/10 --+(time()/3000)
		lock = false
	end
	if (cam.deep%8)==0 and cam.deep!=0 and not lock then
		lock = true
		setnew(cam.deep/8\1)
	end
end

function no_draw()
	cls(red)
	map(0,0,0,0,16,16)
	print(cam.deep, 5, 120, white)
	print(cam.deep/8\1,5,114,white)
end
]]
--MODIFICATION DE LA MAP CHAQUE 8 PIXEL
function setnew(n)
	for i=0,16 do 
		for j=0,16 do
			mset(i, j-1, mget(i,j))
		end
	end
	for i=0,16 do
		mset(i,16, 0)
		random_clock = random(1,100) 
		if random_clock < 25 then
			mset(i,16,1)
		end
		if random_clock == 26 then
			mset(i,16,10)
		end
	end
end

--GENERATION DE LA PREMIER MAP
function firstgenerationmap()
	for i=0,16 do 
		for j=0,17 do
			if random(1,4) == 1 then
				mset(i,j,1)
			end
		end
	end
end


function minimap_debug()
	for i=0,32 do 
		for j=0,32 do
			if mget(i,j) == 1 then
				pset(i,j,green)
			end
		end
	end
	
end
__gfx__
0000000049999994d666666dd666666d9aaaaaa93bbbbbb3c777777c2eeeeee28eeeeee887779993828828820000000000000000000000000000000000000000
00000000944444426d55ddd56dddddd5a999aa92b333bb317ccc77c1e222ee21e888ee827899aab2828828820000000000000000000000000000000000000000
007007009444444265555dd56dd55dd5a99aa992b33bb3317cc77cc1e22ee221e88ee882799aabb2777777770000000000000000000000000000000000000000
000770009444444265555dd56dd555d5a9aa99a2b3bb33b17c77cc71e2ee22e1e8ee88e279aabb72755775570000000000000000000000000000000000000000
00077000944444426d55ddd56ddd55d5aaa99a92bbb33b31777cc7c1eee22e21eee88e829aabb7c1757575770000000000000000000000000000000000000000
00700700944444426ddddd5565ddddd5aa99a992bb33b33177cc7cc1ee22e221ee88e8829abb7cc1777777770000000000000000000000000000000000000000
00000000944444426dddd555655dddd5a99a9992b33b33317cc7ccc1e22e2221e88e88829bb7cc21828828820000000000000000000000000000000000000000
0000000042222221d5555551d55555519222222931111113c111111c211111128222222832221112222222220000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0777777009995590000e200000565000000000a99400000000000000000000000000000000000000000000000000000000000000000000000000000000000000
777777779995aa5900e005000050500000000a944940000000000000000000000000000000000000000000000000000000000000000000000000000000000000
771771779994444400e0050000565000000009400940000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77177177771771770002500000060000000009400940000000000000000000000000000000000000000000000000000000000000000000000000000000000000
777777777e1771e7e002500200565000000004999440000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07777770077777702e02502500505000000000444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bbbb0000bbbb000222225000565000a00000044000000400000000000000000000000000000000000000000000000000000000000000000000000000000000
04000040004004000055550000060000a4000aa9994000a400000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000009940044944400a9400000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000004400000a4000004400000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000009440000a4000099400000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000094000094000099000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000009944009400aa94000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000999aa99aa9440000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000499999944400000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000004444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000013171102720d4741627314562131650f3610d462136651615113354106551615413355154510e6520e25416346136430e64415646106410d64413632156360e631106340d6351361115612136150e613
0101000010274153760c7741337511671175740f6751177213361164610c6620f1531625515456116430f744155420d6311763411636156240d6250f62217621116141561611612176130c615156110e61211613
