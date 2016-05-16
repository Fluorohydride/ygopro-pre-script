--ダーク・サンクチュアリ
--Dark Sanctuary
--Script by mercury233
function c100417010.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--update effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c100417010.chcon1)
	e2:SetOperation(c100417010.chop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_ACTIVATING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c100417010.chcon2)
	e3:SetOperation(c100417010.chop2)
	c:RegisterEffect(e3)
	--negate attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCategory(CATEGORY_COIN)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c100417010.condition)
	e4:SetTarget(c100417010.target)
	e4:SetOperation(c100417010.operation)
	c:RegisterEffect(e4)
end
function c100417010.chcon1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsControler(tp) and rc:IsCode(94212438) and re:GetCode()==EVENT_PHASE+PHASE_END
		and re:GetType()==EFFECT_TYPE_ACTIONS+EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F
end
function c100417010.chop1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():RegisterFlagEffect(100417010,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
end
function c100417010.chcon2(e,tp,eg,ep,ev,re,r,rp)
	return ev==1 and e:GetHandler():GetFlagEffect(100417010)>0
end
function c100417010.chop2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.ChangeChainOperation(1,c100417010.dbop)
end
function c100417010.dbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local id=0
	if c:GetFlagEffect(94212438)==0 then
		id=31893528
	elseif c:GetFlagEffect(94212438)==1 then
		id=67287533
	elseif c:GetFlagEffect(94212438)==2 then
		id=94772232
	elseif c:GetFlagEffect(94212438)==3 then
		id=30170981
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(94212438,1))
	local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,id)
	local tc=g:GetFirst()
	if tc and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x11,0,0,1,RACE_FIEND,ATTRIBUTE_DARK)
	and Duel.SelectYesNo(tp,aux.Stringid(100417010,0)) then
		tc:ResetEffect(EFFECT_CANNOT_SPECIAL_SUMMON,RESET_CODE)
		--monster
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e1,true)
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
		--attributes
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_FIEND)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_DARK)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENCE)
		e5:SetValue(0)
		tc:RegisterEffect(e5,true)
		--recover cannot spsummon
		local e6=Effect.CreateEffect(tc)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		tc:RegisterEffect(e6,true)
		--immune
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e7:SetRange(LOCATION_MZONE)
		e7:SetCode(EFFECT_IMMUNE_EFFECT)
		e7:SetValue(c100417010.efilter)
		e7:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e7)
		--cannot be target
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e8:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e8:SetRange(LOCATION_MZONE)
		e8:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e8)
		Duel.SpecialSummonComplete()
	elseif tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	c:RegisterFlagEffect(94212438,RESET_EVENT+0x1fe0000,0,0)
end
function c100417010.efilter(e,te)
	local tc=te:GetHandler()
	return tc~=e:GetHandler() and not tc:IsCode(94212438)
end
function c100417010.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c100417010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c100417010.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetAttacker()
	local coin=Duel.TossCoin(tp,1)
	if coin==1 then
		if Duel.NegateAttack() then
			Duel.Damage(1-tp,math.ceil(tc:GetAttack()/2),REASON_EFFECT)
		end
	end
end
