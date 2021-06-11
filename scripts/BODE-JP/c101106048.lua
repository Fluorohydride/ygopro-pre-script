--超弩級軍貴一うに型二番艦
--scripted by XyLeN
function c101106048.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--apply the effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106048,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101106048)
	e1:SetCondition(c101106048.effcon)
	e1:SetTarget(c101106048.efftg)
	e1:SetOperation(c101106048.effop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106048,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c101106048.discon)
	e2:SetTarget(c101106048.distg)
	e2:SetOperation(c101106048.disop)
	c:RegisterEffect(e2)
end
function c101106048.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c101106048.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local chk1=c:GetMaterial():FilterCount(Card.IsCode,nil,24639891)>0
	local chk2=c:GetMaterial():FilterCount(Card.IsCode,nil,101106022)>0
	if chk==0 then return (chk1 and Duel.IsPlayerCanDraw(tp,1) or chk2) end
	if chk1 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c101106048.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chk1=c:GetMaterial():FilterCount(Card.IsCode,nil,24639891)>0
	local chk2=c:GetMaterial():FilterCount(Card.IsCode,nil,101106022)>0
	if chk1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if chk2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c101106048.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local turn=Duel.GetTurnPlayer()
	if turn==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	elseif turn~=tp then
		return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
	end
end
function c101106048.ctfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSetCard(0x166)
end
function c101106048.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c101106048.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(c101106048.ctfilter,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101106048.disfilter(chkc) end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(c101106048.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101106048.disfilter,tp,0,LOCATION_MZONE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101106048.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=tg:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		tc=tg:GetNext()
	end
end
