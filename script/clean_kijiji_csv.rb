if __FILE__ == $0
	filename = ARGV[0]
	file = File.open(filename, 'r')
	#cleaned = File.open("final_kijiji.csv","w")
	values = []
	while(!file.eof?)
		values << file.gets
	end
	cleaner = []
	values.each do |x|
		splt = x.split("**")
		cleaner << x if splt[3].strip != "Toronto, ON, Canada" && splt[3].strip != "Mississauga, ON, Canada"
	end
	#cleaner.each_with_index do |val, i|
	#	for j in (i+1)..cleaner.length
	#		cleaner.delete_at(i) if cleaner[i] == cleaner[j]
	#	end
	#end
	cleaner.each do |x|
		puts x
	end
end