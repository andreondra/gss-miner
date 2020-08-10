print "--- GSS Miner ---"

local limit = 0
local rounds = 0
local orientation

if arg[1] == nil then
    print("Limit not entered.")
    error()
else 
    limit = tonumber(arg[1])
end

if arg[2] == nil then
    print("Rounds not entered.")
    error()
else
    rounds = tonumber(arg[2])
end

if arg[3] == nil or (arg[3] ~= "r" and arg[3] ~= "l") then
	print("Wrong orientation.")
	error()
else
	orientation = arg[3]
end

print("Starting...")
print("Limit:", limit)
print("Fuel:", turtle.getFuelLevel())

function checkgravel()
	while true do
		local success, data = turtle.inspect()
		if success then
			if data.name == "minecraft:gravel" or data.name == "minecraft:sand" then
				turtle.dig()
			else
				break
			end
		end
	end
end

function sortitems()
	for i = 1, 16 do
		turtle.select(i)
		for j = 1, 16 do
			if turtle.compareTo(j) == true and turtle.getItemSpace(j) >= turtle.getItemCount(i) then
				turtle.transferTo(j)
				break
			end
		end
	end
	turtle.select(1)
end

function dropitems()
	for i = 1, 16 do
		local data = turtle.getItemDetail(i)
		
		if data ~= nil then 
			if data.name == "minecraft:cobblestone" or data.name == "minecraft:stone" or data.name == "minecraft:gravel" then
				turtle.select(i)
				turtle.drop()
			end
		end
	end
	turtle.select(1)
end

function mine()
	local mined = 0
	local skipped = 0
	
	while mined < limit do

		print("Mined: ",mined)
		print("Skipped: ", skipped)
		if turtle.getFuelLevel() < 1 then
			print("Refuelling...")
			
			for i = 1, 16 do
				turtle.select(i)
				if turtle.refuel() == true then
					break
				end
				if i == 16 and turtle.refuel() == false then
					print "E: No fuel."
					error()
				end
			end
		end
		
		if turtle.detect() == false then
			turtle.forward()
			skipped = skipped + 1
		else
			
			checkgravel()
			turtle.dig()
			turtle.forward()
			turtle.digUp()
			turtle.digDown()
		
			turtle.turnLeft()
			checkgravel()
			turtle.dig()
			turtle.forward()
			turtle.digUp()
			turtle.digDown()
			turtle.back()
			
			turtle.turnRight()
			turtle.turnRight()
			checkgravel()
			turtle.dig()
			turtle.forward()
		
			turtle.digUp()
			turtle.digDown()
			turtle.back()
		
			turtle.turnLeft()
			
			mined = mined + 1
		end
		
		dropitems()
	end
	
	print("Round finished, going back.")
	for i=0,mined+skipped-1 do
		turtle.back()
	end
end

local round = 1
while round <= rounds do
	print("Round: ", round)
	mine()
	sortitems()
	
	if round ~= rounds then
	
		if orientation == "l" then 
			turtle.turnLeft()
		else 
			turtle.turnRight()
		end
		
		for i = 0, 2 do
			turtle.dig()
			turtle.forward()
			turtle.digUp()
		end
		
		if orientation == "l" then 
			turtle.turnRight()
		else 
			turtle.turnLeft()
		end
	end
	
	round = round + 1
end

if orientation == "l" then 
	turtle.turnRight()
else 
	turtle.turnLeft()
end

for i = 1, (rounds-1) * 3 do
	turtle.forward()
end

if orientation == "l" then 
	turtle.turnLeft()
else 
	turtle.turnRight()
end

print("Finished.")

