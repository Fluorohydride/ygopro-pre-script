--トリックスター・スイートデビル
--Trickstar Sweet Devil
--Scripted by Eerie Code
function c101002044.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfb),2,2)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_LEAVE_FIELD_P)
	e1:SetOperation(c101002044.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(e1)
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
function c101002044.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetLinkedGroup()
	if not g then return end
	local lg=g:Clone()
	lg:KeepAlive()
	e:SetLabelObject(lg)
end
function c101002044.cfilter(c,g)
	return g:IsContains(c)
end
function c101002044.damcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetLabelObject():GetLabelObject()
	if not lg then return false end
	return eg:IsExists(c101002044.cfilter,1,nil,lg)
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
	local lg=c:GetLinkedGroup()
	if not lg then return end
	local gc=lg:GetCount()
	if gc==0 then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-gc*200)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
