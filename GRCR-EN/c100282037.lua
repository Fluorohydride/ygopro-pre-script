--Zektrike Kou-Ou
--
--script by Raye
function c100282037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100282037+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100282037.cost)
	e1:SetTarget(c100282037.target)
	e1:SetOperation(c100282037.activate)
	c:RegisterEffect(e1)
end
function c100282037.tgfilter(c)
	return c:IsSetCard(0x56) and c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsOnField())
end
function c100282037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100282037.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100282037.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c100282037.opfilter(c,e,tp)
	local mft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return c:IsSetCard(0x56) and c:IsType(TYPE_MONSTER)
		and (mft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) or sft>0)
end
function c100282037.cfilter(c) 
	return c:IsSetCard(0x56) and c:IsType(TYPE_MONSTER) and c:IsFaceup() 
end
function c100282037.eqfilter(c)
	return c:IsSetCard(0x56) and c:IsType(TYPE_EQUIP)
end
function c100282037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c100282037.opfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c100282037.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c100282037.eqfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(100282037,0)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(100282037,1)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(0)
	else
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
	end
end
function c100282037.chkfilter(c) 
	return c:IsSetCard(0x56) and c:IsType(TYPE_MONSTER) and c:IsFaceup() 
end
function c100282037.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g1=Duel.SelectMatchingCard(tp,c100282037.opfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local chk=Duel.IsExistingMatchingCard(c100282037.chkfilter,tp,LOCATION_MZONE,0,1,nil)
		local mft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		local tc=g1:GetFirst()
		if tc then
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and mft>0 and (not chk or Duel.SelectOption(tp,1075,1068)==0) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local sg1=Duel.SelectMatchingCard(tp,c100282037.chkfilter,tp,LOCATION_MZONE,0,1,1,nil)
				Duel.HintSelection(sg1)
				local sc=sg1:GetFirst()
				if sc:IsFaceup() and sft>0 then
					if not Duel.Equip(tp,tc,sc) then return end
					--equip limit
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_EQUIP_LIMIT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetLabelObject(sc)
					e1:SetValue(c100282037.eqlimit)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g2=Duel.SelectMatchingCard(tp,c100282037.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(g2)
		local eqc=g2:GetFirst() 
		if eqc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg2=Duel.SelectMatchingCard(tp,c100282037.eqfilter,tp,LOCATION_DECK,0,1,1,nil)
			local ec=sg2:GetFirst()
			if ec then
				if not Duel.Equip(tp,ec,eqc) then return end
				--equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetLabelObject(eqc)
				e1:SetValue(c100282037.eqlimit)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				ec:RegisterEffect(e1)
			end
		end
	end
end
function c100282037.eqlimit(e,c)
	return c==e:GetLabelObject()
end
