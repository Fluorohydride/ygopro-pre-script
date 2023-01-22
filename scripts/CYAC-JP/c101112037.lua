--骑甲虫 残酷撒旦独角仙
--Script by 奥克斯
function c101112037.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x170),aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),true)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101112037)
	e1:SetTarget(c101112037.thtg)
	e1:SetOperation(c101112037.thop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c101112037.splimit)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101112037,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101112037+100)
	e3:SetCondition(c101112037.spcon)
	e3:SetTarget(c101112037.sptg)
	e3:SetOperation(c101112037.spop)
	c:RegisterEffect(e3)
end
function c101112037.thfilter(c)
	return c:IsSetCard(0x170) and c:IsAbleToHand()
end
function c101112037.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112037.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101112037.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101112037.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101112037.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT)
end
function c101112037.ctfilter(c)
	local chk1=c:IsRace(RACE_INSECT) or c:GetPreviousRaceOnField()&RACE_INSECT~=0
	local chk2=c:IsType(TYPE_MONSTER) or c:GetPreviousTypeOnField()&TYPE_MONSTER~=0
	return not c:IsType(TYPE_TOKEN) and c:IsFaceup() and chk1 and chk2
end
function c101112037.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101112037.ctfilter,1,nil)
end
function c101112037.spfilter(c,e,tp)
	if c:IsFacedown() then return false end
	return c:IsSetCard(0x170) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112037.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101112037.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101112037.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101112037.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101112037.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end