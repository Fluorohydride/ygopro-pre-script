--メタルフォーゼ・コンビネーション
--Metalphosis Combination
--Script by nekrozar
function c100909073.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DELAYED_QUICKEFFECT)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetHintTiming(TIMING_SPSUMMON)
	e1:SetTarget(c100909073.target1)
	e1:SetOperation(c100909073.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100909073,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c100909073.cost)
	e2:SetTarget(c100909073.target2)
	e2:SetOperation(c100909073.activate)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100909073,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c100909073.thcon)
	e3:SetTarget(c100909073.thtg)
	e3:SetOperation(c100909073.thop)
	c:RegisterEffect(e3)
end
function c100909073.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
		and Duel.IsExistingTarget(c100909073.filter,tp,LOCATION_GRAVE,0,1,nil,c:GetLevel(),e,tp)
end
function c100909073.filter(c,lv,e,tp)
	return c:GetLevel()>0 and c:GetLevel()<lv and c:IsSetCard(0xe2)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100909073.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c100909073.filter(chkc,teg:GetFirst():GetLevel(),e,tp) end
	if chk==0 then return true end
	if res and teg:IsExists(c100909073.cfilter,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c100909073.filter,tp,LOCATION_GRAVE,0,1,1,nil,teg:GetFirst():GetLevel(),e,tp)
		e:GetHandler():RegisterFlagEffect(100909073,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetCategory(0)
	end
end
function c100909073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(100909073)==0 end
	e:GetHandler():RegisterFlagEffect(100909073,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c100909073.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c100909073.filter(chkc,eg:GetFirst():GetLevel(),e,tp) end
	if chk==0 then return eg:IsExists(c100909073.cfilter,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100909073.filter,tp,LOCATION_GRAVE,0,1,1,nil,eg:GetFirst():GetLevel(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100909073.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(100909073)==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100909073.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c100909073.thfilter(c)
	return c:IsSetCard(0xe2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100909073.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100909073.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100909073.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100909073.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end