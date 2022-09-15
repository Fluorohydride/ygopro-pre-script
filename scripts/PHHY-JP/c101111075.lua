--六世壊根清净
--Script by 奥克斯
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--xyzmat to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x189) and c:IsType(TYPE_XYZ)
end
function s.condition(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local b1=#g1>1 and g1:IsExists(Card.IsAbleToRemove,1,nil,tp,POS_FACEDOWN,REASON_RULE)
	local b2=#g2>1 and g2:IsExists(Card.IsAbleToRemove,1,nil,tp,POS_FACEDOWN,REASON_RULE)
	if chk==0 then return Duel.IsPlayerCanRemove(tp) and (b1 or b2) end
	local g3=g1+g2
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g3,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanRemove(tp) then return end
	local g1=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local b1=#g1>1 and g1:IsExists(Card.IsAbleToRemove,1,nil,tp,POS_FACEDOWN,REASON_RULE)
	local b2=#g2>1 and g2:IsExists(Card.IsAbleToRemove,1,nil,tp,POS_FACEDOWN,REASON_RULE)
	if b1 then
		local ct=#g1-1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g1:FilterSelect(tp,Card.IsAbleToRemove,ct,ct,nil,tp,POS_FACEDOWN,REASON_RULE)
		Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
	end
	if b2 then
		local ct=#g2-1
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g2:FilterSelect(1-tp,Card.IsAbleToRemove,ct,ct,nil,tp,POS_FACEDOWN,REASON_RULE)
		Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
	end
end

function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x189) 
		and c:IsAbleToHand() 
end
function s.xfilter(c)
	local mg=c:GetOverlayGroup():Filter(s.thfilter,nil)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x189)
		and #mg>0 
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.xfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.xfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local mg=tc:GetOverlayGroup():Filter(s.thfilter,nil)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and #mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		Duel.ShuffleHand(tp)
		local bc=mg:Select(tp,1,1,nil):GetFirst()
		if Duel.SendtoHand(bc,nil,REASON_EFFECT)>0 
			and bc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,bc)
			Duel.ShuffleHand(tp)
			if bc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.SpecialSummon(bc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end