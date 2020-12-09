--サンアバロン・メリアス
--Sunavalon Melias
--LUA by Kohana Sonogami
--
function c100273019.initial_effect(c)
	--Link Summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PLANT),2,99,c100273019.lcheck)
	c:EnableReviveLimit()
	--Special Summon "Sunseed Genius Loci" from your GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100273019,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c100273019.spcon)
	e1:SetTarget(c100273019.sptg)
	e1:SetOperation(c100273019.spop)
	c:RegisterEffect(e1)
	--Cannot be targeted for attacks
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	--It can attack of many times up to "Sunvine" you control
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(100273019,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c100273019.mttg)
	e3:SetOperation(c100273019.mtop)
	c:RegisterEffect(e3)
end
function c100273019.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end
function c100273019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c100273019.spfilter(c,e,tp)
	return c:IsCode(100270206) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100273019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c100273019.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100273019.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100273019.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100273019.cfilter(c,g)
	return c:IsSetCard(0x255) and g:IsContains(c)
end
function c100273019.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsControler(tp) and c100273019.cfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c100273019.cfilter,tp,LOCATION_MZONE,0,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100273019.cfilter,tp,LOCATION_MZONE,0,1,1,nil,lg)
end
function c100273019.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x256) and c:IsType(TYPE_LINK)
end
function c100273019.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c100273019.cfilter2,tp,LOCATION_MZONE,0,nil)
	if ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ct-1)
		tc:RegisterEffect(e1)
	end
end
