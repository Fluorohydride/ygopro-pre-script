--人形の家
--scripted by XyLeN
function c100278033.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100278033,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,100278033)
	e1:SetTarget(c100278033.sptg)
	e1:SetOperation(c100278033.spop)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100278033,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c100278033.matcon)
	e2:SetTarget(c100278033.mattg)
	e2:SetOperation(c100278033.matop)
	c:RegisterEffect(e2)
end
function c100278033.filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsAttack(0) or c:IsDefense(0)
		and Duel.IsExistingMatchingCard(c100278033.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function c100278033.filter2(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100278033.cfilter(c)
	return c:IsFaceup() and c:IsCode(75574498) 
end
function c100278033.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100278033.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100278033.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local value=math.min(2,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or not Duel.IsExistingMatchingCard(c100278033.cfilter,tp,LOCATION_MZONE,0,1,nil) then value=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100278033.filter,tp,LOCATION_GRAVE,0,1,value,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100278033.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c100278033.filter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),e,tp)
		local sc=sg:GetFirst() 
		while sc do
			Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(6)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(sc)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e2:SetValue(ATTRIBUTE_DARK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			sc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		tc=g:GetNext()
	end
end
function c100278033.matcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c100278033.matfilter(c)
	return c:IsCode(44190146) and c:IsFaceup() and c:IsCanOverlay() 
end
function c100278033.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100278033.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100278033.cfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c100278033.matop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g1=Duel.SelectMatchingCard(tp,c100278033.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=Duel.SelectMatchingCard(tp,c100278033.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(g2)
		local tc=g2:GetFirst() 
		if tc and Duel.Overlay(tc,g1)~=0 then
			Duel.BreakEffect()
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		end
	end
end
