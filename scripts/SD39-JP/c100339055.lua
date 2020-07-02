--精霊術の使い手
--
--Script by mercury233
function c100339055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100339055+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100339055.cost)
	e1:SetTarget(c100339055.target)
	e1:SetOperation(c100339055.activate)
	c:RegisterEffect(e1)
end
function c100339055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c100339055.filter(c)
	return c:IsSetCard(0xbf) and c:IsType(TYPE_MONSTER)
		or c:IsSetCard(0x10c0) and c:IsType(TYPE_MONSTER)
		or c:IsSetCard(0xc0) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100339055.thfilter(c,e,tp,mft,sft)
	return c100339055.filter(c) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c100339055.setfilter,tp,LOCATION_DECK,0,1,c,e,tp,mft,sft,c:GetCode())
end
function c100339055.setfilter(c,e,tp,mft,sft,code)
	return c100339055.filter(c) and not c:IsCode(code)
		and (sft>0 and c:IsSSetable(false) or mft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function c100339055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then sft=sft-1 end
		return Duel.IsExistingMatchingCard(c100339055.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,mft,sft)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c100339055.activate(e,tp,eg,ep,ev,re,r,rp)
	local mft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc1=Duel.SelectMatchingCard(tp,c100339055.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mft,sft):GetFirst()
	if tc1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc2=Duel.SelectMatchingCard(tp,c100339055.setfilter,tp,LOCATION_DECK,0,1,1,tc1,e,tp,mft,sft,tc1:GetCode()):GetFirst()
		Duel.SendtoHand(tc1,nil,REASON_EFFECT)
		if tc2:IsType(TYPE_MONSTER) then
			Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		else
			Duel.SSet(tp,tc2,tp,false)
		end
		Duel.ConfirmCards(1-tp,Group.FromCards(tc1,tc2))
	end
end
