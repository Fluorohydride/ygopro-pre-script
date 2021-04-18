--ハイドロ・ジェネクス
function c47421985.initial_effect(c)
	aux.AddMaterialCodeList(c,68505803)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,68505803),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	c:EnableReviveLimit()
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47421985,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCondition(c47421985.reccon)
	e1:SetTarget(c47421985.rectg)
	e1:SetOperation(c47421985.recop)
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
function c47421985.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local t=Duel.GetAttackTarget()
	if ev==1 then t=Duel.GetAttacker() end
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	e:SetLabel(t:GetAttack())
	return t:GetLocation()==LOCATION_GRAVE and t:IsType(TYPE_MONSTER)
end
function c47421985.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function c47421985.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
