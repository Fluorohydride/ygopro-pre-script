--剛鬼ザ・パワーロード・オーガ

--Scripted by mallu11
function c101012053.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WARRIOR),2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101012053.atkval)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101012053.imcon)
	e2:SetValue(c101012053.efilter)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101012053,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101012053)
	e3:SetCost(c101012053.descost)
	e3:SetTarget(c101012053.destg)
	e3:SetOperation(c101012053.desop)
	c:RegisterEffect(e3)
end
function c101012053.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c101012053.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c101012053.atkfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	return g:GetSum(Card.GetLink)*200
end
function c101012053.imcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101012053.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c101012053.rfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfc) and c:IsType(TYPE_LINK) and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c101012053.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101012053.rfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c101012053.rfilter,1,1,nil)
	e:SetLabel(g:GetFirst():GetLink())
	Duel.Release(g,REASON_COST)
end
function c101012053.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	local ct=e:GetLabel()
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101012053.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
