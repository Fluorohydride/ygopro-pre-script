--Pride of the Plunder Patroll
--
--Script by JoyJ
function c101012090.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012090,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,101012090)
	e1:SetCondition(c101012090.drtg)
	e1:SetOperation(c101012090.drop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101012090,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101012090+100)
	e2:SetCondition(c101012090.spcond)
	e2:SetCost(c101012090.spcost)
	e2:SetTarget(c101012090.sptg)
	e2:SetOperation(c101012090.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101012090,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101012090+100)
	e3:SetCondition(c101012090.spcond)
	e3:SetCost(c101012090.spcost)
	e3:SetTarget(c101012090.sptg2)
	e3:SetOperation(c101012090.spop2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,101012090+200)
	c:RegisterEffect(e4)
end
function c101012090.spcond(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x13f)
end
function c101012090.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,1-tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c101012090.disfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c101012090.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,tg)
	tg=tg:Filter(Card.IsAbleToGrave,nil)
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c101012090.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101012090.spfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_GRAVE,0,1,nil,c:GetAttribute())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c101012090.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,1-tp,1)
end
function c101012090.disfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c101012090.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_DISCARD)
		local sg=g:Filter(c101012090.disfilter2,nil)
		sg=g:Select(1-p,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(p)
	end
end
function c101012090.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsSetCard(0x13f) and rc:IsControler(tp)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101012090.rcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect() then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
