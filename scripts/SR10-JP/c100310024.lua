--機甲部隊の防衛圏

--Scripted by mallu11
function c100310024.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atk limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(c100310024.tgcon)
	e1:SetValue(c100310024.tgtg)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c100310024.tgcon)
	e2:SetTarget(c100310024.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100310024,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,100310024)
	e3:SetCondition(c100310024.thcon)
	e3:SetTarget(c100310024.thtg)
	e3:SetOperation(c100310024.thop)
	c:RegisterEffect(e3)
end
function c100310024.tgfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLevelAbove(7)
end
function c100310024.tgcon(e)
	return Duel.IsExistingMatchingCard(c100310024.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c100310024.tgtg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLevelBelow(6)
end
function c100310024.sfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
		and bit.band(c:GetPreviousRaceOnField(),RACE_MACHINE)~=0
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c100310024.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100310024.sfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c100310024.thfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function c100310024.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100310024.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100310024.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100310024.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100310024.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
