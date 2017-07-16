--トリックスター・ブラッディマリー
--Trickstar Bloody Mary
--Script by nekrozar
function c100209003.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfb),2,2)
	c:EnableReviveLimit()
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100209003.reccon)
	e1:SetOperation(c100209003.recop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100209003,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,100209003)
	e3:SetCost(c100209003.drcost)
	e3:SetTarget(c100209003.drtg)
	e3:SetOperation(c100209003.drop)
	c:RegisterEffect(e3)
end
function c100209003.cfilter(c,g)
	return c:IsSetCard(0xfb) and g:IsContains(c)
end
function c100209003.reccon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c100209003.cfilter,1,nil,lg)
end
function c100209003.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,100209003)
	Duel.Recover(tp,200,REASON_EFFECT)
end
function c100209003.costfilter(c)
	return c:IsDiscardable() and c:IsSetCard(0xfb)
end
function c100209003.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100209003.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c100209003.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c100209003.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=1
	if Duel.GetLP(tp)>=Duel.GetLP(1-tp)+2000 then ct=2 end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct)
		and Duel.IsPlayerCanDraw(1-tp,1) end
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c100209003.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
