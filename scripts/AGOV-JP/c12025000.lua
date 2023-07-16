--重铠装超量
function c12025000.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c12025000.xyzcond)
	e1:SetTarget(c12025000.xyztg)
	e1:SetOperation(c12025000.xyzop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12025000,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c12025000.eqtg)
	e2:SetOperation(c12025000.eqop)
	c:RegisterEffect(e2)
end
function c12025000.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end

function c12025000.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c12025000.xyzcond(e,tp,eg,ep,ev,re,r,rp,chk)
	return  Duel.IsExistingMatchingCard(c12025000.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c12025000.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12025000.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12025000.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c12025000.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end

function c12025000.tgfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c12025000.eqfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c)
end
function c12025000.eqfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:CheckUniqueOnField(tp) and not c:IsForbidden() 
end
function c12025000.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12025000.tgfilter(chkc,tp) end
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		return ft>0 and Duel.IsExistingTarget(c12025000.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c12025000.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c12025000.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tg=Duel.GetTargetsRelateToChain()
	local tc=tg:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst()
	local ec=Duel.SelectMatchingCard(tp,c12025000.eqfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,tc,tp):GetFirst()
	if tc and ec and ec:CheckUniqueOnField(tp) and not ec:IsForbidden() then
		if not Duel.Equip(tp,ec,tc) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetLabelObject(tc)
		e1:SetValue(c12025000.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(ec:GetAttack())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e2)
		--substitute
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(c12025000.desrepval)
		ec:RegisterEffect(e3,true)
	end
end
function c12025000.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c12025000.desrepval(e,re,r,rp)
	return r&(REASON_BATTLE|REASON_EFFECT)~=0
end
