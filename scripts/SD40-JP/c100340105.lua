--三叉龙的鼓动
function c100340105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100340105)
	e1:SetTarget(c100340105.target)
	e1:SetOperation(c100340105.activate)
	c:RegisterEffect(e1) 
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100340205)
	e2:SetCondition(c100340105.discon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c100340105.disop)
	c:RegisterEffect(e2)
end
function c100340105.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2f) and c:IsType(TYPE_SYNCHRO)
end
function c100340105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c100340105.cfilter,tp,LOCATION_MZONE,0,1,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,nil)
	if chk==0 then return g1:GetClassCount(Card.GetCode)>=1 and g2:GetCount()>0 end
end
function c100340105.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c100340105.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
	if ct>2 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 then
			local sg=g:RandomSelect(tp,1)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c100340105.tfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp) and c:IsSetCard(0x2f) and c:IsType(TYPE_SYNCHRO)
end
function c100340105.discon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c100340105.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c100340105.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end