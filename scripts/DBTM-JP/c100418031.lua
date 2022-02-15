--破壊の神碑
--Script by JustFish
function c100418031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100418031,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100418031+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100418031.target)
	e1:SetOperation(c100418031.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100418031,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,100418031+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c100418031.target1)
	e2:SetOperation(c100418031.activate1)
	c:RegisterEffect(e2)
end
function c100418031.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100418031.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dg=Duel.GetDecktopGroup(1-tp,4)
	if chkc then return chkc:IsOnField() and c100418031.desfilter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c100418031.desfilter,tp,0,LOCATION_ONFIELD,1,nil) and dg:FilterCount(Card.IsAbleToRemove,nil)==4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100418031.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,4,1-tp,LOCATION_DECK)
end
function c100418031.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local g=Duel.GetDecktopGroup(1-tp,4)
			if #g>0 then
				Duel.DisableShuffleCheck()
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local ph=Duel.GetCurrentPhase()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c100418031.skipcon)
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c100418031.spfilter(c,e,tp)
	return c:IsSetCard(0x27e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)>0
end
function c100418031.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100418031.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100418031.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100418031.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local ph=Duel.GetCurrentPhase()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c100418031.skipcon)
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c100418031.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
