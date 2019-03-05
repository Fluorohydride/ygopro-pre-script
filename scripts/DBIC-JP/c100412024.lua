--ウィッチクラフト・バイストリート
--
--Scripted By-FW空鸽
function c100412024.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c100412024.target)
	e1:SetValue(c100412024.indct)
	c:RegisterEffect(e1)
	--ep set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100412024,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100412024)
	e2:SetCondition(c100412024.setcon)
	e2:SetTarget(c100412024.settg)
	e2:SetOperation(c100412024.setop)
	c:RegisterEffect(e2)
	--change cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(100412024)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,100412024)
	c:RegisterEffect(e3)
end
function c100412024.target(e,c)
	return c:IsSetCard(0x228)
end
function c100412024.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c100412024.rccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x228)
end
function c100412024.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.IsExistingMatchingCard(c100412024.rccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100412024.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c100412024.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
