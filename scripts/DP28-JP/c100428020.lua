--ヴォルカニック・リムファイア
--Script by Ruby
function c100428020.initial_effect(c)
	--to grave/set canon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100428020,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c100428020.optg)
	e1:SetOperation(c100428020.opop)
	c:RegisterEffect(e1)
end
function c100428020.tgfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x32) and c:IsAbleToGrave()
end
function c100428020.rmfilter(c,tp)
	return c:IsSetCard(0xb9) and c:IsFaceupEx() and c:IsAbleToRemove()
		and (c:IsLocation(LOCATION_SZONE) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function c100428020.setfilter(c,tp)
	return c:IsSetCard(0xb9) and c:IsType(TYPE_CONTINUOUS)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c100428020.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetFlagEffect(tp,100428020)==0 and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c100428020.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.GetFlagEffect(tp,100428120)==0
		and Duel.IsExistingMatchingCard(c100428020.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c100428020.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(100428020,1),aux.Stringid(100428020,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(100428020,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(100428020,2))+1 end
	e:SetLabel(op)
	if op==0 then
		Duel.RegisterFlagEffect(tp,100428020,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	else
		Duel.RegisterFlagEffect(tp,100428120,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
	end
end
function c100428020.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 then
		if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=Duel.SelectMatchingCard(tp,c100428020.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g1>0 then
				Duel.SendtoGrave(g1,REASON_EFFECT)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rmg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100428020.rmfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,tp)
		if Duel.Remove(rmg:GetFirst(),POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g2=Duel.SelectMatchingCard(tp,c100428020.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
			if #g2>0 then
				Duel.MoveToField(g2:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		end
	end
end
