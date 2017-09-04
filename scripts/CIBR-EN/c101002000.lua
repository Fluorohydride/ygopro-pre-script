--Hallowhallow
--Script by nekrozar
function c101002000.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101002000,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101002000.lvtg)
	e1:SetOperation(c101002000.lvop)
	c:RegisterEffect(e1)
end
function c101002000.lvfilter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c101002000.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101002000.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101002000.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101002000.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101002000.lvop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local dc=Duel.TossDice(tp,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(dc)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
