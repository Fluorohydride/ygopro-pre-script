--炎神－不知火
--Shiranui Sovereignsaga
--Script by nekrozar
function c100911047.initial_effect(c)
	c:SetSPSummonOnce(100911047)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),aux.NonTuner(Card.IsRace,RACE_ZOMBIE),1)
	c:EnableReviveLimit()
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100911047,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c100911047.tdtg)
	e1:SetOperation(c100911047.tdop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c100911047.reptg)
	e2:SetValue(c100911047.repval)
	c:RegisterEffect(e2)
end
function c100911047.tdfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToDeck()
end
function c100911047.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100911047.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c100911047.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100911047.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,g:GetCount(),nil)
	local ct=Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if ct>0 and dg:GetCount()>=ct and Duel.SelectYesNo(tp,aux.Stringid(100911047,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg2=dg:Select(tp,ct,ct,nil)
		Duel.Destroy(sg2,REASON_EFFECT)
	end
end
function c100911047.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_ZOMBIE) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c100911047.rmfilter(c)
	return c:IsSetCard(0xd9) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c100911047.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c100911047.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c100911047.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(100911047,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c100911047.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	end
	return false
end
function c100911047.repval(e,c)
	return c100911047.repfilter(c,e:GetHandlerPlayer())
end
