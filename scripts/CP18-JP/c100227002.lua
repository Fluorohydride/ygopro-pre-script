--サモン・ダイス
--Summon Dice
--Scripted by Eerie Code
function c100227002.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100227002+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100227002.cost)
	e1:SetTarget(c100227002.target)
	e1:SetOperation(c100227002.activate)
	c:RegisterEffect(e1)
end
function c100227002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c100227002.filter1(c)
	return c:IsSummonable(true,nil)
end
function c100227002.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100227002.filter3(c,e,tp)
	return c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100227002.filter(c,e,tp)
	return Duel.IsExistingMatchingCard(c100227002.filter1,tp,LOCATION_HAND,0,1,nil)
		or Duel.IsExistingMatchingCard(c100227002.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		or Duel.IsExistingMatchingCard(c100227002.filter3,tp,LOCATION_HAND,0,1,nil,e,tp)
end
function c100227002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c100227002.activate(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	if d==1 or d==2 then
		local g=Duel.GetMatchingGroup(c100227002.filter1,tp,LOCATION_HAND,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100227002,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.Summon(tp,tc,true,nil)
		end
	elseif d==3 or d==4 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100227002.filter2),tp,LOCATION_GRAVE,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100227002,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif d==7 then
		return
	else
		local g=Duel.GetMatchingGroup(c100227002.filter3,tp,LOCATION_HAND,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100227002,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
