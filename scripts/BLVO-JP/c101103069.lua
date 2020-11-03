--スプリガンズ・ブラスト！

--Scripted by mallu11
function c101103069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,101103069+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101103069.condition)
	e1:SetTarget(c101103069.target)
	e1:SetOperation(c101103069.activate)
	c:RegisterEffect(e1)
end
function c101103069.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x257)
end
function c101103069.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101103069.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101103069.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459)
end
function c101103069.disfilter(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function c101103069.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101103069.disfilter,tp,0,LOCATION_MZONE,1,nil) or Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	local ct=1
	if Duel.IsExistingMatchingCard(c101103069.cfilter,tp,LOCATION_MZONE,0,1,nil) then ct=2 end
	local min=0
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then min=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c101103069.disfilter,tp,0,LOCATION_MZONE,min,ct,nil)
	ct=ct-#g
	local dis=0
	if ct>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 then
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101103069,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLEZONE)
			dis=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)|dis
		elseif #g==0 then
			if ct==2 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>1 and Duel.SelectYesNo(tp,aux.Stringid(101103069,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLEZONE)
				dis=Duel.SelectDisableField(tp,2,0,LOCATION_MZONE,0)|dis
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLEZONE)
				dis=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)|dis
			end
		end
	end
	local tc=g:GetFirst()
	while tc do
		dis=(2^tc:GetSequence())*0x10000|dis
		tc=g:GetNext()
	end
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function c101103069.disfilter2(c,dis)
	return c:IsFaceup() and (2^c:GetSequence())*0x10000&dis~=0
end
function c101103069.disfilter3(c,dis)
	return c:IsFacedown() and (2^c:GetSequence())*0x10000&dis~=0
end
function c101103069.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dis=e:GetLabel()
	local g=Duel.GetMatchingGroup(c101103069.disfilter2,tp,0,LOCATION_MZONE,nil,dis)
	local tc=g:GetFirst()
	while tc do
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		dis=dis-(2^tc:GetSequence())*0x10000
		tc=g:GetNext()
	end
	local sg=Duel.GetMatchingGroup(c101103069.disfilter3,tp,0,LOCATION_MZONE,nil,dis)
	local sc=sg:GetFirst()
	while sc do
		dis=dis-(2^sc:GetSequence())*0x10000
		sc=sg:GetNext()
	end
	if dis~=0 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_FIELD)
		e3:SetOperation(c101103069.disop)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetLabel(dis)
		Duel.RegisterEffect(e3,tp)
	end
end
function c101103069.disop(e,tp)
	return e:GetLabel()
end
