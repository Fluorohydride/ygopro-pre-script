--No-P.U.N.K.ディア・ノート
--
--Script by Trishula9
function c101108022.initial_effect(c)
	--to grave and spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108022,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101108022)
	e1:SetCost(c101108022.tgcost)
	e1:SetTarget(c101108022.tgtg)
	e1:SetOperation(c101108022.tgop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108022,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101108022+100)
	e2:SetCondition(c101108022.spcon)
	e2:SetTarget(c101108022.sptg)
	e2:SetOperation(c101108022.spop)
	c:RegisterEffect(e2)
end
function c101108022.costfilter(c,ec,e,tp)
	if not c:IsSetCard(0x171) or not c:IsType(TYPE_MONSTER) or c:IsPublic() then return false end
	local b1=ec:IsAbleToGrave()
	local b2=ec:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if not b1 and not b2 then return false end
	if b1 and not b2 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if not b1 and b2 then return c:IsAbleToGrave() end
	if b1 and b2 then return c:IsAbleToGrave() or c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
end
function c101108022.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101108022.costfilter,tp,LOCATION_HAND,0,1,c,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sc=Duel.SelectMatchingCard(tp,c101108022.costfilter,tp,LOCATION_HAND,0,1,1,c,c,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,sc)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(sc)
end
function c101108022.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101108022.tgfilter(c,g,e,tp)
	return c:IsAbleToGrave() and g:IsExists(Card.IsCanBeSpecialSummoned,1,c,e,0,tp,false,false)
end
function c101108022.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	local g=Group.FromCards(c,sc)
	local fg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if fg:GetCount()==0 then return end
	if fg:GetCount()==1 then Duel.SendtoGrave(fg,REASON_EFFECT) end
	if fg:GetCount()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Filter(c101108022.tgfilter,nil,g,e,tp):Select(tp,1,1,nil)
		if sg and Duel.SendtoGrave(sg,REASON_EFFECT) and sg:GetFirst():IsLocation(LOCATION_GRAVE) then
			Duel.SpecialSummon(g-sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101108022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c101108022.spfilter(c,e,tp)
	return c:IsSetCard(0x171) and not c:IsLevel(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101108022.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101108022.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101108022.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101108022.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101108022.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101108022.splimit)
	e1:SetLabel(tc:GetCode())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101108022.splimit(e,c,tp,sumtp,sumpos)
	return c:GetCode()==e:GetLabel()
end