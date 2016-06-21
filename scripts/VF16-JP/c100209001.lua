--EMレ・ベルマン
--Performapal Le-Bellman
--Script by mercury233
function c100209001.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--level up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100209001,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c100209001.lvtg)
	e1:SetOperation(c100209001.lvop)
	c:RegisterEffect(e1)
	--level change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100209001,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c100209001.target)
	e2:SetOperation(c100209001.operation)
	c:RegisterEffect(e2)
end
function c100209001.lvfilter(c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)~=0 and c:GetLevel()>0
end
function c100209001.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100209001.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c100209001.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c100209001.lvfilter,tp,LOCATION_MZONE,0,nil)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0xfe0000)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end
function c100209001.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9f) and c:GetLevel()>0
end
function c100209001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc~=c and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100209001.filter(chkc) end
	if chk==0 then return c:GetLevel()>1
		and Duel.IsExistingTarget(c100209001.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100209001.filter,tp,LOCATION_MZONE,0,1,1,c)
	local t={}
	local i=1
	local p=c:GetLevel()-1
	p=math.min(p,5)
	for i=1,p do
		t[i]=i
	end
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c100209001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:GetLevel()>1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-lv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_LEVEL)
			e2:SetValue(lv)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
