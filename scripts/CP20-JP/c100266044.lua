--機塊テスト
--Appliancer Test
--Scripted by Sock#3222
function c100266044.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c100266044.target)
	e1:SetOperation(c100266044.activate)
	c:RegisterEffect(e1)
end
function c100266044.filter(c,tp)
	if not (c:IsType(TYPE_LINK) and c:IsSetCard(0x24b)) then return false end
	local zone=bit.band(c:GetLinkedZone(tp),0x1f)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c100266044.gfilter(c)
	return c:IsSetCard(0x24b) and c:IsType(TYPE_LINK) and c:GetLink()==1
end
function c100266044.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100266044.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100266044.filter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingTarget(c100266044.gfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100266044.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c100266044.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local zone=bit.band(tc:GetLinkedZone(tp),0x1f)
	upbound=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if zone==0 or upbound<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then upbound=1 end
	local g=Duel.SelectMatchingCard(tp,c100266044.gfilter,tp,LOCATION_GRAVE,0,1,upbound,nil)
	if g:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone)
			tc:RegisterFlagEffect(100266044,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(c100266044.rmcon)
		e1:SetOperation(c100266044.rmop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c100266044.rmfilter(c,fid)
	return c:GetFlagEffectLabel(100266044)==fid
end
function c100266044.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c100266044.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c100266044.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c100266044.rmfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
