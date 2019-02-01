--Final Light
--Script by JoyJ
function c101007090.initial_effect(c)
	--activate
	local e1 = Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101007090+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101007090.condition)
	e1:SetCost(c101007090.cost)
	e1:SetTarget(c101007090.target)
	e1:SetOperation(c101007090.operation)
	c:RegisterEffect(e1)
end
function c101007090.condition(e,tp,eg,ep,ev,re,r,rp)
	for _,te in ipairs({Duel.GetPlayerEffect(tp,EFFECT_LPCOST_CHANGE)}) do
		local val=te:GetValue()
		if val(te,e,tp,1000)~=1000 then return false end
	end
	return true
end
function c101007090.filtervalkyrie(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x122) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function c101007090.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then
		e:SetLabel(10)
		return true
	end
end
function c101007090.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = Duel.GetMatchingGroup(c101007090.filtervalkyrie,tp,LOCATION_GRAVE,0,nil,e,tp)
	local graveCount = g:GetClassCount(Card.GetCode)
	local mZoneCount = Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return false end
	if chk == 0 then
		if e:GetLabel() ~= 10 then return false end
		return mZoneCount > 0 and g:GetCount() > 0 and Duel.CheckLPCost(tp,1000)
	end
	local n = graveCount
	if graveCount > mZoneCount then
		n = mZoneCount
	end
	if (Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)) then
		n = 1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101007090,0))
	local pay_list = {}
	for p = 1, n do
		if Duel.CheckLPCost(tp,1000*p) then table.insert(pay_list, p) end
	end
	local pay = Duel.AnnounceNumber(tp,table.unpack(pay_list))
	Duel.PayLPCost(tp,pay*1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local spg = Group.CreateGroup()
	for p2 = 1, n do
		if g:GetCount() == 0 then
			break
		end
		local add = g:Select(tp,1,1,nil):GetFirst()
		spg:AddCard(add)
		g = g:Remove(Card.IsCode,nil,add:GetCode())
	end
	Duel.SetTargetCard(spg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,spg:GetCount(),spg,tp,0)
end
function c101007090.filter2(c,e,sp)
	return c:IsAttackBelow(2000) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c101007090.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1, ft1 = Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e), Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft1 <= 0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft1 = 1 end
	local sg = g1
	if g1:GetCount() > ft1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg = g1:Select(tp,ft1,ft1,nil)
	end
	local count = Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	if count <= 0 then return end
	local g2 = Duel.GetMatchingGroup(c101007090.filter2,tp,0,LOCATION_GRAVE,nil,e,1-tp)
	local ft2 = Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft2 > count then ft2 = count end
	if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft2 = 1 end
	if g2:GetCount() > 0 and ft2 > 0 and Duel.SelectYesNo(1-tp,aux.Stringid(101007090,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		sg = g2:Select(1-tp,1,ft2,nil)
		Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end
