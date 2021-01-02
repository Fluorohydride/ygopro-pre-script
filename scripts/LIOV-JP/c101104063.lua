--炎のチャンピオンの爆発的な誕生
--Explosive Birth of the Flame Champion
--Scripted by Kohana Sonogami
function c101104063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101104063.target)
	e1:SetOperation(c101104063.activate)
	c:RegisterEffect(e1)
end
function c101104063.filter1(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsDefense(200) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c101104063.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetOriginalLevel())
end
function c101104063.filter2(c,e,tp,lv)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsDefense(200) and not c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101104063.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalLevel()+lv)
end
function c101104063.filter3(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101104063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101104063.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c101104063.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c101104063.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetOriginalLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c101104063.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,lv)
	local lv=lv+g2:GetFirst():GetOriginalLevel()
	g2:AddCard(tc)
	if Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c101104063.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
