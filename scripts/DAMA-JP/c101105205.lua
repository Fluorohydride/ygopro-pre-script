--光来する奇跡

--scripted by Xylen5967
function c101105205.initial_effect(c)
	aux.AddCodeList(c,44508094)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101105205.target)
	e1:SetOperation(c101105205.activate)
	c:RegisterEffect(e1)
	--cannot to deck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c101105205.tdlimit)
	c:RegisterEffect(e2)
	--apply
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c101105205.opcon)
	e3:SetTarget(c101105205.optg)
	e3:SetOperation(c101105205.opop)
	c:RegisterEffect(e3)
end
function c101105205.tdfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevel(1) and (c:IsAbleToDeck() or c:IsLocation(LOCATION_DECK))
end
function c101105205.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101105205.tdfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
end
function c101105205.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(c101105205.tdfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc:IsLocation(LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
		else
			Duel.ConfirmCards(1-tp,tc)
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		end
	end
end
function c101105205.tdlimit(e,c)
	return (c:IsCode(44508094) or c:IsType(TYPE_SYNCHRO) and aux.IsCodeListed(c,44508094)) and c:IsOnField()
end
function c101105205.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c101105205.opcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101105205.cfilter,1,nil)
end
function c101105205.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101105205.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,101105205)==0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101105205.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,101105205+100)==0
	if chk==0 then return b1 or b2 end
end
function c101105205.opop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetFlagEffect(tp,101105205)==0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101105205.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,101105205+100)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(101105205,1),aux.Stringid(101105205,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(101105205,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(101105205,2))+1
	else return end
	if op==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,101105205,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101105205.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,101105205+100,RESET_PHASE+PHASE_END,0,1)
	end
end
