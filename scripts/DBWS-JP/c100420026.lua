--征服斗魂 三一爆发
--scripted by JoyJ
function c100420026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,100420026+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100420026.target)
	e1:SetOperation(c100420026.activate)
	c:RegisterEffect(e1)
end
function c100420026.spfilter(c,e,tp,attr)
	return c:IsSetCard(0x297) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsAttribute(attr)
end
function c100420026.filter(c,e,tp)
	return c:IsFaceup() c:IsSetCard(0x297) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c100420026.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetAttribute())
end
function c100420026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100420026.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c100420026.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100420026.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100420026.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local attr=tc:GetAttribute()
		local max=Duel.GetMZoneCount(tp)
		if max>2 then max=2 end
		local g=Duel.GetMatchingGroup(c100420026.spfilter,tp,LOCATION_HAND,0,nil,e,tp,attr)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,max)
		if #sg<1 then return end
		local rg=Group.FromCards(Duel.GetFirstTarget())
		for c in aux.Next(sg) do
			if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				rg:Merge(c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp))
			end
		end
		Duel.SpecialSummonComplete()
		if #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(100420026,1)) then
			Duel.SendtoHand(rg,nil,REASON_EFFECT)
		end
	end
end
