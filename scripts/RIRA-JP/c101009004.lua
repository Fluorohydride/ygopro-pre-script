--海晶乙女シースター
--
--Scripted By-FW空鸽
function c101009004.initial_effect(c)
	--boost
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101009004,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(2,101009004)
	e1:SetCost(c101009004.adcost)
	e1:SetTarget(c101009004.adtg)
	e1:SetOperation(c101009004.adop)
	c:RegisterEffect(e1)
end
function c101009004.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101009004.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x22b)
end
function c101009004.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101009004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101009004.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101009004.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101009004.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
