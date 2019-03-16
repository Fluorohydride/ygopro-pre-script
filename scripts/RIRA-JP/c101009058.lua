--天威無崩の地
--
--scripted by JoyJ
function c101009058.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--immune effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c101009058.etarget)
	e2:SetValue(c101009058.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101009058.drcon)
	e3:SetTarget(c101009058.drtg)
	e3:SetOperation(c101009058.drop)
	c:RegisterEffect(e3)
end
function c101009058.etarget(e,c)
	return not c:IsType(TYPE_EFFECT)
end
function c101009058.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER)
end
function c101009058.drfilter1(c)
	return not c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c101009058.drfilter2(c,tp)
	return c:IsType(TYPE_EFFECT) and c:GetSummonPlayer()==1-tp and c:IsFaceup()
end
function c101009058.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101009058.drfilter1,tp,LOCATION_MZONE,0,1,nil)
		and eg:IsExists(c101009058.drfilter2,1,nil,tp)
end
function c101009058.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101009058.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
