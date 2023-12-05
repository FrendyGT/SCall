if OwnerValidity == true and Owner == "FrendyGT" then
bot = getBot()
bots = getBots()
world = bot:getWorld()
inventory = bot:getInventory()	
	
function AnlikYer()
    Dunyadami = tostring(world.name)
    if Dunyadami ~= "" and Dunyadami ~= "EXIT" then
        localbot = world:getLocal()
        if localbot then
            Botx = math.floor(localbot.posx / 32) 
            Boty = math.floor(localbot.posy / 32)
        end
    end
end

function floats(idz)
    float = 0
    for i, obj in pairs(world:getObjects()) do
        if obj.id == idz then 
            float = float + obj.count
        end
    end
    return {ucanlar = float}
end

function join(a,b) 
    sleep(DELAY_JOIN)
    bot:warp(a,b)
    sleep(DELAY_JOIN)
    AnlikYer()
    Dunyadami = tostring(world.name)
    if Dunyadami ~= "" and Dunyadami ~= "EXIT" then
        if world:getTile(Botx,Boty).fg == 6 then
            join(a,b)
        end
    end
end

function takeP()
    for _, obj in pairs(world:getObjects()) do
      if obj.id == 98 then
        xp = math.floor(obj.x / 32)
        yp = math.floor(obj.y / 32)
        bot:findPath(xp,yp)
        sleep(1000)
        bot.auto_collect = true
        bot.collect_range = 1 
        sleep(500)
        bot.auto_collect = false
        if inventory:getItemCount(98) > 0 then
          break
        end
      end
    end
end

function dropPick()
    bot:sendPacket(2, "action|drop\n|itemID|" .. 98)
    bot:sendPacket(2, "action|dialog_return\ndialog_name|drop_item\nitemID|" .. 98 .. "|\ncount|" .. inventory:getItemCount(98) - 1)
    sleep(1000)
end

function cekpik()
    if Pick and inventory:getItemCount(98) > 1 then
        join(WORLD_PICKAXE,ID_WORLD_PICKAXE)
        dropPick()
        sleep(1000)
    end
end

function PickaxeControl()
    if USE_PICK and inventory:getItemCount(98) == 0 then
        join(WORLD_PICKAXE,ID_WORLD_PICKAXE)
        sleep(500)
        takeP()
        sleep(3000)
        if inventory:getItemCount(98) > 0 then
            bot:wear(98)
            sleep(2000)
            dropPick()
            sleep(1000)
            if inventory:getItemCount(98) > 1 then
                join(WORLD_PICKAXE,ID_WORLD_PICKAXE)
                dropPick()
                sleep(1000)
                cekpik()
            end
        else
            while inventory:getItemCount(98) == 0 do
                sleep(5000)
                join(WORLD_PICKAXE,ID_WORLD_PICKAXE)
                sleep(500)
                takeP()
                sleep(3000)
                if inventory:getItemCount(98) > 0 then
                    bot:wear(98)
                    sleep(2000)
                    dropPick()
                    sleep(1000)
                    if inventory:getItemCount(98) > 1 then
                        join(WORLD_PICKAXE,ID_WORLD_PICKAXE)
                        dropPick()
                        sleep(1000)
                        cekpik()
                    end
                end
            end
        end
    end
    if inventory:getItemCount(98) > 1 then
        join(WORLD_PICKAXE,ID_WORLD_PICKAXE)
        dropPick()
        sleep(1000)
    end
end
PickaxeControl()

function take() 
    ReconnectTakeBlock()
    for _,obj in pairs(world:getObjects()) do
      if obj.id == BLOCKID then 
            ReconnectTakeBlock()
            AnlikYer()
            if world:getTile(Botx,Boty).fg == 6 then
                join(WORLD_BLOCK,WORLD_BLOCKid)
            end
            local x = math.floor(obj.x / 32)
            local y = math.floor(obj.y / 32)
            bot:findPath(x,y)
            bot.auto_collect = true
            sleep(1000) 
        end
        if inventory:getItemCount(BLOCKID) > 1 then
            bot.auto_collect = false
            break
        end
    end
end
itemler = 0
function tarama()
    itemler = 0
    for _, obj in pairs(world:getObjects()) do
        if obj.id == BLOCKID then 
            itemler = itemler + obj.count
        end
    end
    return itemler
