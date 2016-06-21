--次元障壁
--Dimension Barrier
--Script by dest
function c100910078.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1,100910078+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100910078.target)
	e1:SetOperation(c100910078.operation)
	c:RegisterEffect(e1)
end
function c100910078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	Duel.SetTargetParam(Duel.SelectOption(tp,1057,1056,1063,1073,1074))
end
function c100910078.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ct=nil
	if opt==0 then ct=TYPE_RITUAL end
	if opt==1 then
		ct=TYPE_FUSION
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(27581098)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e0:SetTargetRange(1,1)
		e0:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e0,tp)
	end
	if opt==2 then ct=TYPE_SYNCHRO end
	if opt==3 then ct=TYPE_XYZ end
	if opt==4 then ct=TYPE_PENDULUM end	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(ct)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c100910078.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c100910078.distg)
	e2:SetLabel(ct)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetOperation(c100910078.disop)
	e3:SetLabel(ct)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c100910078.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(e:GetLabel())
end
function c100910078.distg(e,c)
	return c:IsType(e:GetLabel())
end
function c100910078.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_MZONE and re:IsActiveType(e:GetLabel()) then
		Duel.NegateEffect(ev)
	end
end
