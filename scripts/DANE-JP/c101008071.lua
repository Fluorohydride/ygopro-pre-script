--超量合神－マグナフォーメーション
--
--Script by mercury233
function c101008071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetCondition(c101008071.tgcon)
	e2:SetTarget(c101008071.tglimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101008071,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,101008071)
	e3:SetTarget(c101008071.mttg)
	e3:SetOperation(c101008071.mtop)
	c:RegisterEffect(e3)
end
function c101008071.tgcon(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c101008071.tglimit(e,c)
	return c:IsSetCard(0xdc)
end
function c101008071.filter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xdc)
		and Duel.IsExistingMatchingCard(c101008071.filter2,tp,LOCATION_MZONE,0,1,c,e)
end
function c101008071.filter2(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function c101008071.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101008071.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101008071.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101008071.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c101008071.mtop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101008071,1))
	local g=Duel.SelectMatchingCard(tp,c101008071.filter2,tp,LOCATION_MZONE,0,1,1,tc,e)
	if g:GetCount()>0 then
		Duel.Overlay(tc,g)
	end
end
