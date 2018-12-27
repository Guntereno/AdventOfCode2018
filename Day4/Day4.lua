DataParser = {}
DataParser.current_guard = nil
DataParser.current_shift = nil
DataParser.current_date = nil
DataParser.current_minute = nil
DataParser.currently_awake = true
DataParser.data = {}

function DataParser.finish_current_shift(self)
    if(self.current_shift ~= nil) then
        for index = self.current_minute, 59 do
            table.insert(self.current_shift, self.currently_awake)
        end
        assert(#(self.current_shift) == 60)

        if(self.data[self.current_guard] == nil) then
            self.data[self.current_guard] = {}
        end
        assert(self.current_date ~= nil)
        table.insert(self.data[self.current_guard],
        {
            date=self.current_date,
            shift=self.current_shift
        })
    end
end

function DataParser.process_line(self, line)
	local result = {}
	entry_month, entry_day, entry_hour, entry_minute, entry = string.match(
        line,
        '^%[1518%-(%d%d)%-(%d%d) (%d%d)%:(%d%d)%] (.*)')

    id, action = string.match(entry, "Guard %#(%d+) (.*)")
    if action ~= nil then
        assert(action == "begins shift")

        self:finish_current_shift()

        self.current_guard = id
        self.current_shift = {}
        self.current_minute = 0
        self.current_date = nil
        self.currently_awake = true

        -- Some guards sttart their shift a few minutes early
        if(entry_hour == "23") then
            entry_day = string.format("%02d",
                tonumber(entry_day) + 1)
        else
            assert(entry_hour == "00")
        end
        self.current_date = entry_month .. '-' .. entry_day
    else
        for index = self.current_minute, (entry_minute - 1) do
            table.insert(self.current_shift, self.currently_awake)
        end
        self.currently_awake = not self.currently_awake
        self.current_minute = entry_minute

        if entry == "falls asleep" then
            assert(self.currently_awake == false)
        elseif entry == "wakes up" then
            assert(self.currently_awake == true)
        else
            assert(false, "Invalid line! " .. line)
        end
    end

    return result
end

function DataParser.process_file(self, file_name)
    local file = assert(io.open (file_name, "r"))
    local lines = {}
    while true do
    local line = file:read("*line")
    if line == nil then
        break
    end
    table.insert(lines, line)
    end
    table.sort(lines)
    for key, line in ipairs(lines) do
        self:process_line(line)
    end
    self:finish_current_shift()
end

function get_total_minutes_asleep(shifts)
    local minutes_asleep = 0
    for i = 1, #shifts do
        local shift_minutes_slept = 0
        for j = 1, #(shifts[i].shift) do
            if(not shifts[i].shift[j]) then
                shift_minutes_slept = shift_minutes_slept + 1
            end
        end
        minutes_asleep = minutes_asleep + shift_minutes_slept
    end
    return minutes_asleep
end

function get_most_slept_minute(shifts)
    local frequency = {}
    for minute = 1, 60 do
        table.insert(frequency, 0)
    end
    for shift_index = 1,#shifts do
        for minute = 1, 60 do
            if not shifts[shift_index].shift[minute] then
                frequency[minute] = frequency[minute] + 1
            end
        end
    end
    most_slept_minute = nil
    highest_frequency = 0
    for minute = 1, 60 do
        if frequency[minute] > highest_frequency then
            highest_frequency = frequency[minute]
            most_slept_minute = minute
        end
    end
    if(most_slept_minute) then
        return most_slept_minute - 1, highest_frequency
    else
        return nil, nil
    end
end

function strategy_one(data)
    local sleepiest_guard = nil
    local most_minutes_slept = 0
    for guard, shifts in pairs(data) do
        minutes_asleep = get_total_minutes_asleep(shifts)
        if(minutes_asleep and minutes_asleep > most_minutes_slept) then
            sleepiest_guard = guard
            most_minutes_slept = minutes_asleep
        end
    end

    local shifts = data[sleepiest_guard]
    local most_slept_minute, frequency = get_most_slept_minute(shifts)

    print("Part One: " .. (sleepiest_guard * most_slept_minute))
end

function strategy_two(data)
    local chosen_guard = nil
    local chosen_minute = nil
    local highest_frequency = 0
    for guard, shifts in pairs(data) do
        local most_slept_minute, frequency = get_most_slept_minute(shifts)
        if(frequency and frequency > highest_frequency) then
            chosen_guard = guard
            chosen_minute = most_slept_minute
            highest_frequency = frequency
        end
    end

    print("Part Two: " .. (chosen_guard * chosen_minute))
end

function div(a, b)
    return (a - a % b) / b
end

function output_table(data)
    io.write('          ')
    for t = 1, 60 do
        io.write(div(t, 10))
    end
    io.write('\n          ')
    for t = 1, 60 do
        io.write((t - 1) % 10)
    end
    io.write('\n')

    lines = {}
    current_line = ""
    for guard, shifts in pairs(data) do
        for shift_index = 1, #shifts do
            current_line = current_line .. (shifts[shift_index].date .. ' ')
            current_line = current_line .. ('#' .. guard .. ' ')
            for i = 1, 60 do
                if (shifts[shift_index].shift[i]) then
                    current_line = current_line .. ('.')
                else
                    current_line = current_line .. ('#')   
                end
            end
            table.insert(lines, current_line)
            current_line = ""
        end
    end
    table.sort(lines)
    for i=1, #lines do
        print(lines[i])
    end
end

DataParser:process_file('Input.txt')
output_table(DataParser.data)
strategy_one(DataParser.data)
strategy_two(DataParser.data)
