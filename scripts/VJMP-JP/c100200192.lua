--プロキシー・ホース

--Scripted by mallu11
function c100200192.initial_effect(c)
	--extra hand link
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100200192,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_CYBERSE))
	e1:SetCountLimit(1,100200192)
	e1:SetValue(c100200192.matval)
	c:RegisterEffect(e1)
	--to extra deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100200192,1))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100200292)
	e2:SetCondition(c100200192.tdcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100200192.tdtg)
	e2:SetOperation(c100200192.tdop)
	c:RegisterEffect(e2)
end
function c100200192.matval(e,lc,mg,c,tp)
	if not lc:IsRace(RACE_CYBERSE) then return false,nil end
	return true,not mg or mg:IsContains(e:GetHandler()) and not mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND)
end
function c100200192.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100200192.tdfilter(c,e)
	return c:IsType(TYPE_LINK) and c:IsAbleToExtra() and c:IsCanBeEffectTarget(e)
end
function c100200192.fselect(g)
	return g:IsExists(Card.IsRace,1,nil,RACE_CYBERSE)
end
function c100200192.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c100200192.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e)
	if chk==0 then return g1:CheckSubGroup(c100200192.fselect,2,2) end
	local g2=Duel.GetMatchingGroup(c100200192.tdfilter,tp,LOCATION_GRAVE,0,nil,e)
	local sg=g2:SelectSubGroup(tp,c100200192.fselect,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,sg,2,0,0)
end
function c100200192.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
