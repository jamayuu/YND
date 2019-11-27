def sort(ary,limit,depth = 0,debug = false)
  if depth == limit then
    return ary
  end
  ary2 = []
  ary3 = []
  for m in 0..(ary.length - 1) do
    if (1 << depth) & ary[m] > 0 then
      ary2 << ary[m]
    else
      ary3 << ary[m]
    end
  end
  aryret = ary3 + ary2
  if debug then
    printf("depth:%d\n",depth)
    p ary
    p ary3
    p ary2
    p aryret
    puts("\n")
  end
  return sort(aryret,limit,depth + 1,debug)
end

def check_time
  time_start = Process.times.utime
  yield
  time_end = Process.times.utime
  return time_end - time_start
end

def randary(length,limit)
  ret = []
  length.times do
    ret << rand(1 << limit)
  end
  return ret
end

def one_test(length,limit,num,debug = false,debug_sort = false)
  ary = []
  num.times do
    ary << randary(length,limit)
  end
  time = check_time{
    ary.each do |el|
      sort(el,limit,0,debug_sort)
    end
  }
  if debug then printf("length:%4d limit:%3d time:%3.3f sec\n",length,limit,time) end
  return time
end

def test(length,limit,num)
  for leng in 1..length do
    for lim in 1..limit
      one_test(leng,lim,num,true)
    end
    puts("\n")
  end
end

one_test(10,10,3,true,true)
test(10,10,3000)
