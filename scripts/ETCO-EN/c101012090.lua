--Pride of the Plunder Patroll
--
--Script by JoyJ
function c101012090.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012090,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,101012090)
	e1:SetCondition(c101012090.drcon)
	e1:SetTarget(c101012090.drtg)
	e1:SetOperation(c101012090.drop)
	c:RegisterEffect(e1)
	--hand to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101012090,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101012090+100)
	e2:SetCondition(c101012090.tgcond)
	e2:SetCost(c101012090.tgcost)
	e2:SetTarget(c101012090.tgtg)
	e2:SetOperation(c101012090.tgop)
	c:RegisterEffect(e2)
	--extra to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101012090,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101012090+100)
	e3:SetCondition(c101012090.tgcond)
	e3:SetCost(c101012090.tgcost)
	e3:SetTarget(c101012090.tgtg2)
	e3:SetOperation(c101012090.tgop2)
	c:RegisterEffect(e3)
end
function c101012090.drcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then return end
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsSetCard(0x13f) and rc:IsControler(tp)
end
function c101012090.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101012090.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101012090.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x13f)
end
function c101012090.tgcond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
		and Duel.IsExistingMatchingCard(c101012090.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101012090.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101012090.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c101012090.tgfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c101012090.tgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		local sg=g:Filter(c101012090.tgfilter1,nil)
		Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_TOGRAVE)
		local tg=sg:Select(1-p,1,1,nil)
		if tg:GetCount()>0 then
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
		Duel.ShuffleHand(p)
	end
end
function c101012090.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,1-tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c101012090.tgop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	local tg=g:Filter(Card.IsAbleToGrave,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	Duel.ShuffleExtra(1-tp)
end
