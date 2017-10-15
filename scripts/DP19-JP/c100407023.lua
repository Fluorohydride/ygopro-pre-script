--おジャマッチング
--Ojamatching
--Scripted by Eerie Code
function c100407023.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100407023.cost)
	e1:SetTarget(c100407023.target)
	e1:SetOperation(c100407023.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100407023.drtg)
	e2:SetOperation(c100407023.drop)
	c:RegisterEffect(e2)
end
function c100407023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c100407023.cfilter(c,tp)
	return c:IsSetCard(0xf) and (c:IsFaceup() or not c:IsOnField()) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c100407023.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c,c:GetCode())
		and Duel.IsExistingMatchingCard(c100407023.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c)
end
function c100407023.filter1(c,cd)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf) and not c:IsCode(cd) and c:IsAbleToHand()
end
function c100407023.filter2(c)
	return c:IsType(TYPE_MONSTER) and (c:IsCode(59464593,980973,46384672,73879377,65192027,89189982) or c:IsSetCard(0x20f)) and c:IsAbleToHand()
end
function c100407023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c100407023.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100407023.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100407023.activate(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100407023.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,sc,sc:GetCode())
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100407023.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,sc)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local gg=g2:Select(tp,1,1,nil)
	g:Merge(gg)
	if g:GetCount()==2 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local og=Duel.GetOperatedGroup():Filter(Card.IsSummonable,nil,true,nil)
		if og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100407023,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=og:Select(tp,1,1,nil):GetFirst()
			Duel.Summon(tp,sg,true,nil)
		end
	end
end
function c100407023.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf) and c:IsAbleToDeck()
end
function c100407023.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c100407023.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c100407023.tdfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100407023.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100407023.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
