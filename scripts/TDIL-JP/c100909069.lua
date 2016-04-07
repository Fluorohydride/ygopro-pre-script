--融合死円舞曲
--Fusion Doom Waltz
--Script by mercury233
function c100909069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100909069.target)
	e1:SetOperation(c100909069.activate)
	c:RegisterEffect(e1)
end
function c100909069.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0xad)
end
function c100909069.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c100909069.filter3(c,ex2)
	return c~=ex2 and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsDestructable()
end
function c100909069.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c100909069.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c100909069.filter2,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c100909069.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,3,nil,nil) end
	local g1=Duel.SelectTarget(tp,c100909069.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	local g2=Duel.SelectTarget(tp,c100909069.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	local g3=Duel.GetMatchingGroup(c100909069.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,g1:GetFirst(),g2:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g3,g3:GetCount(),0,0)
	local dam=g3:GetSum(Card.GetAttack)
	if g3:FilterCount(Card.IsControler,nil,tp)>0 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,dam) end
	if g3:FilterCount(Card.IsControler,nil,1-tp)>0 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam) end
end
function c100909069.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	local dam=tc1:GetAttack()+tc2:GetAttack()
	local g=Duel.GetMatchingGroup(c100909069.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,tc1,tc2)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local dg=Duel.GetOperatedGroup()
		if dg:IsExists(aux.FilterEqualFunction(Card.GetPreviousControler,tp),1,nil) then Duel.Damage(tp,dam,REASON_EFFECT) end
		if dg:IsExists(aux.FilterEqualFunction(Card.GetPreviousControler,1-tp),1,nil) then Duel.Damage(1-tp,dam,REASON_EFFECT) end
	end
end
