--電網の落とし穴
--Network Trap Hole
--Script by nekrozar
function c101004076.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c101004076.target)
	e1:SetOperation(c101004076.activate)
	c:RegisterEffect(e1)
end
function c101004076.filter(c,tp)
	return c:GetSummonPlayer()~=tp and bit.band(c:GetSummonLocation(),LOCATION_DECK+LOCATION_GRAVE)~=0
		and c:IsAbleToRemove() and c:IsLocation(LOCATION_MZONE)
end
function c101004076.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c101004076.filter,nil,tp)
	local ct=g:GetCount()
	if chk==0 then return ct>0 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end

function c101004076.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101004076.filter,nil,tp):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
