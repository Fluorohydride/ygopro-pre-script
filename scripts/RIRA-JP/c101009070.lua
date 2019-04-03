--フォーチュンレディ・リワインド
--
--Scripted By-ღ Viola
function c101009070.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101009070+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101009070.sptg)
	e1:SetOperation(c101009070.spop)
	c:RegisterEffect(e1)
end
function c101009070.filter(c,e,tp)
	return c:IsSetCard(0x31) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0x8,tp,false,false)
end
function c101009070.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101009070.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c101009070.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	local ft=Duel.GetMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c101009070.filter,tp,LOCATION_REMOVED,0,nil,e,tp):Filter(Card.IsCanBeEffectTarget,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,tg:GetCount(),0,0)
end
function c101009070.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local ft=Duel.GetMZoneCount(tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if ft<1 or g:GetCount()<1 or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if g:GetCount()<=ft then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0x8,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(101009070,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		g:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(c101009070.retcon)
		e1:SetOperation(c101009070.retop)
		Duel.RegisterEffect(e1,tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0x8,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(101009070,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		sg:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(sg)
		e1:SetCondition(c101009070.retcon)
		e1:SetOperation(c101009070.retop)
		Duel.RegisterEffect(e1,tp)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_RULE)
	end
end
function c101009070.retfilter(c,fid)
	return c:GetFlagEffectLabel(101009070)==fid
end
function c101009070.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c101009070.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c101009070.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c101009070.retfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
end
