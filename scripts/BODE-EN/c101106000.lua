--Heritage of the Light
--script by Raye
function c101106000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106000,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101106000)
	e2:SetCondition(c101106000.drcon)
	e2:SetTarget(c101106000.drtg)
	e2:SetOperation(c101106000.drop)
	c:RegisterEffect(e2)
end
function c101106000.typfilter(c,sumtype) 
	return c:IsFaceup() and c:GetType()&sumtype>0
end
function c101106000.cfilter(c,tp)
	local sumtype=bit.band(c:GetType(),TYPE_RITUAL|TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ)
	return c:IsFaceup()
		and (c:IsSummonType(SUMMON_TYPE_RITUAL) or c:IsSummonType(SUMMON_TYPE_FUSION)
			or c:IsSummonType(SUMMON_TYPE_SYNCHRO) or c:IsSummonType(SUMMON_TYPE_XYZ))
		and Duel.IsExistingMatchingCard(c101106000.typfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,sumtype)
end
function c101106000.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101106000.cfilter,1,nil,tp)
end
function c101106000.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101106000.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
