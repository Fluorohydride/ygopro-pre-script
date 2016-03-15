--オッドアイズ・ミラージュ・ドラゴン
--Odd-Eyes Mirage Dragon
--Script by mercury233
function c100206001.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100206001,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100206001)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100206001.indcon)
	e1:SetTarget(c100206001.indtg)
	e1:SetOperation(c100206001.indop)
	c:RegisterEffect(e1)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100206001.pencon)
	e2:SetTarget(c100206001.pentg)
	e2:SetOperation(c100206001.penop)
	c:RegisterEffect(e2)
end
function c100206001.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x99)
end
function c100206001.indcon(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return (tc1 and tc1:IsSetCard(0x99)) or (tc2 and tc2:IsSetCard(0x99))
end
function c100206001.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100206001.indfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100206001.indfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100206001.indfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100206001.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetValue(c100206001.valcon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c100206001.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c100206001.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0x99) and c:IsType(TYPE_PENDULUM)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
end
function c100206001.desfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c100206001.penfilter(c)
	return c:IsSetCard(0x99) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsCode(100206001) and not c:IsForbidden()
end
function c100206001.pencon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100206001.cfilter,1,nil,tp)
end
function c100206001.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100206001.desfilter,tp,LOCATION_SZONE,0,nil)
	if chk==0 then return g:GetCount()>0
		and Duel.IsExistingMatchingCard(c100206001.penfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100206001.penop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c100206001.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.HintSelection(g)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c100206001.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
