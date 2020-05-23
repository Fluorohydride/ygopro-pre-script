--ヌメロン・ダイレクト

--Scripted by mallu11
function c100266027.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SPSUMMON_COUNT)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100266027.condition)
	e1:SetTarget(c100266027.target)
	e1:SetOperation(c100266027.activate)
	c:RegisterEffect(e1)
end
function c100266027.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(100266026,tp,LOCATION_FZONE) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c100266027.spfilter(c,e,tp)
	return c:IsSetCard(0x124a) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c100266027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100266027.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100266027.exfilter1(c)
	return c:IsFacedown() and c:IsType(TYPE_XYZ)
end
function c100266027.exfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c100266027.fselect(g,ft1,ft2,ect,ft)
	return aux.dncheck(g) and #g<=ft and #g<=ect
		and g:FilterCount(c100266027.exfilter1,nil)<=ft1
		and g:FilterCount(c100266027.exfilter2,nil)<=ft2
end
function c100266027.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		if ft>0 then ft=1 end
	end
	local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
	if ect>0 and (ft1>0 or ft2>0) then
		local sg=Duel.GetMatchingGroup(c100266027.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=sg:SelectSubGroup(tp,c100266027.fselect,false,1,4,ft1,ft2,ect,ft)
			if rg:GetCount()>0 then
				local fid=c:GetFieldID()
				local tc=rg:GetFirst()
				while tc do
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
					tc:RegisterFlagEffect(100266027,RESET_EVENT+RESETS_STANDARD,0,1,fid)
					tc=rg:GetNext()
				end
				Duel.SpecialSummonComplete()
				rg:KeepAlive()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(rg)
				e1:SetCondition(c100266027.rmcon)
				e1:SetOperation(c100266027.rmop)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetLabel(c100266027.getsummoncount(tp))
	e2:SetTarget(c100266027.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetLabel(c100266027.getsummoncount(tp))
	e6:SetValue(c100266027.countval)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
end
function c100266027.getsummoncount(tp)
	return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
end
function c100266027.rmfilter(c,fid)
	return c:GetFlagEffectLabel(100266027)==fid
end
function c100266027.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c100266027.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c100266027.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c100266027.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
function c100266027.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c100266027.getsummoncount(sump)>e:GetLabel()
end
function c100266027.countval(e,re,tp)
	if c100266027.getsummoncount(tp)>e:GetLabel() then return 0 else return 1 end
end
