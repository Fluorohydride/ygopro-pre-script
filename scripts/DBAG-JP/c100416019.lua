--ラドレミコード・エンジェリア

--scripted by Xylen5967
function c100416019.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c100416019.actcon1)
	e1:SetOperation(c100416019.actop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(c100416019.subop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100416019,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,100416019)
	e3:SetTarget(c100416019.sptg)
	e3:SetOperation(c100416019.spop)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c100416019.actcon2)
	e4:SetValue(c100416019.actlimit2)
	c:RegisterEffect(e4)
end
function c100416019.actfilter1(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x265) and c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c100416019.actcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100416019.actfilter1,1,nil,tp)
end
function c100416019.actop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c100416019.chlimit)
	elseif Duel.GetCurrentChain()==1 then
		c:RegisterFlagEffect(100416019,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING) 
		e1:SetOperation(c100416019.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone() 
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c100416019.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(100416019)
	c:Reset()
end
function c100416019.subop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(100416021)~=0 then
		Duel.SetChainLimitTillChainEnd(c100416019.chlimit)
	end
end
function c100416019.chlimit(e,ep,tp)
	return ep==tp or e:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c100416019.cfilter(c,e,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsSetCard(0x265) and c:IsType(TYPE_PENDULUM)
		and Duel.IsExistingMatchingCard(c100416019.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLeftScale())
end
function c100416019.spfilter(c,e,tp,sc)
	return c:IsSetCard(0x265) and c:IsType(TYPE_MONSTER) and not c:IsCode(100416019)
		and math.abs(c:GetLeftScale()-sc)==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100416019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100416019.cfilter,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100416019.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c100416019.cfilter,1,1,nil,e,tp)
	if Duel.Release(g,REASON_COST)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c100416019.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,g:GetFirst():GetLeftScale())
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c100416019.pfilter(c) 
	local lsc=c:GetLeftScale()
	local rsc=c:GetRightScale()
	return (lsc%2~=0 or rsc%2~=0) and c:IsType(TYPE_PENDULUM)
end
function c100416019.actfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x265) and c:IsControler(tp)
end
function c100416019.actcon2(e)
	local a=Duel.GetAttacker()
	return a and a:IsControler(e:GetHandlerPlayer()) and a:IsSetCard(0x265)
		and Duel.IsExistingMatchingCard(c100416019.pfilter,tp,LOCATION_PZONE,0,1,nil)
end
function c100416019.actlimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
