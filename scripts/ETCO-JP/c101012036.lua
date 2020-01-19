--朔夜しぐれ

--Scripted by mallu11
function c101012036.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012036,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101012036)
	e1:SetCondition(c101012036.discon)
	e1:SetCost(c101012036.discost)
	e1:SetTarget(c101012036.distg)
	e1:SetOperation(c101012036.disop)
	c:RegisterEffect(e1)
end
function c101012036.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==1-tp and (aux.disfilter1(c) or c:GetAttack()>0)
end
function c101012036.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101012036.cfilter,1,nil,tp)
end
function c101012036.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c101012036.disfilter(c,g)
	return g:IsContains(c)
end
function c101012036.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c101012036.cfilter,nil,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101012036.disfilter(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(c101012036.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c101012036.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	end
end
function c101012036.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
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
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(101012036,RESET_EVENT+RESET_TURN_SET+RESET_OVERLAY+RESET_MSCHANGE+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(101012036,1))
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetOperation(c101012036.damop)
		Duel.RegisterEffect(e3,tp)
	end
end
function c101012036.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not eg:IsContains(tc) then return end
	if tc:GetFlagEffectLabel(101012036)~=e:GetLabel() then
		e:Reset()
		return
	end
	Duel.Hint(HINT_CARD,0,101012036)
	Duel.Damage(tc:GetPreviousControler(),tc:GetBaseAttack(),REASON_EFFECT)
	tc:ResetFlagEffect(101012036)
	e:Reset()
end
