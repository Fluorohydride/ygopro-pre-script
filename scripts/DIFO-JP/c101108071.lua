--兽带斗神起身
function c101108071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101108071)
	e1:SetTarget(c101108071.target)
	e1:SetOperation(c101108071.activate)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108071,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,44644530)
	e2:SetCondition(c101108071.eqcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101108071.eqtg)
	e2:SetOperation(c101108071.eqop)
	c:RegisterEffect(e2)
end
function c101108071.spfilter(c,e,tp)
	return c:IsSetCard(0x27a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101108071.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101108071.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101108071.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101108071.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101108071.eqfilter(c)
	return c:IsSetCard(0x27a) and c:IsType(TYPE_MONSTER)
end
function c101108071.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101108071.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(101108071,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg=g:Select(tp,1,1,nil)
			local ec=g:GetFirst()
			if ec then
				if not Duel.Equip(tp,ec,tc) then return end
				--equip limit
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetLabelObject(tc)
				e1:SetValue(c101108071.eqlimit)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				ec:RegisterEffect(e1)
			end
		end
	end
end
function c101108071.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c101108071.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c101108071.filter(c)
	return c:IsSetCard(0x27a) and c:IsFaceup()
end
function c101108071.filter1(c,e)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsRelateToEffect(e)
end
function c101108071.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101108071.eqfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingTarget(c101108071.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c101108071.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c101108071.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c101108071.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:Filter(c101108071.filter1,nil,e):GetFirst()
	g:RemoveCard(tc)
	local ec=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
	if tc and ec and ec:IsRelateToEffect(e) then
		if not Duel.Equip(tp,ec,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetLabelObject(tc)
		e1:SetValue(c101108071.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
	end
end