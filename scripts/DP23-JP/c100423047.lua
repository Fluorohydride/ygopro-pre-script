--EMポップアップ

--Scripted by mallu11
function c100423047.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100423047+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100423047.cost)
	e1:SetTarget(c100423047.target)
	e1:SetOperation(c100423047.activate)
	c:RegisterEffect(e1)
end
function c100423047.cfilter(c,e,tp,lsc,rsc)
	local lv=c:GetLevel()
	return (c:IsSetCard(0x9f) or (c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM)) or c:IsSetCard(0x99)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and lv>lsc and lv<rsc
end
function c100423047.fselect(g)
	if g:GetClassCount(Card.GetCode)==g:GetCount() then
		Duel.SetSelectedCard(g)
		return true
	else return false end
end
function c100423047.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local h=Duel.GetMatchingGroupCount(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,nil)
	if e:GetHandler():IsLocation(LOCATION_HAND) then h=h-1 end
	if chk==0 then return h>0 end
	local gc=1
	if Duel.IsPlayerCanDraw(tp,2) then gc=2 end
	if Duel.IsPlayerCanDraw(tp,3) then gc=3 end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,gc,nil)
	e:SetLabel(Duel.SendtoGrave(sg,REASON_COST))
end
function c100423047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c100423047.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local ct=Duel.Draw(p,d,REASON_EFFECT)
	local mz=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local flag=0
	if ct>0 and mz>0 and Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.GetFieldCard(tp,LOCATION_PZONE,1) then
		local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
		local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
		if lsc>rsc then lsc,rsc=rsc,lsc end
		if Duel.IsExistingMatchingCard(c100423047.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp,lsc,rsc) and Duel.SelectYesNo(tp,aux.Stringid(100423047,0)) then
			Duel.BreakEffect()
			local count=math.min(ct,mz)
			local g=Duel.GetMatchingGroup(c100423047.cfilter,tp,LOCATION_HAND,0,nil,e,tp,lsc,rsc)
			local sg=g:SelectSubGroup(tp,c100423047.fselect,false,1,count,tp)
			flag=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if flag==0 then
		local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		Duel.SetLP(tp,Duel.GetLP(tp)-h*1000)
	end
end
