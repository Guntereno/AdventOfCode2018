file = assert(io.open ('Input.txt', "r"))

frequency_changes = {}
while true do
  local line = file:read("*line")
  if line == nil then
    break
  end
  change = tonumber(line)
  table.insert(frequency_changes, change)
end

function puzzle_1 ()
  current_frequency = 0
  for index = 1, #frequency_changes do
    current_frequency = current_frequency + frequency_changes[index]
  end
  print("Part One: " .. current_frequency)
end

function puzzle_2 ()
  done = false
  current_change_index = 1
  current_frequency = 0
  frequencies_reached = {}
  while not done do
    change = frequency_changes[current_change_index]
    current_frequency = current_frequency + change
    frequencies_reached[current_frequency] = frequencies_reached[current_frequency] and frequencies_reached[current_frequency] + 1 or 1
    if frequencies_reached[current_frequency] > 1 then
      done = true
    else
      current_change_index = current_change_index + 1
      if current_change_index > #frequency_changes then
        current_change_index = 1
      end
    end
  end
  print("Part Two: " .. current_frequency)
end

puzzle_1()
puzzle_2()