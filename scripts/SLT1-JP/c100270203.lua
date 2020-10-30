--銀河眼の極光波竜
--Galaxy-Eyes Cipher Ex Dragon
--Scripted by Xylen09
function c100270203.initial_effect(c)
	--Xyz Summon
	aux.AddXyzProcedure(c,nil,10,2,c100270203.ovfilter,aux.Stringid(100270203,1),2,c100270203.xyzop)
	c:EnableReviveLimit()
	--Cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100270203,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c100270203.dcost)
	e1:SetOperation(c100270203.dop)
	c:RegisterEffect(e1)
	--Xyz Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100270203,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c100270203.ovtg)
	e2:SetOperation(c100270203.ovop)
	c:RegisterEffect(e2)
end
function c100270203.ovfilter(c)
	return c:IsCode(2530830,12632096,18963306) and c:IsType(TYPE_MONSTER) and not c:IsCode(100270203)
end
function c100270203.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100270203)==0 end
	Duel.RegisterFlagEffect(tp,100270203,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c100270203.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c100270203.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(aux.tgoval)
		c:RegisterEffect(e1)
	end
end
function c100270203.osfilter(c)
	return c:IsSetCard(0x107b) and c:IsRankBelow(9) and c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function c100270203.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100270203.osfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOEXTRA)
end
function c100270203.ovop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectTarget(tp,c100270203.osfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if tc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()>0 then
			Duel.Overlay(tc,mg)
		end
		tc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(tc,Group.FromCards(c))
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	 end
end
