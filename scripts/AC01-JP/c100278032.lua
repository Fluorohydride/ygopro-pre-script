--ヌメロン・ストーム
--Numeron Storm
function c100278032.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100278032.descon)
	e1:SetTarget(c100278032.destg)
	e1:SetOperation(c100278032.desop)
	c:RegisterEffect(e1)
end
function c100278032.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x268)
end
function c100278032.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100278032.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100278032.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100278032.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c100278032.desfilter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c100278032.desfilter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c100278032.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c100278032.desfilter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if Duel.Destroy(sg,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
