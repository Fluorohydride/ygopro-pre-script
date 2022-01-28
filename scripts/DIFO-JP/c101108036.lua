--スターヴ・ヴェノム・プレデター・フュージョン・ドラゴン
--
--Script by JSY1728
function c101108036.initial_effect(c)
	--Fusion Material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c101108036.fusmatfilter,aux.FilterBoolFunction(Card.IsFusionType,TYPE_FUSION),true)
	--Negate Activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108036,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c101108036.negcon)
	e1:SetTarget(c101108036.negtg)
	e1:SetOperation(c101108036.negop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108036,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,101108036)
	e2:SetCondition(c101108036.spcon)
	e2:SetTarget(c101108036.sptg)
	e2:SetOperation(c101108036.spop)
	c:RegisterEffect(e2)
end
function c101108036.fusmatfilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsFusionType(TYPE_FUSION)
end
function c101108036.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c101108036.negcfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1041)>0 and c:IsReleasableByEffect()
end
function c101108036.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108036.negcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c101108036.negcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c101108036.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c101108036.negcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g>0 and Duel.Release(g,REASON_EFFECT)~=0 then
		Duel.NegateActivation(ev)
	end
end
function c101108036.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) and rp==1-tp and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c101108036.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101108036.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101108036.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101108036.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101108036.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101108036.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
