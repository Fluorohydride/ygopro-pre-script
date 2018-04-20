--オーバード・パラディオン

--Script by nekrozar
function c101005055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101005055+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101005055.target)
	e1:SetOperation(c101005055.activate)
	c:RegisterEffect(e1)
end
function c101005055.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x116)
end
function c101005055.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101005055.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101005055.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101005055.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101005055.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c101005055.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c101005055.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end
