--王の憤激

--Scripted by nekrozar
function c100413039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,100413039+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100413039.cost)
	e1:SetTarget(c100413039.target)
	e1:SetOperation(c100413039.activate)
	c:RegisterEffect(e1)
end
function c100413039.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c100413039.costfilter(c,tp)
	return c:IsSetCard(0x134) and Duel.IsExistingTarget(c100413039.matfilter1,tp,LOCATION_MZONE,0,1,c,tp,Group.FromCards(c))
end
function c100413039.matfilter1(c,tp,g)
	local sg=g:Clone()
	sg:AddCard(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c100413039.matfilter2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,g:GetCount(),sg)
end
function c100413039.matfilter2(c)
	return c:IsSetCard(0x134) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN) and not c:IsForbidden()
end
function c100413039.fselect(g,tp)
	if Duel.IsExistingTarget(c100413039.matfilter1,tp,LOCATION_MZONE,0,1,g,tp,g) then
		Duel.SetSelectedCard(g)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function c100413039.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100413039.matfilter1(chkc,tp,g) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		return Duel.CheckReleaseGroup(tp,c100413039.costfilter,1,nil,tp)
	end
	local rg=Duel.GetReleaseGroup(tp):Filter(c100413039.costfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,c100413039.fselect,false,1,99,tp)
	sg:KeepAlive()
	e:SetLabelObject(sg)
	Duel.Release(sg,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100413039.matfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,sg)
end
function c100413039.activate(e,tp,eg,ep,ev,re,r,rp)
	local rg=e:GetLabelObject()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		rg:AddCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100413039.matfilter2),tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,rg:GetCount()-1,rg:GetCount()-1,rg)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
