polymer = {}
local file = io.open("Input.txt", "r")
repeat
    local c = file:read(1)
    if(c ~= '\n') then
        table.insert(polymer, c)
    end
until c == nil

function remove_unit(char, polymer)
    local removed = 0
    local result = {}
    for i=1, #polymer do
        if(not (string.lower(polymer[i]) == string.lower(char))) then
            table.insert(result, polymer[i])
        else
            removed = removed + 1
        end
    end
    return result, removed
end

function step(polymer)
    local modified = false
    local i = 1
    repeat
        a = polymer[i]
        b = polymer[i + 1]
        if((string.lower(a) == string.lower(b)) and (a ~= b)) then
            table.remove(polymer, i)
            table.remove(polymer, i)
            return polymer
        end
        i = i + 1
    until (i == #polymer)
    return nil
end

function react(polymer)
    local current_polymer = polymer
    local done = false
    repeat
        local updated = step(current_polymer)
        if(updated) then
            current_polymer = updated
            -- print(table.concat(current_polymer))
        else
            done = true
        end
    until(done)

    return current_polymer
end

function part_one()
    local done = false
    local current_polymer = react(polymer)
    print("Part One: " .. #current_polymer)
end

function part_two()
    local min_length = nil

    -- Characters A-Z
    for byte = 65, 90 do
        local char = string.char(byte)
        local redacted
        local removed
        redacted, removed = remove_unit(char, polymer)
        if removed ~= 0 then
            local reacted = react(redacted)
            if((min_length == nil) or (#reacted < min_length)) then
                min_length = #reacted
            end
            print(char .. ": " .. #reacted .. " '" .. table.concat(reacted) .. "''")
        end
    end

    print("Part Two: " .. min_length) 
end

part_one()
part_two()