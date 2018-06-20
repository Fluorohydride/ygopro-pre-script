--超雷龍－サンダー・ドラゴン
--Superbolt Thunder Dragon
--Script by dest
function c101006036.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,31786629,aux.FilterBoolFunction(Card.IsRace,RACE_THUNDER),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c101006036.spcon)
	e2:SetOperation(c101006036.spop)
	c:RegisterEffect(e2)
	--disable search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_DECK)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c101006036.reptg)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(101006036,ACTIVITY_CHAIN,c101006036.chainfilter)
end
function c101006036.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_THUNDER) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND)
end
function c101006036.spfilter(c,fc,tp)
	return c:IsRace(RACE_THUNDER) and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_FUSION)
		and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c,fc)>0
end
function c101006036.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCustomActivityCount(101006036,tp,ACTIVITY_CHAIN)~=0
		and Duel.CheckReleaseGroup(tp,c101006036.spfilter,1,nil,c,fc,tp)
end
function c101006036.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c101006036.spfilter,1,1,nil,c,fc,tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c101006036.repfilter(c)
	return c:IsRace(RACE_THUNDER) and c:IsAbleToRemove()
end
function c101006036.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c101006036.repfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c101006036.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
