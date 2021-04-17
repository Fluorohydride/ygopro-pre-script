--LL－バード・サンクチュアリ

--Scripted by mallu11
function c100425039.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--overlay
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100425039,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,100425039)
	e1:SetTarget(c100425039.target)
	e1:SetOperation(c100425039.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100425039,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100425139)
	e2:SetCondition(c100425039.drcon)
	e2:SetTarget(c100425039.drtg)
	e2:SetOperation(c100425039.drop)
	c:RegisterEffect(e2)
end
function c100425039.ovfilter(c,e)
	return c:IsFaceup() and c:IsRace(RACE_WINDBEAST) and c:IsType(TYPE_XYZ) and c:IsCanBeEffectTarget(e)
end
function c100425039.fselect(g)
	return g:IsExists(Card.IsCanOverlay,1,nil)
end
function c100425039.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c100425039.ovfilter,tp,LOCATION_MZONE,0,nil,e)
	if chkc then return false end
	if chk==0 then return g:CheckSubGroup(c100425039.fselect,2,2) end
	local sg=g:SelectSubGroup(tp,c100425039.fselect,false,2,2)
	Duel.SetTargetCard(sg)
end
function c100425039.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local c1=g:GetFirst()
	local c2=g:GetNext()
	if not c1:IsRelateToEffect(e) or not c2:IsRelateToEffect(e) then return end
	if c1:IsImmuneToEffect(e) or c2:IsImmuneToEffect(e) then return end
	local b1=c1:IsCanOverlay()
	local b2=c2:IsCanOverlay()
	if not b1 and not b2 then return end
	if not (b1 and b2) then
		if not b1 and b2 then
			c1,c2=c2,c1
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		c1=g:Select(tp,1,1,nil):GetFirst()
		c2=g:Filter(aux.TRUE,c1):GetFirst()
	end
	local mg=c1:GetOverlayGroup()
	if mg:GetCount()>0 then Duel.Overlay(c2,mg) end
	Duel.Overlay(c2,Group.FromCards(c1))
end
function c100425039.drfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>=3
end
function c100425039.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100425039.drfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100425039.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100425039.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
