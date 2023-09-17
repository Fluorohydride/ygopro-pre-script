--öÍΩYΩÁ§À÷¡§Îæß”Ú
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(s.chainop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.tdcon)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(s.descon)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and rc:IsSetCard(0x2f) then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2f) and (c:IsAbleToHand() or c:IsAbleToDeck())
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local res=false
	if g1:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and g1:IsAbleToDeck() then
		if Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 then
			res=true
		end
	elseif g1:IsType(TYPE_TOKEN) then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
	elseif g1:IsAbleToHand() and (not g1:IsAbleToDeck() or Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
		if Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,g1)~=0 then
			res=true
		end
	else
		if Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
			res=true
		end
	end
	if res==true and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.BreakEffect()
		local g2=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoDeck(g2,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
function s.sfilter(c)
	return c:IsSetCard(0x2f) and c:IsFacedown()
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetClassCount(Card.GetCode)<3 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.ConfirmCards(1-tp,sg)
	else Duel.Destroy(c,REASON_EFFECT) end
end