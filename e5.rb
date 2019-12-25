# -*- coding: utf-8 -*-
$board = Array.new(8) do
  Array.new(8,0)
end
$map = Array.new(10) do
  Array.new(10,-1)
end
#black = 1,white = 0

#mapにboardを反映する
def reflect()
  for x in 0..7 do
    for y in 0..7 do
      $map[y+1][x+1] = $board[y][x]
    end
  end
end

#boardとmapの初期化
def initialize_othello()
  $board = Array.new(8) do
    Array.new(8,0)
  end
  $board[3][3] = 2
  $board[4][4] = 2
  $board[4][3] = 1
  $board[3][4] = 1
  reflect()
  return $board
end

#上が1であとは右回りに方向をつけている、その方向に一つ移動した座標を返す
def retd(point,dir = 0,n = 1)
  case dir
    when 0
      ret = [point[0],point[1]]
    when 1
      ret = [point[0]-n,point[1]]
    when 2
      ret = [point[0]-n,point[1]+n]
    when 3
      ret = [point[0],point[1]+n]
    when 4
      ret = [point[0]+n,point[1]+n]
    when 5
      ret = [point[0]+n,point[1]]
    when 6
      ret = [point[0]+n,point[1]-n]
    when 7
      ret = [point[0],point[1]-n]
    when 8
      ret = [point[0]-n,point[1]-n]
    else
      ret = nil
  end
  return ret
end

def retb(point,dir = 0)
    return $map[retd(point,dir)[0]+1][retd(point,dir)[1]+1]
end


#置いた位置からいくつ違う色が並んでいるかを返す、色は置いたものの色
def leng(point,dir,color,ret = 0)
  nex = retb(point,dir)
  if nex == -1 || nex == 0 then
    return 0
  elsif nex != color then
    return leng(retd(point,dir),dir,color,ret + 1)
  elsif retb(point,dir) == color then
    return ret
  end
end

#置いた場所、色を見てひっくり返す
def flip(point,color)
  if retb(point) == 0 then
    for dir in 1..8 do
      length = leng(point,dir,color)
      #p length
      if length != 0 then
        for n in 0..(length) do
          $board[retd(point,dir,n)[0]][retd(point,dir,n)[1]] = color
        end
      end
    end
  end
end

#実際動かす
def move_othello(player, y, x)
  flip([y,x],player)
  reflect()
  return $board
end

=begin
p initialize_othello
p "----"
p move_othello(1, 3, 2)
p "----"
p move_othello(2, 2, 4)
p "----"
p move_othello(1, 3, 5)
p "----"
p move_othello(2, 4, 2)
p "----"
p move_othello(1, 5, 4)
p "----"
p move_othello(2, 2, 3)
p "----"
p move_othello(2, 2, 6)
=end
