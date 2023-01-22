--开放的大地
--Script by 奥克斯
function c101112054.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--special summon or search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112054,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c101112054.spcon)
	e1:SetTarget(c101112054.sptg)
	e1:SetOperation(c101112054.spop)
	c:RegisterEffect(e1)
end
function c101112054.cfilter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsFaceup() and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function c101112054.filter1(c)
	return c:IsType(TYPE_MONSTER) and (c:IsCode(68468459) or aux.IsCodeListed(c,68468459)) and c:IsAbleToHand()
end
function c101112054.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsCode(68468459) or aux.IsCodeListed(c,68468459)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112054.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101112054.cfilter,1,nil,1-tp)
end
function c101112054.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c101112054.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,101112054+100)==0
	local b2=Duel.IsExistingMatchingCard(c101112054.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,101112054+200)==0
	local ct=e:GetHandler():GetFlagEffect(101112054)
	if chk==0 then return ct==0 and (b1 or b2) end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(101112054,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(101112054,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.RegisterFlagEffect(tp,101112054+100,RESET_PHASE+PHASE_END,0,1)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
		Duel.RegisterFlagEffect(tp,101112054+200,RESET_PHASE+PHASE_END,0,1)
	end
	if (sel==0 and not b2) or (sel~=0 and not b1) then
		e:GetHandler():RegisterFlagEffect(101112054,RESET_CHAIN,0,1)
	end
end
function c101112054.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101112054.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if #g==0 then return end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local g=Duel.GetMatchingGroup(c101112054.filter2,tp,LOCATION_HAND,0,nil,e,tp)
		if ft==0 or #g==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if #sg==0 then return end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end