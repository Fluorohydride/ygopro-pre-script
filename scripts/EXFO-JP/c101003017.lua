--黄華の機界騎士
--Mekk-Knight of the Yellow Bloom
--Scripted by Eerie Code
function c101003017.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101003017)
	e1:SetCondition(c101003017.hspcon)
	e1:SetValue(c101003017.hspval)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101003017,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c101003017.cost)
	e3:SetTarget(c101003017.target)
	e3:SetOperation(c101003017.operation)
	c:RegisterEffect(e3)
end
function c101003017.cfilter(c)
	return c:GetColumnGroupCount()>0
end
function c101003017.getzone(tp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c101003017.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		if tc:IsControler(tp) then		
			zone=bit.bor(zone,bit.band(tc:GetColumnZone(LOCATION_MZONE),0xff))
		else
			zone=bit.bor(zone,bit.rshift(bit.band(tc:GetColumnZone(LOCATION_MZONE),0xff0000),16))
		end
	end
	return zone
end
function c101003017.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c101003017.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101003017.hspval(e,c)
	local tp=c:GetControler()
	return 0,c101003017.getzone(tp)
end
function c101003017.costfilter(c)
	return c:IsSetCard(0x20c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c101003017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101003017.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101003017.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101003017.filter(c,g)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and g:IsContains(c)
end
function c101003017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cg=e:GetHandler():GetColumnGroup()
	if chkc then return c101003017.filter(chkc,cg) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c101003017.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,cg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101003017.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101003017.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
