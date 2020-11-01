--デュアルアバター - エンパワードミギョ
--小花ソノガミ
function c284224.initial_effect(c)
	--フュージョン召喚
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11759079,aux.FilterBoolFunction(Card.IsFusionSetCard,0x14f),2,true,false)
	--最初に破壊されない
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c284224.indtg)
	e1:SetValue(c284224.indct)
	c:RegisterEffect(e1)
	--すべての呪文/トラップを返す
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(284224,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetCondition(c284224.thcon)
	e2:SetTarget(c284224.thtg)
	e2:SetOperation(c284224.thop)
	c:RegisterEffect(e2)
	--破壊
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,284224)
	e3:SetCondition(c284224.descon)
	e3:SetTarget(c284224.destg)
	e3:SetOperation(c284224.desop)
	c:RegisterEffect(e3)
end
--初回は破壊されない
function c284224.indtg(e,c)
	return c:IsFaceup() and c:IsType(0x14f) and c:IsType(TYPE_FUSION)
end
function c284224.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
--すべてを拭く
function c284224.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c284224.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c284224.thfilter,tp,0,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c284224.thfilter,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c284224.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c284224.thfilter,tp,0,LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
--破壊された
function c284224.desfilter(c)
	return c:IsFaceup and c:IsType(TYPE_FUSION)
end
function c284224.descon(e)
	return Duel.IsExistingMatchingCard(c284224.desfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
		and ep==1-tp and re:GetHandler():IsOnField() and re:IsActiveType(TYPE_MONSTER) 
end
function c284224.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c284224.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
