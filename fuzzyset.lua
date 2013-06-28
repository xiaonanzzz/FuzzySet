
if not FuzzySet then
	FuzzySet = {}
end

FuzzySet.delta = 0.3

-- setmap contains all set and their elements
function FuzzySet:AddItem(setmap, item, setid)
	assert(setmap and item and setid)
	if not setmap[setid] then
		setmap[setid] = {}
	end

	table.insert(setmap[setid], item)
end


function FuzzySet:MakeProb(itemx, item)
	local dif = itemx - item
	local delta = self.delta
	assert(delta > 0)
	local pbx = 1/(delta*math.sqrt(2*math.pi)) * math.exp(dif*dif/(2*delta*delta))
	return pbx
end

function FuzzySet:BelongTo(fs, item)
	local maxid = nil
	local maxpb = 0
	for setid, itemlist in pairs(fs.setmap) do
		local pbsum = 0
		for i, itemx in ipairs(itemlist) do
			local dif = itemx - item
			local pbx = self:MakeProb(itemx, item)
			pbsum = pbsum + pbx
		end
		if not maxpb or maxpb < pbsum then
			maxid = setid
			maxpb = pbsum
		end
	end
	return maxid
end



