--深淵の獣アルベル
--Script by 奥克斯
function c101112008.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,68468459,LOCATION_MZONE+LOCATION_GRAVE)
	--control or special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101112008)
	e1:SetCost(c101112008.cost)
	e1:SetTarget(c101112008.tg)
	e1:SetOperation(c101112008.op)
	c:RegisterEffect(e1)
end
function c101112008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c101112008.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsControlerCanBeChanged()
end
function c101112008.filter2(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112008.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then
			return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101112008.filter1(chkc)
		else
			return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101112008.filter2(chkc,e,tp)
		end
	end
	local c=e:GetHandler()
	local b1=Duel.IsExistingTarget(c101112008.filter1,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(c101112008.filter2,tp,0,LOCATION_GRAVE,1,nil,e,tp) and Duel.GetMZoneCount(tp,c)>0
	if chk==0 then return c:IsAbleToGrave() and (b1 or b2) end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(101112008,0),aux.Stringid(101112008,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(101112008,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(101112008,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_CONTROL)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,c101112008.filter1,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c101112008.filter2,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
end
function c101112008.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if not c:IsRelateToEffect(e) or Duel.SendtoGrave(c,REASON_EFFECT)==0 then return false end
		if c:GetLocation()~=LOCATION_GRAVE or not tc:IsRelateToEffect(e) then return false end
		Duel.GetControl(tc,tp)
	else
		local tc=Duel.GetFirstTarget()
		if not c:IsRelateToEffect(e) or Duel.SendtoGrave(c,REASON_EFFECT)==0 then return false end
		if c:GetLocation()~=LOCATION_GRAVE or not tc:IsRelateToEffect(e) then return false end
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
