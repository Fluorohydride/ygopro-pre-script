--D-HERO デッドリーガイ
--Destiny HERO - Deadlyguy
--Script by dest
function c100208001.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc008),c100208001.ffilter,true)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100208001,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,100208001)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e1:SetCondition(c100208001.atkcon)
	e1:SetCost(c100208001.atkcost)
	e1:SetTarget(c100208001.atktg)
	e1:SetOperation(c100208001.atkop)
	c:RegisterEffect(e1)
end
function c100208001.ffilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_EFFECT)
end
function c100208001.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c100208001.tgfilter(c)
	return c:IsSetCard(0xc008) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c100208001.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local exc
	local g=Duel.GetMatchingGroup(c100208001.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if g:GetCount()==1 then exc=g:GetFirst() end
	if chk==0 then return g:GetCount()>0
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,exc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,exc)
	Duel.SendtoGrave(tg,REASON_COST+REASON_DISCARD)
end
function c100208001.atfilter(c)
	return c:IsSetCard(0xc008) and c:IsFaceup()
end
function c100208001.cfilter(c)
	return c:IsSetCard(0xc008) and c:IsType(TYPE_MONSTER)
end
function c100208001.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100208001.atfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100208001.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100208001.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local tg=Duel.GetMatchingGroup(c100208001.atfilter,tp,LOCATION_MZONE,0,nil)
		if tg:GetCount()<=0 then return end
		local sg=Duel.GetMatchingGroupCount(c100208001.cfilter,tp,LOCATION_GRAVE,0,nil)
		tc=tg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(sg*200)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=tg:GetNext()
		end
	end
end
