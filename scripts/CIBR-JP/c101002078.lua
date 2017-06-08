--導爆線
--Blasting Wire
--Scripted by Eerie Code
function c101002078.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c101002078.condition)
	e1:SetTarget(c101002078.target)
	e1:SetOperation(c101002078.activate)
	c:RegisterEffect(e1)
end
function c101002078.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_SZONE)
end
function c101002078.filter(c,seq,tp)
	if c:IsLocation(LOCATION_SZONE) and c:GetSequence()>=5 then return false end
	if c:IsControler(tp) then
		return c:GetSequence()==seq or (seq==1 and c:GetSequence()==5) or (seq==3 and c:GetSequence()==6)
	else
		return c:GetSequence()==4-seq or (seq==1 and c:GetSequence()==6) or (seq==3 and c:GetSequence()==5)
	end
end
function c101002078.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c101002078.filter(chkc,e:GetLabel(),tp) end
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if chk==0 then return Duel.IsExistingTarget(c101002078.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,seq,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101002078.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,seq,tp)
	e:SetLabel(seq)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101002078.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
