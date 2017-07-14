--トリックスター・スイートデビル
--Trickstar Sweet Devil
--Scripted by Eerie Code
function c101002044.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfb),2,2)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101002044.damcon)
	e2:SetOperation(c101002044.damop)
	c:RegisterEffect(e2)
	--reduce atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101002044.atkcon)
	e3:SetOperation(c101002044.atkop)
	c:RegisterEffect(e3)
end
function c101002044.cfilter(c,tp,zone)
	if not c:IsReason(REASON_DESTROY) then return false end
	local seq=c:GetPreviousSequence()
	if c:IsControler(tp) then
		return bit.band(zone,bit.lshift(1,seq))~=0
	else
		return bit.band(bit.rshift(zone,16),bit.lshift(1,seq))~=0
	end
end
function c101002044.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101002044.cfilter,1,nil,e:GetHandler():GetLinkedZone())
end
function c101002044.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101002044)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
function c101002044.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_BATTLE)==0 and re
		and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xfb)
end
function c101002044.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetLinkedGroupCount()
	if ct<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-ct*200)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
