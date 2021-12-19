--閃刀起動－リンケージ
--
--Script by Trishula9
function c100285002.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100285002.condition)
	e1:SetTarget(c100285002.target)
	e1:SetOperation(c100285002.activate)
	c:RegisterEffect(e1)
end
function c100285002.cfilter(c)
	return c:GetSequence()<5
end
function c100285002.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c100285002.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100285002.spfilter(c,e,tp)
	return c:IsSetCard(0x1115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,0x60)
end
function c100285002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c100285002.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100285002.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler()):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT) and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c100285002.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP,0x60)
			local fg=Duel.GetMatchingGroup(c100285002.atkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
			if fg:CheckSubGroup(c100285002.check,2,2) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(1000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
			end
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c100285002.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c100285002.atkfilter(c)
	return c:IsSetCard(0x1115) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c100285002.check(sg)
	return sg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) and sg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK)
end
function c100285002.splimit(e,c)
	return not c:IsSetCard(0x1115) and c:IsLocation(LOCATION_EXTRA)
end