end

function TrashTheJunks()
    for i, trash in ipairs(TRASH_LIST) do
        if inventory:getItemCount(trash) > TRASH_COUNT then
          	bot:trash(trash, inventory:getItemCount(trash))
            sleep(1000)
        end
    end
end

function OnlineControl()
    if bot.status ~= 1 then
        while bot.status ~= 1 do
            bot:connect()
            sleep(10000)
        end
    end
end

function tilealfg(x,y)
    OnlineControl()
    AnlikYer()
    Dunyadami = tostring(world.name)
    if Dunyadami ~= "" and Dunyadami ~= "EXIT" then
        tilefgx = world:getTile(x,y).fg
        return {tilefg = tilefgx}
    end
end

function tilealbg(x,y)
    OnlineControl()
    AnlikYer()
    Dunyadami = tostring(world.name)
    if Dunyadami ~= "" and Dunyadami ~= "EXIT" then
        tilebgx = world:getTile(x,y).bg
        return {tilebg = tilebgx}
    end
end

function tilepnb()
    if MODE_PNB == "UP" then
        if (tilealfg(Botx,Boty-2).tilefg ~= 0 or tilealbg(Botx,Boty-2).tilebg ~= 0) then
            Reconnect()
            AnlikYer()
            bot:hit(Botx,Boty-2) 
            sleep(DELAY_BREAK)
        elseif tilealfg(Botx,Boty-2).tilefg == 0 then
		    AnlikYer()
            bot:place(Botx,Boty-2,BLOCKID)
            sleep(DELAY_PUT)
        end
    elseif MODE_PNB == "DOWN" then
        if (tilealfg(Botx,Boty+2).tilefg ~= 0 or tilealbg(Botx,Boty+2).tilebg ~= 0) then
            Reconnect()
            AnlikYer()
            bot:hit(Botx,Boty+2) 
            sleep(DELAY_BREAK)
        elseif tilealfg(Botx,Boty+2).tilefg == 0 then
		    AnlikYer()
            bot:place(Botx,Boty+2,BLOCKID)
            sleep(DELAY_PUT)
        end
    elseif MODE_PNB == "MUTLI" then
        if (tilealfg(Botx,Boty+2).tilefg ~= 0 or tilealbg(Botx,Boty+2).tilebg ~= 0) then
            Reconnect()
            AnlikYer()
            bot:hit(Botx,Boty+2) 
            sleep(DELAY_BREAK)
        elseif tilealfg(Botx,Boty+2).tilefg == 0 then
		    AnlikYer()
            bot:place(Botx,Boty+2,BLOCKID)
            sleep(DELAY_PUT)
        end
        if (tilealfg(Botx,Boty-2).tilefg ~= 0 or tilealbg(Botx,Boty-2).tilebg ~= 0) then
            Reconnect()
            AnlikYer()
            bot:hit(Botx,Boty-2) 
            sleep(DELAY_BREAK)
        elseif tilealfg(Botx,Boty-2).tilefg == 0 then
		    AnlikYer()
            bot:place(Botx,Boty-2,BLOCKID)
            sleep(DELAY_PUT)
        end
    end
end

local originalPositions = {}

function GoToSpot()
    local offsetX = RANGE_BETWEEN_BOTS
    local botList = getBot():getWorld():getPlayers()
    local botName = getBot().name
    local botIndex = nil
    for index, bot in ipairs(botList) do
        if bot.name == botName then
            botIndex = index
            break
        end
    end
    if botIndex then
        checker()
        if getBot():isInWorld(string.upper(WORLD_BREAK)) then
            local storedPosition = originalPositions[botName]
            local destinationX, destinationY
            if storedPosition then
                destinationX = storedPosition.x
                destinationY = storedPosition.y
            else
                for _, tile in pairs(getBot():getWorld():getTiles()) do
                    if tile.fg == PATOKAN or tile.bg == PATOKAN then
                        destinationX = tile.x + offsetX * (botIndex - 1)
                        destinationY = tile.y
                        break
                    end
                end
                originalPositions[botName] = { x = destinationX, y = destinationY }
            end
            sleep(500)
            getBot():findPath(destinationX, destinationY)
            sleep(400)
        end
    end
end

