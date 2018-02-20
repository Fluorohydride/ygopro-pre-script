--Goddess of Sweet Revenge
function c100241001.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100241001,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c100241001.condition)
	e1:SetCost(c100241001.cost)
	e1:SetTarget(c100241001.target)
	e1:SetOperation(c100241001.operation)
	c:RegisterEffect(e1)
end
function c100241001.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,e:GetHandler())==0
end
function c100241001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c100241001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	if sg:FilterCount(Card.IsDestructable,nil,e)>0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function c100241001.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100241001.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if Duel.Destroy(sg,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c100241001.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(100241001,1)) then
		Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,c100241001.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
