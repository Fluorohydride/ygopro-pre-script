--次元骰子
--id:Ruby QQ:917770701
function c100290006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c100290006.spcon)
	e1:SetCost(c100290006.cost)
	e1:SetTarget(c100290006.target)
	e1:SetOperation(c100290006.activate)
	c:RegisterEffect(e1)
end
function c100290006.filter1(c)
	return c:IsFaceup() and c.toss_dice
end
function c100290006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100290006.filter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100290006.costfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c100290006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100290006.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c100290006.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c100290006.filter2(c,e,tp)
	return c.toss_dice and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_MONSTER)
end
function c100290006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c100290006.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100290006.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100290006.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end