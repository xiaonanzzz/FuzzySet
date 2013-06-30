

if not Cost then
	Cost = {}
end

function Cost:NewCostdataset()
	
	return {
		allcost = {},	-- pure data
		time = {},		-- fuzzyset of time
		loc = {},		-- fuzzyset of location
		amount = {},	-- fuzzyset of amount cost
	}
	
end

-- dataset = {allcost, time, loc, amount}
function Cost:AddItem(dataset, cost, time, typeid, loc)

	if not dataset.allcost then
		error("table of Cost.allcost not exists!")	
	end

	assert(cost > 0 and time > 0 and typeid > 0)
	assert(loc.x >= -180 and loc.x <= 180)
	assert(loc.y >= -90 and loc.y <= 90)

	local item = {
		cost = cost,
		time = time,
		typeid = typeid,
		loc = loc,
	}
	table.insert(dataset.allcost, item)
	self:AddItem2FuzzySet(dataset, item)
end

function Cost:AddItem2FuzzySet(dataset, item)
	FuzzySet:AddItem(dataset.time, item.time, item.typeid)
	FuzzySet:AddItem(dataset.amount, item.cost, item.typeid)
end



function Cost:GuessType(dataset, cost, time, loc)
	assert(dataset)
	assert( cost and time)
	-- loc can be nil
	
	local probmap = FuzzySet:MakeSetProb(dataset.time, time)
	assert(probmap)

	local probmapx = FuzzySet:MakeSetProb(dataset.amount, cost)
	
	for typeid, prob in pairs(probmap) do
		local probx = probmapx[typeid]
		if not probx then
			assert()
			probx = 0
		end

		probmap[typeid] = prob + probx
	end
	

		
	return probmap
end


function Cost:SortProbmap(probmap)
	local orderlist = {}

	for typeid, prob in pairs(probmap) do
		table.insert(orderlist, typeid)
	end

	table.sort(orderlist, function (a, b)
		return probmap[a] < probmap[b]	
	end
	)
	return orderlist
end



