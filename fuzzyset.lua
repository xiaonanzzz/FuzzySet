
if not FuzzySet then
	FuzzySet = {}
end

FuzzySet.delta = 1

-- setmap contains all set and their elements
function FuzzySet:AddItem(setmap, item, setid)
	assert(setmap and item and setid)
	if not setmap[setid] then
		setmap[setid] = {}
	end

	table.insert(setmap[setid], item)
end


function FuzzySet:_MakeProb(itemx, item)
	local dif = itemx - item
	local delta = self.delta
	assert(delta > 0)
	local pbx = 1/(delta*math.sqrt(2*math.pi)) * math.exp(-dif*dif/(2*delta*delta))
	return pbx
end


-- return a setid -> probability map
-- probmap = {
-- [1] = 0.1,
-- [2] = 1.3,
--}
function FuzzySet:MakeSetProb(fs, item)
	local setmap = {}
	for setid, itemlist in pairs(fs.setmap) do
		local pbsum = 0
		for i, itemx in ipairs(itemlist) do
			local pbx = self:_MakeProb(itemx, item)
			pbsum = pbsum + pbx
		end
		setmap[setid] = pbsum
	end
	return setmap
end


-- return the setid which item most probably belongs to
function FuzzySet:BelongTo(fs, item)
	local maxid = nil
	local maxpb = 0
	local setmap = self:MakeSetProb(fs, item)

	for setid, pb in pairs(setmap) do
		if maxpb < pb then
			maxid = setid
			maxpb = pb
		end
	end

	return maxid, maxpb
end



