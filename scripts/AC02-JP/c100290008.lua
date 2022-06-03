--ENシャッフル
--
--Script by Trishula9
function c100290008.initial_effect(c)
	aux.AddCodeList(c,89943723)
	aux.AddSetNameMonsterList(c,0x3008)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100290008)
	e1:SetTarget(c100290008.sptg)
	e1:SetOperation(c100290008.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100290008+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100290008.drtg)
	e2:SetOperation(c100290008.drop)
	c:RegisterEffect(e2)
end
function c100290008.tdfilter(c,e,tp)
	return c:IsSetCard(0x3008,0x1f) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c100290008.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c100290008.spfilter(c,e,tp,code)
	return c:IsSetCard(0x3008,0x1f) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100290008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100290008.tdfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100290008.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,c100290008.tdfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100290008.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c100290008.filter1(c,tp)
	return (c:IsCode(89943723) or (c:IsSetCard(0x3008) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c100290008.filter2,tp,LOCATION_GRAVE,0,1,nil))) and c:IsAbleToDeck()
end
function c100290008.filter2(c)
	return c:IsSetCard(0x1f) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c100290008.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c100290008.filter1,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c100290008.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sc1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100290008.filter1),tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if not sc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	if sc1:IsCode(89943723) then
		local sc2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100290008.filter2),tp,LOCATION_GRAVE,0,0,1,nil):GetFirst()
		if not sc2 then
			if Duel.SendtoDeck(sc1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and sc1:IsLocation(LOCATION_DECK) then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		else
			local sg=Group.FromCards(sc1,sc2)
			if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
				and sc1:IsLocation(LOCATION_DECK) and sc2:IsLocation(LOCATION_DECK) then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	else
		local sc2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100290008.filter2),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if sc2 then
			local sg=Group.FromCards(sc1,sc2)
			if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
				and sc1:IsLocation(LOCATION_DECK) and sc2:IsLocation(LOCATION_DECK) then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end