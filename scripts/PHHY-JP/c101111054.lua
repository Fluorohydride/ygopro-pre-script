--タリホー！スプリガンズ！
--Script by 神数不神
function c101111054.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111054,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101111054)
	e1:SetTarget(c101111054.target)
	e1:SetOperation(c101111054.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(101111054,1))
	e2:SetCost(c101111054.cost)
	e2:SetOperation(c101111054.activate2)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101111054,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,101111054)
	e3:SetTarget(c101111054.mattg)
	e3:SetOperation(c101111054.matop)
	c:RegisterEffect(e3)
end
function c101111054.filter(c)
	return c:IsSetCard(0x155) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101111054.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101111054.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101111054.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101111054.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101111054.filter2(c,e,tp)
	return c:IsSetCard(0x155) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101111054.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local spct=Duel.GetMatchingGroupCount(c101111054.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if spct>ct then spct=ct end
	if spct>3 then spct=3 end
	if spct<1 then return false end
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,LOCATION_MZONE,0,1,REASON_COST) end
	spct=Duel.RemoveOverlayCard(tp,LOCATION_MZONE,0,1,spct,REASON_COST)
	e:SetLabel(spct)
end
function c101111054.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101111054.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local spct=Duel.GetMatchingGroupCount(c101111054.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		if ct>0 and spct>0 and Duel.SelectYesNo(tp,aux.Stringid(101111054,2)) then
			spct=e:GetLabel()
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c101111054.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,spct,spct,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c101111054.matfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function c101111054.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101111054.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101111054.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101111054.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101111054.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end




