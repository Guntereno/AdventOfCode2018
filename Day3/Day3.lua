file = assert(io.open ('Input.txt', "r"))

function claim_right(claim)
	return claim.x + claim.w
end

function claim_bottom(claim)
	return claim.y + claim.h
end

function line_to_claim(line)
	local result = {}
	id, x, y, w, h = string.match(line, "#(%d+) @ (%d+),(%d+): (%d+)x(%d+)")

	result["id"] = id
	result["x"] = x
	result["y"] = y
	result["w"] = w
	result["h"] = h
	result["right"] = claim_right
	result["bottom"] = claim_bottom
	return result
end

claims = {}
sheet_width = 1000
sheet_height = 1000

while true do
  local line = file:read("*line")
  if line == nil then
    break
  end
  table.insert(claims, line_to_claim(line))
end

function claims_intersect(a, b)
	return (a.x < b.right() and
	a.right() > b.left() and
	a.y > b.bottom() and
	a.bottom() < b.y ) 
end

function puzzle_1()
	local freq_matrix = {}

	for index, claim in pairs(claims) do 
		for x = claim.x, claim:right() do
			for y = claim.y, claim:bottom() do
				local index = x + ((y-1) * sheet_width)
				local current = freq_matrix[index] and (freq_matrix[index] + 1) or 1
				freq_matrix[index] = current
			end
		end
	end

	local count = 0
	for y = 1,1000 do
		for x=1,1000 do
			local index = x + ((y-1) * sheet_width)
			local value = freq_matrix[index] and (freq_matrix[index] + 1) or 0
			if value > 1 then
				count = count + 1
			end
		end
	end

	return count
end

print(puzzle_1())