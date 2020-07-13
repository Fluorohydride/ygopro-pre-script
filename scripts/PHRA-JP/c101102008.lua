--铁兽战线 弗拉克杜尔
function c101102008.initial_effect(c)
	--to gy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101102008,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101102008)
	e1:SetCost(c101102008.tgcost)
	e1:SetTarget(c101102008.tgtg)
	e1:SetOperation(c101102008.tgop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101102008,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101102008+100)
	e2:SetCost(c101102008.spcost)
	e2:SetTarget(c101102008.sptg)
	e2:SetOperation(c101102008.spop)
	c:RegisterEffect(e2)
end
function c101102008.tgfilter(c)
	return c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsLevelBelow(3) and c:IsAbleToGrave()
end
function c101102008.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c101102008.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101102008.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101102008.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101102008.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c101102008.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c101102008.cfilter(c)
	return c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsAbleToRemoveAsCost()
end
function c101102008.fselect(g,e,tp)
	return Duel.IsExistingMatchingCard(c101102008.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g:GetCount())
end
function c101102008.spfilter(c,e,tp,lk)
	return c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsLink(lk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c101102008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local cg=Duel.GetMatchingGroup(c101102008.cfilter,tp,LOCATION_GRAVE,0,nil)
		local ct=cg:GetCount()
		return cg:CheckSubGroup(c101102008.fselect,1,ct,e,tp)
	end
	local cg=Duel.GetMatchingGroup(c101102008.cfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=cg:GetCount()
	local rg=cg:SelectSubGroup(tp,c101102008.fselect,false,1,ct,e,tp,ct)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(rg:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101102008.spop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(0xff,0xff)
	e2:SetTarget(aux.NOT(aux.TargetBoolFunction(Card.IsRace,RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST)))
	e2:SetValue(c101102008.sumlimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lk=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101102008.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lk)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101102008.sumlimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end