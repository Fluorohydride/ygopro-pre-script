--双天将 密迹
--
--小花ソノガミ
function c101103041.initial_effect(c)
	--フュージョン召喚
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11759079,aux.FilterBoolFunction(Card.IsFusionSetCard,0x14f),2,true,true)
	--effect monster material check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c101103041.matcheck)
	c:RegisterEffect(e0)
	--最初に破壊されない
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c101103041.indtg)
	e1:SetValue(c101103041.indct)
	c:RegisterEffect(e1)
	--すべての呪文/トラップを返す
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103041,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c101103041.thtg)
	e2:SetOperation(c101103041.thop)
	c:RegisterEffect(e2)
	--破壊
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101103041)
	e3:SetCondition(c101103041.descon)
	e3:SetTarget(c101103041.destg)
	e3:SetOperation(c101103041.desop)
	c:RegisterEffect(e3)
end
function c101103041.matcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_EFFECT) then
		c:RegisterFlagEffect(85360035,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
	end
end
--初回は破壊されない
function c101103041.indtg(e,c)
	return c:IsType(0x14f) and c:IsType(TYPE_FUSION)
end
function c101103041.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
--すべてを拭く
function c101103041.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c101103041.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101103041.thfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c101103041.thfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c101103041.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101103041.thfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c101103041.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
--破壊された
function c101103041.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c101103041.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c101103041.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c101103041.desop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
