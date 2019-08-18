pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function rotate_aroundcenter(p,degree)
	local res={};
	--sin and cos accept 0~1 which remap from 0~180
	res.x=(p.x-0.5)*cos(degree)-(p.y-0.5)*sin(degree);
	res.y=(p.x-0.5)*sin(degree)+(p.y-0.5)*cos(degree);
	res.x+=0.5;
	res.y+=0.5;
	return res;
end

function rotate_triangle(triangle,degree)
	triangle.a=rotate_aroundcenter(triangle.a,degree);
	triangle.b=rotate_aroundcenter(triangle.b,degree);
	triangle.c=rotate_aroundcenter(triangle.c,degree);
	return triangle;
end


function edgefunction(px,py,a,b)
	return ((px-a.x)*(b.y-a.y)-(py-a.y)*(b.x-a.x));
end

function rasterize_tri(i,j,triangle)
	local ndci=i/128.0;
	local ndcj=j/128.0;
	
	local a=edgefunction(ndci,ndcj,triangle.a,triangle.b);
	local b=edgefunction(ndci,ndcj,triangle.b,triangle.c);
	local c=edgefunction(ndci,ndcj,triangle.c,triangle.a);
	local d=((a>=0) and (b>=0))and (c>=0);
	if d then
		return triangle.col;
	else
		return 0;
	end
end

function _init()
	counter=0;
end

function _halflumgreen()
	srand(counter);
	if rnd()<=0.5 then
		return 0;
	else
		return 11;
	end
end

function _update()
	
end

function _draw()
	//cls();
	counter+=1;
	local a=counter;
	tri=rotate_triangle(getgeom_a(),counter/360);
	for i=0,128 do
		for j=0,128 do
			tcol=rasterize_tri(i,j,tri);
			if pget(i,j)!=tcol then
				pset(i,j,tcol);--too costy
			end
		end
	end
	//print(tostr(counter),0,120);
end
-->8
function getgeom_a()
	pa={};
	pa.x=0.5;
	pa.y=0.3;
	
	pb={};
	pb.x=0.2;
	pb.y=0.7;
	
	pc={};
	pc.x=0.8;
	pc.y=0.7;
	
	triangle={};
	triangle.a=pa;
	triangle.b=pb;
	triangle.c=pc;
	triangle.col=11;
	return triangle;
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
