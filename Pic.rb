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

#右:2、下:1
def make_line(img,point1,point2,t,pix)
  if (linegragh(point1,point2).a != 0) then
    for x in 0..($size[0]-1) do
      for y in 0..($size[0]-1) do
        if (point1.x >= x)==(point2.x <= x) then
          pixset(img,x,(linegragh(point1,point2).a * x + linegragh(point1,point2).b).to_i,t,pix)
        end
      end
    end
  else
    for y in 0..($size[0]-1) do
      pixset(img,linegraph(point1,point2).b,y,t,pix)
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

init(300,300)
make_circle($img,Point.new(150,100),50,0.3,$redpix)
$tri = [Point.new(10,10),Point.new(150,250),Point.new(250,150)]
make_tri($img,$tri,0.3,$bluepix)
make_line($img,Point.new(50,50),Point.new(200,100),0.9,$greenpix)
$poly = [Point.new(10,10),Point.new(100,50),Point.new(180,100),Point.new(220,200),Point.new(100,200)]
make_poly($img,$poly,0.3,$graypix)
filewrite("t.ppm",$img)
