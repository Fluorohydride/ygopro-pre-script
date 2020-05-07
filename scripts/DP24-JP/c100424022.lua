--根絶の機皇神

--Scripted by mallu11
function c100424022.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100424022,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,100424022)
	e1:SetTarget(c100424022.target)
	e1:SetOperation(c100424022.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100424022,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,100424122)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c100424022.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100424022.destg)
	e2:SetOperation(c100424022.desop)
	c:RegisterEffect(e2)
end
function c100424022.filter(c,e,tp)
	return c:IsSetCard(0x13) and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
		and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,true,false))
end
function c100424022.fselect(g,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct1=g:FilterCount(Card.IsAbleToHand,nil)
	local ct2=g:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,true,false)
	return (ct1==#g or ct2==#g and ct2<=ft and not Duel.IsPlayerAffectedByEffect(tp,59822133)) and aux.dncheck(g)
end
function c100424022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c100424022.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chkc then return false end
	if chk==0 then return g:CheckSubGroup(c100424022.fselect,3,3,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:SelectSubGroup(tp,c100424022.fselect,false,3,3,e,tp)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,0,0,0)
end
function c100424022.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local b1=tg:IsExists(Card.IsAbleToHand,1,nil)
		local b2=tg:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,true,false) and ft>0
		local opt=0
		if b1 and not b2 then
			opt=Duel.SelectOption(tp,1190)
		elseif not b1 and b2 then
			opt=Duel.SelectOption(tp,1152)+1
		elseif b1 and b2 then
			opt=Duel.SelectOption(tp,1190,1152)
		end
		if opt==0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		else
			local sg=tg:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,true,false)
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			if sg:GetCount()<=ft then
				Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local pg=sg:Select(tp,ft,ft,nil)
				Duel.SpecialSummon(pg,0,tp,tp,true,false,POS_FACEUP)
				sg:Sub(pg)
				Duel.SendtoGrave(sg,REASON_RULE)
			end
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c100424022.splimit)
		if Duel.GetTurnPlayer()==tp then
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c100424022.splimit(e,c)
	return not c:IsRace(RACE_MACHINE)
end
function c100424022.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5013)
end
function c100424022.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100424022.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100424022.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c100424022.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100424022.desfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c100424022.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c100424022.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local atk=tc:GetTextAttack()
			if atk>0 then
				Duel.Damage(1-tp,atk,REASON_EFFECT)
			end
		end
	end
end
