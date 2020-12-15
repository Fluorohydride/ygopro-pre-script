--聖天樹の月桂精
--Sunavalon Daphne
--Scripted by Kohana Sonogami
function c100273018.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PLANT),2,2)
	c:EnableReviveLimit()
	--untargetable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(100273018,0)) 
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100273018)
	e2:SetCost(c100273018.tdcost)
	e2:SetTarget(c100273018.tdtg)
	e2:SetOperation(c100273018.tdop)
	c:RegisterEffect(e2)
end
function c100273018.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c100273018.tdfilter(c)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_PLANT) and c:IsAbleToExtra()
end
function c100273018.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c100273018.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100273018.tdfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100273018,1))
	local g=Duel.SelectTarget(tp,c100273018.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,g:GetCount(),0,0)
end
function c100273018.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
