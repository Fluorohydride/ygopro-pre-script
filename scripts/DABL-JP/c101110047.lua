--Volo, the Doom-Originator Vassal Dragon
--Scripted by: XGlitchy30

function c101110047.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,6,2,nil,nil,99)
	--stat boost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c101110047.statval)
	c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1x)
	--quick effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110047,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101110047)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
	e2:SetTarget(c101110047.target)
	e2:SetOperation(c101110047.operation)
	c:RegisterEffect(e2)
end
function c101110047.statval(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)*100
end

function c101110047.filter(c,e,tp,chk1,chk2)
	return (chk1 and c:IsAbleToDeck()) or (chk2 and c101110047.tgcheck(c,e,tp))
end
function c101110047.tgcheck(c,e,tp)
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)
	else
		return c:IsSSetable(false,tp)
	end
end
function c101110047.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if not chkc:IsLocation(LOCATION_GRAVE) or not chkc:IsControler(1-tp) then return false end
		if e:GetLabel()==1 then
			return c101110047.filter(chkc,e,tp,true,false)
		elseif e:GetLabel()==2 then
			return c101110047.filter(chkc,e,tp,false,true)
		end
	end
	local c=e:GetHandler()
	local chk1, chk2 = c:CheckRemoveOverlayCard(tp,1,REASON_COST), c:CheckRemoveOverlayCard(tp,2,REASON_COST)
	if chk==0 then
		return (chk1 or chk2) and Duel.IsExistingTarget(c101110047.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp,chk1,chk2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101110047.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,chk1,chk2)
	if #g>0 then
		local tc=g:GetFirst()
		local b1 = chk1 and tc:IsAbleToDeck()
		local b2 = chk2 and c101110047.tgcheck(tc,e,tp)
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(101110047,1)
			opval[off]=0
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(101110047,2)
			opval[off]=1
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		e:SetLabel(sel)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(101110047,sel+1))
		if sel==0 then
			e:SetCategory(CATEGORY_TODECK)
			c:RemoveOverlayCard(tp,1,1,REASON_COST)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,tp,LOCATION_GRAVE)
		elseif sel==1 then
			if tc:IsType(TYPE_MONSTER) then
				e:SetCategory(CATEGORY_SPECIAL_SUMMON)
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,tp,LOCATION_GRAVE)
			else
				e:SetCategory(0)
				Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,tp,LOCATION_GRAVE)
			end
			c:RemoveOverlayCard(tp,2,2,REASON_COST)
		end
	end
end
function c101110047.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToChain(0) then return end
	local sel=e:GetLabel()
	if sel==0 then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	elseif sel==1 then
		if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)>0 and tc:IsLocation(LOCATION_MZONE) and tc:IsFacedown() then
				Duel.ConfirmCards(1-tp,tc)
			end
		elseif tc:IsSSetable() then
			Duel.SSet(tp,tc)
		end
	end
end