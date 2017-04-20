--覇王の逆鱗
--Supreme King's Wrath
--Scripted by Eerie Code
function c101001070.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101001070.condition)
	e1:SetTarget(c101001070.target)
	e1:SetOperation(c101001070.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c101001070.matcost)
	e2:SetTarget(c101001070.mattg)
	e2:SetOperation(c101001070.matop)
	c:RegisterEffect(e2)
end
function c101001070.cfilter(c)
	return c:IsFaceup() and c:IsCode(13331639)
end
function c101001070.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101001070.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101001070.desfilter(c)
	return not c101001070.cfilter(c)
end
function c101001070.spfilter(c,e,tp)
	return c:IsSetCard(0x20f8) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c101001070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101001070.desfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 then loc=loc+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE end
		if Duel.GetLocationCountFromEx(tp)>-1 then loc=loc+LOCATION_EXTRA end
		return g:GetCount()>0 and loc~=0
			and Duel.IsExistingMatchingCard(c101001070.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c101001070.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c101001070.desfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.Destroy(dg,REASON_EFFECT)==0 then return end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	local loc=0
	if ft1>0 then loc=loc+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE end
	if ft2>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	local ct=4
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101001070.spfilter),tp,loc,0,nil,e,tp)
	if sg:GetCount()==0 then return end
	local rg=Group.CreateGroup()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil):GetFirst()
		rg:AddCard(tg)
		sg:Remove(Card.IsCode,nil,tg:GetCode())
		if tg:IsLocation(LOCATION_EXTRA) then ft2=ft2-1
		else ft1=ft1-1 end
		if ft1<=0 then sg:Remove(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE) end
		if ft2<=0 then sg:Remove(Card.IsLocation,nil,LOCATION_EXTRA) end
		ft=ft-1
		ct=ct-1
	until ct==0 or sg:GetCount()==0 or ft==0 or not Duel.SelectYesNo(tp,aux.Stringid(101001070,0))
	local tc=rg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
		tc=rg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c101001070.matcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c101001070.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x20f8) and c:IsType(TYPE_XYZ)
end
function c101001070.matfilter(c)
	return c:IsSetCard(0x20f8) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
end
function c101001070.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101001070.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101001070.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101001070.matfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101001070.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101001070.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c101001070.matfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
