def ch(ary,obj)
  if !(ary.class == Array || ary.class == String) then
		return false
	end
  for n in 0..(ary.length - 1) do
    if obj == ary[n] then
			return true
		end
  end
  return false
end

def pattern(str,p,debug)
  vowel = ["a","i","u","e","o"]
  spevowel = ["a","u","o"]
  speH = ["s","c"]
  speY = ["s","r","p","t","g","h","k","b","m","j"]

  if p >= str.length then
    return true
  end

  if debug == 1 then
    printf("%s:%03d\n",str[p],p)
  end

  if str.class != String then
    return false
  end

  if ch(vowel,str[p]) || str[p] == "n" then
    return pattern(str,p+1,debug)
  end

  if p+1 >= str.length then
    return false
  end
  if !ch(vowel,str[p]) && ch(vowel,str[p+1]) then
    return pattern(str,p+2,debug)
  end

  if p+2 >= str.length then
    return false
  end
  if !ch(vowel,str[p]) then
    if str[p] == str[p+1] && ch(vowel,str[p+2]) then
      return pattern(str,p+3,debug)
    end
    if ch(speH,str[p]) && str[p+1] == "h" && ch(vowel,str[p+2]) then
      return pattern(str,p+3,debug)
    end
    if ch(speY,str[p]) && str[p+1] == "y" && ch(spevowel,str[p+2]) then
      return pattern(str,p+3,debug)
    end
  end
  return false
end




def anag(origin)
  if origin.class != String then return false end
  str = []
	ans = []
  for n in 0..(origin.length - 1) do
    str.push(origin[n])
  end
	p = 0
	str.permutation {|ary|
		ans.push("")
		ary.each do |k|
			ans[p] = ans[p] + k
		end
		p += 1;
	}
	return ans
end

def out(str,debug)
  ans = []
	anag(str).each do |k|
    if debug == 1 then
  		if pattern(k,0,0) then
        printf("%02d %s %s\n",k.length,k,"true")
      else
        printf("%02d %s %s\n",k.length,k,"false")
      end
    else
      if pattern(k,0,0) && !ch(ans,k) then
        ans.push(k)
      end
    end
	end
  for n in 0..(ans.length - 1) do
    printf("%04d:%s\n",n+1,ans[n])
  end
	return nil
end
