// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\MedPack.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================
Script.Load("lua/Weapons/Projectile.lua")
Script.Load("lua/ScriptActor.lua")
Script.Load("lua/DropPack.lua")
Script.Load("lua/PickupableMixin.lua")
Script.Load("lua/Mixins/ClientModelMixin.lua")
Script.Load("lua/TeamMixin.lua")

class 'MedPack' (DropPack)

MedPack.kMapName = "medpack"

MedPack.kModelName = PrecacheAsset("models/marine/medpack/medpack.model")
MedPack.kHealthSound = PrecacheAsset("sound/NS2.fev/marine/common/health")

MedPack.kHealth = 50

local networkVars =
{
}

function MedPack:OnInitialized()

    DropPack.OnInitialized(self)
    
    self:SetModel(MedPack.kModelName)

    if Client then
        InitMixin(self, PickupableMixin, { kRecipientType = "Marine" })
    end
    
end

function MedPack:OnTouch(recipient)

	 --recipient:AddHealth(MedPack.kHealth, false, true)
	 recipient:SetHealth(recipient.health - MedPack.kHealth)
	 
	 if recipient.health  ==0 then 
	     recipient.Kill(recipient, nil, recipient:GetOrigin(),  GetNormalizedVector(recipient:GetOrigin()));
     end

         // Do damage to nearby targets.
        //local hitEntities = GetEntitiesWithMixinForTeamWithinRange("Live", GetEnemyTeamNumber(self:GetTeamNumber()), self:GetOrigin(), kGrenadeLauncherGrenadeDamageRadius)
        
        if recipient:GetTeam():GetNumDeadPlayers() + 1 ==  recipient:GetTeam():GetNumPlayers() then
            
            NS2Gamerules:EndGame(NS2Gamerules.GetTeam2())

            Race:lose();
        end
      

    StartSoundEffectAtOrigin(MedPack.kHealthSound, self:GetOrigin())
    
    TEST_EVENT("Commander MedPack picked up")
    
end

function MedPack:GetIsValidRecipient(recipient)
    return recipient:GetHealth() >=0
end


Shared.LinkClassToMap("MedPack", MedPack.kMapName, networkVars, false)

--Class_Reload("MedPack", MedPack)

Print("Medpack overridden")