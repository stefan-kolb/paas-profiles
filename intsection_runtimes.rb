require 'roo'

class Helper

def self.rename_keys k
  names = [ "java", ".net", "python", "php", "ruby", "node" ]
  print "["
	
	c = 0
	k.each do |e, i|
		unless c == 0
		  print ","
		end
		c += 1
		print names[e-1]
	end
	
	print "]"
end

def self.combine 
	perm = [1,2,3,4,5,6].combination(1).to_a
	perm.concat([1,2,3,4,5,6].combination(2).to_a)
	perm.concat([1,2,3,4,5,6].combination(3).to_a)
	perm.concat([1,2,3,4,5,6].combination(4).to_a)
	perm.concat([1,2,3,4,5,6].combination(5).to_a)
	perm.concat([1,2,3,4,5,6].combination(6).to_a)
	perm
end

end

file = Roo::Excelx.new("Cloud Platforms (PaaS).xlsx")
file.default_sheet = file.sheets.first

entries = Hash.new

i = 0
4.upto(85) do |line|
  entry = []
  unless file.cell(line,'G').nil? 
		entry << 1
	end
  unless file.cell(line,'H').nil? 
	  entry << 2
	end
  unless file.cell(line,'I').nil? 
	  entry << 3
	end
  unless file.cell(line,'J').nil? 
	  entry << 4 
	end
  unless file.cell(line,'K').nil? 
	  entry << 5 
	end
  unless file.cell(line,'M').nil? 
	  entry << 6
	end

	entries[i] = entry
	i += 1
end

p = Helper::combine

result = Hash.new

p.each do |mu|
  desc = mu
	count = 0 
	
  entries.each do |key, arr|
	  unless (mu & arr).size < mu.size
  		count += 1
		end
	end
	
	result[mu] = count
end

result = result.sort_by { |perm, count| count }.reverse

result.each do |k,v|
  Helper::rename_keys k 
	puts ": " << v.to_s
end