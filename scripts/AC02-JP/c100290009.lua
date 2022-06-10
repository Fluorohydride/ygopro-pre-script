--鎮魂の決闘
--
--Script by Trishula9
function c100290009.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100290009+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100290009.target)
	e1:SetOperation(c100290009.activate)
	c:RegisterEffect(e1)
end
function c100290009.filter(c,e,tp,tid)
	return c:GetTurnID()==tid and c:IsReason(REASON_BATTLE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c100290009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100290009.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount()))
		or (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100290009.filter,tp,0,LOCATION_GRAVE,1,nil,e,1-tp,Duel.GetTurnCount())) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function c100290009.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100290009.filter),tp,LOCATION_GRAVE,0,nil,e,tp,Duel.GetTurnCount())
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100290009,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			if tc:IsCode(89943723) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetRange(LOCATION_MZONE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetCondition(c100290009.atkcon)
				e1:SetValue(c100290009.atkval)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end
		end
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100290009.filter),1-tp,LOCATION_GRAVE,0,nil,e,1-tp,Duel.GetTurnCount())
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(100290009,0)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local tc=g:Select(1-tp,1,1,nil):GetFirst()
			Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK)
		end
	end
	Duel.SpecialSummonComplete()
end
function c100290009.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local a,d=Duel.GetBattleMonster(0)
	if (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and (a==e:GetHandler() and d or a and d==e:GetHandler()) then
		e:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL+PHASE_END)
		return true
	end
	return false
end
function c100290009.atkval(e,c)
	return e:GetHandler():GetAttack()*2
end