--翼の恩返し
--Script By JSY1728
function c100278016.initial_effect(c)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100278016+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100278016.drcon)
	e1:SetCost(c100278016.drcost)
	e1:SetTarget(c100278016.drtg)
	e1:SetOperation(c100278016.drop)
	c:RegisterEffect(e1)
end
function c100278016.cfilter(c,g)
	return c:IsFacedown() or not c:IsRace(RACE_WINDBEAST)
		or g:IsExists(Card.IsOriginalCodeRule,1,c,c:GetOriginalCodeRule())
end
function c100278016.drcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetCount()>=2 and not g:IsExists(c100278016.cfilter,1,nil,g)
end
function c100278016.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c100278016.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c100278016.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
