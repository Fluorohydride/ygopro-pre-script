--Zektrike Kou-Ou
--
--script by Raye
function c100282037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100282037,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100282037+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100282037.cost)
	e1:SetTarget(c100282037.optg)
	e1:SetOperation(c100282037.opop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(100282037,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetTarget(c100282037.eqtg)
	e2:SetOperation(c100282037.eqop)
	c:RegisterEffect(e2)
end
function c100282037.tgcostfilter(c)
	return c:IsSetCard(0x56) and c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsOnField())
end
function c100282037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100282037.tgcostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100282037.tgcostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c100282037.opfilter(c,e,tp)
	if not (c:IsSetCard(0x56) and c:IsType(TYPE_MONSTER)) then return false end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return (ft1>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or ft2>0
end
function c100282037.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100282037.opfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c100282037.cfilter(c)
	return c:IsSetCard(0x56) and c:IsType(TYPE_MONSTER)
end
function c100282037.opop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c100282037.opfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local chk=Duel.IsExistingMatchingCard(c100282037.cfilter,tp,LOCATION_MZONE,0,1,nil)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and ft1>0 and (not chk and ft2>0 or Duel.SelectOption(tp,1075,1068)==0) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sg=Duel.SelectMatchingCard(tp,c100282037.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
			local sc=sg:GetFirst() 
			if sc then
				if not Duel.Equip(tp,tc,sc) then return end
				--equip limit
				local e1=Effect.CreateEffect(e:GetHandler())
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
end
function c100282037.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x56)
end
function c100282037.eqfilter(c)
	return c:IsSetCard(0x56) and c:IsType(TYPE_EQUIP)
end
function c100282037.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c100282037.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100282037.eqfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c100282037.eqop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c100282037.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst() 
	if tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c100282037.eqfilter,tp,LOCATION_DECK,0,1,1,nil)
		local ec=g:GetFirst()
		if ec then
			if not Duel.Equip(tp,ec,tc) then return end
			--equip limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetLabelObject(tc)
			e1:SetValue(c100282037.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
		end
	end
end
function c100282037.eqlimit(e,c)
	return c==e:GetLabelObject()
end
