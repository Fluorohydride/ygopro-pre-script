--影依の炎核 ヴォイド
--
--Script by 龙骑
function c100270202.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100270202,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100270202)
	e1:SetCost(c100270202.cost)
	e1:SetTarget(c100270202.target)
	e1:SetOperation(c100270202.operation)
	c:RegisterEffect(e1)
	--SendtoGrave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100270202,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,100270202)
	e2:SetCost(c100270202.cost)
	e2:SetTarget(c100270202.tgtg)
	e2:SetOperation(c100270202.tgop)
	c:RegisterEffect(e2)
end
function c100270202.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c100270202.cfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c100270202.tgfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute())
end
function c100270202.tgfilter(c,att)
	return c:IsAbleToGrave() and c:GetAttribute()==att and c:IsSetCard(0x9d)
end
function c100270202.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100270202.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100270202.cfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100270202.cfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c100270202.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local att=tc:GetOriginalAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c100270202.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,att)
		if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c100270202.ctfilter(c)
	return c:IsFaceup()
end
function c100270202.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(c100270202.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetClassCount(Card.GetAttribute)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c100270202.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.DiscardDeck(tp,e:GetLabel(),REASON_EFFECT)
end