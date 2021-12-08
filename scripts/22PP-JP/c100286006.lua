--咒念的化身 衔尾蛇
function c100286006.initial_effect(c)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100286006,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100286006)
	e1:SetCost(c100286006.spcost)
	e1:SetTarget(c100286006.sptg)
	e1:SetOperation(c100286006.spop)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c100286006.downtg)
	e2:SetValue(-300)
	c:RegisterEffect(e2)
	local e3=Effect.Clone(e2)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100286006,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,100286006+100)
	e4:SetCost(c100286006.thcost)
	e4:SetTarget(c100286006.thtg)
	e4:SetOperation(c100286006.thop)
	c:RegisterEffect(e4)
end
function c100286006.cfilter(c,tp)
	return c:IsRace(RACE_REPTILE) and Duel.GetMZoneCount(tp,c)>0
end
function c100286006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100286006.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c100286006.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c100286006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100286006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100286006.downtg(e,c)
	return c:IsFaceup()
end
function c100286006.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c100286006.rcheck(c)
	return c:GetTextAttack()>0 
end
function c100286006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
			if e:GetLabel()==1 then
				return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.CheckReleaseGroup(tp,c100286006.rcheck,1,nil) 
			else
				return false
			end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c100286006.rcheck,1,1,nil,tp)
	local tc=g:GetFirst()
	local atk=tc:GetTextAttack()
	Duel.SetTargetParam(atk)
	Duel.Release(g,REASON_COST)
end
function c100286006.thop(e,tp,eg,ep,ev,re,r,rp)
	local atk=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end