function checker()
    for _, tile in pairs(getBot():getWorld():getTiles()) do
        if tile.bg == 6 or tile.fg == 6 then
            if getBot():isInTile(tile.x, tile.y) then
                sleep(1000)
                join(WORLD_BREAK,ID_WORLD_BREAK)
                sleep(2000)
                break
            end
        end
    end
end

function rets(var)
    if var:get(0):getString() == "OnDialogRequest" then
      count = var:get(1):getString():match("|Amount:|(%d+)")
      x = var:get(1):getString():match("|tilex|(%d+)")
      y = var:get(1):getString():match("|tiley|(%d+)")
      if var:get(1):getString():find("end_dialog|itemsucker_seed|Close|Update") and var:get(1):getString():find("retrieveitem") then
        sendPackets(2, [[
action|dialog_return
dialog_name|itemsucker_seed
tilex|]] .. x .. [[
|
tiley|]] .. y .. [[
|
buttonClicked|retrieveitem

chk_enablesucking|1]])
      elseif var:get(1):getString():find("end_dialog|itemremovedfromsucker|Close|Retrieve") then
        sendPackets(2, [[
action|dialog_return
dialog_name|itemremovedfromsucker
tilex|]] .. x .. [[
|
tiley|]] .. y .. [[
|
itemtoremove|]] .. count)
      elseif var:get(1):getString():find("end_dialog|itemsucker_block|Close|Update") and var:get(1):getString():find("retrieveitem") then
        sendPackets(2, [[
action|dialog_return
dialog_name|itemsucker_block
tilex|]] .. x .. [[
|
tiley|]] .. y .. [[
|
buttonClicked|retrieveitem

chk_enablesucking|1]])
        return true
      end
    end
end

function PNB()
    addEvent(Event.variantlist, rets)
    if not USE_GAUT then
        bot.auto_collect = true
        bot.collect_range = 5
    else
        bot.auto_collect = false
    end
    if world.name ~= WORLD_BREAK then
        join(WORLD_BREAK,ID_WORLD_BREAK)
    end
    if LEGIT_MODE then
        bot.legit_mode = true
    elseif not LEGIT_MODE then
        bot.legit_mode = false
    end
    AnlikYer()
    GoToSpot()
    if CHANGE_COLOR then
	    bot:setSkin(math.random(1, 6))
    end
    bot:say("Hexagonal is fake,diagonal is thick")
    while inventory:getItemCount(BLOCKID) > 0 do
        Reconnect()
        tilepnb()
    end
    Reconnect()
    if inventory:getItemCount(BLOCKID) == 0 and USE_GAUT and RETRIEVE_GAUT then 
        Reconnect()
        for _, titid in pairs(world:getTiles()) do
            if titid.fg == 6946 then
            Reconnect()
            bot:findPath(titid.x, titid.y - 1)
            sleep(1000)
        end
    end
    AnlikYer()
    bot:wrench(Botx,Boty+1)
    sleep(1000)
    listenEvents(1)
    sleep(2000)
    for _, kisik in pairs(world:getTiles()) do
        if kisik.fg == 6948 then
            Reconnect()
            bot:findPath(kisik.x, kisik.y - 1)
            sleep(500)
        end
    end
    AnlikYer()
    bot:wrench(Botx,Boty+1)
    sleep(1000)
    listenEvents(1)
    sleep(2000)
    end
end

