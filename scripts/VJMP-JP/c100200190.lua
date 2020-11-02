--迅雷の暴君 グローザー
--Grozer the Thunderclap Tyrant
--Script by: XGlitchy30

--aux.Stringid Guide for whoever edits the cdb:
--0=Negate
--1=Protection
--2=Indestructable by battle
--3=Indestructable by the opponent's card effects
--4=Cannot be targeted by the opponent's card effects

function c100200190.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_FIEND),1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100200190,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,100200190)
	e1:SetCondition(c100200190.negcon)
	e1:SetTarget(c100200190.negtg)
	e1:SetOperation(c100200190.negop)
	c:RegisterEffect(e1)
	--protection
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100200190,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c100200190.econ)
	e2:SetOperation(c100200190.eop)
	c:RegisterEffect(e2)
end
function c100200190.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c100200190.dcfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c100200190.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c100200190.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100200190.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100200190.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c100200190.dcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100200190.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c100200190.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c100200190.dcfilter,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if ((tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
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
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
		end
	end
end
function c100200190.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FIEND) and c:IsPreviousLocation(LOCATION_HAND) and c:IsControler(tp)
end
function c100200190.econ(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c100200190.cfilter,1,nil,tp)
		and (c:GetFlagEffect(100200190)==0 or bit.band(c:GetFlagEffectLabel(100200190),0x7)~=0x7 or not c:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) or not c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)
			or not c:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET))
end
function c100200190.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=(c:GetFlagEffect(100200190)==0 or bit.band(c:GetFlagEffectLabel(100200190),0x1)==0 or not c:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE))
	local b2=(c:GetFlagEffect(100200190)==0 or bit.band(c:GetFlagEffectLabel(100200190),0x2)==0 or not c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT))
	local b3=(c:GetFlagEffect(100200190)==0 or bit.band(c:GetFlagEffectLabel(100200190),0x4)==0 or not c:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET))
	if not b1 and not b2 and not b3 then return end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(100200190,2)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(100200190,3)
		opval[off]=1
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(100200190,4)
		opval[off]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	if sel==0 then
		if c:GetFlagEffect(100200190)==0 then
			c:RegisterFlagEffect(100200190,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		c:SetFlagEffectLabel(100200190,bit.bor(c:GetFlagEffectLabel(100200190),0x1))
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(100200190,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		c:RegisterEffect(e1)
	elseif sel==1 then
		if c:GetFlagEffect(100200190)==0 then
			c:RegisterFlagEffect(100200190,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		c:SetFlagEffectLabel(100200190,bit.bor(c:GetFlagEffectLabel(100200190),0x2))
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(100200190,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(aux.indoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	else
		if c:GetFlagEffect(100200190)==0 then
			c:RegisterFlagEffect(100200190,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		c:SetFlagEffectLabel(100200190,bit.bor(c:GetFlagEffectLabel(100200190),0x4))
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(100200190,4))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
