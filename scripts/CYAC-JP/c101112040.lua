--超重神将シャナ－O
--Script by 奥克斯
function c101112040.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--spsummon (self)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112040,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,101112040)
	e1:SetCondition(c101112040.spdcon)
	e1:SetTarget(c101112040.spdtg)
	e1:SetOperation(c101112040.spdop)
	c:RegisterEffect(e1)
	--defence attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101112040,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_BATTLE_START+TIMING_BATTLE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c101112040.spcon)
	e3:SetTarget(c101112040.sptg)
	e3:SetOperation(c101112040.spop)
	c:RegisterEffect(e3)
end
function c101112040.spdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c101112040.spdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if tc and #g==0 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+EFFECT_DISABLE+CATEGORY_ATKCHANGE)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	end
end
function c101112040.spdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL+TYPE_TRAP)
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if #g==0 and tc and tc:IsRelateToBattle()
		and tc:IsControler(1-tp) and tc:IsFaceup()
		and (tc:GetAttack()>0 or aux.NegateMonsterFilter(tc)) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(0)
		tc:RegisterEffect(e3)
	end
end
function c101112040.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c101112040.spfilter(c,e,tp)
	return c:IsSetCard(0x9a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function c101112040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c101112040.spfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return ft>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE+LOCATION_GRAVE)
end
function c101112040.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101112040.spfilter),tp,LOCATION_SZONE+LOCATION_GRAVE,0,nil,e,tp)
	if ft==0 or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	if #sg==0 then return end
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0
		and c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.SelectYesNo(tp,aux.Stringid(101112040,1)) then
		Duel.BreakEffect()
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
