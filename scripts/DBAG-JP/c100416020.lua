--シドレミコード・ビューティア

--scripted by Xylen5967
function c100416020.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c100416020.actcon)
	e1:SetOperation(c100416020.actop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100416020,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100416020)
	e2:SetTarget(c100416020.rmtg)
	e2:SetOperation(c100416020.rmop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100416020,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCountLimit(1)
	e3:SetTarget(c100416020.destg)
	e3:SetOperation(c100416020.desop)
	c:RegisterEffect(e3)
end
function c100416020.actcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsSetCard(0x265)
end
function c100416020.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c100416020.chlimit)
end
function c100416020.chlimit(e,ep,tp)
	return tp==ep
end
function c100416020.rfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100416020.rfilter2(c)
	return c:IsType(TYPE_EFFECT) 
end
function c100416020.pfilter(c) 
	if not c:IsType(TYPE_PENDULUM) then return false end
	return (c:GetLeftScale()%2==0 or c:GetRightScale()%2==0)
end
function c100416020.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c100416020.rfilter2,tp,0,LOCATION_MZONE,1,nil) end
	if Duel.IsExistingMatchingCard(c100416020.pfilter,tp,LOCATION_PZONE,0,1,nil)
		and Duel.IsExistingTarget(c100416020.rfilter1,tp,0,LOCATION_SZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100416020,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c100416020.rfilter1,tp,0,LOCATION_SZONE,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c100416020.rfilter2,tp,0,LOCATION_MZONE,1,1,nil)
	end
end
function c100416020.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	end
end
function c100416020.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local p1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local p2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local sp1=0
	local sp2=0
	local sp1=p1 and p1:GetLeftScale() or -1
	local sp2=p2 and p2:GetRightScale() or -1
	local atk=math.max(sp1,sp2)
	local bc=Duel.GetAttackTarget()
	if chk==0 then return atk>0 and Duel.GetAttacker()==c
		and bc and bc:IsFaceup() and bc:IsAttackAbove(atk*300) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c100416020.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
