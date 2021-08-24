--聖殿の水遣い
function c100417026.initial_effect(c)
	aux.AddCodeList(c,100417125)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100417026,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100417026)
	e1:SetCondition(c100417026.spcon)
	e1:SetTarget(c100417026.sptg)
	e1:SetOperation(c100417026.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100417026,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,100417026+100)
	e2:SetCost(c100417026.thcost)
	e2:SetTarget(c100417026.thtg)
	e2:SetOperation(c100417026.thop)
	c:RegisterEffect(e2)
	--set 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100417026,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,100417026+200)
	e3:SetCondition(c100417026.scon)
	e3:SetTarget(c100417026.stg)
	e3:SetOperation(c100417026.sop)
	c:RegisterEffect(e3)
end
function c100417026.cfilter(c)
	return c:IsCode(100417125) and c:IsFaceup()
end
function c100417026.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100417026.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100417026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100417026.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end
function c100417026.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100417026.thfilter(c)
	return c:IsCode(100417025) and c:IsAbleToHand()
end
function c100417026.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100417026.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100417026.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100417026.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100417026.scfilter(c)
	return c:IsCode(100417125) and c:IsFaceup()
end
function c100417026.scon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100417026.scfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100417026.stfilter(c,tp)
	return aux.IsCodeListed(c,100417125) and c:IsType(TYPE_FIELD) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c100417026.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100417026.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp) end
end
function c100417026.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c100417026.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end