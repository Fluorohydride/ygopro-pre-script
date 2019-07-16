--氷の王 ニードヘッグ

--Scripted by nekrozar
function c100413031.initial_effect(c)
	c:SetUniqueOnField(1,0,100413031)
	--disable special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100413031,0))
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100413031)
	e5:SetCondition(c100413031.discon)
	e5:SetCost(c100413031.discost)
	e5:SetTarget(c100413031.distg)
	e5:SetOperation(c100413031.disop)
	c:RegisterEffect(e5)
end
function c100413031.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c100413031.costfilter(c)
	return c:IsSetCard(0x232) or c:IsRace(RACE_WYRM)
end
function c100413031.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100413031.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c100413031.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c100413031.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c100413031.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
