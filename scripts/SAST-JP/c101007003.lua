--転生炎獣ウルヴィー
--Salamangreat Wolvie
--scripted by LogicalNonsense
function c101007003.initial_effect(c)
	--Used as material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(c101007003.lkcon)
	e1:SetOperation(c101007003.lkop)
	c:RegisterEffect(e1)
	--GY recycle, if special summoned
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101007003,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,101007003)
	e2:SetCondition(c101007003.thcon1)
	e2:SetTarget(c101007003.thtg)
	e2:SetOperation(c101007003.thop)
	c:RegisterEffect(e2)
	--GY recycle, if added to hand
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_HAND)
	e3:SetCondition(c101007003.thcon2)
	e3:SetCost(c101007003.thcost)
	c:RegisterEffect(e3)
end
function c101007003.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end
function c101007003.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	rc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	rc:RegisterEffect(e2)
end
function c101007003.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c101007003.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT)~=0 and c:IsPreviousLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp
end
function c101007003.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c101007003.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end
function c101007003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101007003.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101007003.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101007003.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101007003.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
