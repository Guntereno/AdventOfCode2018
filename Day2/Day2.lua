file = assert(io.open ('Input.txt', "r"))

ids = {}
while true do
  local line = file:read("*line")
  if line == nil then
    break
  end
  table.insert(ids, line)
end

function calculate_checksum(ids)
	local num_twos = 0
	local num_threes = 0

	for id_key, id in pairs(ids) do
		local letter_frequencies = {}
		for ch_index = 1, #id do
			local ch = id:sub(ch_index, ch_index)
			if letter_frequencies[ch] == nil then
				letter_frequencies[ch] = 1
			else
				letter_frequencies[ch] = letter_frequencies[ch] + 1
			end
		end

		local has_two = false
		local has_three = false
		for freq_key, freq in pairs(letter_frequencies) do
			has_two = has_two or (freq == 2)
			has_three = has_three or (freq == 3)
			if (has_two and has_three) then
				break
			end
		end

		if has_two then num_twos = num_twos + 1 end
		if has_three then num_threes = num_threes + 1 end
	end

	return num_twos * num_threes
end

function puzzle_1()
	print("Part One: " .. calculate_checksum(ids))
end

function get_same_characters(str1, str2)
	local result = ""
	assert(#str1 == #str2)
	for ch_index = 1, #str1 do
		local ch1 = str1:sub(ch_index, ch_index)
		local ch2 = str2:sub(ch_index, ch_index)
		if (ch1 == ch2) then
			result = result .. ch1
		end
	end
	return result
end

function puzzle_2()
	local id_count =  #ids
	local id_len = #ids[1]
	local result = nil
	for i = 1, id_count, 1 do
		for j = i + 1, id_count, 1 do
			same_chars = get_same_characters(ids[i], ids[j])
			if (#same_chars == (id_len - 1)) then
				result = same_chars
				break
			end
		end
		if result then
			break
		end
	end
	print("Part Two: " .. result)
end

puzzle_1()
puzzle_2()