function DropF()
    bot.auto_collect = false
    while not USE_GAUT and bot.gem_count > PRICE_PACK and BUY_PACK do
        Reconnectpkt()
        bot:sendPacket(2, "action|buy\nitem|"..NAME_PACK)
        sleep(3000) -- you can change delay
    end
    if inventory:getItemCount(SEEDID) > 0 then
        join(WORLD_SEED,ID_WORLD_SEED)
        Reconnect()
        while (inventory:getItemCount(SEEDID) > 0) do
            if world.name ~= WORLD_SEED then
                join(WORLD_SEED,ID_WORLD_SEED)
            end
            Reconnect()
            AnlikYer()
            for _, tile in pairs(world:getTiles()) do 
                if tile.fg == PATOKAN_SEED or tile.bg == PATOKAN_SEED and USE_PATOKAN_SEED then 
                    bot:findPath(tile.x-1, tile.y)
                    sleep(1000)
                    bot:setDirection(false)
                    sleep(100)
                    bot:drop(SEEDID,inventory:getItemCount(SEEDID))
                    sleep(500)
                    while (inventory:getItemCount(SEEDID) > 0) do
                        bot:moveRight()
                        sleep(500)
                        bot:drop(SEEDID,inventory:getItemCount(SeedID))
                        sleep(500)
                    end
                elseif not USE_PATOKAN_SEED then
                    while (inventory:getItemCount(SEEDID) > 0) do
                        bot:moveRight()
                        sleep(500)
                        bot:drop(SEEDID,inventory:getItemCount(SEEDID))
                        sleep(500)
                    end
                end
            end
        end  
    end
    for _, PACKID in pairs(ID_PACK) do
        if getBot():getInventory():getItemCount(PACKID) > DROP_COUNT then
            join(WORLD_PACK,ID_WORLD_PACK)
            Reconnect()
            while inventory:getItemCount(PACKID) > DROP_COUNT do
                 if world.name ~= WORLD_PACK then
                    join(WORLD_PACK,ID_WORLD_PACK)
                end
                Reconnect()
                AnlikYer()
                for _, tile in pairs(world:getTiles()) do 
                    if tile.fg == PATOKAN_PACK or tile.bg == PATOKAN_PACK and USE_PATOKAN_PACK then 
                        bot:findPath(tile.x-1, tile.y)
                        sleep(1000)
                        bot:setDirection(false)
                        sleep(100)
                        bot:drop(PACKID,inventory:getItemCount(PACKID))
                        sleep(500)
                        while (inventory:getItemCount(PACKID) > DROP_COUNT) do
                            bot:moveRight()
                            sleep(500)
                            bot:drop(PACKID,inventory:getItemCount(PACKID))
                            sleep(500)
                        end
                    elseif not USE_PATOKAN_PACK then
                        while (inventory:getItemCount(PACKID) > DROP_COUNT) do
                            bot:moveRight()
                            sleep(500)
                            bot:drop(PACKID,inventory:getItemCount(PACKID))
                            sleep(500)
                        end
                    end
                end
            end
        end
    end
end

function Reconnectpkt()
    if bot.status ~= 1 then       
        while bot.status ~= 1 do
            bot:connect()
            sleep(10000)
        end
        join(WORLD_BREAK,ID_WORLD_BREAK)
    end
end

function ReconnectTakeBlock()
    if bot.status ~= 1 then
        while bot.status ~= 1 do
            bot:connect()
            sleep(10000)
        end
        join(WORLD_BLOCK,ID_WORLD_BLOCK)
    end
    Dunyadami = tostring(world.name)
    if Dunyadami ~= "" and Dunyadami ~= "EXIT" then
        AnlikYer()
        if world:getTile(Botx,Boty).fg == 6 then
            join(WORLD_BLOCK,ID_WORLD_BLOCK)
        end
    end
end

function Reconnect()
    if bot.status ~= 1 then 
        while bot.status ~= 1 do
            bot:connect()
            sleep(10000)
        end
        join(WORLD_BREAK,ID_WORLD_BREAK)
    end
    Dunyadami = tostring(world.name)
    if Dunyadami ~= "" and Dunyadami ~= "EXIT" then
        AnlikYer()
        if world:getTile(Botx,Boty).fg == 6 then
            join(ID_WORLD_BREAK,ID_WORLD_BREAK)
        end
    end
end

isOwner = true

while isOwner == true do 
    Reconnect()
    DropF()
    for i, list in ipairs(WORLD_BLOCK) do
        list = string.upper(list)
        join(list[1],ID_WORLD_BLOCK)
        tarama()
        if itemler > 1 and inventory:getItemCount(BLOCKID) == 0 then
            take()
            tarama()
        elseif itemler == 0  and inventory:getItemCount(BLOCKID) == 0 then
            join(list[i],ID_WORLD_BLOCK)
            tarama()
            take()
            if getBot():getWorld().name == list[#list]:upper() then
                bot:leaveWorld()
                sleep(5000)
                bot:stopScript()
            end
        end
    end
    if inventory:getItemCount(BLOCKID) > 0 then
        join(WORLD_BREAK,ID_WORLD_BREAK)
        PNB()
    end
    DropF()
    TrashTheJunks()
end
