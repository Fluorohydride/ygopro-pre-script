--VS トリニティ・バースト
--scripted by JoyJ
function c100420026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,100420026+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100420026.target)
	e1:SetOperation(c100420026.activate)
	c:RegisterEffect(e1)
end
function c100420026.spfilter(c,e,tp,attr)
	return c:IsSetCard(0x195) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:GetOriginalAttribute()~=attr
end
function c100420026.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x195) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c100420026.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetOriginalAttribute())
end
function c100420026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100420026.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c100420026.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100420026.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100420026.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local attr=tc:GetOriginalAttribute()
		local max=Duel.GetMZoneCount(tp)
		if max>2 then max=2 end
		if max<1 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then max=1 end
		local g=Duel.GetMatchingGroup(c100420026.spfilter,tp,LOCATION_HAND,0,nil,e,tp,attr)
		if #g==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,max)
		local rg=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		local fid=c:GetFieldID()
		local sg=Group.CreateGroup()
		sg:KeepAlive()
		for sc in aux.Next(tg) do
			if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e2)
				sc:RegisterFlagEffect(100420026,RESET_EVENT+RESETS_STANDARD,0,1,fid)
				rg:Merge(sc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp))
				sg:AddCard(sc)
			end
		end
		if #sg>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabel(fid)
			e1:SetLabelObject(sg)
			e1:SetCondition(c100420026.thcon)
			e1:SetOperation(c100420026.thop)
			Duel.RegisterEffect(e1,tp)
		end
		Duel.SpecialSummonComplete()
		if #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(100420026,1)) then
			Duel.SendtoHand(rg,nil,REASON_EFFECT)
		end
	end
end
function c100420026.thfilter(c,fid)
	return c:GetFlagEffectLabel(100420026)==fid
end
function c100420026.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c100420026.thfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c100420026.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c100420026.thfilter,nil,e:GetLabel())
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
