--恩惠之风
function c101010074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCondition(c101010074.cost1)
	e1:SetTarget(c101010074.target1)
	e1:SetOperation(c101010074.activate1)
	c:RegisterEffect(e1)
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetTarget(c101010074.target2)
	e2:SetOperation(c101010074.activate2)
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCondition(c101010074.cost3)
	e2:SetTarget(c101010074.target3)
	e2:SetOperation(c101010074.activate3)
end
function c101010074.cfilter1(c)
	return c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
		and c:IsRace(RACE_PLANT)
end
function c101010074.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c101010074.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE) end
	Duel.DiscardHand(tp,c101010074.cfilter1,1,1,REASON_COST,nil)
end
function c101010074.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c101010074.activate1(e,tp,eg,ep,ev,re,r,rp)
	local _,__,___,p,d = Duel.GetOperationInfo(0,CATEGORY_RECOVER)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c101010074.tgfilter2(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToDeck()
end
function c101010074.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE)
		and c101010074.tgfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010074.tgfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	local g = Duel.SelectTarget(tp,c101010074.tgfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE)
end
function c101010074.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c = Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoDeck(c) > 0 then
		Duel.BreakEffect()
		Duel.Recover(tp,500,REASON_EFFECT)
	end
end
function c101010074.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c101010074.filter3(c,e,tp)
	return c:IsSetCard(0xc9) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010074.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c101010074.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c101010074.activate3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp) > 0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101010074.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end


