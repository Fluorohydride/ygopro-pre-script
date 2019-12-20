--デコード・トーカー・ヒートソウル

--Scripted by mallu11
function c100259041.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),2,3,c100259041.lcheck)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100259041.atkval)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100259041,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e2:SetCountLimit(1,100259041)
	e2:SetCost(c100259041.drcost)
	e2:SetTarget(c100259041.drtg)
	e2:SetOperation(c100259041.drop)
	c:RegisterEffect(e2)
end
function c100259041.lcheck(g)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c100259041.atkval(e,c)
	return c:GetLinkedGroupCount()*500
end
function c100259041.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c100259041.cfilter(c,e,tp,mc)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK) and c:IsLinkBelow(3) and not c:IsCode(100259041)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c100259041.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100259041.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 and Duel.GetLP(tp)<=2000 and c:IsRelateToEffect(e) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c100259041.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and Duel.SelectYesNo(tp,aux.Stringid(100259041,1)) then
		Duel.BreakEffect()
		if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_REMOVED) then
			local g=Duel.SelectMatchingCard(tp,c100259041.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
