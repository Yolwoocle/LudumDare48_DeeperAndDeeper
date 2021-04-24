pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--init
player = {
	x = 60,
	y = 60,
	vx = 0,
	vy = 0,
	speed = 0.3,
	friction = 0.8,
	gravity = 0,
	life = 3,
}

cam = {
	x = 0,
	y = 0,
	deep = 0
}

anchor = {x=0, y=0}

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

function _init()

end

-->8
//update

function _update60()
	if player.life <= 0 then
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
	player.x += player.vx
	player.y += player.vy

	--anchors
	--for all(anchors) do
	anchor.x, anchor.y = player.x - 4, player.y + 14
	destroy_x1 = (anchor.x + 4) \ 8
	destroy_y1 = anchor.y \ 8+(cam.deep)
	destroy_x2 = (anchor.x + 12) \ 8
	if mget(destroy_x1, destroy_y1) != 0 then
		player.life -= 1
	end
	

	mset(destroy_x1, destroy_y1, 0)
	mset(destroy_x2, destroy_y1, 0)

	--camera
	cam.x *= -0.8
	cam.y *= -0.8
	if abs(cam.x)<1 or abs(cam.y)<1 then
		cam.x = 0
		cam.y = 0
	end
	--0.5 is speed of cube par frame of desnade
	cam.deep += 0.1+(time()/300)
end

function screenshake()
	cam.x = rnd({-1,1})
	cam.y = rnd({-1,1})
end

-->8
--draw 

function _draw()
	cls(black)
	map(0,cam.deep, 0,((cam.deep%1)*8)*-1,16,17)

	--player 
	for i=0, player.y\8 do
		spr(35, player.x, player.y - i*8 - 8)
	end
	spr(36, player.x-4, player.y, 2, 2)
	spr(33, player.x, player.y - 8)

	--camera
	camera(cam.x, cam.y)
	print("pRONFONDEUR :"..(cam.deep\1).."M", 5, 5)
	print("rANDOM"..rnd(16),10,10)
	
	--camera(cam.x, cam.y)
	mset(rnd(16), cam.deep + 16, 1)
	print("life: " .. player.life, 4, 4, white)
	print("deep: " .. cam.deep, 4, 12, white)
	print("rnd: " .. rnd(16), 4, 20, white)
end



__gfx__
0000000049999994d666666dd666666d9aaaaaa93bbbbbb3c777777c2eeeeee28eeeeee888888882000000000000000000000000000000000000000000000000
00000000944444426d55ddd56dddddd5a999aa92b333bb317ccc77c1e222ee21e888ee8288111182000000000000000000000000000000000000000000000000
007007009444444265555dd56dd55dd5a99aa999b33bb3337cc77ccce22ee222e88ee88881111112000000000000000000000000000000000000000000000000
000770009444444265555dd56dd555d5a9aa99a2b3bb33b17c77cc71e2ee22e1e8ee88e281811812000000000000000000000000000000000000000000000000
00077000944444426d55ddd56ddd55d5aaa99a92bbb33b31777cc7c1eee22e21eee88e8281111112000000000000000000000000000000000000000000000000
00700700944444426ddddd5565ddddd5aa99a992bb33b33177cc7cc1ee22e221ee88e88288111182000000000000000000000000000000000000000000000000
00000000944444426dddd555655dddd5a99a9992b33b33317cc7ccc1e22e2221e88e888288188182000000000000000000000000000000000000000000000000
0000000042222221d5555551d55555519292222931311113c1c1111c212111128282222822222222000000000000000000000000000000000000000000000000
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
