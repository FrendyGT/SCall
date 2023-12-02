bot = getBot()

local seedid = blockid+1
local savex = 0
local savey = 0
function gogaut()
    checker()
    local updatedSavex, updatedSavey = savex, savey
    
    if getBot():isInWorld(string.upper(worldname)) then
        for _, tile in pairs(getBot():getWorld():getTiles()) do
            if tile.bg == 6946 or tile.fg == 6946 then
                sleep(1000)
                updatedSavex = tile.x
                updatedSavey = tile.y - 1
                getBot():findPath(tile.x, tile.y - 1)
                sleep(1000)
                break
            end
        end
    end
    
    return updatedSavex, updatedSavey 
end
            
function retgaia(c)
    sleep(delayret)
    bot:wrench(savex, savey+1)
    sleep(delayret)
    bot:sendPacket(2, [[
    action|dialog_return
    dialog_name|itemsucker_seed
    tilex|]] ..savex.. [[
    |
    tiley|]] ..savey + 1 .. [[
    |
    buttonClicked|retrieveitem
    chk_enablesucking|1|]])
    sleep(delayret)
    bot:sendPacket(2, [[
    action|dialog_return
    dialog_name|itemremovedfromsucker
    tilex|]] ..savex.. [[
    |
    tiley|]] ..savey + 1 .. [[
    |
    itemtoremove|]] .. c)
end

function retut(c)
    sleep(delayret)
    bot:wrench(savex+1, savey+1)
    sleep(delayret)
    bot:sendPacket(2, [[
    action|dialog_return
    dialog_name|itemsucker_block
    tilex|]] ..savex + 1 .. [[
    |
    tiley|]] ..savey + 1 .. [[
    |
    buttonClicked|retrieveitem
    chk_enablesucking|1|]])
    sleep(delayret)
    bot:sendPacket(2, [[
    action|dialog_return
    dialog_name|itemremovedfromsucker
    tilex|]] ..savex + 1 .. [[
    |
    tiley|]] ..savey + 1 .. [[
    |
    itemtoremove|]] .. c)
end

function checker1()
    for _, tile in pairs(getBot():getWorld():getTiles()) do
        if tile.bg == 6 or tile.fg == 6 then
            if getBot():isInTile(tile.x, tile.y) then
                return false
            else
                return true
            end
        end
    end
end

function retrieveBlock()
	savex, savey = gogaut()
    local bot = getBot()

    if not bot or bot.status ~= BotStatus.online or not savex or not savey then
        return
    end
    local amount = 200 - getBot():getInventory():getItemCount(blockid)
    local result = retut(amound)

    if result == true then
        bot:say("Retrieved block successfully.")
    end
end

function retrieveSeed()
	savex, savey = gogaut()
    local bot = getBot()

    if not bot or bot.status ~= BotStatus.online or not savex or not savey then
        return
    end
    local amount = 200 - getBot():getInventory():getItemCount(seedid)
    local result = retgaia(amound)

    if result == true then
        bot:say("Retrieved seed successfully.")
    end
end


function gotoworld()
    getBot():warp(worldname, worldid)
    sleep(delayjoin)
end

function save()
    getBot():warp(savename, saveid)
    sleep(delayjoin)
end

function saveblock()
    getBot():warp(savene, saveze)
    sleep(delayjoin)
end

function dropseeds()
    if getBot():getInventory():getItemCount(seedid) > maxamount then
        save()
        sleep(delayjoin)
        while getBot():isInWorld(string.upper(savename)) and getBot():getInventory():getItemCount(seedid) > maxamount do
            local theseedamount = getBot():getInventory():getItemCount(seedid)
            sleep(300)
            getBot():moveLeft()
            sleep(300)
            getBot():drop(seedid, theseedamount)
            sleep(1000)
            if getBot():getInventory():getItemCount(seedid) == 0 then 
                sleep(1000)
                break 
            end
        end
    end
end

function dropblocks()
    if getBot():getInventory():getItemCount(blockid) > maxamount then
        saveblock()
        sleep(delayjoin)
        while getBot():isInWorld(string.upper(savene)) and getBot():getInventory():getItemCount(blockid) > maxamount do
            local theblockamount = getBot():getInventory():getItemCount(blockid)
            sleep(300)
            getBot():moveLeft()
            sleep(300)
            getBot():drop(blockid, theblockamount)
            sleep(1000)
            if getBot():getInventory():getItemCount(blockid) == 0 then 
                sleep(1000)
                break 
            end
        end
    end
end


function checker()
    for _, tile in pairs(getBot():getWorld():getTiles()) do
        if tile.bg == 6 or tile.fg == 6 then
            if getBot():isInTile(tile.x, tile.y) then
                getBot():leaveWorld()
                sleep(2000)
                break
            end
        end
    end
end

function retrives()
retrieveSeed()
sleep(delayret)
retrieveBlock()
end

function main()
    sleep(1000)
    
    if not getBot():isInWorld(string.upper(worldname)) then
        gotoworld()
    end
    
    sleep(2000)
    
    savex, savey = gogaut()

    
    while getBot():getInventory():getItemCount(seedid) <= maxamount and getBot():getInventory():getItemCount(blockid) <= maxamount and getBot():isInTile(savex, savey) and getBot():isInWorld(string.upper(worldname)) do
        retrives()
        sleep(delayret)
        if getBot():getInventory():getItemCount(seedid) <= maxamount and getBot():getInventory():getItemCount(blockid) <= maxamount then 
            sleep(2000)
        end
    end
    checker()
    dropblocks()
    sleep(2000)
    dropseeds()
end

while true do
    main()
    sleep(2000) 
end
