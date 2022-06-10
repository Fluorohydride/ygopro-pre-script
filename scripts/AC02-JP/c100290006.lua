--ディメンジョン・ダイス
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
function c100290006.cfilter(c)
	return c:IsFaceup() and c.toss_dice
end
function c100290006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100290006.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
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
function c100290006.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c.toss_dice and not c.toss_dice_in_pendulum_only
end
function c100290006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		e:SetLabel(0)
		return res and Duel.IsExistingMatchingCard(c100290006.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100290006.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100290006.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
