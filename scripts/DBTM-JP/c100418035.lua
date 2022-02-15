--黄金の雫の神碑
--Script by JustFish
function c100418035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100418035+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100418035.target)
	e1:SetOperation(c100418035.activate)
	c:RegisterEffect(e1)
end
function c100418035.spfilter(c,e,tp)
	return c:IsSetCard(0x27e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)>0
end
function c100418035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetDecktopGroup(1-tp,4)
	local b1=Duel.IsPlayerCanDraw(1-tp,1) and dg:FilterCount(Card.IsAbleToRemove,nil)==4
	local b2=Duel.IsExistingMatchingCard(c100418035.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100418035,0),aux.Stringid(100418035,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100418035,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100418035,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,4,1-tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function c100418035.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 then
		if Duel.Draw(1-tp,1,REASON_EFFECT)~=0 then
			local g1=Duel.GetDecktopGroup(1-tp,4)
			if #g1>0 then
				Duel.DisableShuffleCheck()
				Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100418035.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
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
			e1:SetCondition(c100418035.skipcon)
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c100418035.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
