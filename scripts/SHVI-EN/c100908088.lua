--Super Anti-Kaiju War Machine Mecha-Dogoran
--Script by nekrozar
function c100908088.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,20000000,LOCATION_MZONE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100908088.spcon)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100908088,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c100908088.eqcost)
	e2:SetTarget(c100908088.eqtg)
	e2:SetOperation(c100908088.eqop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c100908088.atkval)
	c:RegisterEffect(e3)
end
function c100908088.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd3)
end
function c100908088.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100908087.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c100908088.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x37,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x37,2,REASON_COST)
end
function c100908088.eqfilter(c)
	return c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER)
end
function c100908088.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c100908088.eqfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c100908088.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c100908088.eqfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and not tc:IsHasEffect(EFFECT_NECRO_VALLEY) then
		if not Duel.Equip(tp,tc,c,true) then return end
		tc:RegisterFlagEffect(100908088,RESET_EVENT+0x1fe0000,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c100908088.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c100908088.eqlimit(e,c)
	return e:GetOwner()==c
end
function c100908088.atkfilter(c)
	return c:IsSetCard(0xd3) and c:GetFlagEffect(100908088)~=0
end
function c100908088.atkval(e,c)
	local g=e:GetHandler():GetEquipGroup():Filter(c100908088.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
