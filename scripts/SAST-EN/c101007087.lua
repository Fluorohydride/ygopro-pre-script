--Time Thief Flyback
--Script by JoyJ
function c101007087.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101007087,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101007087)
	e1:SetTarget(c101007087.target)
	e1:SetOperation(c101007087.activate)
	c:RegisterEffect(e1)
	--grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101007087,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101007087)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101007087.mattg)
	e2:SetOperation(c101007087.matop)
	c:RegisterEffect(e2)
end
function c101007087.xyzfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x229)
end
function c101007087.matfilter(c)
	return c:IsSetCard(0x229)
end
function c101007087.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101007087.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101007087.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101007087.matfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101007087.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c101007087.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101007087,2))
		local g=Duel.SelectMatchingCard(tp,c101007087.matfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function c101007087.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101007087.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101007087.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101007087.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c101007087.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101007087,2))
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_GRAVE,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
