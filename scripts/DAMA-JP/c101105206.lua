--スターダスト・イルミネイト

--scripted by Xylen5967
function c101105206.initial_effect(c)
	aux.AddCodeList(c,44508094)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101105206)
	e1:SetTarget(c101105206.target)
	e1:SetOperation(c101105206.activate)
	c:RegisterEffect(e1)
	--increase / decrease
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105206,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101105206+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101105206.lvltg)
	e2:SetOperation(c101105206.lvlop)
	c:RegisterEffect(e2)
end
function c101105206.tgfilter(c,check)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa3)
		and (c:IsAbleToGrave() or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c101105206.cfilter(c)
	return c:IsFaceup() and (c:IsCode(44508094) or c:IsType(TYPE_SYNCHRO) and aux.IsCodeListed(c,44508094))
end
function c101105206.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.IsExistingMatchingCard(c101105206.cfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		return Duel.IsExistingMatchingCard(c101105206.tgfilter,tp,LOCATION_DECK,0,1,nil,check)
	end
end
function c101105206.activate(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsExistingMatchingCard(c101105206.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c101105206.tgfilter,tp,LOCATION_DECK,0,1,1,nil,check)
	local tc=g:GetFirst()
	if tc then
		if check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1191,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
function c101105206.lvlfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa3) and c:IsLevelAbove(0)
end
function c101105206.lvltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101105206.lvlfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101105206.lvlfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,c101105206.lvlfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101105206.lvlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local opt=0
		if tc:IsLevel(1) then
			opt=Duel.SelectOption(tp,aux.Stringid(101105206,1))
		else
			opt=Duel.SelectOption(tp,aux.Stringid(101105206,1),aux.Stringid(101105206,2))
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		if opt==0 then
			e1:SetValue(1)
		else
			e1:SetValue(-1)
		end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
