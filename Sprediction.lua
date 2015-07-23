--[[
       _____  _____                 _  _        _    _               
      / ____||  __ \               | |(_)      | |  (_)              
     | (___  | |__) |_ __  ___   __| | _   ___ | |_  _   ___   _ __  
      \___ \ |  ___/| '__|/ _ \ / _` || | / __|| __|| | / _ \ | '_ \ 
      ____) || |    | |  |  __/| (_| || || (__ | |_ | || (_) || | | |
     |_____/ |_|    |_|   \___| \__,_||_| \___| \__||_| \___/ |_| |_|
                                                                 
       
        By Scriptologe a.k.a Nebelwolfi

        How To Use:
            require("SPrediction")
            SP = SPrediction()
            Position, Chance, Direction = SP:Predict(_Q, myHero, Target)
            if Chance >= X then
                CastSpell(_Q, Position.x, Position.y)
            end

            - Position is the predicted position of the target
                If chance is 0 the target position will be returned instead

            - Chance can go from 0 to 3
                 0:  Will not hit
                 1:  50% Hitchance
                 2:  75% Hitchance
                 3: >90% Hitchance
                 
            - Direction the target walks to
                Vector otherwise nil
]]--     

_G.SPredictionAutoUpdate = true
_G.SPredictionVersion    = 2.7

class 'SPrediction' -- {
    function SPrediction:__init()
        if SPredictionAutoUpdate then self:Update() end
        self.tickTable = {}
        AddTickCallback(function() self:Tick() end)
        AddNewPathCallback(function(unit, startPos, endPos, isDash, dashSpeed, dashGravity, dashDistance) self:NewPath(unit, startPos, endPos, isDash, dashSpeed, dashGravity, dashDistance) end)
        return self
    end

    function SPrediction:Update()
      local SPredictionServerData = GetWebResult("raw.github.com", "/nebelwolfi/BoL/master/Common/SPrediction.version")
      if SPredictionServerData then
        local SPredictionServerVersion = type(tonumber(SPredictionServerData)) == "number" and tonumber(SPredictionServerData) or nil
        if SPredictionServerVersion then
          if tonumber(SPredictionVersion) < SPredictionServerVersion then
            self:Msg("New version available v"..SPredictionServerVersion.." - Updating, please don't press F9")
            DelayAction(function() DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Common/SPrediction.lua".."?rand="..math.random(1,10000), LIB_PATH.."SPrediction.lua", function () self:Msg("Successfully updated. ("..SPredictionVersion.." => "..SPredictionServerVersion..")") end) end, 1.5)
          end
        end
      else
        self:Msg("Error downloading version info")
      end
      self:Msg("Loaded the latest version (v"..SPredictionVersion..")")
    end

    function SPrediction:Msg(msg, title) print("<font color=\"#6699ff\"><b>[SPrediction]: "..(title or myHero.charName).." - </b></font> <font color=\"#FFFFFF\">"..msg..".</font>")  end

    function SPrediction:Tick()
        for i=1,heroManager.iCount do 
            unit = heroManager:GetHero(i)
            if unit ~= nil then
                while self.tickTable[unit.networkID] and self.tickTable[unit.networkID][1] and self.tickTable[unit.networkID][1].time < GetInGameTimer() - 1.337 do
                    table.remove(self.tickTable[unit.networkID], 1)
                end
            end
        end
    end

    function SPrediction:NewPath(unit, startPos, endPos, isDash, dashSpeed, dashGravity, dashDistance)
        if unit.type ~= "AIHeroClient" then return end
        if not self.tickTable[unit.networkID] then self.tickTable[unit.networkID] = {} end
        if (self:GetDistance(startPos, endPos) > 0 or unit.isMoving) then
            table.insert(self.tickTable[unit.networkID], {unit = Vector(unit), startPos = Vector(startPos), endPos = Vector(endPos), time = GetInGameTimer()})
        end
    end

    function SPrediction:GetBaitLevel(unit) -- "brain.lua", going to find a better way for the time series analysis soon
        local baitLevel = 0
        if self.tickTable[unit.networkID] then
            local j, k = #self.tickTable[unit.networkID], self.tickTable[unit.networkID]
            for i=j, 1, -1 do
                if k[i] and k[i-1] then
                    local dirPerc = self:GetDirectionDifferencePerc(k[i].endPos-k[i].startPos,k[i-1].endPos-k[i-1].startPos)
                    baitLevel = baitLevel + (1/(j-i+1)) * (dirPerc <= 100 and dirPerc or 100)
                end
            end
            baitLevel = baitLevel < 0 and 0 or baitLevel / 2
        end
        return baitLevel
    end

    function SPrediction:GetDirectionDifferencePerc(dir1,dir2)
        return Vector(Vector(dir1.x, dir1.y, dir1.z):normalized()*100-Vector(dir2.x, dir2.y, dir2.z):normalized()*100):len()/2
    end

    function SPrediction:UnitFacingUnit(unit1, unit2)
        return self:GetDistance(self:PredictPos(unit1), unit2) < self:GetDistance(unit1, unit2)
    end

    function SPrediction:UnitFacingMe(unit1)
        return self:UnitFacingUnit(unit1, myHero)
    end

    function SPrediction:GetTargetDirection(target)
        local wp = self:GetWayPoints(target)
        if #wp == 1 then
            return Vector(target.x, target.y, target.z)
        elseif #wp >= 2 then
            return Vector(wp[2].x-target.x, wp[2].y-target.y, wp[2].z-target.z)
        end
    end

    function SPrediction:GetWayPoints(target) -- ty vpred
        local result = {}
        if target.hasMovePath then
            table.insert(result, Vector(target))
            for i = target.pathIndex, target.pathCount do
                path = target:GetPath(i)
                table.insert(result, Vector(path))
            end
        else
            table.insert(result, Vector(target))
        end
        return result
    end

    function SPrediction:GetDistance(p1,p2)
        local dx = p1.x - p2.x
        local dz = (p1.z or p1.y) - (p2.z or p2.y)
        return dx*dx + dz*dz
    end

    function SPrediction:PredictPos(target, speed, delay, source)
        speed = speed or target.ms
        delay = delay or 0
        source = source or myHero
        local dir = self:GetTargetDirection(target)
        local pos = nil
        local HitBox = target.boundingRadius
        if dir and target.isMoving then
            pos = Vector(target)+Vector(dir.x, dir.y, dir.z):normalized()*(speed ~= target.ms and GetDistance(target,source)*target.ms/speed or speed/8)+Vector(dir.x, dir.y, dir.z):normalized()*delay*target.ms
        elseif not target.isMoving then
            pos = Vector(target)
        end
        if pos then
            baitLevel = self:GetBaitLevel(target)/100
            if target.isMoving then pos = pos-(pos-target)*baitLevel end
            return pos, HitBox
        end
    end

    function SPrediction:Predict(target, range, speed, delay, width, collision, source)
        if not target or target.dead or not range or not speed or not delay or not width then return nil, 0, nil end
        source = source or myHero
        collision = type(collision) == 'number' and collision or collision and 0 or math.huge
        if target.type ~= "AIHeroClient" then
            local Position, HitBox = self:PredictPos(target, speed, delay, source)
            return (target.isMoving and Position) and Vector(target)+(Vector(Position)-target)/4 or Vector(target), 2, Position
        end
        local hitChance, PredictedPos = 0, nil
        local Position, HitBox = self:PredictPos(target, speed, delay, source)
        local baitLevel = self:GetBaitLevel(target)
        local rangeOffset = range+width/2-(self:UnitFacingUnit(target, source) and HitBox or 0)
        local col1, col2, Mcol, mcol, Hcol, hcol, Mcol2, mcol2, Hcol2, hcol2, Mcol3, mcol3, Hcol3, hcol3 = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
        if collision ~= math.huge then
            minions = minionManager(MINION_ALL, range, target, MINION_SORT_HEALTH_ASC).objects
            if #minions > 0 then
                col1 = Collision(self, range, speed, delay, width < 100 and 100 or width+25)
                col2 = Collision(self, range, speed, delay, width)
                Mcol, mcol = col1:Compute(minions, source, Position)
                Mcol2, mcol2 = col1:Compute(minions, source, target)
                Mcol3, mcol3 = col2:Compute(minions, source, Position)
            end
        end
        if self:GetDistance(Position, source) < rangeOffset * rangeOffset then
            if collision == math.huge or not Mcol or mcol < collision then
                if (not target.isMoving or baitLevel < 30) and (not collision or not Mcol2 or mcol2 < collision) then
                    hitChance = hitChance + 3
                else
                    hitChance = hitChance + 2
                end
            elseif not Mcol3 or mcol3 < collision then
                if not target.isMoving or baitLevel < 30 then hitChance = hitChance + 1 end
                hitChance = hitChance + 1
            end
        end
        if Position and IsWall(D3DXVECTOR3(Position.x,Position.y,Position.z)) then hitChance = hitChance-1 end
        return Position, hitChance, self:PredictPos(target)
    end

class("Collision") -- {
    function Collision:__init(SP, range, speed, delay, width)
        self.range = range
        self.speed = speed
        self.delay = delay
        self.width = width
        self.SP = SP
        self.TotalWidths = {[48] = (48 + width) ^ 2, [60] = (60 + width) ^ 2}
    end
    function Collision:Compute(unitTable, startP, endP)
        local numCollisions = 0
        for i, minion in ipairs(unitTable) do
            if minion.team ~= startP.team then
                local predP = self.SP:Predict(minion, self.range, self.speed, self.delay, self.width, false, startP)
                local ProjPoint,_,OnSegment = VectorPointProjectionOnLineSegment(startP, endP, predP)
                if OnSegment then
                    if GetDistanceSqr(ProjPoint, predP) < (minion.boundingRadius + self.width) ^ 2 then
                        numCollisions = numCollisions + 1
                    end
                end
            end
        end
        return numCollisions>0, numCollisions
    end
-- }
