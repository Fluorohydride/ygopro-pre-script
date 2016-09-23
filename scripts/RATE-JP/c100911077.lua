--魂源への影劫回帰
--Purusha Shaddoll Aion
--Script by mercury233
function c100911077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c100911077.condition)
	e1:SetTarget(c100911077.target)
	e1:SetOperation(c100911077.activate)
	c:RegisterEffect(e1)
end
function c100911077.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c100911077.filter(c)
	return c:IsSetCard(0x9d) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c100911077.tgfilter(c)
	return c:IsSetCard(0x9d) and c:IsAbleToGrave()
end
function c100911077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100911077.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100911077.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100911077.tgfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100911077.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c100911077.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100911077.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(1000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			local fid=c:GetFieldID()
			tc:RegisterFlagEffect(100911077,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetReset(RESET_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetLabel(fid)
			e3:SetLabelObject(tc)
			e3:SetCondition(c100911077.flipcon)
			e3:SetOperation(c100911077.flipop)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c100911077.flipcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetFlagEffectLabel(100911077)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c100911077.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangePosition(e:GetLabelObject(),POS_FACEDOWN_DEFENSE)
end
