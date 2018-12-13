file = assert(io.open ('Input.txt', "r"))

function top(claim)
	return claim.y + 1
end

function bottom(claim)
	return claim.y + claim.h
end

function left(claim)
	return claim.x + 1
end

function right(claim)
	return claim.x + claim.w
end

function line_to_claim(line)
	local result = {}
	id, x, y, w, h = string.match(line, "#(%d+) @ (%d+),(%d+): (%d+)x(%d+)")

	result["id"] = id
	result["x"] = x
	result["y"] = y
	result["w"] = w
	result["h"] = h
	result.left = left
	result.right = right
	result.top = top
	result.bottom = bottom
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

function puzzle_1()
	local freq_matrix = {}
	local not_overlapping = {}
	for index = 1,#claims,1 do
		table.insert(not_overlapping, index)
	end
	local count = 0

	for claim_index, claim in pairs(claims) do 
		for x = claim:left(), claim:right() do
			for y = claim:top(), claim:bottom() do
				local index = x + ((y - 1) * sheet_width)
				local is_shared = false
				if (freq_matrix[index] == nil) then
					freq_matrix[index] = {}
				else
					is_shared = true
				end
				table.insert(freq_matrix[index], claim_index)
				if is_shared then
					if (#(freq_matrix[index]) == 1) then
						count = count + 1
					end
					for claimer_index = 1, #(freq_matrix[index]) do
						claimer = freq_matrix[index][claimer_index]
						not_overlapping[claimer] = nil
					end
				end
			end
		end
	end
	print("Part One: " .. count)

	local part_2_result = 0
	local num_not_overlapping = 0
	for key, value in pairs(not_overlapping) do
		part_2_result = key
		num_not_overlapping = num_not_overlapping + 1
	end
	assert(num_not_overlapping == 1)
	print("Part Two: " .. part_2_result)
end

print(puzzle_1())