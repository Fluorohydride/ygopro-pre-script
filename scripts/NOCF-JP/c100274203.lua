--ヌメロン・カオス・リチューアル
--Numeron Chaos Ritual
--Anime Retrain Version by Kohana
function c100274203.initial_effect(c)
	--Activate/Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100274203.xyzcon)
	e1:SetTarget(c100274203.xyztg)
	e1:SetOperation(c100274203.xyzop)
	c:RegisterEffect(e1)
	if not c100274203.global_check then
		c100274203.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c100274203.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c100274203.cfilter(c)
	return c:GetPreviousLocation()&LOCATION_ONFIELD>0 and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousCodeOnField()==79747096
		and c:IsReason(REASON_EFFECT) and c:GetReasonEffect():IsActiveType(TYPE_MONSTER)
end
function c100274203.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c100274203.cfilter,nil)
	for tc in aux.Next(g) do
		Duel.RegisterFlagEffect(tc:GetPreviousControler(),100274203,RESET_PHASE+PHASE_END,0,1)
	end
end
function c100274203.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,100274203)>0
end
function c100274203.xyzfilter1(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x114a) and c:IsCanOverlay()
end
function c100274203.xyzfilter2(c)
	return c:IsCode(41418852) and c:IsCanOverlay()
end
function c100274203.xyzfilter3(c,e,tp)
	return c:IsCode(100274201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c100274203.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c100274203.xyzfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingTarget(c100274203.xyzfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,4,nil)
		and Duel.IsExistingMatchingCard(c100274203.xyzfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg1=Duel.SelectTarget(tp,c100274203.xyzfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg2=Duel.SelectTarget(tp,c100274203.xyzfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100274203.mtfilter(c,e)
	return c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c100274203.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c100274203.xyzfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=sg:GetFirst()
	if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(10000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetValue(1000)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		sc:RegisterEffect(e2)
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local g=tg:Filter(c100274203.mtfilter,nil,e)
		local tc=g:GetFirst()
		while tc do
			Duel.Overlay(sc,Group.FromCards(tc))
			tc=g:GetNext()
		end
	end
	Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetLabel(c100274203.getsummoncount(tp))
	e1:SetTarget(c100274203.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetLabel(c100274203.getsummoncount(tp))
	e3:SetValue(c100274203.countval)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c100274203.getsummoncount(tp)
	return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
end
function c100274203.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c100274203.getsummoncount(sump)>e:GetLabel()
end
function c100274203.countval(e,re,tp)
	if c100274203.getsummoncount(tp)>e:GetLabel() then return 0 else return 1 end
end
