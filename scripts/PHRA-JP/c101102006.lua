--铁兽战线 纳贝尔
function c101102006.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101102006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101102006)
	e1:SetCost(c101102006.spcost)
	e1:SetTarget(c101102006.sptg)
	e1:SetOperation(c101102006.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101102006,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,101102006+100)
	e2:SetTarget(c101102006.thtg)
	e2:SetOperation(c101102006.thop)
	c:RegisterEffect(e2)
end
function c101102006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c101102006.cfilter(c)
	return c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsAbleToRemoveAsCost()
end
function c101102006.fselect(g,e,tp)
	return Duel.IsExistingMatchingCard(c101102006.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g:GetCount())
end
function c101102006.spfilter(c,e,tp,lk)
	return c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsLink(lk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c101102006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local cg=Duel.GetMatchingGroup(c101102006.cfilter,tp,LOCATION_GRAVE,0,nil)
		local ct=cg:GetCount()
		return cg:CheckSubGroup(c101102006.fselect,1,ct,e,tp)
	end
	local cg=Duel.GetMatchingGroup(c101102006.cfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=cg:GetCount()
	local rg=cg:SelectSubGroup(tp,c101102006.fselect,false,1,ct,e,tp,ct)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(rg:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101102006.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(aux.NOT(aux.TargetBoolFunction(Card.IsRace,RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST)))
	e1:SetValue(c101102006.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lk=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101102006.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lk)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101102006.sumlimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
function c101102006.thfilter(c)
	return c:IsSetCard(0x24f) and c:IsType(TYPE_MONSTER) and not c:IsCode(101102006) and c:IsAbleToHand()
end
function c101102006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101102006.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101102006.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101102006.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end