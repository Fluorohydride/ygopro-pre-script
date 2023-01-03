--識無辺世壊
--Script by 奥克斯
function c101112074.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c101112074.condition)
	e1:SetTarget(c101112074.target)
	e1:SetOperation(c101112074.activate)
	c:RegisterEffect(e1)
end
function c101112074.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,101112036)
end
function c101112074.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101112074.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local sg=Duel.GetMatchingGroup(c101112074.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
		local ag=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_MZONE,0,nil,101112036)
		if tc:IsOriginalCodeRule(101112036) and ft>0 and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(101112074,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=sg:Select(tp,1,1,nil)
			if #sg1==0 then return false end
			Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
		elseif not tc:IsOriginalCodeRule(101112036) and #ag>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local ag1=ag:Select(tp,1,1,nil)
			if #ag1==0 then return false end
			Duel.HintSelection(ag1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ag1:GetFirst():RegisterEffect(e1)
		end
	end
end
function c101112074.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(56099748) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
