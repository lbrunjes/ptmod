// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Exploder.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/ScriptActor.lua")
Script.Load("lua/DropPack.lua")
Script.Load("lua/PickupableMixin.lua")
Script.Load("lua/Mixins/ClientModelMixin.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/Weapons/Marine/Grenade.lua")

class 'Exploder' (DropPack)

Exploder.kMapName = "Exploder"

Exploder.kModelName = PrecacheAsset("models/marine/medpack/medpack.model")
Exploder.kHealthSound = PrecacheAsset("sound/NS2.fev/marine/common/health")

Exploder.kHealth = 50

local networkVars =
{
}

function Exploder:OnInitialized()

    DropPack.OnInitialized(self)
    
    self:SetModel(Exploder.kModelName)

    if Client then
        InitMixin(self, PickupableMixin, { kRecipientType = "Marine" })
    end
    
end

function Exploder:OnTouch(recipient)

    -- spawn a  grenade above it
    --pick a startpoint
    local grenadeStartPoint = self:GetOrigin()
    local grenadeDirection =  Vector3(1,1,1)

    grenadeDirection:Normalize()

    local grenade = CreateEntity(Grenade.kMapName, grenadeStartPoint, GetEnemyTeamNumber(recipient:GetTeamNumber()))
    local startVelocity = grenadeDirection  * 10

    local angles = Angles(0,0,0)
    angles.yaw = GetYawFromVector(grenadeDirection)
    angles.pitch = GetPitchFromVector(grenadeDirection)
    grenade:SetAngles(angles)

    grenade:Setup(player, startVelocity, true, nil, player)

    StartSoundEffectAtOrigin(Exploder.kHealthSound, self:GetOrigin())

    TEST_EVENT("Commander Exploder picked up")
    
end

function Exploder:GetIsValidRecipient(recipient)
    return recipient:GetHealth() >=0
end


Shared.LinkClassToMap("Exploder", Exploder.kMapName, networkVars, false)

--Class_Reload("Exploder", Exploder)

Print("Medpack overridden")