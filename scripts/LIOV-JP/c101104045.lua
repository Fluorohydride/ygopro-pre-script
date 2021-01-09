--ダークインファント@イグニスター

--Scripted by mallu11
function c101104045.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c101104045.mfilter,1,1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104045,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101104045)
	e1:SetCondition(c101104045.thcon)
	e1:SetTarget(c101104045.thtg)
	e1:SetOperation(c101104045.thop)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101104045,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101104145)
	e2:SetCondition(c101104045.seqcon)
	e2:SetTarget(c101104045.seqtg)
	e2:SetOperation(c101104045.seqop)
	c:RegisterEffect(e2)
end
function c101104045.mfilter(c)
	return not c:IsLinkType(TYPE_LINK) and c:IsLinkSetCard(0x135)
end
function c101104045.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101104045.thfilter(c)
	return c:IsCode(59054773) and c:IsAbleToHand()
end
function c101104045.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101104045.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101104045.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101104045.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101104045.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:GetBaseAttack()==2300 and rc:IsRace(RACE_CYBERSE)
end
function c101104045.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=bit.band(e:GetHandler():GetLinkedZone(),0x1f)
		return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0,zone)>0
	end
end
function c101104045.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup() and c:IsControler(tp)) then return end
	local zone=bit.band(e:GetHandler():GetLinkedZone(),0x1f)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local flag=bit.bxor(zone,0xff)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	if c:GetSequence()==nseq and Duel.SelectYesNo(tp,aux.Stringid(101104045,2)) then
		Duel.BreakEffect()
		local attr=Duel.AnnounceAttribute(tp,1,0xff-c:GetAttribute())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(attr)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
