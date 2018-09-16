--魔女の一撃
--Witch's Strike
--Script by mercury233
function c101007079.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101007079,0))
	e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_SUMMON_NEGATED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c101007079.condition)
    e1:SetTarget(c101007079.target)
    e1:SetOperation(c101007079.activate)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_NEGATED)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_CUSTOM+101007079)
    c:RegisterEffect(e3)
	if not c101007079.global_check then
		c101007079.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetOperation(c101007079.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101007079.checkop(e,tp,eg,ep,ev,re,r,rp)
	local dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_PLAYER)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+101007079,e,0,dp,0,0)
end
function c101007079.condition(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp
end
function c101007079.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101007079.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
