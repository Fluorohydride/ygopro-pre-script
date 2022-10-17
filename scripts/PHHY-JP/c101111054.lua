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
	e1:SetCost(c101111054.cost)
	e1:SetTarget(c101111054.target)
	e1:SetOperation(c101111054.activate)
	c:RegisterEffect(e1)
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
function c101111054.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local spct=0
	if Duel.CheckRemoveOverlayCard(tp,LOCATION_MZONE,0,1,REASON_COST)
		and Duel.SelectYesNo(tp,aux.Stringid(101111054,1)) then
		spct=Duel.RemoveOverlayCard(tp,LOCATION_MZONE,0,1,3,REASON_COST)
	end
	e:SetLabel(spct)
end
function c101111054.thfilter(c)
	return c:IsSetCard(0x155) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101111054.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101111054.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101111054.spfilter(c,e,tp)
	return c:IsSetCard(0x155) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101111054.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101111054.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local ct=Duel.GetMatchingGroupCount(c101111054.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		local spct=e:GetLabel()
		if spct>0 and ct>=spct and ft>=spct
			and Duel.SelectYesNo(tp,aux.Stringid(101111054,2)) then
			Duel.BreakEffect()
			local sg=Duel.SelectMatchingCard(tp,c101111054.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,spct,spct,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101111054.matfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function c101111054.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101111054.matfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101111054.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101111054.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101111054.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT)>0
		and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
