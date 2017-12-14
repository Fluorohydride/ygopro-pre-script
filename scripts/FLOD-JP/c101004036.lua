--トポロジック・トゥリスバエナ
--Topologic Tulisbaena
--Scripted by Eerie Code
function c101004036.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101004036,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101004036.rmcon)
	e1:SetTarget(c101004036.rmtg)
	e1:SetOperation(c101004036.rmop)
	c:RegisterEffect(e1)
end
function c101004036.cfilter(c,g)
	return g:IsContains(c)
end
function c101004036.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c101004036.cfilter,1,nil,lg)
end
function c101004036.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c101004036.cfilter,nil,e:GetHandler():GetLinkedGroup())
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c101004036.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if not c:IsRelateToEffect(e) or not lg then return end
	local g=eg:Filter(c101004036.cfilter,nil,lg)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	g:Merge(g2)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsControler,nil,1-tp)
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
