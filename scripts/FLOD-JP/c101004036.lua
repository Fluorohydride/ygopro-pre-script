--トポロジック・トゥリスバエナ
--Topologic Tulisbaena
--Scripted by Eerie Code
function c101004036.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5821478,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101004036.rmcon)
	e1:SetTarget(c101004036.rmtg)
	e1:SetOperation(c101004036.rmop)
	c:RegisterEffect(e1)
end
function c101004036.cfilter(c,zone)
	local seq=c:GetSequence()
	if c:IsControler(1) then seq=seq+16 end
	return bit.extract(zone,seq)~=0
end
function c101004036.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c101004036.cfilter,1,nil,e:GetHandler():GetLinkedZone())
end
function c101004036.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c101004036.cfilter,1,nil,e:GetHandler():GetLinkedZone())
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c101004036.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=eg:Filter(c101004036.cfilter,1,nil,c:GetLinkedZone())
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	g:Merge(g2)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsControler,nil,1-tp)
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
