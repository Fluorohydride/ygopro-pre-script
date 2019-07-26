--ベイオネット・パニッシャー

--Scripted by nekrozar
function c100254004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100254004+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100254004.target)
	e1:SetOperation(c100254004.activate)
	c:RegisterEffect(e1)
end
function c100254004.cfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x10f)
end
function c100254004.rmfilter1(c)
	return c:IsFacedown() and c:IsLocation(LOCATION_EXTRA)
end
function c100254004.rmfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsLocation(LOCATION_ONFIELD)
end
function c100254004.lmfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(3000)
end
function c100254004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c100254004.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE,nil)
	if chk==0 then return (g1:IsExists(Card.IsType,1,nil,TYPE_FUSION) and g2:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE))
		or (g1:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and g2:IsExists(c100254004.rmfilter1,3,nil))
		or (g1:IsExists(Card.IsType,1,nil,TYPE_XYZ) and g2:IsExists(c100254004.rmfilter2,1,nil))
		or (g1:IsExists(Card.IsType,1,nil,TYPE_LINK) and g2:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)) end
	if Duel.IsExistingMatchingCard(c100254004.lmfilter,tp,LOCATION_MZONE,0,1,nil) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c100254004.chainlm)
	end
end
function c100254004.chainlm(e,rp,tp)
	return tp==rp
end
function c100254004.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c100254004.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE,nil)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	local res=0
	if g1:IsExists(Card.IsType,1,nil,TYPE_FUSION) and g2:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g2:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
	if g1:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and g2:IsExists(c100254004.rmfilter1,3,nil) then
		if res~=0 then Duel.BreakEffect() end
		local rg=g2:Filter(c100254004.rmfilter1,nil):RandomSelect(tp,3)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
	if g1:IsExists(Card.IsType,1,nil,TYPE_XYZ) and g2:IsExists(c100254004.rmfilter2,1,nil) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g2:FilterSelect(tp,c100254004.rmfilter2,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
	if g1:IsExists(Card.IsType,1,nil,TYPE_LINK) and g2:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g2:FilterSelect(tp,Card.IsLocation,1,3,nil,LOCATION_GRAVE)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
