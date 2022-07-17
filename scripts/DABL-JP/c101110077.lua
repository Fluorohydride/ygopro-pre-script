--Ninjitsu Art of Fallen Leaves' Dance
local s,id,o=GetID()
function s.initial_effect(c)
	--You can only use 1 "Ninjitsu Art of Fallen Leaves' Dance" effect per turn, and only once that turn.
	--Activate this card by targeting 1 "Ninja" monster or face-down Defense Position monster on the field; Tribute it, and if you do, Special Summon 1 "Ninja" monster from your Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--When this card leaves the field, send that monster to the GY.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--If this card is face-up: You can target 1 "Ninjitsu Art" Continuous Spell/Trap in your Spell & Trap Zone; return it to the hand.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCondition(function() return c:IsFaceup() end)
	e3:SetTarget(s.htg)
	e3:SetOperation(s.hop)
	c:RegisterEffect(e3)
end
function s.cfilter(c,tp)
	return (c:IsFaceup() and c:IsSetCard(0x2b) or c:IsPosition(POS_FACEDOWN_DEFENSE)) and c:IsReleasableByEffect()
		and Duel.GetMZoneCount(tp,c)>0
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x2b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToChain(0) and Duel.Release(tc,REASON_EFFECT)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then c:SetCardTarget(sc) end
	Duel.SpecialSummonComplete()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then Duel.SendtoGrave(tc,REASON_EFFECT) end
end
function s.hfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x61) and c:IsType(TYPE_CONTINUOUS) and c:GetSequence()<5
		and c:IsAbleToHand()
end
function s.htg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.hfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.hfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,Duel.SelectTarget(tp,s.hfilter,tp,LOCATION_SZONE,0,1,1,nil),1,0,0)
end
function s.hop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToChain(0) then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
end
