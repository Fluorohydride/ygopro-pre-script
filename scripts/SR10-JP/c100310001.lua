--マシンナーズ・カーネル

--Scripted by mallu11
function c100310001.initial_effect(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c100310001.splimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100310001,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,100310001)
	e2:SetTarget(c100310001.destg)
	e2:SetOperation(c100310001.desop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100310001,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,100310101)
	e3:SetTarget(c100310001.sptg)
	e3:SetOperation(c100310001.spop)
	c:RegisterEffect(e3)
end
function c100310001.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c100310001.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
		and Duel.IsExistingMatchingCard(c100310001.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c100310001.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c100310001.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100310001.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100310001.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c100310001.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local g=Duel.GetMatchingGroup(c100310001.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	g:AddCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c100310001.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRace(RACE_MACHINE) then
		local g=Duel.GetMatchingGroup(c100310001.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		g:AddCard(tc)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c100310001.sfilter(c,tp)
	return not c:IsCode(100310001) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
		and bit.band(c:GetPreviousAttributeOnField(),ATTRIBUTE_EARTH)~=0
		and bit.band(c:GetPreviousRaceOnField(),RACE_MACHINE)~=0
		and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c100310001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100310001.sfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c100310001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100310001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
