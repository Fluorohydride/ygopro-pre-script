--地磅计量
function c101111078.initial_effect(c)
	  --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetCondition(c101111078.condition)
	e1:SetTarget(c101111078.target)
	e1:SetOperation(c101111078.operation)
	c:RegisterEffect(e1)
end
function c101111078.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=2
end
function c101111078.tgfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c101111078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mc=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local count=mc-1
	if chk==0 then return count>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,count,1-tp,LOCATION_MZONE)
end
function c101111078.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_MZONE,0)
	local count=g:GetCount()-1
	if count>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,count,count,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end