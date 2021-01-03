--結晶の魔女サンドリヨン
--Magistus Witch Cendrillon
--Scripted by Kohana Sonogami
function c101104042.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c101104042.mfilter,c101104042.xyzcheck,2,2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104042,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101104042)
	e1:SetCost(c101104042.spcost)
	e1:SetTarget(c101104042.sptg)
	e1:SetOperation(c101104042.spop)
	c:RegisterEffect(e1)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101104042,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101104042+100)
	e3:SetCondition(c101104042.discon)
	e3:SetTarget(c101104042.distg)
	e3:SetOperation(c101104042.disop)
	c:RegisterEffect(e3)
end
function c101104042.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsXyzLevel(xyzc,4) and c:IsRace(RACE_SPELLCASTER)
end
function c101104042.xyzcheck(g)
	return g:GetClassCount(Card.GetAttribute)==#g
end
function c101104042.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101104042.spfilter(c,e,tp)
	return c:IsSetCard(0x150) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101104042.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101104042.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101104042.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101104042.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c101104042.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c101104042.splimit(e,c)
	return not c:IsSetCard(0x150) and c:IsLocation(LOCATION_EXTRA)
end
function c101104042.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c101104042.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function c101104042.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c101104042.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101104042.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,c101104042.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c101104042.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
