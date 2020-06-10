--双天脚之鸿鹄
function c101102015.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101102015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101102015)
	e1:SetCondition(c101102015.spcon)
	e1:SetTarget(c101102015.sptg)
	e1:SetOperation(c101102015.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101102015,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101102015+100)
	e2:SetTarget(c101102015.thtg)
	e2:SetOperation(c101102015.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101102015.spfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0x24d) and not c:IsCode(101102015) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end
function c101102015.sffilter(c,e,tp,tc)
	return c:IsSetCard(0x24d) and c:IsType(TYPE_FUSION)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c101102015.desfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x24d)
		and Duel.IsExistingMatchingCard(c101102015.sffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c101102015.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c101102015.spfilter,1,nil,tp) and Duel.GetTurnPlayer()~=tp
end
function c101102015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101102015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c101102015.desfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(101102015,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c101102015.desfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			if Duel.Destroy(g,REASON_EFFECT)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,c101102015.sffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
				if sg:GetCount()>0 then
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
function c101102015.thfilter(c)
	return c:IsSetCard(0x24d) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c101102015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101102015.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101102015.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101102015.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end