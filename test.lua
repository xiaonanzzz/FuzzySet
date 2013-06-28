

if not FuzzySet then
	FuzzySet = {}
end

function FuzzySet:TestMain()
	dofile("trainingset.lua")
	dofile("fuzzyset.lua")

	for i = 1, 20, 0.1 do 
		local maxid, maxpb = self:BelongTo(self.traningset, i)
		local len = math.floor(maxpb/0.03)
		local sz = "!"
		for i = 1, len do
			sz = sz.."-"
			if i == 80 then
				sz = sz.. "^--->"
				break
			end
		end
		print(i, maxid, sz, maxpb)
	end
end



