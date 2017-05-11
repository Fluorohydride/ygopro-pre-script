--リンク・ディサイプル
--Link Disciple
--Scripted by Eerie Code
function c100200132.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c100200132.matfilter,1,1)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100200132,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100200132)
	e1:SetCost(c100200132.cost)
	e1:SetTarget(c100200132.target)
	e1:SetOperation(c100200132.operation)
	c:RegisterEffect(e1)
end
function c100200132.matfilter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_CYBERS)
end
function c100200132.cfilter(c,g)
	return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c100200132.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100200132.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c100200132.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c100200132.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100200132.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	end
end
