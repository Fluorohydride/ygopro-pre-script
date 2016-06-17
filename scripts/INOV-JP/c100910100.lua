--進化合獣ヒュードラゴン
--Advanced Chemical Beast Hy Dragon
--Script by dest
function c100910100.initial_effect(c)
	aux.EnableDualAttribute(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100910100,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(c100910100.target)
	e1:SetOperation(c100910100.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.IsDualState)
	e2:SetTarget(c100910100.reptg)
	e2:SetValue(c100910100.repval)
	e2:SetOperation(c100910100.repop)
	c:RegisterEffect(e2)
end
function c100910100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsType(TYPE_DUAL) and tc~=e:GetHandler() end
	Duel.SetTargetCard(tc)
end
function c100910100.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function c100910100.repfilter(c,tp,e)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsType(TYPE_DUAL) and c:IsReason(REASON_EFFECT) and c:GetFlagEffect(100910100)==0
end
function c100910100.desfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c100910100.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100910100.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
		and eg:IsExists(c100910100.repfilter,1,nil,tp,e) end
	if Duel.SelectYesNo(tp,aux.Stringid(100910100,1)) then
		local g=eg:Filter(c100910100.repfilter,nil,tp,e)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local tg=Duel.SelectMatchingCard(tp,c100910100.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		Duel.HintSelection(tg)
		Duel.SetTargetCard(tg)
		tg:GetFirst():RegisterFlagEffect(100910100,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
		tg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c100910100.repval(e,c)
	return c==e:GetLabelObject()
end
function c100910100.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
