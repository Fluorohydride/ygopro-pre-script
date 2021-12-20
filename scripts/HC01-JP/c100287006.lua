--決闘塔アルカトラズ
--
--Script by Trishula9
function c100287006.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--choose
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100287006,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c100287006.cstg)
	e2:SetOperation(c100287006.csop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100287006,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c100287006.dop)
	c:RegisterEffect(e3)
end
function c100287006.cstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,LOCATION_DECK)
end
function c100287006.csfilter1(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetTextAttack()>=0 and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c100287006.csfilter2(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetTextAttack()>=0 and c:IsAbleToRemove(1-tp,POS_FACEDOWN)
end
function c100287006.csop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sc1=Duel.SelectMatchingCard(tp,c100287006.csfilter1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local sc2=Duel.SelectMatchingCard(1-tp,c100287006.csfilter2,1-tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if sc1 and sc2 then
		local p=0
		if sc1:GetTextAttack()>sc2:GetTextAttack() then p=tp
		elseif sc1:GetTextAttack()<sc2:GetTextAttack() then p=1-tp
		else p=PLAYER_ALL end
		Duel.ConfirmCards(1-tp,sc1)
		Duel.ConfirmCards(tp,sc2)
		Duel.Remove(Group.FromCards(sc1,sc2),POS_FACEDOWN,REASON_EFFECT)
		if (p==tp or p==PLAYER_ALL) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,nil,e,0,tp,false,false)
			and Duel.SelectYesNo(tp,aux.Stringid(100287006,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false):GetFirst()
			if sc then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DIRECT_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
			end
		end
		if (p==1-tp or p==PLAYER_ALL) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,1-tp,LOCATION_HAND,0,1,nil,e,0,1-tp,false,false)
			and Duel.SelectYesNo(1-tp,aux.Stringid(100287006,2)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(1-tp,Card.IsCanBeSpecialSummoned,1-tp,LOCATION_HAND,0,1,1,nil,e,0,1-tp,false,false):GetFirst()
			if sc then
				Duel.SpecialSummon(sc,0,1-tp,1-tp,false,false,POS_FACEUP)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DIRECT_ATTACK)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e2)
			end
		end
	end
end
function c100287006.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()==tp then
		c:RegisterFlagEffect(100287006,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetLabel(Duel.GetTurnCount()+2)
		e1:SetCountLimit(1)
		e1:SetCondition(c100287006.descon)
		e1:SetOperation(c100287006.desop)
		Duel.RegisterEffect(e1,tp)
	else
		c:RegisterFlagEffect(100287006,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetLabel(Duel.GetTurnCount()+1)
		e2:SetCountLimit(1)
		e2:SetCondition(c100287006.descon)
		e2:SetOperation(c100287006.desop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c100287006.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnCount()==e:GetLabel() and c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()
		and c:GetFlagEffect(100287006)>0
end
function c100287006.desop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end