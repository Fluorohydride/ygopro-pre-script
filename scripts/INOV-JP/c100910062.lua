--創星の因子
--Genesis Tellarknight
--Script by mercury233
function c100910062.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetTarget(c100910062.target)
	e1:SetOperation(c100910062.activate)
	c:RegisterEffect(e1)
end
function c100910062.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100910062.cfilter(c)
	return c:IsSetCard(0x9c) and c:IsFaceup()
end
function c100910062.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c100910062.cfilter,tp,LOCATION_ONFIELD,0,c)
	if chk==0 then return ct>0
		and Duel.IsExistingMatchingCard(c100910062.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,c) end
	local g=Duel.GetMatchingGroup(c100910062.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
end
function c100910062.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c100910062.cfilter,tp,LOCATION_ONFIELD,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c100910062.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,c)
	Duel.Destroy(g,REASON_EFFECT)
end
