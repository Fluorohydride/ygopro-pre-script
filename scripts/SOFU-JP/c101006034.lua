--サイバース・クロック・ドラゴン
--Cyberse Clock Dragon
--Script by dest
function c101006034.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,101006001,aux.FilterBoolFunction(Card.IsFusionType,TYPE_LINK),1,63,true,true)
	--mill + atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101006034,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101006034.atkcon)
	e1:SetTarget(c101006034.atktg)
	e1:SetOperation(c101006034.atkop)
	c:RegisterEffect(e1)
	--target/atk protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(c101006034.atcon)
	e2:SetValue(c101006034.atlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c101006034.atcon)
	e3:SetTarget(c101006034.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101006034,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c101006034.thcon)
	e4:SetTarget(c101006034.thtg)
	e4:SetOperation(c101006034.thop)
	c:RegisterEffect(e4)
end
function c101006034.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101006034.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial():Filter(Card.IsType,nil,TYPE_LINK)
	local ct=0
	for tc in aux.Next(mg) do
		ct=ct+tc:GetLink()
	end
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c101006034.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.DiscardDeck(tp,e:GetLabel(),REASON_EFFECT)~=0 then
		local ct=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetCount()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c101006034.ftarget)
		e1:SetLabel(c:GetFieldID())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e1)
		end
	end
end
function c101006034.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c101006034.atcon(e)
	return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_LINK)
end
function c101006034.atlimit(e,c)
	return c~=e:GetHandler()
end
function c101006034.tglimit(e,c)
	return c~=e:GetHandler()
end
function c101006034.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_EFFECT) and c:IsSummonType(SUMMON_TYPE_FUSION) and c:GetPreviousControler()==tp
end
function c101006034.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c101006034.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101006034.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101006034.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101006034.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
