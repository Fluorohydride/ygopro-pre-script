--死眼の伝霊-プシュコポンポス
--Script by XyLeN
function c101105028.initial_effect(c)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105028,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101105028)
	e1:SetCondition(c101105028.rmcon)
	e1:SetTarget(c101105028.rmtg)
	e1:SetOperation(c101105028.rmop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105028,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,101105028)
	e2:SetCondition(c101105028.tgcon)
	e2:SetTarget(c101105028.tgtg)
	e2:SetOperation(c101105028.tgop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101105028,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,101105028+100)
	e3:SetCondition(c101105028.spcon)
	e3:SetTarget(c101105028.sptg)
	e3:SetOperation(c101105028.spop)
	c:RegisterEffect(e3)
	--handle the e3
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_REMOVE)
	e4:SetOperation(c101105028.regop)
	c:RegisterEffect(e4)
end
function c101105028.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)>Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_SPELL+TYPE_TRAP)
end
function c101105028.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c101105028.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101105028.rmfilter,tp,0,LOCATION_GRAVE,nil)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101105028.rmop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101105028.rmfilter),tp,0,LOCATION_GRAVE,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c101105028.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_MONSTER)<Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_SPELL+TYPE_TRAP)
end
function c101105028.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c101105028.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101105028.tgfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return e:GetHandler():IsAbleToGrave() and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c101105028.tgop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c101105028.tgfilter,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
function c101105028.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(101105028,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
end
function c101105028.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetTurnID()~=Duel.GetTurnCount() and c:GetFlagEffect(101105028)>0
end
function c101105028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101105028.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
