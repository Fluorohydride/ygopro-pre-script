--武人マヒトツ
--Bujin Mahitotsu
--Scripted by Kohana Sonogami
--
function c101104012.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104012,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101104012)
	e1:SetCost(c101104012.spcost)
	e1:SetTarget(c101104012.sptg)
	e1:SetOperation(c101104012.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(101104012,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,101104012+100)
	e2:SetCondition(c101104012.phcon)
	e2:SetCost(c101104012.thcost)
	e2:SetTarget(c101104012.thtg)
	e2:SetOperation(c101104012.thop)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(101104012,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,101104012+100)
	e3:SetCondition(c101104012.phcon)
	e3:SetCost(c101104012.tgcost)
	e3:SetTarget(c101104012.tgtg)
	e3:SetOperation(c101104012.tgop)
	c:RegisterEffect(e3)
end
function c101104012.costfilter1(c)
	return c:IsSetCard(0x88) and c:IsAbleToGraveAsCost()
end
function c101104012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101104012.costfilter1,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c101104012.costfilter1,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c101104012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101104012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101104012.phcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c101104012.costfilter2(c,tp)
	return c:IsSetCard(0x88) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c101104012.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c101104012.thfilter(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x88) and not c:IsCode(code) and c:IsAbleToHand()
end
function c101104012.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101104012.costfilter2,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c101104012.costfilter2,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SendtoGrave(g,REASON_COST)
end
function c101104012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101104012.thop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c101104012.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101104012.costfilter3(c,tp)
	return c:IsSetCard(0x88) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101104012.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c101104012.tgfilter(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x88) and not c:IsCode(code) and c:IsAbleToGrave()
end
function c101104012.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101104012.costfilter3,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c101104012.costfilter3,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	e:SetLabel(tc:GetCode())
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function c101104012.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101104012.tgop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101104012.tgfilter,tp,LOCATION_DECK,0,1,1,nil,code)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
