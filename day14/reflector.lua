-- Wyatt Geckle
--
-- Advent of Code 2023 Day 14


-- Given a boolean function func(elem) and a list, returns a new list
-- with any element where func(elem) == false removed.
local function filter(func, list)
    local filtered = {}

    for _, elem in ipairs(list) do
        if func(elem) then
            table.insert(filtered, elem)
        end
    end

    return filtered
end

-- Given a function func(i, elem) and a list, returns a new list with
-- every element mapped to func(i, elem).
local function imap(func, list)
    local mapped = {}

    for i, elem in ipairs(list) do
        table.insert(mapped, func(i, elem))
    end

    return mapped
end

-- Given a list, return its sum.
local function sum(list)
    local result = 0

    for _, num in ipairs(list) do
        result = result + num
    end

    return result
end

-- Deep copies the platform.
local function platform_copy(platform)
    local copied = {}

    for _, row in ipairs(platform) do
        table.insert(copied, {})

        for _, elem in ipairs(row) do
            table.insert(copied[#copied], elem)
        end
    end
    return copied
end

-- Given two instances of the platform, checks if they're equal.
local function platform_equals(platform_one, platform_two)
    for row = 1,#platform_one do
        for col = 1,#platform_one[1] do
            if platform_one[row][col] ~= platform_two[row][col] then
                return false
            end
        end
    end

    return true
end

-- Tilts the table north in-place.
local function tilt_north(platform)
    for col = 1,#platform[1] do
        local roll_row = 1

        for row = 1,#platform do
            if platform[row][col] == "O" then
                platform[row][col],
                platform[roll_row][col] = platform[roll_row][col],
                                          platform[row][col]
                roll_row = roll_row + 1
            elseif platform[row][col] == "#" then
                roll_row = row + 1
            end
        end
    end
end

-- Tilts the table south in-place.
local function tilt_south(platform)
    for col = 1,#platform[1] do
        local roll_row = #platform

        for row = #platform,1,-1 do
            if platform[row][col] == "O" then
                platform[row][col],
                platform[roll_row][col] = platform[roll_row][col],
                                          platform[row][col]
                roll_row = roll_row - 1
            elseif platform[row][col] == "#" then
                roll_row = row - 1
            end
        end
    end
end

-- Tilts the table east in-place.
local function tilt_east(platform)
    for row = 1,#platform do
        local roll_col = #platform[1]

        for col = #platform[1],1,-1 do
            if platform[row][col] == "O" then
                platform[row][col],
                platform[row][roll_col] = platform[row][roll_col],
                                          platform[row][col]
                roll_col = roll_col - 1
            elseif platform[row][col] == "#" then
                roll_col = col - 1
            end
        end
    end
end

-- Tilts the table west in-place.
local function tilt_west(platform)
    for row = 1,#platform do
        local roll_col = 1

        for col = 1,#platform[1] do
            if platform[row][col] == "O" then
                platform[row][col],
                platform[row][roll_col] = platform[row][roll_col],
                                          platform[row][col]
                roll_col = roll_col + 1
            elseif platform[row][col] == "#" then
                roll_col = col + 1
            end
        end
    end
end

-- Performs a single spin cycle on the platform in-place.
local function spin_cycle(platform)
    tilt_north(platform)
    tilt_west(platform)
    tilt_south(platform)
    tilt_east(platform)
end

-- Returns the load on the platform.
local function platform_load(platform)
    return sum(imap(function(index, row)
        return (#platform - index + 1) * #filter(function(tile)
            return tile == "O"
        end, row)
    end, platform))
end


if #arg == 0 then
    io.stderr:write("Please provide the puzzle input file.\n")
    os.exit(1)
end

local platform = {{}}

-- Build the platform 2D table from the puzzle input file.
local f = assert(io.open(arg[1], "r"))
for char in string.gmatch(string.sub(f:read("*all"), 0, -2), ".") do
    if char == "\n" then
        table.insert(platform, {})
    else
        table.insert(platform[#platform], char)
    end
end
f:close()

tilt_north(platform)
print("Part One: " .. platform_load(platform))

-- Complete the first spin cycle.
tilt_west(platform)
tilt_south(platform)
tilt_east(platform)

-- Save the first cycle to a list of past cycles.
local past_cycles = {platform_copy(platform)}

-- After some amount of spin cycles, the platform enters a sequence loop
-- of some number of states.  Find the number of spin cycles which
-- starts the sequence loop, then compute the remaining cycles required
-- to get an equivalent platform state to the one at 1000000000 spin
-- cycles.
local remaining_cycles = 0
while remaining_cycles == 0 do
    spin_cycle(platform)

    for cycle_start, past_cycle in ipairs(past_cycles) do
        if platform_equals(platform, past_cycle) then
            local sequence_cycles = #past_cycles + 1 - cycle_start
            remaining_cycles = (1000000000 - cycle_start) % sequence_cycles
            break
        end
    end

    table.insert(past_cycles, platform_copy(platform))
end

for _ = 1,remaining_cycles do
    spin_cycle(platform)
end

print("Part Two: " .. platform_load(platform))

