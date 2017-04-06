--星杯剣士アウラム
--Star Grail Swordsman Aurum
--Script by mercury233
function c101001049.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1fd),2,2)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c101001049.atkval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101001049,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101001049)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c101001049.spcost1)
	e2:SetTarget(c101001049.sptg1)
	e2:SetOperation(c101001049.spop1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101001049,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c101001049.spcon2)
	e3:SetTarget(c101001049.sptg2)
	e3:SetOperation(c101001049.spop2)
	c:RegisterEffect(e3)
end
function c101001049.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1fe)
end
function c101001049.atkval(e,c)
	return Duel.GetMatchingGroup(c101001049.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)*300
end
function c101001049.cfilter(c,g)
	return c:IsSetCard(0x1fd) and g:IsContains(c)
end
function c101001049.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101001049.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c101001049.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c101001049.spfilter1(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c101001049.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=e:GetHandler():GetLinkedZone()
	local cc=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and chkc~=cc and c101001049.spfilter1(chkc,e,tp,zone) end
	if chk==0 then return zone~=0 and Duel.IsExistingTarget(c101001049.spfilter1,tp,LOCATION_GRAVE,0,1,cc,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101001049.spfilter1,tp,LOCATION_GRAVE,0,1,1,cc,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101001049.spop1(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone)
		Duel.SpecialSummonComplete()
	end
end
function c101001049.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c101001049.spfilter2(c,e,tp)
	return c:IsSetCard(0x1fd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101001049.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101001049.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101001049.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101001049.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
