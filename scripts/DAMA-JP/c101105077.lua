--モンスターアソート

--Scripted by mallu11
function c101105077.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,101105077+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101105077.target)
	e1:SetOperation(c101105077.activate)
	c:RegisterEffect(e1)
end
function c101105077.filter(c,g)
	return g:IsExists(c101105077.filter2,1,c,c) and c:IsType(TYPE_NORMAL)
end
function c101105077.filter2(c,cc)
	return c:IsRace(cc:GetRace()) and c:IsAttribute(cc:GetAttribute()) and c:IsLevel(cc:GetLevel()) and c:IsType(TYPE_EFFECT)
end
function c101105077.fselect(g)
	return g:IsExists(c101105077.filter,1,nil,g)
end
function c101105077.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101105077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101105077.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(c101105077.fselect,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101105077.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101105077.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,c101105077.fselect,false,2,2)
	if sg and #sg==2 then
		Duel.ConfirmCards(1-tp,sg)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.ShuffleDeck(tp)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
