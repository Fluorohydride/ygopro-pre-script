--火山缘发式子弹
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
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x32)
end
function c100428020.rmfilter(c,e,tp)
	return c:IsSetCard(0xb9) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToRemove()
		and (c:IsLocation(LOCATION_SZONE) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function c100428020.setfilter(c,e,tp)
	return c:IsSetCard(0xb9) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()
end
function c100428020.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c100428020.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,100428020)==0 and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100428020.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c100428020.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,100428120)==0
	if chk==0 then return b1 or b2 end
end
function c100428020.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c100428020.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,100428020)==0 and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100428020.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c100428020.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,100428120)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(100428020,1),aux.Stringid(100428020,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(100428020,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(100428020,2))+1
	else return end
	if op==0 then
		if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c100428020.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
			local g1=Duel.SelectMatchingCard(tp,c100428020.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoGrave(g1,REASON_EFFECT)
			Duel.RegisterFlagEffect(tp,100428020,RESET_PHASE+PHASE_END,0,1)
		end
	else
		local rmg=Duel.SelectMatchingCard(tp,c100428020.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
		local g2=Duel.SelectMatchingCard(tp,c100428020.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		if Duel.Remove(rmg:GetFirst(),POS_FACEUP,REASON_EFFECT)~=0 and g2:GetCount()>0 then
			Duel.MoveToField(g2:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.RegisterFlagEffect(tp,100428120,RESET_PHASE+PHASE_END,0,1)
		end
	end
end