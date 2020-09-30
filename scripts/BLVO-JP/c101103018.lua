--魔轟神マルコシア
--
--Script by JustFish
function c101103018.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103018,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101103018)
	e1:SetTarget(c101103018.tg)
	e1:SetOperation(c101103018.op)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103018,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,101103018+100)
	e2:SetCondition(c101103018.thcon)
	e2:SetTarget(c101103018.thtg)
	e2:SetOperation(c101103018.thop)
	c:RegisterEffect(e2)
end
function c101103018.dhfilter(c)
	return c:GetCode()~=101103018 and c:IsSetCard(0x35) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c101103018.dhfilter1(c)
	return c:GetCode()~=101103018 and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c101103018.gselect(g)
	return g:IsExists(c101103018.dhfilter,1,nil)
end
function c101103018.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101103018.dhfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c101103018.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101103018.dhfilter,tp,LOCATION_HAND,0,e:GetHandler())
	local hg=Duel.GetMatchingGroup(c101103018.dhfilter1,tp,LOCATION_HAND,0,e:GetHandler())
	if #g<1 then return end
	if #g==1 and #hg==0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	else
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
		local tg=hg:SelectSubGroup(tp,c101103018.gselect,false,1,2)
		Duel.SendtoGrave(tg,REASON_DISCARD+REASON_EFFECT)
	end
	local og,c=Duel.GetOperatedGroup(),e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) and #og>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(#og*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c101103018.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and bit.band(r,REASON_DISCARD)~=0
end
function c101103018.thfilter(c)
	return c:IsSetCard(0x35) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c101103018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101103018.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101103018.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
