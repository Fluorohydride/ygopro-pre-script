--華麗なるハーピィ・レディ
--The Elegant Harpie Lady
--Scripted by Eerie Code, mod by mercury233
function c100411005.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100411005)
	e1:SetTarget(c100411005.target)
	e1:SetOperation(c100411005.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100411005+100)
	e2:SetCondition(c100411005.thcon)
	e2:SetTarget(c100411005.thtg)
	e2:SetOperation(c100411005.thop)
	c:RegisterEffect(e2)
end
c100411005.card_code_list={12206212}
function c100411005.tdfilter(c,e,tp)
	return c:IsCode(12206212) and c:IsAbleToDeck() 
end
function c100411005.spfilter(c,e,tp)
	return c:IsSetCard(0x64) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100411005.spfilter1(c,e,tp)
	return c100411005.spfilter(c,e,tp)
		and Duel.IsExistingMatchingCard(c100411005.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetOriginalCode())
end
function c100411005.spfilter2(c,e,tp,code1)
	return c100411005.spfilter(c,e,tp)
		and c:GetOriginalCode()~=code1
		and Duel.IsExistingMatchingCard(c100411005.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp,code1,c:GetOriginalCode())
end
function c100411005.spfilter3(c,e,tp,code1,code2)
	return c100411005.spfilter(c,e,tp)
		and c:GetOriginalCode()~=code1 and c:GetOriginalCode()~=code2
end
function c100411005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100411005.tdfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c100411005.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=Duel.SelectMatchingCard(tp,c100411005.tdfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,g)
	if #dg>0 and Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c100411005.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(100411005,2)) then
		local sg1=Duel.SelectMatchingCard(tp,c100411005.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local sg2=Duel.SelectMatchingCard(tp,c100411005.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,sg1:GetFirst():GetOriginalCode())
		local sg3=Duel.SelectMatchingCard(tp,c100411005.spfilter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,sg1:GetFirst():GetOriginalCode(),sg2:GetFirst():GetOriginalCode())
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.BreakEffect()
		Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100411005.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100411005.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WIND)
end
function c100411005.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and (rp==1-tp or (rp==tp and re:GetHandler():IsSetCard(0x64))) and c:GetPreviousControler()==tp
end
function c100411005.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x64) and c:IsAbleToHand()
end
function c100411005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100411005.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100411005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100411005.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
