--Valkyrie Funfte
--
--Script by Real_Scl
function c101008086.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x122))
	e1:SetValue(c101008086.val)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101008086,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101008086)
	e2:SetCondition(c101008086.tgcon)
	e2:SetTarget(c101008086.tgtg)
	e2:SetOperation(c101008086.tgop)
	c:RegisterEffect(e2)
end
function c101008086.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c101008086.val(e,c)
	return Duel.GetMatchingGroupCount(c101008086.atkfilter,e:GetHandlerPlayer(),0,LOCATION_REMOVED,nil)*200
end
function c101008086.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x122) and not c:IsCode(101008086)
end
function c101008086.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101008086.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101008086.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c101008086.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101008086.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101008086.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101008086.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
