--セイクリッド・カドケウス
--Constellar Caduceus
--Scripted by Gecko-chan
function c101103022.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103022,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101103022)
	e1:SetCondition(c101103022.spcon)
	e1:SetTarget(c101103022.sptg)
	e1:SetOperation(c101103022.spop)
	c:RegisterEffect(e1)
	--Search Spell/Trap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103022,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101103022+100)
	e2:SetTarget(c101103022.srtg)
	e2:SetOperation(c101103022.srop)
	c:RegisterEffect(e2)
	--Unclassified Effect as material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101103022,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetCondition(c101103022.mcon)
	e3:SetTarget(c101103022.mtg)
	e3:SetOperation(c101103022.mop)
	c:RegisterEffect(e3)
end
--Modified from Bluebeard, the Plunder Patroll Shipwright
function c101103022.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x53) and not c:IsCode(101103022)
end
function c101103022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101103022.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101103022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101103022.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--Modified from Nemeses Flag
function c101103022.srfilter(c)
	return c:IsSetCard(0x53) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c101103022.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101103022.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101103022.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101103022.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Modified from Gagaga Magician and Supreme King Dragon Clear Wing
function c101103022.mcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsSetCard(0x53) and c:IsType(TYPE_XYZ) and c:IsRelateToBattle() and bc and bc:IsFaceup()
		and bc:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and bc:IsRelateToBattle()
end
function c101103022.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc and bc:IsRelateToBattle() and bc:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function c101103022.mop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
