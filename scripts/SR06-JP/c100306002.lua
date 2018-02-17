--悪王アフリマ
--Ahrima, King of Wickedness
--Script by nekrozar
function c100306002.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100306002,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c100306002.thcost)
	e1:SetTarget(c100306002.thtg)
	e1:SetOperation(c100306002.thop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100306002,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100306002)
	e2:SetCost(c100306002.drcost)
	e2:SetTarget(c100306002.drtg)
	e2:SetOperation(c100306002.drop)
	c:RegisterEffect(e2)
end
function c100306002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c100306002.thfilter1(c)
	return c:IsCode(100306022) and c:IsAbleToHand()
end
function c100306002.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c100306002.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100306002.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c100306002.thfilter1,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c100306002.thfilter2(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsDefenseAbove(2000) and c:IsAbleToHand()
end
function c100306002.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return ((Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_DARK) and Duel.IsPlayerCanDraw(tp,1))
		or (Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,c,ATTRIBUTE_DARK) and Duel.IsExistingMatchingCard(c100306002.thfilter2,tp,LOCATION_DECK,0,1,nil))) end
	local sg=nil
	if Duel.IsExistingMatchingCard(c100306002.thfilter2,tp,LOCATION_DECK,0,1,nil) and not Duel.IsPlayerCanDraw(tp,1) then
		sg=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,c,ATTRIBUTE_DARK)
	else
		sg=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_DARK)
	end
	e:SetLabelObject(sg:GetFirst())
	Duel.Release(sg,REASON_COST)
end
function c100306002.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabelObject()~=e:GetHandler() then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100306002.drop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject()~=e:GetHandler() and Duel.IsExistingMatchingCard(c100306002.thfilter2,tp,LOCATION_DECK,0,1,nil)
		and (not Duel.IsPlayerCanDraw(tp,1) or Duel.SelectYesNo(tp,aux.Stringid(100306002,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c100306002.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
