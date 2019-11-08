# coding: utf-8
Pix = Struct.new(:r,:g,:b)
Point = Struct.new(:x,:y)
Line = Struct.new(:a,:b)
$redpix = Pix.new(255,100,100)
$bluepix = Pix.new(100,100,255)
$greenpix = Pix.new(100,255,100)
$graypix = Pix.new(100,100,100)
$size = [0,0]
$img = []

def init(x,y)
  $size[0] = x
  $size[1] = y
  $img = Array.new($size[0]) do
    Array.new($size[1]) do Pix.new(255,255,255) end
  end
end

def pixset(img,x,y,t,pix)
  if 0 <= x && x < $size[0] && 0 <= y && y < $size[1] then
    img[x][y].r = (img[x][y].r * t + pix.r * (1-t)).to_i
    img[x][y].g = (img[x][y].g * t + pix.g * (1-t)).to_i
    img[x][y].b = (img[x][y].b * t + pix.b * (1-t)).to_i
  end
end

def filewrite(name,img)
  open(name, "wb") do |f|
    f.puts("P6\n" + $size[0].to_s + " " + $size[1].to_s + "\n255")
    #img.each do |y|
    #  y.each do |pix|
    #    f.write(pix.to_a.pack("ccc"))
    #  end
    #end
    for y in 0..($size[1]-1) do
      for x in 0..($size[0]-1) do
        f.write(img[x][y].to_a.pack("ccc"))
      end
    end
  end
end

def linegragh(p1,p2)
  if p1.x != p2.x then
    return Line.new(((p1.y - p2.y).to_f)/(p1.x - p2.x), p1.y - ((((p1.y - p2.y).to_f)/(p1.x - p2.x))*p1.x))
  else
    return Line.new(0,p1.x)
  end
end

def make_line(img,point1,point2,leng,t,pix)
  for k in 0..(leng - 1) do
    if ( linegragh(point1,point2).a != 0) then
      for x in 0..($size[0]-1) do
        for y in 0..($size[1]-1) do
          if (point1.x >= x)==(point2.x <= x) then
            pixset(img,x,( linegragh(point1,point2).a * x + linegragh(point1,point2).b).to_i + k,t,pix)
          end
        end
      end
    else
      for y in 0..($size[1]-1) do
        pixset(img,linegragh(point1,point2).b + k,y,t,pix)
      end
    end
  end
end

def sign(p1,p2,p3)
  return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
end

def tricheker(tripoint,point)
  b = [false,false,false]
  b1 = (sign(point, tripoint[0], tripoint[1]) < 0.0);
  b2 = (sign(point, tripoint[1], tripoint[2]) < 0.0);
  b3 = (sign(point, tripoint[2], tripoint[0]) < 0.0);
  return ((b1 == b2)&&(b2 == b3))
end

def make_tri(img,tripoint,t,pix)
  for x in 0..($size[0]-1) do
    for y in 0..($size[0]-1) do
      if tricheker(tripoint,Point.new(x,y)) then
        pixset(img,x,y,t,pix)
      end
    end
  end
end

def make_circle(img,point,range,t,pix)
  for x in 0..($size[0]-1) do
    for y in 0..($size[0]-1) do
      if ((x - point.x)**2 + (y - point.y)**2) <= range**2 then
        pixset(img,x,y,t,pix)
      end
    end
  end
end

def make_poly(img,points,t,pix)
  ret = Array.new($size[0]) do
    Array.new($size[1],false)
  end

  for x in 0..($size[0]-1) do
    for y in 0..($size[1]-1) do
      for k in 1..(points.length - 2) do
        tripoint = [points[0],points[k],points[k + 1]]
        if tricheker(tripoint,Point.new(x,y)) then
          ret[x][y] = true
        elsif y == (linegragh(points[0],points[k]).a * x + linegragh(points[0],points[k]).b).to_i && (points[0].x >= x)==(points[k].x <= x) then
          ret[x][y] = true
        end
      end
    end
  end
  for x in 0..($size[0]-1) do
    for y in 0..($size[1]-1) do
      if ret[x][y] then pixset(img,x,y,t,pix) end
    end
  end
end

def make_gradate(img,point,xlength,ylength,type,pix)
  for x in (point.x)..(point.x + xlength) do
    for y in (point.y)..(point.y + ylength) do
      if type == "x" then
        pixset(img,x,y,((x - point.x).to_f/xlength).to_f,pix)
      else
        pixset(img,x,y,((y - point.y).to_f/ylength).to_f,pix)
      end
    end
  end
end

def gradatemot(img,point,xlength,ylength,type,t)

  for x in (point.x)..(point.x + xlength) do
    for y in (point.y)..(point.y + ylength) do
      if type == "x" then
        t1 = ((x - point.x).to_f/xlength).to_f
      elsif type == "-x" then
        t1 = -((x - point.x).to_f/xlength).to_f
      elsif type == "y" then
        t1 = ((y - point.y).to_f/ylength).to_f
      else
        t1 = -((y - point.y).to_f/ylength).to_f
      end
      if 0 <= x && x < $size[0] && 0 <= y && y < $size[1] then
        img[x][y].r = (255 - (255 - img[x][y].r) * t1 * t).to_i
        img[x][y].g = (255 - (255 - img[x][y].g) * t1 * t).to_i
        img[x][y].b = (255 - (255 - img[x][y].b) * t1 * t).to_i
      end
    end
  end
end

#init(600,400)
#make_gradate($img,Point.new(0,0),$size[0],$size[1],"y",$greenpix)
#$poly1 = [Point.new(0,100),Point.new(0,300),Point.new(100,400),Point.new(200,200),Point.new(100,0)]
#$poly2 = [Point.new(600,100),Point.new(600,300),Point.new(500,400),Point.new(400,200),Point.new(500,0)]
#make_poly($img,$poly1,0.3,$bluepix)
#make_poly($img,$poly2,0.3,$bluepix)
#make_circle($img,Point.new(300,200),100,0.3,$redpix)
#gradatemot($img,Point.new(0,0),$size[0],$size[1],"x",0.5)
#make_line($img,Point.new(2,0),Point.new(200,100),10,0.1,$bluepix)
#make_line($img,Point.new(200,0),Point.new(0,200),5,0.1,$greenpix)
#filewrite("t.ppm",$img)
