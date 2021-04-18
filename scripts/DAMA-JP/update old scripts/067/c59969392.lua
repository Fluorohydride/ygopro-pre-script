--アンデット・スカル・デーモン
function c59969392.initial_effect(c)
	aux.AddMaterialCodeList(c,33420078)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,33420078),aux.NonTuner(Card.IsRace,RACE_ZOMBIE),2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_ZOMBIE))
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
if Auxiliary.AddMaterialCodeList==nil then
	function Auxiliary.AddMaterialCodeList(c,...)
		if c:IsStatus(STATUS_COPYING_EFFECT) then return end
		local mat={}
		for _,code in ipairs{...} do
			mat[code]=true
		end
		if c.material==nil then
			local mt=getmetatable(c)
			mt.material=mat
		end
		for index,_ in pairs(mat) do
			Auxiliary.AddCodeList(c,index)
		end
	end
end
