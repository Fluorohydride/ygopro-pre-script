--F.A. Winners
--Scripted by Eerie Code
function c101004089.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101004089)
	e3:SetCondition(c101004089.rmcon)
	e3:SetTarget(c101004089.rmtg)
	e3:SetOperation(c101004089.rmop)
	c:RegisterEffect(e3)
end
function c101004089.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	if not d then return false end
	if not a:IsControler(tp) then a,d=d,a end
	return a:IsControler(tp) and a:IsSetCard(0x107)
		and a:GetLevel()-a:GetOriginalLevel()>=5
		and ep~=tp
end
function c101004089.rmfilter(c)
	return c:IsAbleToRemove() and (c:IsLocation(LOCATION_ONFIELD) or aux.SpElimFilter(c,false,true))
end
function c101004089.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101004089.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c101004089.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c101004089.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		tc:RegisterFlagEffect(101004089,RESET_EVENT+0x1fe0000,0,1)
		local g=Duel.GetMatchingGroup(c101004089.winfilter,tp,LOCATION_REMOVED,0,nil)
		if g:GetClassCount(Card.GetCode)>=3 then
			Duel.Win(tp,0x1d)
		end
	end
end
function c101004089.winfilter(c)
	return c:IsSetCard(0x107) and c:IsType(TYPE_FIELD) and c:GetFlagEffect(101004089)~=0
end
