--ディメンジョン・ダイス 
--
--Script by Trishula9
function c100290006.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100290006.condition)
	e1:SetCost(c100290006.cost)
	e1:SetTarget(c100290006.target)
	e1:SetOperation(c100290006.activate)
	c:RegisterEffect(e1)
end
function c100290006.filter(c)
	return c.toss_dice and c:IsFaceup()
end
function c100290006.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100290006.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100290006.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c100290006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c100290006.spfilter(c,e,tp)
	return c.toss_dice and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100290006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c100290006.rfilter,1,nil,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c100290006.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
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