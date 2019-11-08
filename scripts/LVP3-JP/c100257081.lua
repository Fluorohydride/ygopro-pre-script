--星鍵士リイヴ

--Scripted by mallu11
function c100257081.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(c100257081.spcost)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100257081,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100257081)
	e1:SetTarget(c100257081.sttg)
	e1:SetOperation(c100257081.stop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100257081,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100257181)
	e2:SetCondition(c100257081.tdcon)
	e2:SetTarget(c100257081.tdtg)
	e2:SetOperation(c100257081.tdop)
	c:RegisterEffect(e2)
end
function c100257081.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0xfe)
end
function c100257081.stfilter(c)
	return c:IsSetCard(0xfe) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100257081.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100257081.stfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c100257081.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c100257081.stfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetCondition(c100257081.aclimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c100257081.actfilter(c)
	return c:IsSetCard(0xfe) and c:IsType(TYPE_MONSTER)
end
function c100257081.aclimit(e)
	return not Duel.IsExistingMatchingCard(c100257081.actfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function c100257081.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and r==REASON_LINK and c:IsLocation(LOCATION_GRAVE)
end
function c100257081.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c100257081.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
