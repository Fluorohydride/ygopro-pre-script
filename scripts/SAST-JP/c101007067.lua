--Pot of Indulgence
--Scripted by Eerie Code
function c101007067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c101007067.condition)
	e1:SetCost(c101007067.cost)
	e1:SetTarget(c101007067.target)
	e1:SetOperation(c101007067.activate)
	c:RegisterEffect(e1)
end
function c101007067.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c101007067.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c101007067.cfilter(c)
	return c:IsFacedown() and c:IsAbleToRemoveAsCost()
end
function c101007067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101007067.cfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsPlayerCanDraw(tp,1) and #g>=3
	end
	local op=1
	if Duel.IsPlayerCanDraw(tp,2) and #g>=6 then
		op=Duel.SelectOption(tp,aux.Stringid(101007067,0),aux.Stringid(101007067,1))+1
	else
		op=Duel.SelectOption(tp,aux.Stringid(101007067,0))+1
	end
	local rg=g:RandomSelect(tp,op*3)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(op)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,op)
end
function c101007067.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
