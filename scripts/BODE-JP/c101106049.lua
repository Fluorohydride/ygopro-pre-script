--空母軍貫－しらうお型特務艦
--scripted by XyLeN
function c101106049.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--apply the effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106049,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101106049)
	e1:SetCondition(c101106049.effcon)
	e1:SetTarget(c101106049.efftg)
	e1:SetOperation(c101106049.effop)
	c:RegisterEffect(e1)
	--protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c101106049.indescon)
	e2:SetTarget(c101106049.indestg)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c101106049.atkval)
	c:RegisterEffect(e3)
end
function c101106049.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c101106049.thfilter(c)
	return c:IsSetCard(0x166) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c101106049.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local chk1=c:GetMaterial():FilterCount(Card.IsCode,nil,24639891)>0
	local chk2=c:GetMaterial():FilterCount(Card.IsCode,nil,101106023)>0
	if chk==0 then return chk1 and Duel.IsPlayerCanDraw(tp,1)
		or chk2 and Duel.IsExistingMatchingCard(c101106049.thfilter,tp,LOCATION_DECK,0,1,nil) end
	e:SetCategory(0)
	if chk1 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if chk2 then
		e:SetCategory(e:GetCategory()|(CATEGORY_TOHAND+CATEGORY_SEARCH))
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c101106049.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chk1=c:GetMaterial():FilterCount(Card.IsCode,nil,24639891)>0
	local chk2=c:GetMaterial():FilterCount(Card.IsCode,nil,101106023)>0
	if chk1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if chk2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101106049.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c101106049.indescon(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c101106049.indestg(e,c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSetCard(0x166)
end
function c101106049.atkval(e,c)
	return c:GetBaseDefense()
end
