--coded by Lyris
--Silenforcing Barrier
local s, id, o = GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--limit attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(s.alimit)
	c:RegisterEffect(e2)
	--cannot target
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.cfilter(c)
	return c:IsFaceup() and (c:IsCode(101203019) or c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_RITUAL)
		and c:IsLocation(LOCATION_MZONE))
end
function s.condition(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.alimit(e,c)
	return c:IsFacedown() or not c:IsType(TYPE_RITUAL)
end
function s.filter(c)
	return (c:IsSetCard(0x2a6) or c:IsSetCard(0x2052) and c:GetType()&0x81==0x81) and c:IsAbleToHand()
		and not c:IsCode(id)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
