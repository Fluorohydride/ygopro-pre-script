--銀河眼の極光波竜
--
--"Lua By REIKAI 2404873791"
function c100270203.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2,c100270203.ovfilter,aux.Stringid(100270203,0),2,c100270203.xyzop)
	c:EnableReviveLimit()
	--CANNOT be tg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100270203,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c100270203.cost)
	e1:SetOperation(c100270203.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100270203,2))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c100270203.con)
	e2:SetTarget(c100270203.tg)
	e2:SetOperation(c100270203.op)
	c:RegisterEffect(e2)
end
function c100270203.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10e5)
end
function c100270203.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100270203)==0 end
	Duel.RegisterFlagEffect(tp,100270203,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c100270203.filter1(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c100270203.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c100270203.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c100270203.filter1,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e3:SetValue(aux.tgoval)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
function c100270203.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100270203.filter(c)
	return c:IsType(TYPE_XYZ) and c:IsRankBelow(9) and c:IsRace(RACE_DRAGON) and c:IsAbleToExtra()
end
function c100270203.xyzfilter(c,mc,e,tp)
	return mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c100270203.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100270203.filter,tp,LOCATION_GRAVE,0,1,nli) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE)
end
function c100270203.op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c100270203.filter,tp,LOCATION_GRAVE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100270203.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local c=e:GetHandler()
	local g=Duel.GetOperatedGroup()
	if not g then return end
	local sc=g:GetFirst()
	if sc and c:IsRelateToEffect(e) and c100270203.xyzfilter(sc,c,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(100270203,4)) then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
